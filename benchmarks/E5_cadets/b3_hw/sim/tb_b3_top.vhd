-- tb_b3_top.vhd : end-to-end check  raw JSON-lines stream -> b3_top results
--  * stream.txt   : "<idle_cycles> <128 hex>" per 64-byte word (byte 63 first)
--  * expected.txt : first line = #lines; then "<err> <logit_ben> <logit_mal> <128 hex B3 vector>"
-- Checks, per line and in order: the standalone extractor (vector + err) and the full
-- pipeline (err, both logits, forward decision at THRESH=0). Also checks the result count.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
library work;
use work.PkgKAN.all;

entity tb_b3_top is
  generic (KAN_LAT : natural := 8);
end entity;

architecture sim of tb_b3_top is
  signal clk      : std_logic := '0';
  signal rst      : std_logic := '1';
  signal in_valid : std_logic := '0';
  signal in_data  : std_logic_vector(511 downto 0) := (others => '0');
  signal ex_valid, ex_err : std_logic;
  signal ex_vec   : std_logic_vector(511 downto 0);
  signal r_valid, r_mal, r_err, r_fwd : std_logic;
  signal r_ben, r_malg : signed(OUTPUT_WIDTH-1 downto 0);
  signal stim_done : boolean := false;
  signal ex_n, ex_bad, top_n, top_bad : integer := 0;
begin
  clk <= not clk after 1.5515 ns;                  -- 322.27 MHz (100G CMAC user clock)

  top : entity work.b3_top generic map (THRESH => 0, KAN_LAT => KAN_LAT)
    port map (clk => clk, rst => rst, in_valid => in_valid, in_data => in_data,
              res_valid => r_valid, res_logit_ben => r_ben, res_logit_mal => r_malg,
              res_mal => r_mal, res_err => r_err, res_forward => r_fwd);
  ext : entity work.b3_extract
    port map (clk => clk, rst => rst, in_valid => in_valid, in_data => in_data,
              out_valid => ex_valid, out_vec => ex_vec, out_err => ex_err);

  stim : process
    file fs : text open read_mode is "stream.txt";
    variable L : line; variable gap : integer; variable w : std_logic_vector(511 downto 0);
  begin
    for k in 1 to 5 loop wait until rising_edge(clk); end loop;
    rst <= '0';
    for k in 1 to 3 loop wait until rising_edge(clk); end loop;
    while not endfile(fs) loop
      readline(fs, L); read(L, gap); hread(L, w);
      for g in 1 to gap loop in_valid <= '0'; wait until rising_edge(clk); end loop;
      in_valid <= '1'; in_data <= w; wait until rising_edge(clk);
    end loop;
    in_valid <= '0';
    for k in 1 to 200 loop wait until rising_edge(clk); end loop;
    stim_done <= true; wait;
  end process;

  mon_ext : process                                 -- standalone extractor: vector + err
    file fe : text open read_mode is "expected.txt";
    variable L : line; variable n, e, lb, lm : integer; variable v : std_logic_vector(511 downto 0);
    variable cnt, bad : integer := 0;
  begin
    readline(fe, L); read(L, n);
    loop
      wait until falling_edge(clk);
      exit when stim_done;
      if ex_valid = '1' then
        cnt := cnt + 1;
        if cnt <= n then
          readline(fe, L); read(L, e); read(L, lb); read(L, lm); hread(L, v);
          if (ex_err = '1') /= (e = 1) or (e = 0 and ex_vec /= v) then
            bad := bad + 1;
            report "EXTRACT MISMATCH line " & integer'image(cnt) severity warning;
          end if;
        end if;
        ex_n <= cnt; ex_bad <= bad;
      end if;
    end loop;
    wait;
  end process;

  mon_top : process                                 -- full pipeline: err, logits, decision
    file fe : text open read_mode is "expected.txt";
    variable L : line; variable n, e, lb, lm : integer; variable v : std_logic_vector(511 downto 0);
    variable cnt, bad : integer := 0; variable fwd_exp : boolean;
  begin
    readline(fe, L); read(L, n);
    loop
      wait until falling_edge(clk);
      exit when stim_done;
      if r_valid = '1' then
        cnt := cnt + 1;
        if cnt <= n then
          readline(fe, L); read(L, e); read(L, lb); read(L, lm); hread(L, v);
          fwd_exp := (e = 1) or (lm - lb >= 0);
          if (r_err = '1') /= (e = 1)
             or (e = 0 and (to_integer(r_ben) /= lb or to_integer(r_malg) /= lm))
             or ((r_fwd = '1') /= fwd_exp) then
            bad := bad + 1;
            report "TOP MISMATCH line " & integer'image(cnt) & " got err=" & std_logic'image(r_err) &
                   " logits=(" & integer'image(to_integer(r_ben)) & "," & integer'image(to_integer(r_malg)) &
                   ") exp err=" & integer'image(e) & " logits=(" & integer'image(lb) & "," & integer'image(lm) & ")"
                   severity warning;
          end if;
        end if;
        top_n <= cnt; top_bad <= bad;
      end if;
    end loop;
    wait;
  end process;

  final : process
    file fe : text open read_mode is "expected.txt";
    variable L : line; variable n : integer;
  begin
    readline(fe, L); read(L, n);
    wait until stim_done; wait for 10 ns;
    report "B3 E2E: lines=" & integer'image(n) &
           " | extractor results=" & integer'image(ex_n) & " mismatches=" & integer'image(ex_bad) &
           " | pipeline results=" & integer'image(top_n) & " mismatches=" & integer'image(top_bad) severity note;
    if ex_n = n and top_n = n and ex_bad = 0 and top_bad = 0 then
      report "B3 E2E PASSED" severity note;
    else
      report "B3 E2E FAILED" severity warning;
    end if;
    std.env.finish;
  end process;
end architecture;
