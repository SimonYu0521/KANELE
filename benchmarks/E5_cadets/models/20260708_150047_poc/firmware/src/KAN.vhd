library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PkgKAN.all;
use work.PkgLUT.all;

entity KAN is
  port (
    clk    : in  std_logic;
    en     : in  std_logic := '1';
    input  : in  input_vec_t;
    output : out output_vec_t
  );
end entity;

architecture rtl of KAN is
  -- === auto: signal declarations ===
  -- Layer 0 (64->16)
  signal act_0_0_14, act_0_1_14, act_0_3_0, act_0_3_2, act_0_3_4, act_0_3_10, act_0_3_14, act_0_9_3, act_0_9_14, act_0_10_6, act_0_10_14, act_0_12_0, act_0_12_1, act_0_12_2, act_0_12_3, act_0_12_4 : lut_output_t_0;
  signal act_0_12_5, act_0_12_6, act_0_12_7, act_0_12_8, act_0_12_9, act_0_12_10, act_0_12_11, act_0_12_13, act_0_12_14, act_0_12_15, act_0_13_0, act_0_13_1, act_0_13_2, act_0_13_3, act_0_13_4, act_0_13_5 : lut_output_t_0;
  signal act_0_13_6, act_0_13_7, act_0_13_8, act_0_13_9, act_0_13_10, act_0_13_11, act_0_13_12, act_0_13_13, act_0_13_14, act_0_13_15, act_0_14_0, act_0_14_1, act_0_14_2, act_0_14_3, act_0_14_4, act_0_14_5 : lut_output_t_0;
  signal act_0_14_6, act_0_14_7, act_0_14_8, act_0_14_9, act_0_14_10, act_0_14_11, act_0_14_12, act_0_14_14, act_0_15_0, act_0_15_2, act_0_15_3, act_0_15_4, act_0_15_5, act_0_15_6, act_0_15_10, act_0_15_13 : lut_output_t_0;
  signal act_0_15_14, act_0_15_15, act_0_16_1, act_0_16_2, act_0_16_3, act_0_16_10, act_0_16_15, act_0_17_1, act_0_18_6, act_0_18_10, act_0_19_15, act_0_22_3, act_0_22_6, act_0_23_6, act_0_24_1, act_0_24_3 : lut_output_t_0;
  signal act_0_24_6, act_0_29_0, act_0_29_2, act_0_29_10, act_0_29_12, act_0_30_0, act_0_30_1, act_0_30_3, act_0_30_6, act_0_30_10, act_0_30_12, act_0_30_14, act_0_31_1, act_0_31_2, act_0_31_3, act_0_31_10 : lut_output_t_0;
  signal act_0_31_11, act_0_31_12, act_0_31_14, act_0_32_0, act_0_32_1, act_0_32_2, act_0_32_5, act_0_32_12, act_0_32_14, act_0_33_0, act_0_33_1, act_0_33_2, act_0_33_3, act_0_33_4, act_0_33_6, act_0_33_8 : lut_output_t_0;
  signal act_0_33_9, act_0_33_10, act_0_33_11, act_0_33_12, act_0_33_13, act_0_33_14, act_0_33_15, act_0_34_0, act_0_34_1, act_0_34_2, act_0_34_3, act_0_34_4, act_0_34_6, act_0_34_7, act_0_34_9, act_0_34_10 : lut_output_t_0;
  signal act_0_34_11, act_0_34_12, act_0_34_13, act_0_34_15, act_0_35_0, act_0_35_1, act_0_35_2, act_0_35_3, act_0_35_8, act_0_35_10, act_0_35_11, act_0_35_12, act_0_35_13, act_0_35_14, act_0_36_0, act_0_36_1 : lut_output_t_0;
  signal act_0_36_2, act_0_36_3, act_0_36_4, act_0_36_5, act_0_36_6, act_0_36_7, act_0_36_8, act_0_36_10, act_0_36_11, act_0_36_14, act_0_36_15, act_0_37_0, act_0_37_1, act_0_37_2, act_0_37_3, act_0_37_4 : lut_output_t_0;
  signal act_0_37_6, act_0_37_7, act_0_37_9, act_0_37_10, act_0_37_11, act_0_37_12, act_0_37_13, act_0_37_14, act_0_38_0, act_0_38_1, act_0_38_2, act_0_38_3, act_0_38_4, act_0_38_5, act_0_38_6, act_0_38_7 : lut_output_t_0;
  signal act_0_38_8, act_0_38_9, act_0_38_10, act_0_38_11, act_0_38_12, act_0_38_14, act_0_38_15, act_0_39_0, act_0_39_3, act_0_39_4, act_0_39_6, act_0_39_7, act_0_39_9, act_0_39_10, act_0_39_11, act_0_39_12 : lut_output_t_0;
  signal act_0_39_13, act_0_39_15, act_0_40_0, act_0_40_1, act_0_40_2, act_0_40_3, act_0_40_4, act_0_40_5, act_0_40_6, act_0_40_8, act_0_40_9, act_0_40_10, act_0_40_12, act_0_40_14, act_0_41_0, act_0_41_1 : lut_output_t_0;
  signal act_0_41_2, act_0_41_4, act_0_41_5, act_0_41_6, act_0_41_7, act_0_41_9, act_0_41_10, act_0_41_11, act_0_41_12, act_0_41_13, act_0_41_14, act_0_41_15, act_0_42_0, act_0_42_1, act_0_42_2, act_0_42_3 : lut_output_t_0;
  signal act_0_42_4, act_0_42_6, act_0_42_7, act_0_42_9, act_0_42_10, act_0_42_11, act_0_42_12, act_0_42_14, act_0_43_0, act_0_43_1, act_0_43_2, act_0_43_3, act_0_43_4, act_0_43_6, act_0_43_8, act_0_43_10 : lut_output_t_0;
  signal act_0_43_12, act_0_43_13, act_0_43_14, act_0_44_0, act_0_44_2, act_0_44_3, act_0_44_7, act_0_44_9, act_0_44_10, act_0_44_11, act_0_44_15, act_0_45_0, act_0_45_1, act_0_45_2, act_0_45_3, act_0_45_5 : lut_output_t_0;
  signal act_0_45_6, act_0_45_8, act_0_45_9, act_0_45_10, act_0_45_11, act_0_45_12, act_0_45_13, act_0_45_15, act_0_46_0, act_0_46_2, act_0_46_8, act_0_46_10, act_0_46_15, act_0_47_12, act_0_48_0, act_0_48_6 : lut_output_t_0;
  signal act_0_48_12, act_0_48_15, act_0_49_0, act_0_49_12, act_0_50_0, act_0_50_2, act_0_50_4, act_0_50_8, act_0_50_12, act_0_50_15, act_0_51_1, act_0_51_2, act_0_51_3, act_0_51_7, act_0_51_8, act_0_51_13 : lut_output_t_0;
  signal act_0_51_14, act_0_52_1, act_0_52_6, act_0_52_8, act_0_52_15, act_0_53_3, act_0_53_7, act_0_53_8, act_0_53_10, act_0_53_13, act_0_53_14, act_0_54_2, act_0_54_7, act_0_54_9, act_0_54_15, act_0_55_2 : lut_output_t_0;
  signal act_0_55_6, act_0_55_9, act_0_55_10, act_0_56_0, act_0_56_6, act_0_56_14, act_0_56_15, act_0_59_3, act_0_59_6, act_0_59_10, act_0_59_14, act_0_60_6, act_0_60_7, act_0_60_10, act_0_60_11, act_0_60_14 : lut_output_t_0;
  signal act_0_60_15, act_0_63_10, act_0_63_12 : lut_output_t_0;
  signal out0_0, out0_1, out0_2, out0_3, out0_4, out0_5, out0_6, out0_7, out0_8, out0_9, out0_10, out0_11, out0_12, out0_13, out0_14, out0_15 : lut_output_t_0;
  signal out0_0_reg, out0_1_reg, out0_2_reg, out0_3_reg, out0_4_reg, out0_5_reg, out0_6_reg, out0_7_reg, out0_8_reg, out0_9_reg, out0_10_reg, out0_11_reg, out0_12_reg, out0_13_reg, out0_14_reg, out0_15_reg : lut_output_t_0;

