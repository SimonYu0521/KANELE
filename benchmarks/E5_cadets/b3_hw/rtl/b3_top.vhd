-- =============================================================================
-- b3_top.vhd  --  log stream  ->  B3 preprocessing  ->  folded KAN core  ->  verdict
--
--   in_data (64 B/clk JSON-lines stream) --> b3_extract --> KAN (generated, input folded:
--   din = raw B3 bytes) --> d = logit_mal - logit_ben --> res_mal = (d >= THRESH)
--
-- One res_valid pulse per log line, in stream order, KAN_LAT+2 cycles after the line's
-- extraction (1 extract-output register, KAN pipeline, 1 decision register).
--   res_mal     : model says malicious at the configured threshold
--   res_err     : line failed the format guard (not classified)
--   res_forward : res_mal or res_err  -> send the line to the downstream IDS
--
-- THRESH (integer logit units, d in [-63, 63]); P(mal) = sigmoid(0.151659 * d):
--     tau = 0.5  -> 0   (argmax)      tau = 0.1   -> -14     tau = 0.01 -> -30
--     tau = 0.001 -> -45              floor (drop only the most-confident-benign
--                                     point mass d = -63) -> -62
-- =============================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PkgKAN.all;

entity b3_top is
  generic (
    THRESH  : integer := 0;
    KAN_LAT : natural := 8          -- KAN core: input sampled -> output valid (cycles)
  );
  port (
    clk           : in  std_logic;
    rst           : in  std_logic;
    in_valid      : in  std_logic;
    in_data       : in  std_logic_vector(511 downto 0);
    res_valid     : out std_logic;
    res_logit_ben : out signed(OUTPUT_WIDTH-1 downto 0);
    res_logit_mal : out signed(OUTPUT_WIDTH-1 downto 0);
    res_mal       : out std_logic;
    res_err       : out std_logic;
    res_forward   : out std_logic
  );
end entity;

architecture rtl of b3_top is
  signal ev_valid : std_logic;
  signal ev_vec   : std_logic_vector(511 downto 0);
  signal ev_err   : std_logic;
  signal din      : input_vec_t;
  signal dout     : output_vec_t;
  signal vpipe    : std_logic_vector(1 to KAN_LAT) := (others => '0');
  signal epipe    : std_logic_vector(1 to KAN_LAT) := (others => '0');
begin
  ext : entity work.b3_extract
    port map (clk => clk, rst => rst, in_valid => in_valid, in_data => in_data,
              out_valid => ev_valid, out_vec => ev_vec, out_err => ev_err);

  -- raw B3 bytes go straight into the core (the input transform is folded into layer 0)
  g_din : for i in 0 to N_INPUT-1 generate
    din(i) <= unsigned(ev_vec(8*i+7 downto 8*i));
  end generate;

  kan : entity work.KAN
    port map (clk => clk, en => '1', input => din, output => dout);

  process(clk)
    variable d : signed(OUTPUT_WIDTH downto 0);
    variable m : std_logic;
  begin
    if rising_edge(clk) then
      if rst = '1' then
        vpipe <= (others => '0'); epipe <= (others => '0'); res_valid <= '0';
      else
        vpipe <= ev_valid & vpipe(1 to KAN_LAT-1);
        epipe <= ev_err   & epipe(1 to KAN_LAT-1);
        d := resize(dout(1), OUTPUT_WIDTH+1) - resize(dout(0), OUTPUT_WIDTH+1);
        if d >= THRESH then m := '1'; else m := '0'; end if;
        res_valid     <= vpipe(KAN_LAT);
        res_logit_ben <= dout(0);
        res_logit_mal <= dout(1);
        res_mal       <= m;
        res_err       <= epipe(KAN_LAT);
        res_forward   <= m or epipe(KAN_LAT);
      end if;
    end if;
  end process;
end architecture;
