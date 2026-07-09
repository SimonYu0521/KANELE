-- tb_kan_demo.vhd : classification demo.
-- Feeds 30 RAW-byte events (demo_in.txt) into the folded core, argmax's the two
-- logits, and reports predicted vs true class (demo_label.txt) + accuracy.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;   -- hread for std_logic_vector (hex input)
use std.textio.all;
library work;
use work.PkgKAN.all;

entity tb_kan_demo is end entity;

architecture sim of tb_kan_demo is
  signal clk : std_logic := '0';
  constant TCLK : time := 10 ns;
  signal en  : std_logic := '1';
  signal din  : input_vec_t := (others => (others => '0'));
  signal dout : output_vec_t;
  constant LATENCY : natural := 8;

  -- read N space-separated HEX bytes into the input vector
  procedure read_line_into(signal v : inout input_vec_t; L : inout line) is
    variable b : std_logic_vector(INPUT_WIDTH-1 downto 0);
  begin
    for i in v'range loop
      hread(L, b);
      v(i) <= unsigned(b);
    end loop;
  end procedure;

begin
  clk <= not clk after TCLK/2;

  UUT : entity work.KAN
    port map (clk => clk, en => en, input => din, output => dout);

  stim : process
    file fin  : text open read_mode is "demo_in_hex.txt";
    file flab : text open read_mode is "demo_label.txt";
    variable l_in, l_lab, Lo : line;
    variable lbl, gb, gm, pred : integer;
    variable total : integer := 0;
    variable correct : integer := 0;
  begin
    for k in 0 to 3 loop wait until rising_edge(clk); end loop;
    en <= '1';

    while not endfile(fin) loop
      readline(fin, l_in);   read_line_into(din, l_in);
      readline(flab, l_lab); read(l_lab, lbl);

      wait until rising_edge(clk);
      for k in 1 to LATENCY-1 loop wait until rising_edge(clk); end loop;
      wait for 1 ns;

      gb := to_integer(dout(0));   -- benign logit
      gm := to_integer(dout(1));   -- malicious logit
      if gm > gb then pred := 1; else pred := 0; end if;

      write(Lo, string'("vec "));  write(Lo, total);
      write(Lo, string'("  logits[benign="));   write(Lo, gb);
      write(Lo, string'(", malicious="));        write(Lo, gm);
      write(Lo, string'("]  pred="));
      if pred = 1 then write(Lo, string'("MALICIOUS")); else write(Lo, string'("BENIGN   ")); end if;
      write(Lo, string'("  true="));
      if lbl = 1 then write(Lo, string'("MALICIOUS")); else write(Lo, string'("BENIGN   ")); end if;
      if pred = lbl then write(Lo, string'("  [OK]")); correct := correct + 1;
      else                write(Lo, string'("  [WRONG]")); end if;
      report Lo.all severity note; deallocate(Lo);

      total := total + 1;
    end loop;

    report "=== Classifier accuracy: " & integer'image(correct) & "/" &
           integer'image(total) & " correct ===" severity note;
    wait;
  end process;
end architecture;