-- Layer 1 (16->2)
  signal act_1_0_0, act_1_0_1, act_1_1_0, act_1_1_1, act_1_2_0, act_1_2_1, act_1_3_0, act_1_3_1, act_1_4_0, act_1_4_1, act_1_5_0, act_1_5_1, act_1_6_0, act_1_6_1, act_1_7_0, act_1_7_1 : lut_output_t_1;
  signal act_1_8_0, act_1_8_1, act_1_9_0, act_1_9_1, act_1_10_0, act_1_10_1, act_1_11_0, act_1_11_1, act_1_12_0, act_1_12_1, act_1_13_0, act_1_13_1, act_1_14_0, act_1_14_1, act_1_15_0, act_1_15_1 : lut_output_t_1;
begin

  -- === auto: layer blocks ===
  -- LAYER 0, ch 0
  gen_l0c0 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_0_0;
  signal s2_0, s2_1 : sum_t_0_0;
  signal sum_0_0 : sum_t_0_0;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_0.mem") port map (clk, input(3), act_0_3_0);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_0.mem") port map (clk, input(12), act_0_12_0);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_0.mem") port map (clk, input(13), act_0_13_0);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_0.mem") port map (clk, input(14), act_0_14_0);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_0.mem") port map (clk, input(15), act_0_15_0);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_0.mem") port map (clk, input(29), act_0_29_0);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_0.mem") port map (clk, input(30), act_0_30_0);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_0.mem") port map (clk, input(32), act_0_32_0);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_0.mem") port map (clk, input(33), act_0_33_0);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_0.mem") port map (clk, input(34), act_0_34_0);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_0.mem") port map (clk, input(35), act_0_35_0);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_0.mem") port map (clk, input(36), act_0_36_0);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_0.mem") port map (clk, input(37), act_0_37_0);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_0.mem") port map (clk, input(38), act_0_38_0);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_0.mem") port map (clk, input(39), act_0_39_0);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_0.mem") port map (clk, input(40), act_0_40_0);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_0.mem") port map (clk, input(41), act_0_41_0);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_0.mem") port map (clk, input(42), act_0_42_0);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_0.mem") port map (clk, input(43), act_0_43_0);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_0.mem") port map (clk, input(44), act_0_44_0);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_0.mem") port map (clk, input(45), act_0_45_0);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_0.mem") port map (clk, input(46), act_0_46_0);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_0.mem") port map (clk, input(48), act_0_48_0);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_0.mem") port map (clk, input(49), act_0_49_0);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_0.mem") port map (clk, input(50), act_0_50_0);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_0.mem") port map (clk, input(56), act_0_56_0);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_3_0, SUM_WIDTH_0_0) + resize(act_0_12_0, SUM_WIDTH_0_0) + resize(act_0_13_0, SUM_WIDTH_0_0) + resize(act_0_14_0, SUM_WIDTH_0_0);
        s1_1 <= resize(act_0_15_0, SUM_WIDTH_0_0) + resize(act_0_29_0, SUM_WIDTH_0_0) + resize(act_0_30_0, SUM_WIDTH_0_0) + resize(act_0_32_0, SUM_WIDTH_0_0);
        s1_2 <= resize(act_0_33_0, SUM_WIDTH_0_0) + resize(act_0_34_0, SUM_WIDTH_0_0) + resize(act_0_35_0, SUM_WIDTH_0_0) + resize(act_0_36_0, SUM_WIDTH_0_0);
        s1_3 <= resize(act_0_37_0, SUM_WIDTH_0_0) + resize(act_0_38_0, SUM_WIDTH_0_0) + resize(act_0_39_0, SUM_WIDTH_0_0) + resize(act_0_40_0, SUM_WIDTH_0_0);
        s1_4 <= resize(act_0_41_0, SUM_WIDTH_0_0) + resize(act_0_42_0, SUM_WIDTH_0_0) + resize(act_0_43_0, SUM_WIDTH_0_0) + resize(act_0_44_0, SUM_WIDTH_0_0);
        s1_5 <= resize(act_0_45_0, SUM_WIDTH_0_0) + resize(act_0_46_0, SUM_WIDTH_0_0) + resize(act_0_48_0, SUM_WIDTH_0_0) + resize(act_0_49_0, SUM_WIDTH_0_0);
        s1_6 <= resize(act_0_50_0, SUM_WIDTH_0_0) + resize(act_0_56_0, SUM_WIDTH_0_0);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_0_0 <= s2_0 + s2_1;
      end if;
    end process;
    out0_0 <= saturate(sum_0_0, 6);
  end block;

  -- LAYER 0, ch 1
  gen_l0c1 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5 : sum_t_0_1;
  signal s2_0, s2_1 : sum_t_0_1;
  signal sum_0_1 : sum_t_0_1;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_1.mem") port map (clk, input(12), act_0_12_1);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_1.mem") port map (clk, input(13), act_0_13_1);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_1.mem") port map (clk, input(14), act_0_14_1);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_1.mem") port map (clk, input(16), act_0_16_1);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_1.mem") port map (clk, input(17), act_0_17_1);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_1.mem") port map (clk, input(24), act_0_24_1);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_1.mem") port map (clk, input(30), act_0_30_1);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_1.mem") port map (clk, input(31), act_0_31_1);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_1.mem") port map (clk, input(32), act_0_32_1);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_1.mem") port map (clk, input(33), act_0_33_1);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_1.mem") port map (clk, input(34), act_0_34_1);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_1.mem") port map (clk, input(35), act_0_35_1);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_1.mem") port map (clk, input(36), act_0_36_1);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_1.mem") port map (clk, input(37), act_0_37_1);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_1.mem") port map (clk, input(38), act_0_38_1);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_1.mem") port map (clk, input(40), act_0_40_1);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_1.mem") port map (clk, input(41), act_0_41_1);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_1.mem") port map (clk, input(42), act_0_42_1);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_1.mem") port map (clk, input(43), act_0_43_1);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_1.mem") port map (clk, input(45), act_0_45_1);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_1.mem") port map (clk, input(51), act_0_51_1);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_1.mem") port map (clk, input(52), act_0_52_1);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_12_1, SUM_WIDTH_0_1) + resize(act_0_13_1, SUM_WIDTH_0_1) + resize(act_0_14_1, SUM_WIDTH_0_1) + resize(act_0_16_1, SUM_WIDTH_0_1);
        s1_1 <= resize(act_0_17_1, SUM_WIDTH_0_1) + resize(act_0_24_1, SUM_WIDTH_0_1) + resize(act_0_30_1, SUM_WIDTH_0_1) + resize(act_0_31_1, SUM_WIDTH_0_1);
        s1_2 <= resize(act_0_32_1, SUM_WIDTH_0_1) + resize(act_0_33_1, SUM_WIDTH_0_1) + resize(act_0_34_1, SUM_WIDTH_0_1) + resize(act_0_35_1, SUM_WIDTH_0_1);
        s1_3 <= resize(act_0_36_1, SUM_WIDTH_0_1) + resize(act_0_37_1, SUM_WIDTH_0_1) + resize(act_0_38_1, SUM_WIDTH_0_1) + resize(act_0_40_1, SUM_WIDTH_0_1);
        s1_4 <= resize(act_0_41_1, SUM_WIDTH_0_1) + resize(act_0_42_1, SUM_WIDTH_0_1) + resize(act_0_43_1, SUM_WIDTH_0_1) + resize(act_0_45_1, SUM_WIDTH_0_1);
        s1_5 <= resize(act_0_51_1, SUM_WIDTH_0_1) + resize(act_0_52_1, SUM_WIDTH_0_1);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5;
        -- Stage 3
        sum_0_1 <= s2_0 + s2_1;
      end if;
    end process;
    out0_1 <= saturate(sum_0_1, 6);
  end block;

  -- LAYER 0, ch 2
  gen_l0c2 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_0_2;
  signal s2_0, s2_1 : sum_t_0_2;
  signal sum_0_2 : sum_t_0_2;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_2.mem") port map (clk, input(3), act_0_3_2);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_2.mem") port map (clk, input(12), act_0_12_2);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_2.mem") port map (clk, input(13), act_0_13_2);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_2.mem") port map (clk, input(14), act_0_14_2);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_2.mem") port map (clk, input(15), act_0_15_2);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_2.mem") port map (clk, input(16), act_0_16_2);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_2.mem") port map (clk, input(29), act_0_29_2);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_2.mem") port map (clk, input(31), act_0_31_2);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_2.mem") port map (clk, input(32), act_0_32_2);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_2.mem") port map (clk, input(33), act_0_33_2);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_2.mem") port map (clk, input(34), act_0_34_2);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_2.mem") port map (clk, input(35), act_0_35_2);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_2.mem") port map (clk, input(36), act_0_36_2);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_2.mem") port map (clk, input(37), act_0_37_2);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_2.mem") port map (clk, input(38), act_0_38_2);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_2.mem") port map (clk, input(40), act_0_40_2);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_2.mem") port map (clk, input(41), act_0_41_2);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_2.mem") port map (clk, input(42), act_0_42_2);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_2.mem") port map (clk, input(43), act_0_43_2);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_2.mem") port map (clk, input(44), act_0_44_2);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_2.mem") port map (clk, input(45), act_0_45_2);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_2.mem") port map (clk, input(46), act_0_46_2);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_2.mem") port map (clk, input(50), act_0_50_2);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_2.mem") port map (clk, input(51), act_0_51_2);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_2.mem") port map (clk, input(54), act_0_54_2);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_2.mem") port map (clk, input(55), act_0_55_2);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_3_2, SUM_WIDTH_0_2) + resize(act_0_12_2, SUM_WIDTH_0_2) + resize(act_0_13_2, SUM_WIDTH_0_2) + resize(act_0_14_2, SUM_WIDTH_0_2);
        s1_1 <= resize(act_0_15_2, SUM_WIDTH_0_2) + resize(act_0_16_2, SUM_WIDTH_0_2) + resize(act_0_29_2, SUM_WIDTH_0_2) + resize(act_0_31_2, SUM_WIDTH_0_2);
        s1_2 <= resize(act_0_32_2, SUM_WIDTH_0_2) + resize(act_0_33_2, SUM_WIDTH_0_2) + resize(act_0_34_2, SUM_WIDTH_0_2) + resize(act_0_35_2, SUM_WIDTH_0_2);
        s1_3 <= resize(act_0_36_2, SUM_WIDTH_0_2) + resize(act_0_37_2, SUM_WIDTH_0_2) + resize(act_0_38_2, SUM_WIDTH_0_2) + resize(act_0_40_2, SUM_WIDTH_0_2);
        s1_4 <= resize(act_0_41_2, SUM_WIDTH_0_2) + resize(act_0_42_2, SUM_WIDTH_0_2) + resize(act_0_43_2, SUM_WIDTH_0_2) + resize(act_0_44_2, SUM_WIDTH_0_2);
        s1_5 <= resize(act_0_45_2, SUM_WIDTH_0_2) + resize(act_0_46_2, SUM_WIDTH_0_2) + resize(act_0_50_2, SUM_WIDTH_0_2) + resize(act_0_51_2, SUM_WIDTH_0_2);
        s1_6 <= resize(act_0_54_2, SUM_WIDTH_0_2) + resize(act_0_55_2, SUM_WIDTH_0_2);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_0_2 <= s2_0 + s2_1;
      end if;
    end process;
    out0_2 <= saturate(sum_0_2, 6);
  end block;

  -- LAYER 0, ch 3
  gen_l0c3 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_0_3;
  signal s2_0, s2_1 : sum_t_0_3;
  signal sum_0_3 : sum_t_0_3;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_3.mem") port map (clk, input(9), act_0_9_3);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_3.mem") port map (clk, input(12), act_0_12_3);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_3.mem") port map (clk, input(13), act_0_13_3);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_3.mem") port map (clk, input(14), act_0_14_3);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_3.mem") port map (clk, input(15), act_0_15_3);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_3.mem") port map (clk, input(16), act_0_16_3);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_3.mem") port map (clk, input(22), act_0_22_3);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_3.mem") port map (clk, input(24), act_0_24_3);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_3.mem") port map (clk, input(30), act_0_30_3);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_3.mem") port map (clk, input(31), act_0_31_3);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_3.mem") port map (clk, input(33), act_0_33_3);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_3.mem") port map (clk, input(34), act_0_34_3);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_3.mem") port map (clk, input(35), act_0_35_3);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_3.mem") port map (clk, input(36), act_0_36_3);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_3.mem") port map (clk, input(37), act_0_37_3);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_3.mem") port map (clk, input(38), act_0_38_3);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_3.mem") port map (clk, input(39), act_0_39_3);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_3.mem") port map (clk, input(40), act_0_40_3);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_3.mem") port map (clk, input(42), act_0_42_3);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_3.mem") port map (clk, input(43), act_0_43_3);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_3.mem") port map (clk, input(44), act_0_44_3);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_3.mem") port map (clk, input(45), act_0_45_3);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_3.mem") port map (clk, input(51), act_0_51_3);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_3.mem") port map (clk, input(53), act_0_53_3);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_3.mem") port map (clk, input(59), act_0_59_3);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_9_3, SUM_WIDTH_0_3) + resize(act_0_12_3, SUM_WIDTH_0_3) + resize(act_0_13_3, SUM_WIDTH_0_3) + resize(act_0_14_3, SUM_WIDTH_0_3);
        s1_1 <= resize(act_0_15_3, SUM_WIDTH_0_3) + resize(act_0_16_3, SUM_WIDTH_0_3) + resize(act_0_22_3, SUM_WIDTH_0_3) + resize(act_0_24_3, SUM_WIDTH_0_3);
        s1_2 <= resize(act_0_30_3, SUM_WIDTH_0_3) + resize(act_0_31_3, SUM_WIDTH_0_3) + resize(act_0_33_3, SUM_WIDTH_0_3) + resize(act_0_34_3, SUM_WIDTH_0_3);
        s1_3 <= resize(act_0_35_3, SUM_WIDTH_0_3) + resize(act_0_36_3, SUM_WIDTH_0_3) + resize(act_0_37_3, SUM_WIDTH_0_3) + resize(act_0_38_3, SUM_WIDTH_0_3);
        s1_4 <= resize(act_0_39_3, SUM_WIDTH_0_3) + resize(act_0_40_3, SUM_WIDTH_0_3) + resize(act_0_42_3, SUM_WIDTH_0_3) + resize(act_0_43_3, SUM_WIDTH_0_3);
        s1_5 <= resize(act_0_44_3, SUM_WIDTH_0_3) + resize(act_0_45_3, SUM_WIDTH_0_3) + resize(act_0_51_3, SUM_WIDTH_0_3) + resize(act_0_53_3, SUM_WIDTH_0_3);
        s1_6 <= resize(act_0_59_3, SUM_WIDTH_0_3);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_0_3 <= s2_0 + s2_1;
      end if;
    end process;
    out0_3 <= saturate(sum_0_3, 6);
  end block;

  -- LAYER 0, ch 4
  gen_l0c4 : block
  signal s1_0, s1_1, s1_2, s1_3 : sum_t_0_4;
  signal s2_0 : sum_t_0_4;
  signal sum_0_4 : sum_t_0_4;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_4.mem") port map (clk, input(3), act_0_3_4);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_4.mem") port map (clk, input(12), act_0_12_4);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_4.mem") port map (clk, input(13), act_0_13_4);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_4.mem") port map (clk, input(14), act_0_14_4);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_4.mem") port map (clk, input(15), act_0_15_4);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_4.mem") port map (clk, input(33), act_0_33_4);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_4.mem") port map (clk, input(34), act_0_34_4);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_4.mem") port map (clk, input(36), act_0_36_4);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_4.mem") port map (clk, input(37), act_0_37_4);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_4.mem") port map (clk, input(38), act_0_38_4);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_4.mem") port map (clk, input(39), act_0_39_4);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_4.mem") port map (clk, input(40), act_0_40_4);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_4.mem") port map (clk, input(41), act_0_41_4);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_4.mem") port map (clk, input(42), act_0_42_4);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_4.mem") port map (clk, input(43), act_0_43_4);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_4.mem") port map (clk, input(50), act_0_50_4);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_3_4, SUM_WIDTH_0_4) + resize(act_0_12_4, SUM_WIDTH_0_4) + resize(act_0_13_4, SUM_WIDTH_0_4) + resize(act_0_14_4, SUM_WIDTH_0_4);
        s1_1 <= resize(act_0_15_4, SUM_WIDTH_0_4) + resize(act_0_33_4, SUM_WIDTH_0_4) + resize(act_0_34_4, SUM_WIDTH_0_4) + resize(act_0_36_4, SUM_WIDTH_0_4);
        s1_2 <= resize(act_0_37_4, SUM_WIDTH_0_4) + resize(act_0_38_4, SUM_WIDTH_0_4) + resize(act_0_39_4, SUM_WIDTH_0_4) + resize(act_0_40_4, SUM_WIDTH_0_4);
        s1_3 <= resize(act_0_41_4, SUM_WIDTH_0_4) + resize(act_0_42_4, SUM_WIDTH_0_4) + resize(act_0_43_4, SUM_WIDTH_0_4) + resize(act_0_50_4, SUM_WIDTH_0_4);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        -- Stage 3
        sum_0_4 <= s2_0;
      end if;
    end process;
    out0_4 <= saturate(sum_0_4, 6);
  end block;

  -- LAYER 0, ch 5
  gen_l0c5 : block
  signal s1_0, s1_1, s1_2 : sum_t_0_5;
  signal s2_0 : sum_t_0_5;
  signal sum_0_5 : sum_t_0_5;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_5.mem") port map (clk, input(12), act_0_12_5);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_5.mem") port map (clk, input(13), act_0_13_5);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_5.mem") port map (clk, input(14), act_0_14_5);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_5.mem") port map (clk, input(15), act_0_15_5);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_5.mem") port map (clk, input(32), act_0_32_5);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_5.mem") port map (clk, input(36), act_0_36_5);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_5.mem") port map (clk, input(38), act_0_38_5);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_5.mem") port map (clk, input(40), act_0_40_5);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_5.mem") port map (clk, input(41), act_0_41_5);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_5.mem") port map (clk, input(45), act_0_45_5);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_12_5, SUM_WIDTH_0_5) + resize(act_0_13_5, SUM_WIDTH_0_5) + resize(act_0_14_5, SUM_WIDTH_0_5) + resize(act_0_15_5, SUM_WIDTH_0_5);
        s1_1 <= resize(act_0_32_5, SUM_WIDTH_0_5) + resize(act_0_36_5, SUM_WIDTH_0_5) + resize(act_0_38_5, SUM_WIDTH_0_5) + resize(act_0_40_5, SUM_WIDTH_0_5);
        s1_2 <= resize(act_0_41_5, SUM_WIDTH_0_5) + resize(act_0_45_5, SUM_WIDTH_0_5);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2;
        -- Stage 3
        sum_0_5 <= s2_0;
      end if;
    end process;
    out0_5 <= saturate(sum_0_5, 6);
  end block;

  -- LAYER 0, ch 6
  gen_l0c6 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_0_6;
  signal s2_0, s2_1 : sum_t_0_6;
  signal sum_0_6 : sum_t_0_6;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_6.mem") port map (clk, input(10), act_0_10_6);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_6.mem") port map (clk, input(12), act_0_12_6);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_6.mem") port map (clk, input(13), act_0_13_6);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_6.mem") port map (clk, input(14), act_0_14_6);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_6.mem") port map (clk, input(15), act_0_15_6);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_6.mem") port map (clk, input(18), act_0_18_6);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_6.mem") port map (clk, input(22), act_0_22_6);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_6.mem") port map (clk, input(23), act_0_23_6);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_6.mem") port map (clk, input(24), act_0_24_6);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_6.mem") port map (clk, input(30), act_0_30_6);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_6.mem") port map (clk, input(33), act_0_33_6);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_6.mem") port map (clk, input(34), act_0_34_6);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_6.mem") port map (clk, input(36), act_0_36_6);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_6.mem") port map (clk, input(37), act_0_37_6);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_6.mem") port map (clk, input(38), act_0_38_6);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_6.mem") port map (clk, input(39), act_0_39_6);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_6.mem") port map (clk, input(40), act_0_40_6);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_6.mem") port map (clk, input(41), act_0_41_6);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_6.mem") port map (clk, input(42), act_0_42_6);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_6.mem") port map (clk, input(43), act_0_43_6);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_6.mem") port map (clk, input(45), act_0_45_6);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_6.mem") port map (clk, input(48), act_0_48_6);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_6.mem") port map (clk, input(52), act_0_52_6);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_6.mem") port map (clk, input(55), act_0_55_6);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_6.mem") port map (clk, input(56), act_0_56_6);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_6.mem") port map (clk, input(59), act_0_59_6);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_6.mem") port map (clk, input(60), act_0_60_6);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_10_6, SUM_WIDTH_0_6) + resize(act_0_12_6, SUM_WIDTH_0_6) + resize(act_0_13_6, SUM_WIDTH_0_6) + resize(act_0_14_6, SUM_WIDTH_0_6);
        s1_1 <= resize(act_0_15_6, SUM_WIDTH_0_6) + resize(act_0_18_6, SUM_WIDTH_0_6) + resize(act_0_22_6, SUM_WIDTH_0_6) + resize(act_0_23_6, SUM_WIDTH_0_6);
        s1_2 <= resize(act_0_24_6, SUM_WIDTH_0_6) + resize(act_0_30_6, SUM_WIDTH_0_6) + resize(act_0_33_6, SUM_WIDTH_0_6) + resize(act_0_34_6, SUM_WIDTH_0_6);
        s1_3 <= resize(act_0_36_6, SUM_WIDTH_0_6) + resize(act_0_37_6, SUM_WIDTH_0_6) + resize(act_0_38_6, SUM_WIDTH_0_6) + resize(act_0_39_6, SUM_WIDTH_0_6);
        s1_4 <= resize(act_0_40_6, SUM_WIDTH_0_6) + resize(act_0_41_6, SUM_WIDTH_0_6) + resize(act_0_42_6, SUM_WIDTH_0_6) + resize(act_0_43_6, SUM_WIDTH_0_6);
        s1_5 <= resize(act_0_45_6, SUM_WIDTH_0_6) + resize(act_0_48_6, SUM_WIDTH_0_6) + resize(act_0_52_6, SUM_WIDTH_0_6) + resize(act_0_55_6, SUM_WIDTH_0_6);
        s1_6 <= resize(act_0_56_6, SUM_WIDTH_0_6) + resize(act_0_59_6, SUM_WIDTH_0_6) + resize(act_0_60_6, SUM_WIDTH_0_6);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_0_6 <= s2_0 + s2_1;
      end if;
    end process;
    out0_6 <= saturate(sum_0_6, 6);
  end block;

  -- LAYER 0, ch 7
  gen_l0c7 : block
  signal s1_0, s1_1, s1_2, s1_3 : sum_t_0_7;
  signal s2_0 : sum_t_0_7;
  signal sum_0_7 : sum_t_0_7;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_7.mem") port map (clk, input(12), act_0_12_7);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_7.mem") port map (clk, input(13), act_0_13_7);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_7.mem") port map (clk, input(14), act_0_14_7);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_7.mem") port map (clk, input(34), act_0_34_7);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_7.mem") port map (clk, input(36), act_0_36_7);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_7.mem") port map (clk, input(37), act_0_37_7);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_7.mem") port map (clk, input(38), act_0_38_7);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_7.mem") port map (clk, input(39), act_0_39_7);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_7.mem") port map (clk, input(41), act_0_41_7);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_7.mem") port map (clk, input(42), act_0_42_7);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_7.mem") port map (clk, input(44), act_0_44_7);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_7.mem") port map (clk, input(51), act_0_51_7);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_7.mem") port map (clk, input(53), act_0_53_7);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_7.mem") port map (clk, input(54), act_0_54_7);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_7.mem") port map (clk, input(60), act_0_60_7);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_12_7, SUM_WIDTH_0_7) + resize(act_0_13_7, SUM_WIDTH_0_7) + resize(act_0_14_7, SUM_WIDTH_0_7) + resize(act_0_34_7, SUM_WIDTH_0_7);
        s1_1 <= resize(act_0_36_7, SUM_WIDTH_0_7) + resize(act_0_37_7, SUM_WIDTH_0_7) + resize(act_0_38_7, SUM_WIDTH_0_7) + resize(act_0_39_7, SUM_WIDTH_0_7);
        s1_2 <= resize(act_0_41_7, SUM_WIDTH_0_7) + resize(act_0_42_7, SUM_WIDTH_0_7) + resize(act_0_44_7, SUM_WIDTH_0_7) + resize(act_0_51_7, SUM_WIDTH_0_7);
        s1_3 <= resize(act_0_53_7, SUM_WIDTH_0_7) + resize(act_0_54_7, SUM_WIDTH_0_7) + resize(act_0_60_7, SUM_WIDTH_0_7);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        -- Stage 3
        sum_0_7 <= s2_0;
      end if;
    end process;
    out0_7 <= saturate(sum_0_7, 6);
  end block;

  -- LAYER 0, ch 8
  gen_l0c8 : block
  signal s1_0, s1_1, s1_2, s1_3 : sum_t_0_8;
  signal s2_0 : sum_t_0_8;
  signal sum_0_8 : sum_t_0_8;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_8.mem") port map (clk, input(12), act_0_12_8);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_8.mem") port map (clk, input(13), act_0_13_8);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_8.mem") port map (clk, input(14), act_0_14_8);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_8.mem") port map (clk, input(33), act_0_33_8);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_8.mem") port map (clk, input(35), act_0_35_8);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_8.mem") port map (clk, input(36), act_0_36_8);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_8.mem") port map (clk, input(38), act_0_38_8);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_8.mem") port map (clk, input(40), act_0_40_8);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_8.mem") port map (clk, input(43), act_0_43_8);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_8.mem") port map (clk, input(45), act_0_45_8);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_8.mem") port map (clk, input(46), act_0_46_8);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_8.mem") port map (clk, input(50), act_0_50_8);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_8.mem") port map (clk, input(51), act_0_51_8);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_8.mem") port map (clk, input(52), act_0_52_8);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_8.mem") port map (clk, input(53), act_0_53_8);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_12_8, SUM_WIDTH_0_8) + resize(act_0_13_8, SUM_WIDTH_0_8) + resize(act_0_14_8, SUM_WIDTH_0_8) + resize(act_0_33_8, SUM_WIDTH_0_8);
        s1_1 <= resize(act_0_35_8, SUM_WIDTH_0_8) + resize(act_0_36_8, SUM_WIDTH_0_8) + resize(act_0_38_8, SUM_WIDTH_0_8) + resize(act_0_40_8, SUM_WIDTH_0_8);
        s1_2 <= resize(act_0_43_8, SUM_WIDTH_0_8) + resize(act_0_45_8, SUM_WIDTH_0_8) + resize(act_0_46_8, SUM_WIDTH_0_8) + resize(act_0_50_8, SUM_WIDTH_0_8);
        s1_3 <= resize(act_0_51_8, SUM_WIDTH_0_8) + resize(act_0_52_8, SUM_WIDTH_0_8) + resize(act_0_53_8, SUM_WIDTH_0_8);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        -- Stage 3
        sum_0_8 <= s2_0;
      end if;
    end process;
    out0_8 <= saturate(sum_0_8, 6);
  end block;

  -- LAYER 0, ch 9
  gen_l0c9 : block
  signal s1_0, s1_1, s1_2, s1_3 : sum_t_0_9;
  signal s2_0 : sum_t_0_9;
  signal sum_0_9 : sum_t_0_9;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_9.mem") port map (clk, input(12), act_0_12_9);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_9.mem") port map (clk, input(13), act_0_13_9);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_9.mem") port map (clk, input(14), act_0_14_9);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_9.mem") port map (clk, input(33), act_0_33_9);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_9.mem") port map (clk, input(34), act_0_34_9);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_9.mem") port map (clk, input(37), act_0_37_9);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_9.mem") port map (clk, input(38), act_0_38_9);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_9.mem") port map (clk, input(39), act_0_39_9);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_9.mem") port map (clk, input(40), act_0_40_9);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_9.mem") port map (clk, input(41), act_0_41_9);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_9.mem") port map (clk, input(42), act_0_42_9);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_9.mem") port map (clk, input(44), act_0_44_9);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_9.mem") port map (clk, input(45), act_0_45_9);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_9.mem") port map (clk, input(54), act_0_54_9);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_9.mem") port map (clk, input(55), act_0_55_9);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_12_9, SUM_WIDTH_0_9) + resize(act_0_13_9, SUM_WIDTH_0_9) + resize(act_0_14_9, SUM_WIDTH_0_9) + resize(act_0_33_9, SUM_WIDTH_0_9);
        s1_1 <= resize(act_0_34_9, SUM_WIDTH_0_9) + resize(act_0_37_9, SUM_WIDTH_0_9) + resize(act_0_38_9, SUM_WIDTH_0_9) + resize(act_0_39_9, SUM_WIDTH_0_9);
        s1_2 <= resize(act_0_40_9, SUM_WIDTH_0_9) + resize(act_0_41_9, SUM_WIDTH_0_9) + resize(act_0_42_9, SUM_WIDTH_0_9) + resize(act_0_44_9, SUM_WIDTH_0_9);
        s1_3 <= resize(act_0_45_9, SUM_WIDTH_0_9) + resize(act_0_54_9, SUM_WIDTH_0_9) + resize(act_0_55_9, SUM_WIDTH_0_9);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        -- Stage 3
        sum_0_9 <= s2_0;
      end if;
    end process;
    out0_9 <= saturate(sum_0_9, 6);
  end block;

  -- LAYER 0, ch 10
  gen_l0c10 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7 : sum_t_0_10;
  signal s2_0, s2_1 : sum_t_0_10;
  signal sum_0_10 : sum_t_0_10;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_10.mem") port map (clk, input(3), act_0_3_10);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_10.mem") port map (clk, input(12), act_0_12_10);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_10.mem") port map (clk, input(13), act_0_13_10);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_10.mem") port map (clk, input(14), act_0_14_10);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_10.mem") port map (clk, input(15), act_0_15_10);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_10.mem") port map (clk, input(16), act_0_16_10);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_18_10.mem") port map (clk, input(18), act_0_18_10);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_10.mem") port map (clk, input(29), act_0_29_10);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_10.mem") port map (clk, input(30), act_0_30_10);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_10.mem") port map (clk, input(31), act_0_31_10);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_10.mem") port map (clk, input(33), act_0_33_10);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_10.mem") port map (clk, input(34), act_0_34_10);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_10.mem") port map (clk, input(35), act_0_35_10);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_10.mem") port map (clk, input(36), act_0_36_10);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_10.mem") port map (clk, input(37), act_0_37_10);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_10.mem") port map (clk, input(38), act_0_38_10);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_10.mem") port map (clk, input(39), act_0_39_10);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_10.mem") port map (clk, input(40), act_0_40_10);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_10.mem") port map (clk, input(41), act_0_41_10);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_10.mem") port map (clk, input(42), act_0_42_10);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_10.mem") port map (clk, input(43), act_0_43_10);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_10.mem") port map (clk, input(44), act_0_44_10);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_10.mem") port map (clk, input(45), act_0_45_10);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_10.mem") port map (clk, input(46), act_0_46_10);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_10.mem") port map (clk, input(53), act_0_53_10);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_10.mem") port map (clk, input(55), act_0_55_10);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_10.mem") port map (clk, input(59), act_0_59_10);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_10.mem") port map (clk, input(60), act_0_60_10);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_10.mem") port map (clk, input(63), act_0_63_10);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_3_10, SUM_WIDTH_0_10) + resize(act_0_12_10, SUM_WIDTH_0_10) + resize(act_0_13_10, SUM_WIDTH_0_10) + resize(act_0_14_10, SUM_WIDTH_0_10);
        s1_1 <= resize(act_0_15_10, SUM_WIDTH_0_10) + resize(act_0_16_10, SUM_WIDTH_0_10) + resize(act_0_18_10, SUM_WIDTH_0_10) + resize(act_0_29_10, SUM_WIDTH_0_10);
        s1_2 <= resize(act_0_30_10, SUM_WIDTH_0_10) + resize(act_0_31_10, SUM_WIDTH_0_10) + resize(act_0_33_10, SUM_WIDTH_0_10) + resize(act_0_34_10, SUM_WIDTH_0_10);
        s1_3 <= resize(act_0_35_10, SUM_WIDTH_0_10) + resize(act_0_36_10, SUM_WIDTH_0_10) + resize(act_0_37_10, SUM_WIDTH_0_10) + resize(act_0_38_10, SUM_WIDTH_0_10);
        s1_4 <= resize(act_0_39_10, SUM_WIDTH_0_10) + resize(act_0_40_10, SUM_WIDTH_0_10) + resize(act_0_41_10, SUM_WIDTH_0_10) + resize(act_0_42_10, SUM_WIDTH_0_10);
        s1_5 <= resize(act_0_43_10, SUM_WIDTH_0_10) + resize(act_0_44_10, SUM_WIDTH_0_10) + resize(act_0_45_10, SUM_WIDTH_0_10) + resize(act_0_46_10, SUM_WIDTH_0_10);
        s1_6 <= resize(act_0_53_10, SUM_WIDTH_0_10) + resize(act_0_55_10, SUM_WIDTH_0_10) + resize(act_0_59_10, SUM_WIDTH_0_10) + resize(act_0_60_10, SUM_WIDTH_0_10);
        s1_7 <= resize(act_0_63_10, SUM_WIDTH_0_10);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        -- Stage 3
        sum_0_10 <= s2_0 + s2_1;
      end if;
    end process;
    out0_10 <= saturate(sum_0_10, 6);
  end block;

  -- LAYER 0, ch 11
  gen_l0c11 : block
  signal s1_0, s1_1, s1_2, s1_3 : sum_t_0_11;
  signal s2_0 : sum_t_0_11;
  signal sum_0_11 : sum_t_0_11;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_11.mem") port map (clk, input(12), act_0_12_11);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_11.mem") port map (clk, input(13), act_0_13_11);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_11.mem") port map (clk, input(14), act_0_14_11);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_11.mem") port map (clk, input(31), act_0_31_11);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_11.mem") port map (clk, input(33), act_0_33_11);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_11.mem") port map (clk, input(34), act_0_34_11);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_11.mem") port map (clk, input(35), act_0_35_11);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_11.mem") port map (clk, input(36), act_0_36_11);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_11.mem") port map (clk, input(37), act_0_37_11);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_11.mem") port map (clk, input(38), act_0_38_11);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_11.mem") port map (clk, input(39), act_0_39_11);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_11.mem") port map (clk, input(41), act_0_41_11);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_11.mem") port map (clk, input(42), act_0_42_11);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_11.mem") port map (clk, input(44), act_0_44_11);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_11.mem") port map (clk, input(45), act_0_45_11);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_11.mem") port map (clk, input(60), act_0_60_11);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_12_11, SUM_WIDTH_0_11) + resize(act_0_13_11, SUM_WIDTH_0_11) + resize(act_0_14_11, SUM_WIDTH_0_11) + resize(act_0_31_11, SUM_WIDTH_0_11);
        s1_1 <= resize(act_0_33_11, SUM_WIDTH_0_11) + resize(act_0_34_11, SUM_WIDTH_0_11) + resize(act_0_35_11, SUM_WIDTH_0_11) + resize(act_0_36_11, SUM_WIDTH_0_11);
        s1_2 <= resize(act_0_37_11, SUM_WIDTH_0_11) + resize(act_0_38_11, SUM_WIDTH_0_11) + resize(act_0_39_11, SUM_WIDTH_0_11) + resize(act_0_41_11, SUM_WIDTH_0_11);
        s1_3 <= resize(act_0_42_11, SUM_WIDTH_0_11) + resize(act_0_44_11, SUM_WIDTH_0_11) + resize(act_0_45_11, SUM_WIDTH_0_11) + resize(act_0_60_11, SUM_WIDTH_0_11);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        -- Stage 3
        sum_0_11 <= s2_0;
      end if;
    end process;
    out0_11 <= saturate(sum_0_11, 6);
  end block;

  -- LAYER 0, ch 12
  gen_l0c12 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5 : sum_t_0_12;
  signal s2_0, s2_1 : sum_t_0_12;
  signal sum_0_12 : sum_t_0_12;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_12.mem") port map (clk, input(13), act_0_13_12);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_12.mem") port map (clk, input(14), act_0_14_12);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_12.mem") port map (clk, input(29), act_0_29_12);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_12.mem") port map (clk, input(30), act_0_30_12);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_12.mem") port map (clk, input(31), act_0_31_12);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_12.mem") port map (clk, input(32), act_0_32_12);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_12.mem") port map (clk, input(33), act_0_33_12);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_12.mem") port map (clk, input(34), act_0_34_12);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_12.mem") port map (clk, input(35), act_0_35_12);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_12.mem") port map (clk, input(37), act_0_37_12);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_12.mem") port map (clk, input(38), act_0_38_12);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_12.mem") port map (clk, input(39), act_0_39_12);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_12.mem") port map (clk, input(40), act_0_40_12);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_12.mem") port map (clk, input(41), act_0_41_12);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_12.mem") port map (clk, input(42), act_0_42_12);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_12.mem") port map (clk, input(43), act_0_43_12);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_12.mem") port map (clk, input(45), act_0_45_12);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_12.mem") port map (clk, input(47), act_0_47_12);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_12.mem") port map (clk, input(48), act_0_48_12);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_12.mem") port map (clk, input(49), act_0_49_12);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_12.mem") port map (clk, input(50), act_0_50_12);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_12.mem") port map (clk, input(63), act_0_63_12);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_13_12, SUM_WIDTH_0_12) + resize(act_0_14_12, SUM_WIDTH_0_12) + resize(act_0_29_12, SUM_WIDTH_0_12) + resize(act_0_30_12, SUM_WIDTH_0_12);
        s1_1 <= resize(act_0_31_12, SUM_WIDTH_0_12) + resize(act_0_32_12, SUM_WIDTH_0_12) + resize(act_0_33_12, SUM_WIDTH_0_12) + resize(act_0_34_12, SUM_WIDTH_0_12);
        s1_2 <= resize(act_0_35_12, SUM_WIDTH_0_12) + resize(act_0_37_12, SUM_WIDTH_0_12) + resize(act_0_38_12, SUM_WIDTH_0_12) + resize(act_0_39_12, SUM_WIDTH_0_12);
        s1_3 <= resize(act_0_40_12, SUM_WIDTH_0_12) + resize(act_0_41_12, SUM_WIDTH_0_12) + resize(act_0_42_12, SUM_WIDTH_0_12) + resize(act_0_43_12, SUM_WIDTH_0_12);
        s1_4 <= resize(act_0_45_12, SUM_WIDTH_0_12) + resize(act_0_47_12, SUM_WIDTH_0_12) + resize(act_0_48_12, SUM_WIDTH_0_12) + resize(act_0_49_12, SUM_WIDTH_0_12);
        s1_5 <= resize(act_0_50_12, SUM_WIDTH_0_12) + resize(act_0_63_12, SUM_WIDTH_0_12);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5;
        -- Stage 3
        sum_0_12 <= s2_0 + s2_1;
      end if;
    end process;
    out0_12 <= saturate(sum_0_12, 6);
  end block;

  -- LAYER 0, ch 13
  gen_l0c13 : block
  signal s1_0, s1_1, s1_2, s1_3 : sum_t_0_13;
  signal s2_0 : sum_t_0_13;
  signal sum_0_13 : sum_t_0_13;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_13.mem") port map (clk, input(12), act_0_12_13);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_13.mem") port map (clk, input(13), act_0_13_13);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_13.mem") port map (clk, input(15), act_0_15_13);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_13.mem") port map (clk, input(33), act_0_33_13);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_13.mem") port map (clk, input(34), act_0_34_13);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_13.mem") port map (clk, input(35), act_0_35_13);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_13.mem") port map (clk, input(37), act_0_37_13);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_13.mem") port map (clk, input(39), act_0_39_13);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_13.mem") port map (clk, input(41), act_0_41_13);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_13.mem") port map (clk, input(43), act_0_43_13);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_13.mem") port map (clk, input(45), act_0_45_13);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_13.mem") port map (clk, input(51), act_0_51_13);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_13.mem") port map (clk, input(53), act_0_53_13);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_12_13, SUM_WIDTH_0_13) + resize(act_0_13_13, SUM_WIDTH_0_13) + resize(act_0_15_13, SUM_WIDTH_0_13) + resize(act_0_33_13, SUM_WIDTH_0_13);
        s1_1 <= resize(act_0_34_13, SUM_WIDTH_0_13) + resize(act_0_35_13, SUM_WIDTH_0_13) + resize(act_0_37_13, SUM_WIDTH_0_13) + resize(act_0_39_13, SUM_WIDTH_0_13);
        s1_2 <= resize(act_0_41_13, SUM_WIDTH_0_13) + resize(act_0_43_13, SUM_WIDTH_0_13) + resize(act_0_45_13, SUM_WIDTH_0_13) + resize(act_0_51_13, SUM_WIDTH_0_13);
        s1_3 <= resize(act_0_53_13, SUM_WIDTH_0_13);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        -- Stage 3
        sum_0_13 <= s2_0;
      end if;
    end process;
    out0_13 <= saturate(sum_0_13, 6);
  end block;

  -- LAYER 0, ch 14
  gen_l0c14 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_0_14;
  signal s2_0, s2_1 : sum_t_0_14;
  signal sum_0_14 : sum_t_0_14;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_14.mem") port map (clk, input(0), act_0_0_14);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_14.mem") port map (clk, input(1), act_0_1_14);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_14.mem") port map (clk, input(3), act_0_3_14);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_14.mem") port map (clk, input(9), act_0_9_14);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_14.mem") port map (clk, input(10), act_0_10_14);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_14.mem") port map (clk, input(12), act_0_12_14);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_14.mem") port map (clk, input(13), act_0_13_14);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_14.mem") port map (clk, input(14), act_0_14_14);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_14.mem") port map (clk, input(15), act_0_15_14);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_14.mem") port map (clk, input(30), act_0_30_14);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_14.mem") port map (clk, input(31), act_0_31_14);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_14.mem") port map (clk, input(32), act_0_32_14);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_14.mem") port map (clk, input(33), act_0_33_14);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_14.mem") port map (clk, input(35), act_0_35_14);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_14.mem") port map (clk, input(36), act_0_36_14);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_14.mem") port map (clk, input(37), act_0_37_14);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_14.mem") port map (clk, input(38), act_0_38_14);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_14.mem") port map (clk, input(40), act_0_40_14);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_14.mem") port map (clk, input(41), act_0_41_14);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_14.mem") port map (clk, input(42), act_0_42_14);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_14.mem") port map (clk, input(43), act_0_43_14);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_14.mem") port map (clk, input(51), act_0_51_14);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_14.mem") port map (clk, input(53), act_0_53_14);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_14.mem") port map (clk, input(56), act_0_56_14);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_14.mem") port map (clk, input(59), act_0_59_14);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_14.mem") port map (clk, input(60), act_0_60_14);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_14, SUM_WIDTH_0_14) + resize(act_0_1_14, SUM_WIDTH_0_14) + resize(act_0_3_14, SUM_WIDTH_0_14) + resize(act_0_9_14, SUM_WIDTH_0_14);
        s1_1 <= resize(act_0_10_14, SUM_WIDTH_0_14) + resize(act_0_12_14, SUM_WIDTH_0_14) + resize(act_0_13_14, SUM_WIDTH_0_14) + resize(act_0_14_14, SUM_WIDTH_0_14);
        s1_2 <= resize(act_0_15_14, SUM_WIDTH_0_14) + resize(act_0_30_14, SUM_WIDTH_0_14) + resize(act_0_31_14, SUM_WIDTH_0_14) + resize(act_0_32_14, SUM_WIDTH_0_14);
        s1_3 <= resize(act_0_33_14, SUM_WIDTH_0_14) + resize(act_0_35_14, SUM_WIDTH_0_14) + resize(act_0_36_14, SUM_WIDTH_0_14) + resize(act_0_37_14, SUM_WIDTH_0_14);
        s1_4 <= resize(act_0_38_14, SUM_WIDTH_0_14) + resize(act_0_40_14, SUM_WIDTH_0_14) + resize(act_0_41_14, SUM_WIDTH_0_14) + resize(act_0_42_14, SUM_WIDTH_0_14);
        s1_5 <= resize(act_0_43_14, SUM_WIDTH_0_14) + resize(act_0_51_14, SUM_WIDTH_0_14) + resize(act_0_53_14, SUM_WIDTH_0_14) + resize(act_0_56_14, SUM_WIDTH_0_14);
        s1_6 <= resize(act_0_59_14, SUM_WIDTH_0_14) + resize(act_0_60_14, SUM_WIDTH_0_14);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_0_14 <= s2_0 + s2_1;
      end if;
    end process;
    out0_14 <= saturate(sum_0_14, 6);
  end block;

  -- LAYER 0, ch 15
  gen_l0c15 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4 : sum_t_0_15;
  signal s2_0, s2_1 : sum_t_0_15;
  signal sum_0_15 : sum_t_0_15;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_12_15.mem") port map (clk, input(12), act_0_12_15);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_15.mem") port map (clk, input(13), act_0_13_15);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_15.mem") port map (clk, input(15), act_0_15_15);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_15.mem") port map (clk, input(16), act_0_16_15);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_15.mem") port map (clk, input(19), act_0_19_15);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_15.mem") port map (clk, input(33), act_0_33_15);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_15.mem") port map (clk, input(34), act_0_34_15);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_15.mem") port map (clk, input(36), act_0_36_15);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_15.mem") port map (clk, input(38), act_0_38_15);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_15.mem") port map (clk, input(39), act_0_39_15);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_15.mem") port map (clk, input(41), act_0_41_15);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_15.mem") port map (clk, input(44), act_0_44_15);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_15.mem") port map (clk, input(45), act_0_45_15);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_15.mem") port map (clk, input(46), act_0_46_15);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_15.mem") port map (clk, input(48), act_0_48_15);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_15.mem") port map (clk, input(50), act_0_50_15);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_15.mem") port map (clk, input(52), act_0_52_15);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_15.mem") port map (clk, input(54), act_0_54_15);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_15.mem") port map (clk, input(56), act_0_56_15);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_15.mem") port map (clk, input(60), act_0_60_15);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_12_15, SUM_WIDTH_0_15) + resize(act_0_13_15, SUM_WIDTH_0_15) + resize(act_0_15_15, SUM_WIDTH_0_15) + resize(act_0_16_15, SUM_WIDTH_0_15);
        s1_1 <= resize(act_0_19_15, SUM_WIDTH_0_15) + resize(act_0_33_15, SUM_WIDTH_0_15) + resize(act_0_34_15, SUM_WIDTH_0_15) + resize(act_0_36_15, SUM_WIDTH_0_15);
        s1_2 <= resize(act_0_38_15, SUM_WIDTH_0_15) + resize(act_0_39_15, SUM_WIDTH_0_15) + resize(act_0_41_15, SUM_WIDTH_0_15) + resize(act_0_44_15, SUM_WIDTH_0_15);
        s1_3 <= resize(act_0_45_15, SUM_WIDTH_0_15) + resize(act_0_46_15, SUM_WIDTH_0_15) + resize(act_0_48_15, SUM_WIDTH_0_15) + resize(act_0_50_15, SUM_WIDTH_0_15);
        s1_4 <= resize(act_0_52_15, SUM_WIDTH_0_15) + resize(act_0_54_15, SUM_WIDTH_0_15) + resize(act_0_56_15, SUM_WIDTH_0_15) + resize(act_0_60_15, SUM_WIDTH_0_15);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4;
        -- Stage 3
        sum_0_15 <= s2_0 + s2_1;
      end if;
    end process;
    out0_15 <= saturate(sum_0_15, 6);
  end block;

  -- Register block for layer 0
  out_layer0_reg : process(clk)
    begin
      if rising_edge(clk) then
        out0_0_reg <= out0_0;
        out0_1_reg <= out0_1;
        out0_2_reg <= out0_2;
        out0_3_reg <= out0_3;
        out0_4_reg <= out0_4;
        out0_5_reg <= out0_5;
        out0_6_reg <= out0_6;
        out0_7_reg <= out0_7;
        out0_8_reg <= out0_8;
        out0_9_reg <= out0_9;
        out0_10_reg <= out0_10;
        out0_11_reg <= out0_11;
        out0_12_reg <= out0_12;
        out0_13_reg <= out0_13;
        out0_14_reg <= out0_14;
        out0_15_reg <= out0_15;
      end if;
  end process;

  -- LAYER 1, ch 0
  gen_l1c0 : block
  signal s1_0, s1_1, s1_2, s1_3 : sum_t_1_0;
  signal sum_1_0 : sum_t_1_0;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_0.mem") port map (clk, out0_0_reg, act_1_0_0);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_0.mem") port map (clk, out0_1_reg, act_1_1_0);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_0.mem") port map (clk, out0_2_reg, act_1_2_0);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_0.mem") port map (clk, out0_3_reg, act_1_3_0);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_0.mem") port map (clk, out0_4_reg, act_1_4_0);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_0.mem") port map (clk, out0_5_reg, act_1_5_0);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_0.mem") port map (clk, out0_6_reg, act_1_6_0);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_0.mem") port map (clk, out0_7_reg, act_1_7_0);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_0.mem") port map (clk, out0_8_reg, act_1_8_0);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_0.mem") port map (clk, out0_9_reg, act_1_9_0);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_0.mem") port map (clk, out0_10_reg, act_1_10_0);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_0.mem") port map (clk, out0_11_reg, act_1_11_0);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_0.mem") port map (clk, out0_12_reg, act_1_12_0);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_0.mem") port map (clk, out0_13_reg, act_1_13_0);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_14_0.mem") port map (clk, out0_14_reg, act_1_14_0);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_0.mem") port map (clk, out0_15_reg, act_1_15_0);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_0, SUM_WIDTH_1_0) + resize(act_1_1_0, SUM_WIDTH_1_0) + resize(act_1_2_0, SUM_WIDTH_1_0) + resize(act_1_3_0, SUM_WIDTH_1_0);
        s1_1 <= resize(act_1_4_0, SUM_WIDTH_1_0) + resize(act_1_5_0, SUM_WIDTH_1_0) + resize(act_1_6_0, SUM_WIDTH_1_0) + resize(act_1_7_0, SUM_WIDTH_1_0);
        s1_2 <= resize(act_1_8_0, SUM_WIDTH_1_0) + resize(act_1_9_0, SUM_WIDTH_1_0) + resize(act_1_10_0, SUM_WIDTH_1_0) + resize(act_1_11_0, SUM_WIDTH_1_0);
        s1_3 <= resize(act_1_12_0, SUM_WIDTH_1_0) + resize(act_1_13_0, SUM_WIDTH_1_0) + resize(act_1_14_0, SUM_WIDTH_1_0) + resize(act_1_15_0, SUM_WIDTH_1_0);
        -- Stage 2
        sum_1_0 <= s1_0 + s1_1 + s1_2 + s1_3;
      end if;
    end process;
    output(0) <= saturate(sum_1_0, 6);
  end block;

  -- LAYER 1, ch 1
  gen_l1c1 : block
  signal s1_0, s1_1, s1_2, s1_3 : sum_t_1_1;
  signal sum_1_1 : sum_t_1_1;
  begin
    i00 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_0_1.mem") port map (clk, out0_0_reg, act_1_0_1);
    i01 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_1_1.mem") port map (clk, out0_1_reg, act_1_1_1);
    i02 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_2_1.mem") port map (clk, out0_2_reg, act_1_2_1);
    i03 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_3_1.mem") port map (clk, out0_3_reg, act_1_3_1);
    i04 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_4_1.mem") port map (clk, out0_4_reg, act_1_4_1);
    i05 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_5_1.mem") port map (clk, out0_5_reg, act_1_5_1);
    i06 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_6_1.mem") port map (clk, out0_6_reg, act_1_6_1);
    i07 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_7_1.mem") port map (clk, out0_7_reg, act_1_7_1);
    i08 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_8_1.mem") port map (clk, out0_8_reg, act_1_8_1);
    i09 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_9_1.mem") port map (clk, out0_9_reg, act_1_9_1);
    i10 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_10_1.mem") port map (clk, out0_10_reg, act_1_10_1);
    i11 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_11_1.mem") port map (clk, out0_11_reg, act_1_11_1);
    i12 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_12_1.mem") port map (clk, out0_12_reg, act_1_12_1);
    i13 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_13_1.mem") port map (clk, out0_13_reg, act_1_13_1);
    i14 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_14_1.mem") port map (clk, out0_14_reg, act_1_14_1);
    i15 : entity work.LUT_1 generic map (MEMFILE=>"lut_1_15_1.mem") port map (clk, out0_15_reg, act_1_15_1);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_1_0_1, SUM_WIDTH_1_1) + resize(act_1_1_1, SUM_WIDTH_1_1) + resize(act_1_2_1, SUM_WIDTH_1_1) + resize(act_1_3_1, SUM_WIDTH_1_1);
        s1_1 <= resize(act_1_4_1, SUM_WIDTH_1_1) + resize(act_1_5_1, SUM_WIDTH_1_1) + resize(act_1_6_1, SUM_WIDTH_1_1) + resize(act_1_7_1, SUM_WIDTH_1_1);
        s1_2 <= resize(act_1_8_1, SUM_WIDTH_1_1) + resize(act_1_9_1, SUM_WIDTH_1_1) + resize(act_1_10_1, SUM_WIDTH_1_1) + resize(act_1_11_1, SUM_WIDTH_1_1);
        s1_3 <= resize(act_1_12_1, SUM_WIDTH_1_1) + resize(act_1_13_1, SUM_WIDTH_1_1) + resize(act_1_14_1, SUM_WIDTH_1_1) + resize(act_1_15_1, SUM_WIDTH_1_1);
        -- Stage 2
        sum_1_1 <= s1_0 + s1_1 + s1_2 + s1_3;
      end if;
    end process;
    output(1) <= saturate(sum_1_1, 6);
  end block;

end architecture;