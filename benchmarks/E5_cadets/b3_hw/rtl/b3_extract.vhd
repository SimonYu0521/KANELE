-- =============================================================================
-- b3_extract.vhd  --  JSON-lines log stream  ->  B3 64-byte KAN input (no JSON parsing)
--
-- Input : a byte stream of newline-terminated JSON log lines, 64 bytes per valid
--         clock (in_data byte i = bits 8i+7..8i, byte 0 first in stream order).
--         Lines are packed back to back: a line may start at any byte lane.
-- Output: one result per line, a 1-cycle out_valid pulse the cycle after the
--         word that holds the line's newline.
--           out_vec bytes 0..7  = line bytes 51..58            (syscall, fixed offset)
--           out_vec bytes 8..63 = line bytes 254+L .. 309+L    (exe value onward; "floating" start)
--           L = syscall length = position of the syscall's closing quote (bytes 55..59) - 51
--           out_err = '1'  -> line is outside the producer's format contract; FORWARD it
--                      (line < 320 B, no quote at 55..59, or ', "exe": "' not at 244+L..253+L)
--
-- Method: each valid word is concatenated with the previous one and funnel-shifted by
-- the line's start lane p (3-stage 4:1 log shifter), giving 64-byte chunks aligned to
-- the line start. Chunks 0..4 (line bytes 0..319) are kept; synthesis trims every
-- buffer byte that the slice/guard logic never reads.
--
-- Contract (true for the E5 CADETS producer: lines are 329..621 bytes):
--   * the stream starts at a line boundary after reset;
--   * every line is >= 65 bytes (at most one newline per 64-byte word);
--   * lines shorter than 320 bytes are flagged out_err (forwarded).
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity b3_extract is
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    in_valid  : in  std_logic;
    in_data   : in  std_logic_vector(511 downto 0);
    out_valid : out std_logic;
    out_vec   : out std_logic_vector(511 downto 0);
    out_err   : out std_logic
  );
end entity;

architecture rtl of b3_extract is
  subtype byte_t is std_logic_vector(7 downto 0);
  type bytes_t is array (natural range <>) of byte_t;

  constant NBUF  : natural := 320;                        -- line bytes 0..319
  constant GUARD : bytes_t(0 to 9) := (x"2C", x"20", x"22", x"65", x"78", x"65", x"22", x"3A", x"20", x"22");  -- , "exe": "
  constant NL    : byte_t := x"0A";
  constant QUOTE : byte_t := x"22";

  signal v_r   : std_logic := '0';                        -- registered input
  signal d_r   : bytes_t(0 to 63) := (others => (others => '0'));
  signal prev  : bytes_t(0 to 63) := (others => (others => '0'));
  signal buf   : bytes_t(0 to NBUF-1) := (others => (others => '0'));
  signal p     : unsigned(5 downto 0) := (others => '0');   -- start lane of the current line
  signal rel   : unsigned(2 downto 0) := (others => '0');   -- line-relative index of the incoming word (sat. 7)
  signal eol   : std_logic := '0';                          -- newline seen -> emit next cycle
  signal lenok : std_logic := '0';                          -- line length >= 320
  signal o_v   : std_logic := '0';                          -- output registers (initialised)
  signal o_vec : std_logic_vector(511 downto 0) := (others => '0');
  signal o_err : std_logic := '0';

  -- funnel shift: out(j) = v(j + p), v = prev(0..63) & cur(0..63); 3 stages of 4:1
  function funnel(prv, cur : bytes_t(0 to 63); sh : unsigned(5 downto 0)) return bytes_t is
    variable v  : bytes_t(0 to 127);
    variable s1 : bytes_t(0 to 79);
    variable s2 : bytes_t(0 to 67);
    variable s3 : bytes_t(0 to 63);
    variable a, b, c : natural range 0 to 3;
  begin
    v(0 to 63) := prv; v(64 to 127) := cur;
    a := to_integer(sh(5 downto 4)); b := to_integer(sh(3 downto 2)); c := to_integer(sh(1 downto 0));
    for j in 0 to 79 loop s1(j) := v(j + 16*a); end loop;
    for j in 0 to 67 loop s2(j) := s1(j + 4*b); end loop;
    for j in 0 to 63 loop s3(j) := s2(j + c);   end loop;
    return s3;
  end function;
begin
  out_valid <= o_v; out_vec <= o_vec; out_err <= o_err;

  process(clk)
    variable cur   : bytes_t(0 to 63);
    variable chunk : bytes_t(0 to 63);
    variable nl_i  : integer range -1 to 63;
    variable off   : integer range -64 to 1023;
    variable q     : integer range 4 to 8;
    variable found : boolean;
    variable g     : boolean;
    variable c     : natural range 0 to 7;
  begin
    if rising_edge(clk) then
      o_v <= '0';
      -- input register (isolates the stream interface for timing)
      v_r <= in_valid;
      for i in 0 to 63 loop d_r(i) <= in_data(8*i+7 downto 8*i); end loop;

      if rst = '1' then
        v_r <= '0'; p <= (others => '0'); rel <= (others => '0'); eol <= '0'; lenok <= '0';
      else
        -- ---- emit the line whose newline arrived in the previous valid word ----
        if eol = '1' then
          found := false; q := 4;
          for k in 8 downto 4 loop                 -- lowest quote position among bytes 55..59
            if buf(51 + k) = QUOTE then q := k; found := true; end if;
          end loop;
          for i in 0 to 7 loop  o_vec(8*i+7 downto 8*i) <= buf(51 + i); end loop;
          for i in 0 to 55 loop o_vec(8*(8+i)+7 downto 8*(8+i)) <= buf(254 + q + i); end loop;
          g := true;
          for i in 0 to 9 loop
            if buf(244 + q + i) /= GUARD(i) then g := false; end if;
          end loop;
          if found and g and lenok = '1' then o_err <= '0'; else o_err <= '1'; end if;
          o_v <= '1';
          eol <= '0';
        end if;

        -- ---- consume one stream word ----
        if v_r = '1' then
          cur := d_r;
          if rel >= 1 and rel <= 5 then            -- aligned chunk (rel-1) of the current line
            chunk := funnel(prev, cur, p);
            c := to_integer(rel) - 1;
            for j in 0 to 63 loop buf(64*c + j) <= chunk(j); end loop;
          end if;
          nl_i := -1;
          for i in 63 downto 0 loop                -- lowest newline lane
            if cur(i) = NL then nl_i := i; end if;
          end loop;
          if nl_i >= 0 then
            off := 64 * to_integer(rel) + nl_i - to_integer(p);   -- newline offset = line length
            if off >= NBUF then lenok <= '1'; else lenok <= '0'; end if;
            eol <= '1';
            p <= to_unsigned((nl_i + 1) mod 64, 6);
            if nl_i = 63 then rel <= "000"; else rel <= "001"; end if;
          elsif rel /= 7 then
            rel <= rel + 1;
          end if;
          prev <= cur;
        end if;
      end if;
    end if;
  end process;
end architecture;
