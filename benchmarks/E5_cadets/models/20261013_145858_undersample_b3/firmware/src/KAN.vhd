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
  signal act_0_0_9, act_0_1_2, act_0_1_3, act_0_1_10, act_0_2_15, act_0_3_2, act_0_3_7, act_0_8_0, act_0_8_1, act_0_8_2, act_0_8_3, act_0_8_4, act_0_8_5, act_0_8_6, act_0_8_7, act_0_8_8 : lut_output_t_0;
  signal act_0_8_9, act_0_8_10, act_0_8_11, act_0_8_12, act_0_8_13, act_0_8_14, act_0_8_15, act_0_9_0, act_0_9_1, act_0_9_2, act_0_9_3, act_0_9_4, act_0_9_5, act_0_9_6, act_0_9_7, act_0_9_8 : lut_output_t_0;
  signal act_0_9_9, act_0_9_10, act_0_9_11, act_0_9_12, act_0_9_13, act_0_9_14, act_0_9_15, act_0_10_0, act_0_10_1, act_0_10_2, act_0_10_3, act_0_10_4, act_0_10_5, act_0_10_6, act_0_10_7, act_0_10_8 : lut_output_t_0;
  signal act_0_10_9, act_0_10_10, act_0_10_11, act_0_10_12, act_0_10_13, act_0_10_14, act_0_11_0, act_0_11_1, act_0_11_2, act_0_11_3, act_0_11_4, act_0_11_7, act_0_11_8, act_0_11_9, act_0_11_11, act_0_11_12 : lut_output_t_0;
  signal act_0_11_13, act_0_11_14, act_0_13_12, act_0_14_1, act_0_14_2, act_0_14_4, act_0_14_5, act_0_14_7, act_0_14_8, act_0_14_9, act_0_14_10, act_0_14_12, act_0_14_13, act_0_14_15, act_0_15_1, act_0_15_3 : lut_output_t_0;
  signal act_0_15_13, act_0_16_2, act_0_16_3, act_0_17_5, act_0_17_12, act_0_19_1, act_0_19_2, act_0_19_3, act_0_19_6, act_0_19_13, act_0_21_2, act_0_21_3, act_0_21_13, act_0_22_3, act_0_22_5, act_0_22_7 : lut_output_t_0;
  signal act_0_22_10, act_0_23_1, act_0_23_2, act_0_23_3, act_0_23_4, act_0_23_5, act_0_23_7, act_0_23_9, act_0_23_13, act_0_23_14, act_0_23_15, act_0_24_1, act_0_24_2, act_0_24_3, act_0_24_4, act_0_24_6 : lut_output_t_0;
  signal act_0_24_9, act_0_24_10, act_0_24_12, act_0_24_13, act_0_24_14, act_0_24_15, act_0_25_0, act_0_25_1, act_0_25_2, act_0_25_3, act_0_25_5, act_0_25_6, act_0_25_7, act_0_25_10, act_0_25_11, act_0_26_0 : lut_output_t_0;
  signal act_0_26_1, act_0_26_2, act_0_26_3, act_0_26_5, act_0_26_6, act_0_26_7, act_0_26_8, act_0_26_9, act_0_26_10, act_0_26_11, act_0_26_12, act_0_26_13, act_0_26_14, act_0_27_1, act_0_27_2, act_0_27_3 : lut_output_t_0;
  signal act_0_27_5, act_0_27_6, act_0_27_7, act_0_27_8, act_0_27_10, act_0_27_11, act_0_27_13, act_0_27_14, act_0_27_15, act_0_28_1, act_0_28_2, act_0_28_4, act_0_28_5, act_0_28_6, act_0_28_8, act_0_28_10 : lut_output_t_0;
  signal act_0_28_11, act_0_28_12, act_0_28_13, act_0_28_14, act_0_28_15, act_0_29_0, act_0_29_1, act_0_29_2, act_0_29_4, act_0_29_7, act_0_29_9, act_0_29_10, act_0_29_11, act_0_29_13, act_0_29_14, act_0_29_15 : lut_output_t_0;
  signal act_0_30_1, act_0_30_2, act_0_30_4, act_0_30_6, act_0_30_8, act_0_30_9, act_0_30_10, act_0_30_11, act_0_30_12, act_0_30_13, act_0_30_15, act_0_31_1, act_0_31_2, act_0_31_3, act_0_31_6, act_0_31_7 : lut_output_t_0;
  signal act_0_31_9, act_0_31_10, act_0_31_11, act_0_31_12, act_0_31_13, act_0_31_14, act_0_31_15, act_0_32_0, act_0_32_1, act_0_32_2, act_0_32_3, act_0_32_4, act_0_32_5, act_0_32_6, act_0_32_7, act_0_32_8 : lut_output_t_0;
  signal act_0_32_10, act_0_32_11, act_0_32_12, act_0_32_13, act_0_32_14, act_0_32_15, act_0_33_0, act_0_33_1, act_0_33_2, act_0_33_3, act_0_33_4, act_0_33_5, act_0_33_6, act_0_33_7, act_0_33_9, act_0_33_10 : lut_output_t_0;
  signal act_0_33_11, act_0_33_12, act_0_33_13, act_0_33_14, act_0_33_15, act_0_34_0, act_0_34_1, act_0_34_2, act_0_34_3, act_0_34_4, act_0_34_5, act_0_34_6, act_0_34_8, act_0_34_10, act_0_34_11, act_0_34_12 : lut_output_t_0;
  signal act_0_34_13, act_0_34_14, act_0_35_1, act_0_35_2, act_0_35_3, act_0_35_5, act_0_35_6, act_0_35_7, act_0_35_9, act_0_35_11, act_0_35_12, act_0_35_13, act_0_35_14, act_0_36_0, act_0_36_1, act_0_36_2 : lut_output_t_0;
  signal act_0_36_3, act_0_36_5, act_0_36_6, act_0_36_7, act_0_36_8, act_0_36_10, act_0_36_11, act_0_36_14, act_0_37_1, act_0_37_2, act_0_37_3, act_0_37_6, act_0_37_8, act_0_37_9, act_0_37_10, act_0_37_11 : lut_output_t_0;
  signal act_0_37_12, act_0_37_14, act_0_37_15, act_0_38_1, act_0_38_2, act_0_38_3, act_0_38_6, act_0_38_7, act_0_38_8, act_0_38_9, act_0_38_11, act_0_38_12, act_0_38_14, act_0_39_0, act_0_39_1, act_0_39_3 : lut_output_t_0;
  signal act_0_39_5, act_0_39_6, act_0_39_7, act_0_39_8, act_0_39_9, act_0_39_10, act_0_39_11, act_0_39_14, act_0_40_1, act_0_40_3, act_0_40_4, act_0_40_5, act_0_40_6, act_0_40_9, act_0_40_12, act_0_40_13 : lut_output_t_0;
  signal act_0_41_0, act_0_41_1, act_0_41_3, act_0_41_6, act_0_41_7, act_0_41_10, act_0_41_12, act_0_41_13, act_0_41_14, act_0_42_1, act_0_42_4, act_0_42_5, act_0_42_6, act_0_42_7, act_0_42_10, act_0_42_11 : lut_output_t_0;
  signal act_0_42_13, act_0_42_14, act_0_42_15, act_0_43_1, act_0_43_2, act_0_43_5, act_0_43_6, act_0_43_9, act_0_43_10, act_0_43_11, act_0_43_12, act_0_43_13, act_0_43_14, act_0_44_0, act_0_44_1, act_0_44_2 : lut_output_t_0;
  signal act_0_44_4, act_0_44_5, act_0_44_6, act_0_44_8, act_0_44_10, act_0_44_11, act_0_44_12, act_0_44_13, act_0_44_14, act_0_45_2, act_0_45_3, act_0_45_4, act_0_45_6, act_0_45_8, act_0_45_11, act_0_45_14 : lut_output_t_0;
  signal act_0_45_15, act_0_46_0, act_0_46_1, act_0_46_2, act_0_46_3, act_0_46_5, act_0_46_6, act_0_46_9, act_0_46_11, act_0_46_13, act_0_46_14, act_0_46_15, act_0_47_1, act_0_47_2, act_0_47_3, act_0_47_5 : lut_output_t_0;
  signal act_0_47_6, act_0_47_7, act_0_47_9, act_0_47_10, act_0_47_11, act_0_47_13, act_0_47_14, act_0_47_15, act_0_48_2, act_0_48_3, act_0_48_6, act_0_48_7, act_0_48_10, act_0_48_11, act_0_48_12, act_0_48_13 : lut_output_t_0;
  signal act_0_49_1, act_0_49_2, act_0_49_3, act_0_49_5, act_0_49_6, act_0_49_8, act_0_49_9, act_0_49_10, act_0_49_11, act_0_49_12, act_0_49_13, act_0_49_14, act_0_49_15, act_0_50_1, act_0_50_3, act_0_50_4 : lut_output_t_0;
  signal act_0_50_5, act_0_50_6, act_0_50_7, act_0_50_10, act_0_50_11, act_0_50_12, act_0_50_14, act_0_50_15, act_0_51_0, act_0_51_1, act_0_51_2, act_0_51_3, act_0_51_4, act_0_51_8, act_0_51_10, act_0_51_11 : lut_output_t_0;
  signal act_0_51_12, act_0_51_13, act_0_51_15, act_0_52_1, act_0_52_5, act_0_52_6, act_0_52_8, act_0_52_10, act_0_52_12, act_0_52_14, act_0_53_0, act_0_53_1, act_0_53_2, act_0_53_3, act_0_53_5, act_0_53_6 : lut_output_t_0;
  signal act_0_53_8, act_0_53_13, act_0_53_14, act_0_53_15, act_0_54_1, act_0_54_2, act_0_54_3, act_0_54_4, act_0_54_6, act_0_54_7, act_0_54_8, act_0_54_10, act_0_54_11, act_0_54_12, act_0_54_14, act_0_55_0 : lut_output_t_0;
  signal act_0_55_2, act_0_55_3, act_0_55_4, act_0_55_5, act_0_55_6, act_0_55_7, act_0_55_8, act_0_55_10, act_0_55_13, act_0_55_14, act_0_55_15, act_0_56_1, act_0_56_2, act_0_56_3, act_0_56_4, act_0_56_5 : lut_output_t_0;
  signal act_0_56_6, act_0_56_7, act_0_56_8, act_0_56_9, act_0_56_13, act_0_57_0, act_0_57_3, act_0_57_5, act_0_57_6, act_0_57_8, act_0_57_14, act_0_58_0, act_0_58_1, act_0_58_4, act_0_58_6, act_0_58_7 : lut_output_t_0;
  signal act_0_58_8, act_0_58_13, act_0_58_14, act_0_59_0, act_0_59_1, act_0_59_3, act_0_59_5, act_0_59_7, act_0_59_8, act_0_59_9, act_0_59_10, act_0_59_12, act_0_59_13, act_0_59_14, act_0_60_0, act_0_60_1 : lut_output_t_0;
  signal act_0_60_2, act_0_60_3, act_0_60_5, act_0_60_6, act_0_60_7, act_0_60_8, act_0_60_10, act_0_60_12, act_0_60_14, act_0_60_15, act_0_61_1, act_0_61_3, act_0_61_4, act_0_61_5, act_0_61_6, act_0_61_7 : lut_output_t_0;
  signal act_0_61_9, act_0_61_12, act_0_61_14, act_0_61_15, act_0_62_0, act_0_62_1, act_0_62_2, act_0_62_3, act_0_62_4, act_0_62_5, act_0_62_6, act_0_62_7, act_0_62_8, act_0_62_9, act_0_62_10, act_0_62_11 : lut_output_t_0;
  signal act_0_62_12, act_0_62_13, act_0_62_14, act_0_62_15, act_0_63_0, act_0_63_1, act_0_63_4, act_0_63_5, act_0_63_6, act_0_63_7, act_0_63_8, act_0_63_9, act_0_63_11, act_0_63_13, act_0_63_14, act_0_63_15 : lut_output_t_0;
  signal out0_0, out0_1, out0_2, out0_3, out0_4, out0_5, out0_6, out0_7, out0_8, out0_9, out0_10, out0_11, out0_12, out0_13, out0_14, out0_15 : lut_output_t_0;
  signal out0_0_reg, out0_1_reg, out0_2_reg, out0_3_reg, out0_4_reg, out0_5_reg, out0_6_reg, out0_7_reg, out0_8_reg, out0_9_reg, out0_10_reg, out0_11_reg, out0_12_reg, out0_13_reg, out0_14_reg, out0_15_reg : lut_output_t_0;

-- Layer 1 (16->2)
  signal act_1_0_0, act_1_0_1, act_1_1_0, act_1_1_1, act_1_2_0, act_1_2_1, act_1_3_0, act_1_3_1, act_1_4_0, act_1_4_1, act_1_5_0, act_1_5_1, act_1_6_0, act_1_6_1, act_1_7_0, act_1_7_1 : lut_output_t_1;
  signal act_1_8_0, act_1_8_1, act_1_9_0, act_1_9_1, act_1_10_0, act_1_10_1, act_1_11_0, act_1_11_1, act_1_12_0, act_1_12_1, act_1_13_0, act_1_13_1, act_1_14_0, act_1_14_1, act_1_15_0, act_1_15_1 : lut_output_t_1;
begin

  -- === auto: layer blocks ===
  -- LAYER 0, ch 0
  gen_l0c0 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5 : sum_t_0_0;
  signal s2_0, s2_1 : sum_t_0_0;
  signal sum_0_0 : sum_t_0_0;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_0.mem") port map (clk, input(8), act_0_8_0);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_0.mem") port map (clk, input(9), act_0_9_0);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_0.mem") port map (clk, input(10), act_0_10_0);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_0.mem") port map (clk, input(11), act_0_11_0);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_0.mem") port map (clk, input(25), act_0_25_0);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_0.mem") port map (clk, input(26), act_0_26_0);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_0.mem") port map (clk, input(29), act_0_29_0);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_0.mem") port map (clk, input(32), act_0_32_0);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_0.mem") port map (clk, input(33), act_0_33_0);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_0.mem") port map (clk, input(34), act_0_34_0);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_0.mem") port map (clk, input(36), act_0_36_0);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_0.mem") port map (clk, input(39), act_0_39_0);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_0.mem") port map (clk, input(41), act_0_41_0);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_0.mem") port map (clk, input(44), act_0_44_0);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_0.mem") port map (clk, input(46), act_0_46_0);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_0.mem") port map (clk, input(51), act_0_51_0);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_0.mem") port map (clk, input(53), act_0_53_0);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_0.mem") port map (clk, input(55), act_0_55_0);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_57_0.mem") port map (clk, input(57), act_0_57_0);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_58_0.mem") port map (clk, input(58), act_0_58_0);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_0.mem") port map (clk, input(59), act_0_59_0);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_0.mem") port map (clk, input(60), act_0_60_0);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_0.mem") port map (clk, input(62), act_0_62_0);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_0.mem") port map (clk, input(63), act_0_63_0);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_0, SUM_WIDTH_0_0) + resize(act_0_9_0, SUM_WIDTH_0_0) + resize(act_0_10_0, SUM_WIDTH_0_0) + resize(act_0_11_0, SUM_WIDTH_0_0);
        s1_1 <= resize(act_0_25_0, SUM_WIDTH_0_0) + resize(act_0_26_0, SUM_WIDTH_0_0) + resize(act_0_29_0, SUM_WIDTH_0_0) + resize(act_0_32_0, SUM_WIDTH_0_0);
        s1_2 <= resize(act_0_33_0, SUM_WIDTH_0_0) + resize(act_0_34_0, SUM_WIDTH_0_0) + resize(act_0_36_0, SUM_WIDTH_0_0) + resize(act_0_39_0, SUM_WIDTH_0_0);
        s1_3 <= resize(act_0_41_0, SUM_WIDTH_0_0) + resize(act_0_44_0, SUM_WIDTH_0_0) + resize(act_0_46_0, SUM_WIDTH_0_0) + resize(act_0_51_0, SUM_WIDTH_0_0);
        s1_4 <= resize(act_0_53_0, SUM_WIDTH_0_0) + resize(act_0_55_0, SUM_WIDTH_0_0) + resize(act_0_57_0, SUM_WIDTH_0_0) + resize(act_0_58_0, SUM_WIDTH_0_0);
        s1_5 <= resize(act_0_59_0, SUM_WIDTH_0_0) + resize(act_0_60_0, SUM_WIDTH_0_0) + resize(act_0_62_0, SUM_WIDTH_0_0) + resize(act_0_63_0, SUM_WIDTH_0_0);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5;
        -- Stage 3
        sum_0_0 <= s2_0 + s2_1;
      end if;
    end process;
    out0_0 <= saturate(sum_0_0, 6);
  end block;

  -- LAYER 0, ch 1
  gen_l0c1 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_1;
  signal s2_0, s2_1, s2_2 : sum_t_0_1;
  signal sum_0_1 : sum_t_0_1;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_1.mem") port map (clk, input(8), act_0_8_1);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_1.mem") port map (clk, input(9), act_0_9_1);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_1.mem") port map (clk, input(10), act_0_10_1);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_1.mem") port map (clk, input(11), act_0_11_1);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_1.mem") port map (clk, input(14), act_0_14_1);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_1.mem") port map (clk, input(15), act_0_15_1);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_1.mem") port map (clk, input(19), act_0_19_1);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_1.mem") port map (clk, input(23), act_0_23_1);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_1.mem") port map (clk, input(24), act_0_24_1);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_1.mem") port map (clk, input(25), act_0_25_1);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_1.mem") port map (clk, input(26), act_0_26_1);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_1.mem") port map (clk, input(27), act_0_27_1);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_1.mem") port map (clk, input(28), act_0_28_1);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_1.mem") port map (clk, input(29), act_0_29_1);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_1.mem") port map (clk, input(30), act_0_30_1);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_1.mem") port map (clk, input(31), act_0_31_1);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_1.mem") port map (clk, input(32), act_0_32_1);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_1.mem") port map (clk, input(33), act_0_33_1);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_1.mem") port map (clk, input(34), act_0_34_1);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_1.mem") port map (clk, input(35), act_0_35_1);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_1.mem") port map (clk, input(36), act_0_36_1);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_1.mem") port map (clk, input(37), act_0_37_1);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_1.mem") port map (clk, input(38), act_0_38_1);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_1.mem") port map (clk, input(39), act_0_39_1);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_1.mem") port map (clk, input(40), act_0_40_1);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_1.mem") port map (clk, input(41), act_0_41_1);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_1.mem") port map (clk, input(42), act_0_42_1);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_1.mem") port map (clk, input(43), act_0_43_1);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_1.mem") port map (clk, input(44), act_0_44_1);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_1.mem") port map (clk, input(46), act_0_46_1);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_1.mem") port map (clk, input(47), act_0_47_1);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_1.mem") port map (clk, input(49), act_0_49_1);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_1.mem") port map (clk, input(50), act_0_50_1);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_1.mem") port map (clk, input(51), act_0_51_1);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_1.mem") port map (clk, input(52), act_0_52_1);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_1.mem") port map (clk, input(53), act_0_53_1);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_1.mem") port map (clk, input(54), act_0_54_1);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_1.mem") port map (clk, input(56), act_0_56_1);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_58_1.mem") port map (clk, input(58), act_0_58_1);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_1.mem") port map (clk, input(59), act_0_59_1);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_1.mem") port map (clk, input(60), act_0_60_1);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_1.mem") port map (clk, input(61), act_0_61_1);
    i42 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_1.mem") port map (clk, input(62), act_0_62_1);
    i43 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_1.mem") port map (clk, input(63), act_0_63_1);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_1, SUM_WIDTH_0_1) + resize(act_0_9_1, SUM_WIDTH_0_1) + resize(act_0_10_1, SUM_WIDTH_0_1) + resize(act_0_11_1, SUM_WIDTH_0_1);
        s1_1 <= resize(act_0_14_1, SUM_WIDTH_0_1) + resize(act_0_15_1, SUM_WIDTH_0_1) + resize(act_0_19_1, SUM_WIDTH_0_1) + resize(act_0_23_1, SUM_WIDTH_0_1);
        s1_2 <= resize(act_0_24_1, SUM_WIDTH_0_1) + resize(act_0_25_1, SUM_WIDTH_0_1) + resize(act_0_26_1, SUM_WIDTH_0_1) + resize(act_0_27_1, SUM_WIDTH_0_1);
        s1_3 <= resize(act_0_28_1, SUM_WIDTH_0_1) + resize(act_0_29_1, SUM_WIDTH_0_1) + resize(act_0_30_1, SUM_WIDTH_0_1) + resize(act_0_31_1, SUM_WIDTH_0_1);
        s1_4 <= resize(act_0_32_1, SUM_WIDTH_0_1) + resize(act_0_33_1, SUM_WIDTH_0_1) + resize(act_0_34_1, SUM_WIDTH_0_1) + resize(act_0_35_1, SUM_WIDTH_0_1);
        s1_5 <= resize(act_0_36_1, SUM_WIDTH_0_1) + resize(act_0_37_1, SUM_WIDTH_0_1) + resize(act_0_38_1, SUM_WIDTH_0_1) + resize(act_0_39_1, SUM_WIDTH_0_1);
        s1_6 <= resize(act_0_40_1, SUM_WIDTH_0_1) + resize(act_0_41_1, SUM_WIDTH_0_1) + resize(act_0_42_1, SUM_WIDTH_0_1) + resize(act_0_43_1, SUM_WIDTH_0_1);
        s1_7 <= resize(act_0_44_1, SUM_WIDTH_0_1) + resize(act_0_46_1, SUM_WIDTH_0_1) + resize(act_0_47_1, SUM_WIDTH_0_1) + resize(act_0_49_1, SUM_WIDTH_0_1);
        s1_8 <= resize(act_0_50_1, SUM_WIDTH_0_1) + resize(act_0_51_1, SUM_WIDTH_0_1) + resize(act_0_52_1, SUM_WIDTH_0_1) + resize(act_0_53_1, SUM_WIDTH_0_1);
        s1_9 <= resize(act_0_54_1, SUM_WIDTH_0_1) + resize(act_0_56_1, SUM_WIDTH_0_1) + resize(act_0_58_1, SUM_WIDTH_0_1) + resize(act_0_59_1, SUM_WIDTH_0_1);
        s1_10 <= resize(act_0_60_1, SUM_WIDTH_0_1) + resize(act_0_61_1, SUM_WIDTH_0_1) + resize(act_0_62_1, SUM_WIDTH_0_1) + resize(act_0_63_1, SUM_WIDTH_0_1);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_1 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_1 <= saturate(sum_0_1, 6);
  end block;

  -- LAYER 0, ch 2
  gen_l0c2 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_2;
  signal s2_0, s2_1, s2_2 : sum_t_0_2;
  signal sum_0_2 : sum_t_0_2;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_2.mem") port map (clk, input(1), act_0_1_2);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_2.mem") port map (clk, input(3), act_0_3_2);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_2.mem") port map (clk, input(8), act_0_8_2);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_2.mem") port map (clk, input(9), act_0_9_2);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_2.mem") port map (clk, input(10), act_0_10_2);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_2.mem") port map (clk, input(11), act_0_11_2);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_2.mem") port map (clk, input(14), act_0_14_2);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_2.mem") port map (clk, input(16), act_0_16_2);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_2.mem") port map (clk, input(19), act_0_19_2);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_2.mem") port map (clk, input(21), act_0_21_2);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_2.mem") port map (clk, input(23), act_0_23_2);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_2.mem") port map (clk, input(24), act_0_24_2);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_2.mem") port map (clk, input(25), act_0_25_2);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_2.mem") port map (clk, input(26), act_0_26_2);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_2.mem") port map (clk, input(27), act_0_27_2);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_2.mem") port map (clk, input(28), act_0_28_2);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_2.mem") port map (clk, input(29), act_0_29_2);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_2.mem") port map (clk, input(30), act_0_30_2);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_2.mem") port map (clk, input(31), act_0_31_2);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_2.mem") port map (clk, input(32), act_0_32_2);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_2.mem") port map (clk, input(33), act_0_33_2);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_2.mem") port map (clk, input(34), act_0_34_2);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_2.mem") port map (clk, input(35), act_0_35_2);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_2.mem") port map (clk, input(36), act_0_36_2);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_2.mem") port map (clk, input(37), act_0_37_2);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_2.mem") port map (clk, input(38), act_0_38_2);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_2.mem") port map (clk, input(43), act_0_43_2);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_2.mem") port map (clk, input(44), act_0_44_2);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_2.mem") port map (clk, input(45), act_0_45_2);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_2.mem") port map (clk, input(46), act_0_46_2);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_2.mem") port map (clk, input(47), act_0_47_2);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_2.mem") port map (clk, input(48), act_0_48_2);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_2.mem") port map (clk, input(49), act_0_49_2);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_2.mem") port map (clk, input(51), act_0_51_2);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_2.mem") port map (clk, input(53), act_0_53_2);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_2.mem") port map (clk, input(54), act_0_54_2);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_2.mem") port map (clk, input(55), act_0_55_2);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_2.mem") port map (clk, input(56), act_0_56_2);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_2.mem") port map (clk, input(60), act_0_60_2);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_2.mem") port map (clk, input(62), act_0_62_2);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_2, SUM_WIDTH_0_2) + resize(act_0_3_2, SUM_WIDTH_0_2) + resize(act_0_8_2, SUM_WIDTH_0_2) + resize(act_0_9_2, SUM_WIDTH_0_2);
        s1_1 <= resize(act_0_10_2, SUM_WIDTH_0_2) + resize(act_0_11_2, SUM_WIDTH_0_2) + resize(act_0_14_2, SUM_WIDTH_0_2) + resize(act_0_16_2, SUM_WIDTH_0_2);
        s1_2 <= resize(act_0_19_2, SUM_WIDTH_0_2) + resize(act_0_21_2, SUM_WIDTH_0_2) + resize(act_0_23_2, SUM_WIDTH_0_2) + resize(act_0_24_2, SUM_WIDTH_0_2);
        s1_3 <= resize(act_0_25_2, SUM_WIDTH_0_2) + resize(act_0_26_2, SUM_WIDTH_0_2) + resize(act_0_27_2, SUM_WIDTH_0_2) + resize(act_0_28_2, SUM_WIDTH_0_2);
        s1_4 <= resize(act_0_29_2, SUM_WIDTH_0_2) + resize(act_0_30_2, SUM_WIDTH_0_2) + resize(act_0_31_2, SUM_WIDTH_0_2) + resize(act_0_32_2, SUM_WIDTH_0_2);
        s1_5 <= resize(act_0_33_2, SUM_WIDTH_0_2) + resize(act_0_34_2, SUM_WIDTH_0_2) + resize(act_0_35_2, SUM_WIDTH_0_2) + resize(act_0_36_2, SUM_WIDTH_0_2);
        s1_6 <= resize(act_0_37_2, SUM_WIDTH_0_2) + resize(act_0_38_2, SUM_WIDTH_0_2) + resize(act_0_43_2, SUM_WIDTH_0_2) + resize(act_0_44_2, SUM_WIDTH_0_2);
        s1_7 <= resize(act_0_45_2, SUM_WIDTH_0_2) + resize(act_0_46_2, SUM_WIDTH_0_2) + resize(act_0_47_2, SUM_WIDTH_0_2) + resize(act_0_48_2, SUM_WIDTH_0_2);
        s1_8 <= resize(act_0_49_2, SUM_WIDTH_0_2) + resize(act_0_51_2, SUM_WIDTH_0_2) + resize(act_0_53_2, SUM_WIDTH_0_2) + resize(act_0_54_2, SUM_WIDTH_0_2);
        s1_9 <= resize(act_0_55_2, SUM_WIDTH_0_2) + resize(act_0_56_2, SUM_WIDTH_0_2) + resize(act_0_60_2, SUM_WIDTH_0_2) + resize(act_0_62_2, SUM_WIDTH_0_2);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_2 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_2 <= saturate(sum_0_2, 6);
  end block;

  -- LAYER 0, ch 3
  gen_l0c3 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_3;
  signal s2_0, s2_1, s2_2 : sum_t_0_3;
  signal sum_0_3 : sum_t_0_3;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_3.mem") port map (clk, input(1), act_0_1_3);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_3.mem") port map (clk, input(8), act_0_8_3);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_3.mem") port map (clk, input(9), act_0_9_3);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_3.mem") port map (clk, input(10), act_0_10_3);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_3.mem") port map (clk, input(11), act_0_11_3);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_3.mem") port map (clk, input(15), act_0_15_3);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_16_3.mem") port map (clk, input(16), act_0_16_3);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_3.mem") port map (clk, input(19), act_0_19_3);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_3.mem") port map (clk, input(21), act_0_21_3);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_3.mem") port map (clk, input(22), act_0_22_3);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_3.mem") port map (clk, input(23), act_0_23_3);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_3.mem") port map (clk, input(24), act_0_24_3);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_3.mem") port map (clk, input(25), act_0_25_3);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_3.mem") port map (clk, input(26), act_0_26_3);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_3.mem") port map (clk, input(27), act_0_27_3);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_3.mem") port map (clk, input(31), act_0_31_3);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_3.mem") port map (clk, input(32), act_0_32_3);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_3.mem") port map (clk, input(33), act_0_33_3);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_3.mem") port map (clk, input(34), act_0_34_3);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_3.mem") port map (clk, input(35), act_0_35_3);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_3.mem") port map (clk, input(36), act_0_36_3);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_3.mem") port map (clk, input(37), act_0_37_3);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_3.mem") port map (clk, input(38), act_0_38_3);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_3.mem") port map (clk, input(39), act_0_39_3);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_3.mem") port map (clk, input(40), act_0_40_3);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_3.mem") port map (clk, input(41), act_0_41_3);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_3.mem") port map (clk, input(45), act_0_45_3);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_3.mem") port map (clk, input(46), act_0_46_3);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_3.mem") port map (clk, input(47), act_0_47_3);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_3.mem") port map (clk, input(48), act_0_48_3);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_3.mem") port map (clk, input(49), act_0_49_3);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_3.mem") port map (clk, input(50), act_0_50_3);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_3.mem") port map (clk, input(51), act_0_51_3);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_3.mem") port map (clk, input(53), act_0_53_3);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_3.mem") port map (clk, input(54), act_0_54_3);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_3.mem") port map (clk, input(55), act_0_55_3);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_3.mem") port map (clk, input(56), act_0_56_3);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_57_3.mem") port map (clk, input(57), act_0_57_3);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_3.mem") port map (clk, input(59), act_0_59_3);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_3.mem") port map (clk, input(60), act_0_60_3);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_3.mem") port map (clk, input(61), act_0_61_3);
    i41 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_3.mem") port map (clk, input(62), act_0_62_3);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_3, SUM_WIDTH_0_3) + resize(act_0_8_3, SUM_WIDTH_0_3) + resize(act_0_9_3, SUM_WIDTH_0_3) + resize(act_0_10_3, SUM_WIDTH_0_3);
        s1_1 <= resize(act_0_11_3, SUM_WIDTH_0_3) + resize(act_0_15_3, SUM_WIDTH_0_3) + resize(act_0_16_3, SUM_WIDTH_0_3) + resize(act_0_19_3, SUM_WIDTH_0_3);
        s1_2 <= resize(act_0_21_3, SUM_WIDTH_0_3) + resize(act_0_22_3, SUM_WIDTH_0_3) + resize(act_0_23_3, SUM_WIDTH_0_3) + resize(act_0_24_3, SUM_WIDTH_0_3);
        s1_3 <= resize(act_0_25_3, SUM_WIDTH_0_3) + resize(act_0_26_3, SUM_WIDTH_0_3) + resize(act_0_27_3, SUM_WIDTH_0_3) + resize(act_0_31_3, SUM_WIDTH_0_3);
        s1_4 <= resize(act_0_32_3, SUM_WIDTH_0_3) + resize(act_0_33_3, SUM_WIDTH_0_3) + resize(act_0_34_3, SUM_WIDTH_0_3) + resize(act_0_35_3, SUM_WIDTH_0_3);
        s1_5 <= resize(act_0_36_3, SUM_WIDTH_0_3) + resize(act_0_37_3, SUM_WIDTH_0_3) + resize(act_0_38_3, SUM_WIDTH_0_3) + resize(act_0_39_3, SUM_WIDTH_0_3);
        s1_6 <= resize(act_0_40_3, SUM_WIDTH_0_3) + resize(act_0_41_3, SUM_WIDTH_0_3) + resize(act_0_45_3, SUM_WIDTH_0_3) + resize(act_0_46_3, SUM_WIDTH_0_3);
        s1_7 <= resize(act_0_47_3, SUM_WIDTH_0_3) + resize(act_0_48_3, SUM_WIDTH_0_3) + resize(act_0_49_3, SUM_WIDTH_0_3) + resize(act_0_50_3, SUM_WIDTH_0_3);
        s1_8 <= resize(act_0_51_3, SUM_WIDTH_0_3) + resize(act_0_53_3, SUM_WIDTH_0_3) + resize(act_0_54_3, SUM_WIDTH_0_3) + resize(act_0_55_3, SUM_WIDTH_0_3);
        s1_9 <= resize(act_0_56_3, SUM_WIDTH_0_3) + resize(act_0_57_3, SUM_WIDTH_0_3) + resize(act_0_59_3, SUM_WIDTH_0_3) + resize(act_0_60_3, SUM_WIDTH_0_3);
        s1_10 <= resize(act_0_61_3, SUM_WIDTH_0_3) + resize(act_0_62_3, SUM_WIDTH_0_3);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_3 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_3 <= saturate(sum_0_3, 6);
  end block;

  -- LAYER 0, ch 4
  gen_l0c4 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_0_4;
  signal s2_0, s2_1 : sum_t_0_4;
  signal sum_0_4 : sum_t_0_4;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_4.mem") port map (clk, input(8), act_0_8_4);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_4.mem") port map (clk, input(9), act_0_9_4);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_4.mem") port map (clk, input(10), act_0_10_4);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_4.mem") port map (clk, input(11), act_0_11_4);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_4.mem") port map (clk, input(14), act_0_14_4);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_4.mem") port map (clk, input(23), act_0_23_4);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_4.mem") port map (clk, input(24), act_0_24_4);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_4.mem") port map (clk, input(28), act_0_28_4);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_4.mem") port map (clk, input(29), act_0_29_4);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_4.mem") port map (clk, input(30), act_0_30_4);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_4.mem") port map (clk, input(32), act_0_32_4);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_4.mem") port map (clk, input(33), act_0_33_4);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_4.mem") port map (clk, input(34), act_0_34_4);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_4.mem") port map (clk, input(40), act_0_40_4);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_4.mem") port map (clk, input(42), act_0_42_4);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_4.mem") port map (clk, input(44), act_0_44_4);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_4.mem") port map (clk, input(45), act_0_45_4);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_4.mem") port map (clk, input(50), act_0_50_4);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_4.mem") port map (clk, input(51), act_0_51_4);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_4.mem") port map (clk, input(54), act_0_54_4);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_4.mem") port map (clk, input(55), act_0_55_4);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_4.mem") port map (clk, input(56), act_0_56_4);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_58_4.mem") port map (clk, input(58), act_0_58_4);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_4.mem") port map (clk, input(61), act_0_61_4);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_4.mem") port map (clk, input(62), act_0_62_4);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_4.mem") port map (clk, input(63), act_0_63_4);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_4, SUM_WIDTH_0_4) + resize(act_0_9_4, SUM_WIDTH_0_4) + resize(act_0_10_4, SUM_WIDTH_0_4) + resize(act_0_11_4, SUM_WIDTH_0_4);
        s1_1 <= resize(act_0_14_4, SUM_WIDTH_0_4) + resize(act_0_23_4, SUM_WIDTH_0_4) + resize(act_0_24_4, SUM_WIDTH_0_4) + resize(act_0_28_4, SUM_WIDTH_0_4);
        s1_2 <= resize(act_0_29_4, SUM_WIDTH_0_4) + resize(act_0_30_4, SUM_WIDTH_0_4) + resize(act_0_32_4, SUM_WIDTH_0_4) + resize(act_0_33_4, SUM_WIDTH_0_4);
        s1_3 <= resize(act_0_34_4, SUM_WIDTH_0_4) + resize(act_0_40_4, SUM_WIDTH_0_4) + resize(act_0_42_4, SUM_WIDTH_0_4) + resize(act_0_44_4, SUM_WIDTH_0_4);
        s1_4 <= resize(act_0_45_4, SUM_WIDTH_0_4) + resize(act_0_50_4, SUM_WIDTH_0_4) + resize(act_0_51_4, SUM_WIDTH_0_4) + resize(act_0_54_4, SUM_WIDTH_0_4);
        s1_5 <= resize(act_0_55_4, SUM_WIDTH_0_4) + resize(act_0_56_4, SUM_WIDTH_0_4) + resize(act_0_58_4, SUM_WIDTH_0_4) + resize(act_0_61_4, SUM_WIDTH_0_4);
        s1_6 <= resize(act_0_62_4, SUM_WIDTH_0_4) + resize(act_0_63_4, SUM_WIDTH_0_4);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_0_4 <= s2_0 + s2_1;
      end if;
    end process;
    out0_4 <= saturate(sum_0_4, 6);
  end block;

  -- LAYER 0, ch 5
  gen_l0c5 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8 : sum_t_0_5;
  signal s2_0, s2_1, s2_2 : sum_t_0_5;
  signal sum_0_5 : sum_t_0_5;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_5.mem") port map (clk, input(8), act_0_8_5);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_5.mem") port map (clk, input(9), act_0_9_5);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_5.mem") port map (clk, input(10), act_0_10_5);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_5.mem") port map (clk, input(14), act_0_14_5);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_5.mem") port map (clk, input(17), act_0_17_5);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_5.mem") port map (clk, input(22), act_0_22_5);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_5.mem") port map (clk, input(23), act_0_23_5);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_5.mem") port map (clk, input(25), act_0_25_5);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_5.mem") port map (clk, input(26), act_0_26_5);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_5.mem") port map (clk, input(27), act_0_27_5);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_5.mem") port map (clk, input(28), act_0_28_5);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_5.mem") port map (clk, input(32), act_0_32_5);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_5.mem") port map (clk, input(33), act_0_33_5);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_5.mem") port map (clk, input(34), act_0_34_5);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_5.mem") port map (clk, input(35), act_0_35_5);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_5.mem") port map (clk, input(36), act_0_36_5);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_5.mem") port map (clk, input(39), act_0_39_5);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_5.mem") port map (clk, input(40), act_0_40_5);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_5.mem") port map (clk, input(42), act_0_42_5);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_5.mem") port map (clk, input(43), act_0_43_5);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_5.mem") port map (clk, input(44), act_0_44_5);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_5.mem") port map (clk, input(46), act_0_46_5);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_5.mem") port map (clk, input(47), act_0_47_5);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_5.mem") port map (clk, input(49), act_0_49_5);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_5.mem") port map (clk, input(50), act_0_50_5);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_5.mem") port map (clk, input(52), act_0_52_5);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_5.mem") port map (clk, input(53), act_0_53_5);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_5.mem") port map (clk, input(55), act_0_55_5);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_5.mem") port map (clk, input(56), act_0_56_5);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_57_5.mem") port map (clk, input(57), act_0_57_5);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_5.mem") port map (clk, input(59), act_0_59_5);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_5.mem") port map (clk, input(60), act_0_60_5);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_5.mem") port map (clk, input(61), act_0_61_5);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_5.mem") port map (clk, input(62), act_0_62_5);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_5.mem") port map (clk, input(63), act_0_63_5);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_5, SUM_WIDTH_0_5) + resize(act_0_9_5, SUM_WIDTH_0_5) + resize(act_0_10_5, SUM_WIDTH_0_5) + resize(act_0_14_5, SUM_WIDTH_0_5);
        s1_1 <= resize(act_0_17_5, SUM_WIDTH_0_5) + resize(act_0_22_5, SUM_WIDTH_0_5) + resize(act_0_23_5, SUM_WIDTH_0_5) + resize(act_0_25_5, SUM_WIDTH_0_5);
        s1_2 <= resize(act_0_26_5, SUM_WIDTH_0_5) + resize(act_0_27_5, SUM_WIDTH_0_5) + resize(act_0_28_5, SUM_WIDTH_0_5) + resize(act_0_32_5, SUM_WIDTH_0_5);
        s1_3 <= resize(act_0_33_5, SUM_WIDTH_0_5) + resize(act_0_34_5, SUM_WIDTH_0_5) + resize(act_0_35_5, SUM_WIDTH_0_5) + resize(act_0_36_5, SUM_WIDTH_0_5);
        s1_4 <= resize(act_0_39_5, SUM_WIDTH_0_5) + resize(act_0_40_5, SUM_WIDTH_0_5) + resize(act_0_42_5, SUM_WIDTH_0_5) + resize(act_0_43_5, SUM_WIDTH_0_5);
        s1_5 <= resize(act_0_44_5, SUM_WIDTH_0_5) + resize(act_0_46_5, SUM_WIDTH_0_5) + resize(act_0_47_5, SUM_WIDTH_0_5) + resize(act_0_49_5, SUM_WIDTH_0_5);
        s1_6 <= resize(act_0_50_5, SUM_WIDTH_0_5) + resize(act_0_52_5, SUM_WIDTH_0_5) + resize(act_0_53_5, SUM_WIDTH_0_5) + resize(act_0_55_5, SUM_WIDTH_0_5);
        s1_7 <= resize(act_0_56_5, SUM_WIDTH_0_5) + resize(act_0_57_5, SUM_WIDTH_0_5) + resize(act_0_59_5, SUM_WIDTH_0_5) + resize(act_0_60_5, SUM_WIDTH_0_5);
        s1_8 <= resize(act_0_61_5, SUM_WIDTH_0_5) + resize(act_0_62_5, SUM_WIDTH_0_5) + resize(act_0_63_5, SUM_WIDTH_0_5);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8;
        -- Stage 3
        sum_0_5 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_5 <= saturate(sum_0_5, 6);
  end block;

  -- LAYER 0, ch 6
  gen_l0c6 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9, s1_10 : sum_t_0_6;
  signal s2_0, s2_1, s2_2 : sum_t_0_6;
  signal sum_0_6 : sum_t_0_6;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_6.mem") port map (clk, input(8), act_0_8_6);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_6.mem") port map (clk, input(9), act_0_9_6);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_6.mem") port map (clk, input(10), act_0_10_6);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_6.mem") port map (clk, input(19), act_0_19_6);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_6.mem") port map (clk, input(24), act_0_24_6);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_6.mem") port map (clk, input(25), act_0_25_6);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_6.mem") port map (clk, input(26), act_0_26_6);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_6.mem") port map (clk, input(27), act_0_27_6);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_6.mem") port map (clk, input(28), act_0_28_6);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_6.mem") port map (clk, input(30), act_0_30_6);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_6.mem") port map (clk, input(31), act_0_31_6);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_6.mem") port map (clk, input(32), act_0_32_6);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_6.mem") port map (clk, input(33), act_0_33_6);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_6.mem") port map (clk, input(34), act_0_34_6);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_6.mem") port map (clk, input(35), act_0_35_6);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_6.mem") port map (clk, input(36), act_0_36_6);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_6.mem") port map (clk, input(37), act_0_37_6);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_6.mem") port map (clk, input(38), act_0_38_6);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_6.mem") port map (clk, input(39), act_0_39_6);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_6.mem") port map (clk, input(40), act_0_40_6);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_6.mem") port map (clk, input(41), act_0_41_6);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_6.mem") port map (clk, input(42), act_0_42_6);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_6.mem") port map (clk, input(43), act_0_43_6);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_6.mem") port map (clk, input(44), act_0_44_6);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_6.mem") port map (clk, input(45), act_0_45_6);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_6.mem") port map (clk, input(46), act_0_46_6);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_6.mem") port map (clk, input(47), act_0_47_6);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_6.mem") port map (clk, input(48), act_0_48_6);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_6.mem") port map (clk, input(49), act_0_49_6);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_6.mem") port map (clk, input(50), act_0_50_6);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_6.mem") port map (clk, input(52), act_0_52_6);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_6.mem") port map (clk, input(53), act_0_53_6);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_6.mem") port map (clk, input(54), act_0_54_6);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_6.mem") port map (clk, input(55), act_0_55_6);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_6.mem") port map (clk, input(56), act_0_56_6);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_57_6.mem") port map (clk, input(57), act_0_57_6);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_58_6.mem") port map (clk, input(58), act_0_58_6);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_6.mem") port map (clk, input(60), act_0_60_6);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_6.mem") port map (clk, input(61), act_0_61_6);
    i39 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_6.mem") port map (clk, input(62), act_0_62_6);
    i40 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_6.mem") port map (clk, input(63), act_0_63_6);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_6, SUM_WIDTH_0_6) + resize(act_0_9_6, SUM_WIDTH_0_6) + resize(act_0_10_6, SUM_WIDTH_0_6) + resize(act_0_19_6, SUM_WIDTH_0_6);
        s1_1 <= resize(act_0_24_6, SUM_WIDTH_0_6) + resize(act_0_25_6, SUM_WIDTH_0_6) + resize(act_0_26_6, SUM_WIDTH_0_6) + resize(act_0_27_6, SUM_WIDTH_0_6);
        s1_2 <= resize(act_0_28_6, SUM_WIDTH_0_6) + resize(act_0_30_6, SUM_WIDTH_0_6) + resize(act_0_31_6, SUM_WIDTH_0_6) + resize(act_0_32_6, SUM_WIDTH_0_6);
        s1_3 <= resize(act_0_33_6, SUM_WIDTH_0_6) + resize(act_0_34_6, SUM_WIDTH_0_6) + resize(act_0_35_6, SUM_WIDTH_0_6) + resize(act_0_36_6, SUM_WIDTH_0_6);
        s1_4 <= resize(act_0_37_6, SUM_WIDTH_0_6) + resize(act_0_38_6, SUM_WIDTH_0_6) + resize(act_0_39_6, SUM_WIDTH_0_6) + resize(act_0_40_6, SUM_WIDTH_0_6);
        s1_5 <= resize(act_0_41_6, SUM_WIDTH_0_6) + resize(act_0_42_6, SUM_WIDTH_0_6) + resize(act_0_43_6, SUM_WIDTH_0_6) + resize(act_0_44_6, SUM_WIDTH_0_6);
        s1_6 <= resize(act_0_45_6, SUM_WIDTH_0_6) + resize(act_0_46_6, SUM_WIDTH_0_6) + resize(act_0_47_6, SUM_WIDTH_0_6) + resize(act_0_48_6, SUM_WIDTH_0_6);
        s1_7 <= resize(act_0_49_6, SUM_WIDTH_0_6) + resize(act_0_50_6, SUM_WIDTH_0_6) + resize(act_0_52_6, SUM_WIDTH_0_6) + resize(act_0_53_6, SUM_WIDTH_0_6);
        s1_8 <= resize(act_0_54_6, SUM_WIDTH_0_6) + resize(act_0_55_6, SUM_WIDTH_0_6) + resize(act_0_56_6, SUM_WIDTH_0_6) + resize(act_0_57_6, SUM_WIDTH_0_6);
        s1_9 <= resize(act_0_58_6, SUM_WIDTH_0_6) + resize(act_0_60_6, SUM_WIDTH_0_6) + resize(act_0_61_6, SUM_WIDTH_0_6) + resize(act_0_62_6, SUM_WIDTH_0_6);
        s1_10 <= resize(act_0_63_6, SUM_WIDTH_0_6);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9 + s1_10;
        -- Stage 3
        sum_0_6 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_6 <= saturate(sum_0_6, 6);
  end block;

  -- LAYER 0, ch 7
  gen_l0c7 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8 : sum_t_0_7;
  signal s2_0, s2_1, s2_2 : sum_t_0_7;
  signal sum_0_7 : sum_t_0_7;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_3_7.mem") port map (clk, input(3), act_0_3_7);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_7.mem") port map (clk, input(8), act_0_8_7);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_7.mem") port map (clk, input(9), act_0_9_7);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_7.mem") port map (clk, input(10), act_0_10_7);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_7.mem") port map (clk, input(11), act_0_11_7);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_7.mem") port map (clk, input(14), act_0_14_7);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_7.mem") port map (clk, input(22), act_0_22_7);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_7.mem") port map (clk, input(23), act_0_23_7);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_7.mem") port map (clk, input(25), act_0_25_7);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_7.mem") port map (clk, input(26), act_0_26_7);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_7.mem") port map (clk, input(27), act_0_27_7);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_7.mem") port map (clk, input(29), act_0_29_7);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_7.mem") port map (clk, input(31), act_0_31_7);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_7.mem") port map (clk, input(32), act_0_32_7);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_7.mem") port map (clk, input(33), act_0_33_7);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_7.mem") port map (clk, input(35), act_0_35_7);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_7.mem") port map (clk, input(36), act_0_36_7);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_7.mem") port map (clk, input(38), act_0_38_7);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_7.mem") port map (clk, input(39), act_0_39_7);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_7.mem") port map (clk, input(41), act_0_41_7);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_7.mem") port map (clk, input(42), act_0_42_7);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_7.mem") port map (clk, input(47), act_0_47_7);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_7.mem") port map (clk, input(48), act_0_48_7);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_7.mem") port map (clk, input(50), act_0_50_7);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_7.mem") port map (clk, input(54), act_0_54_7);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_7.mem") port map (clk, input(55), act_0_55_7);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_7.mem") port map (clk, input(56), act_0_56_7);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_58_7.mem") port map (clk, input(58), act_0_58_7);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_7.mem") port map (clk, input(59), act_0_59_7);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_7.mem") port map (clk, input(60), act_0_60_7);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_7.mem") port map (clk, input(61), act_0_61_7);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_7.mem") port map (clk, input(62), act_0_62_7);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_7.mem") port map (clk, input(63), act_0_63_7);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_3_7, SUM_WIDTH_0_7) + resize(act_0_8_7, SUM_WIDTH_0_7) + resize(act_0_9_7, SUM_WIDTH_0_7) + resize(act_0_10_7, SUM_WIDTH_0_7);
        s1_1 <= resize(act_0_11_7, SUM_WIDTH_0_7) + resize(act_0_14_7, SUM_WIDTH_0_7) + resize(act_0_22_7, SUM_WIDTH_0_7) + resize(act_0_23_7, SUM_WIDTH_0_7);
        s1_2 <= resize(act_0_25_7, SUM_WIDTH_0_7) + resize(act_0_26_7, SUM_WIDTH_0_7) + resize(act_0_27_7, SUM_WIDTH_0_7) + resize(act_0_29_7, SUM_WIDTH_0_7);
        s1_3 <= resize(act_0_31_7, SUM_WIDTH_0_7) + resize(act_0_32_7, SUM_WIDTH_0_7) + resize(act_0_33_7, SUM_WIDTH_0_7) + resize(act_0_35_7, SUM_WIDTH_0_7);
        s1_4 <= resize(act_0_36_7, SUM_WIDTH_0_7) + resize(act_0_38_7, SUM_WIDTH_0_7) + resize(act_0_39_7, SUM_WIDTH_0_7) + resize(act_0_41_7, SUM_WIDTH_0_7);
        s1_5 <= resize(act_0_42_7, SUM_WIDTH_0_7) + resize(act_0_47_7, SUM_WIDTH_0_7) + resize(act_0_48_7, SUM_WIDTH_0_7) + resize(act_0_50_7, SUM_WIDTH_0_7);
        s1_6 <= resize(act_0_54_7, SUM_WIDTH_0_7) + resize(act_0_55_7, SUM_WIDTH_0_7) + resize(act_0_56_7, SUM_WIDTH_0_7) + resize(act_0_58_7, SUM_WIDTH_0_7);
        s1_7 <= resize(act_0_59_7, SUM_WIDTH_0_7) + resize(act_0_60_7, SUM_WIDTH_0_7) + resize(act_0_61_7, SUM_WIDTH_0_7) + resize(act_0_62_7, SUM_WIDTH_0_7);
        s1_8 <= resize(act_0_63_7, SUM_WIDTH_0_7);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8;
        -- Stage 3
        sum_0_7 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_7 <= saturate(sum_0_7, 6);
  end block;

  -- LAYER 0, ch 8
  gen_l0c8 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7 : sum_t_0_8;
  signal s2_0, s2_1 : sum_t_0_8;
  signal sum_0_8 : sum_t_0_8;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_8.mem") port map (clk, input(8), act_0_8_8);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_8.mem") port map (clk, input(9), act_0_9_8);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_8.mem") port map (clk, input(10), act_0_10_8);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_8.mem") port map (clk, input(11), act_0_11_8);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_8.mem") port map (clk, input(14), act_0_14_8);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_8.mem") port map (clk, input(26), act_0_26_8);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_8.mem") port map (clk, input(27), act_0_27_8);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_8.mem") port map (clk, input(28), act_0_28_8);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_8.mem") port map (clk, input(30), act_0_30_8);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_8.mem") port map (clk, input(32), act_0_32_8);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_8.mem") port map (clk, input(34), act_0_34_8);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_8.mem") port map (clk, input(36), act_0_36_8);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_8.mem") port map (clk, input(37), act_0_37_8);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_8.mem") port map (clk, input(38), act_0_38_8);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_8.mem") port map (clk, input(39), act_0_39_8);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_8.mem") port map (clk, input(44), act_0_44_8);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_8.mem") port map (clk, input(45), act_0_45_8);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_8.mem") port map (clk, input(49), act_0_49_8);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_8.mem") port map (clk, input(51), act_0_51_8);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_8.mem") port map (clk, input(52), act_0_52_8);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_8.mem") port map (clk, input(53), act_0_53_8);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_8.mem") port map (clk, input(54), act_0_54_8);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_8.mem") port map (clk, input(55), act_0_55_8);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_8.mem") port map (clk, input(56), act_0_56_8);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_57_8.mem") port map (clk, input(57), act_0_57_8);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_58_8.mem") port map (clk, input(58), act_0_58_8);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_8.mem") port map (clk, input(59), act_0_59_8);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_8.mem") port map (clk, input(60), act_0_60_8);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_8.mem") port map (clk, input(62), act_0_62_8);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_8.mem") port map (clk, input(63), act_0_63_8);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_8, SUM_WIDTH_0_8) + resize(act_0_9_8, SUM_WIDTH_0_8) + resize(act_0_10_8, SUM_WIDTH_0_8) + resize(act_0_11_8, SUM_WIDTH_0_8);
        s1_1 <= resize(act_0_14_8, SUM_WIDTH_0_8) + resize(act_0_26_8, SUM_WIDTH_0_8) + resize(act_0_27_8, SUM_WIDTH_0_8) + resize(act_0_28_8, SUM_WIDTH_0_8);
        s1_2 <= resize(act_0_30_8, SUM_WIDTH_0_8) + resize(act_0_32_8, SUM_WIDTH_0_8) + resize(act_0_34_8, SUM_WIDTH_0_8) + resize(act_0_36_8, SUM_WIDTH_0_8);
        s1_3 <= resize(act_0_37_8, SUM_WIDTH_0_8) + resize(act_0_38_8, SUM_WIDTH_0_8) + resize(act_0_39_8, SUM_WIDTH_0_8) + resize(act_0_44_8, SUM_WIDTH_0_8);
        s1_4 <= resize(act_0_45_8, SUM_WIDTH_0_8) + resize(act_0_49_8, SUM_WIDTH_0_8) + resize(act_0_51_8, SUM_WIDTH_0_8) + resize(act_0_52_8, SUM_WIDTH_0_8);
        s1_5 <= resize(act_0_53_8, SUM_WIDTH_0_8) + resize(act_0_54_8, SUM_WIDTH_0_8) + resize(act_0_55_8, SUM_WIDTH_0_8) + resize(act_0_56_8, SUM_WIDTH_0_8);
        s1_6 <= resize(act_0_57_8, SUM_WIDTH_0_8) + resize(act_0_58_8, SUM_WIDTH_0_8) + resize(act_0_59_8, SUM_WIDTH_0_8) + resize(act_0_60_8, SUM_WIDTH_0_8);
        s1_7 <= resize(act_0_62_8, SUM_WIDTH_0_8) + resize(act_0_63_8, SUM_WIDTH_0_8);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        -- Stage 3
        sum_0_8 <= s2_0 + s2_1;
      end if;
    end process;
    out0_8 <= saturate(sum_0_8, 6);
  end block;

  -- LAYER 0, ch 9
  gen_l0c9 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_0_9;
  signal s2_0, s2_1 : sum_t_0_9;
  signal sum_0_9 : sum_t_0_9;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_0_9.mem") port map (clk, input(0), act_0_0_9);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_9.mem") port map (clk, input(8), act_0_8_9);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_9.mem") port map (clk, input(9), act_0_9_9);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_9.mem") port map (clk, input(10), act_0_10_9);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_9.mem") port map (clk, input(11), act_0_11_9);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_9.mem") port map (clk, input(14), act_0_14_9);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_9.mem") port map (clk, input(23), act_0_23_9);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_9.mem") port map (clk, input(24), act_0_24_9);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_9.mem") port map (clk, input(26), act_0_26_9);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_9.mem") port map (clk, input(29), act_0_29_9);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_9.mem") port map (clk, input(30), act_0_30_9);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_9.mem") port map (clk, input(31), act_0_31_9);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_9.mem") port map (clk, input(33), act_0_33_9);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_9.mem") port map (clk, input(35), act_0_35_9);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_9.mem") port map (clk, input(37), act_0_37_9);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_9.mem") port map (clk, input(38), act_0_38_9);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_9.mem") port map (clk, input(39), act_0_39_9);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_9.mem") port map (clk, input(40), act_0_40_9);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_9.mem") port map (clk, input(43), act_0_43_9);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_9.mem") port map (clk, input(46), act_0_46_9);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_9.mem") port map (clk, input(47), act_0_47_9);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_9.mem") port map (clk, input(49), act_0_49_9);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_9.mem") port map (clk, input(56), act_0_56_9);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_9.mem") port map (clk, input(59), act_0_59_9);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_9.mem") port map (clk, input(61), act_0_61_9);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_9.mem") port map (clk, input(62), act_0_62_9);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_9.mem") port map (clk, input(63), act_0_63_9);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_0_9, SUM_WIDTH_0_9) + resize(act_0_8_9, SUM_WIDTH_0_9) + resize(act_0_9_9, SUM_WIDTH_0_9) + resize(act_0_10_9, SUM_WIDTH_0_9);
        s1_1 <= resize(act_0_11_9, SUM_WIDTH_0_9) + resize(act_0_14_9, SUM_WIDTH_0_9) + resize(act_0_23_9, SUM_WIDTH_0_9) + resize(act_0_24_9, SUM_WIDTH_0_9);
        s1_2 <= resize(act_0_26_9, SUM_WIDTH_0_9) + resize(act_0_29_9, SUM_WIDTH_0_9) + resize(act_0_30_9, SUM_WIDTH_0_9) + resize(act_0_31_9, SUM_WIDTH_0_9);
        s1_3 <= resize(act_0_33_9, SUM_WIDTH_0_9) + resize(act_0_35_9, SUM_WIDTH_0_9) + resize(act_0_37_9, SUM_WIDTH_0_9) + resize(act_0_38_9, SUM_WIDTH_0_9);
        s1_4 <= resize(act_0_39_9, SUM_WIDTH_0_9) + resize(act_0_40_9, SUM_WIDTH_0_9) + resize(act_0_43_9, SUM_WIDTH_0_9) + resize(act_0_46_9, SUM_WIDTH_0_9);
        s1_5 <= resize(act_0_47_9, SUM_WIDTH_0_9) + resize(act_0_49_9, SUM_WIDTH_0_9) + resize(act_0_56_9, SUM_WIDTH_0_9) + resize(act_0_59_9, SUM_WIDTH_0_9);
        s1_6 <= resize(act_0_61_9, SUM_WIDTH_0_9) + resize(act_0_62_9, SUM_WIDTH_0_9) + resize(act_0_63_9, SUM_WIDTH_0_9);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
        -- Stage 3
        sum_0_9 <= s2_0 + s2_1;
      end if;
    end process;
    out0_9 <= saturate(sum_0_9, 6);
  end block;

  -- LAYER 0, ch 10
  gen_l0c10 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8 : sum_t_0_10;
  signal s2_0, s2_1, s2_2 : sum_t_0_10;
  signal sum_0_10 : sum_t_0_10;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_1_10.mem") port map (clk, input(1), act_0_1_10);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_10.mem") port map (clk, input(8), act_0_8_10);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_10.mem") port map (clk, input(9), act_0_9_10);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_10.mem") port map (clk, input(10), act_0_10_10);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_10.mem") port map (clk, input(14), act_0_14_10);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_22_10.mem") port map (clk, input(22), act_0_22_10);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_10.mem") port map (clk, input(24), act_0_24_10);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_10.mem") port map (clk, input(25), act_0_25_10);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_10.mem") port map (clk, input(26), act_0_26_10);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_10.mem") port map (clk, input(27), act_0_27_10);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_10.mem") port map (clk, input(28), act_0_28_10);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_10.mem") port map (clk, input(29), act_0_29_10);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_10.mem") port map (clk, input(30), act_0_30_10);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_10.mem") port map (clk, input(31), act_0_31_10);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_10.mem") port map (clk, input(32), act_0_32_10);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_10.mem") port map (clk, input(33), act_0_33_10);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_10.mem") port map (clk, input(34), act_0_34_10);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_10.mem") port map (clk, input(36), act_0_36_10);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_10.mem") port map (clk, input(37), act_0_37_10);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_10.mem") port map (clk, input(39), act_0_39_10);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_10.mem") port map (clk, input(41), act_0_41_10);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_10.mem") port map (clk, input(42), act_0_42_10);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_10.mem") port map (clk, input(43), act_0_43_10);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_10.mem") port map (clk, input(44), act_0_44_10);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_10.mem") port map (clk, input(47), act_0_47_10);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_10.mem") port map (clk, input(48), act_0_48_10);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_10.mem") port map (clk, input(49), act_0_49_10);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_10.mem") port map (clk, input(50), act_0_50_10);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_10.mem") port map (clk, input(51), act_0_51_10);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_10.mem") port map (clk, input(52), act_0_52_10);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_10.mem") port map (clk, input(54), act_0_54_10);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_10.mem") port map (clk, input(55), act_0_55_10);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_10.mem") port map (clk, input(59), act_0_59_10);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_10.mem") port map (clk, input(60), act_0_60_10);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_10.mem") port map (clk, input(62), act_0_62_10);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_1_10, SUM_WIDTH_0_10) + resize(act_0_8_10, SUM_WIDTH_0_10) + resize(act_0_9_10, SUM_WIDTH_0_10) + resize(act_0_10_10, SUM_WIDTH_0_10);
        s1_1 <= resize(act_0_14_10, SUM_WIDTH_0_10) + resize(act_0_22_10, SUM_WIDTH_0_10) + resize(act_0_24_10, SUM_WIDTH_0_10) + resize(act_0_25_10, SUM_WIDTH_0_10);
        s1_2 <= resize(act_0_26_10, SUM_WIDTH_0_10) + resize(act_0_27_10, SUM_WIDTH_0_10) + resize(act_0_28_10, SUM_WIDTH_0_10) + resize(act_0_29_10, SUM_WIDTH_0_10);
        s1_3 <= resize(act_0_30_10, SUM_WIDTH_0_10) + resize(act_0_31_10, SUM_WIDTH_0_10) + resize(act_0_32_10, SUM_WIDTH_0_10) + resize(act_0_33_10, SUM_WIDTH_0_10);
        s1_4 <= resize(act_0_34_10, SUM_WIDTH_0_10) + resize(act_0_36_10, SUM_WIDTH_0_10) + resize(act_0_37_10, SUM_WIDTH_0_10) + resize(act_0_39_10, SUM_WIDTH_0_10);
        s1_5 <= resize(act_0_41_10, SUM_WIDTH_0_10) + resize(act_0_42_10, SUM_WIDTH_0_10) + resize(act_0_43_10, SUM_WIDTH_0_10) + resize(act_0_44_10, SUM_WIDTH_0_10);
        s1_6 <= resize(act_0_47_10, SUM_WIDTH_0_10) + resize(act_0_48_10, SUM_WIDTH_0_10) + resize(act_0_49_10, SUM_WIDTH_0_10) + resize(act_0_50_10, SUM_WIDTH_0_10);
        s1_7 <= resize(act_0_51_10, SUM_WIDTH_0_10) + resize(act_0_52_10, SUM_WIDTH_0_10) + resize(act_0_54_10, SUM_WIDTH_0_10) + resize(act_0_55_10, SUM_WIDTH_0_10);
        s1_8 <= resize(act_0_59_10, SUM_WIDTH_0_10) + resize(act_0_60_10, SUM_WIDTH_0_10) + resize(act_0_62_10, SUM_WIDTH_0_10);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8;
        -- Stage 3
        sum_0_10 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_10 <= saturate(sum_0_10, 6);
  end block;

  -- LAYER 0, ch 11
  gen_l0c11 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7 : sum_t_0_11;
  signal s2_0, s2_1 : sum_t_0_11;
  signal sum_0_11 : sum_t_0_11;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_11.mem") port map (clk, input(8), act_0_8_11);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_11.mem") port map (clk, input(9), act_0_9_11);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_11.mem") port map (clk, input(10), act_0_10_11);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_11.mem") port map (clk, input(11), act_0_11_11);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_25_11.mem") port map (clk, input(25), act_0_25_11);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_11.mem") port map (clk, input(26), act_0_26_11);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_11.mem") port map (clk, input(27), act_0_27_11);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_11.mem") port map (clk, input(28), act_0_28_11);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_11.mem") port map (clk, input(29), act_0_29_11);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_11.mem") port map (clk, input(30), act_0_30_11);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_11.mem") port map (clk, input(31), act_0_31_11);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_11.mem") port map (clk, input(32), act_0_32_11);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_11.mem") port map (clk, input(33), act_0_33_11);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_11.mem") port map (clk, input(34), act_0_34_11);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_11.mem") port map (clk, input(35), act_0_35_11);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_11.mem") port map (clk, input(36), act_0_36_11);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_11.mem") port map (clk, input(37), act_0_37_11);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_11.mem") port map (clk, input(38), act_0_38_11);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_11.mem") port map (clk, input(39), act_0_39_11);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_11.mem") port map (clk, input(42), act_0_42_11);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_11.mem") port map (clk, input(43), act_0_43_11);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_11.mem") port map (clk, input(44), act_0_44_11);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_11.mem") port map (clk, input(45), act_0_45_11);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_11.mem") port map (clk, input(46), act_0_46_11);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_11.mem") port map (clk, input(47), act_0_47_11);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_11.mem") port map (clk, input(48), act_0_48_11);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_11.mem") port map (clk, input(49), act_0_49_11);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_11.mem") port map (clk, input(50), act_0_50_11);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_11.mem") port map (clk, input(51), act_0_51_11);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_11.mem") port map (clk, input(54), act_0_54_11);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_11.mem") port map (clk, input(62), act_0_62_11);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_11.mem") port map (clk, input(63), act_0_63_11);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_11, SUM_WIDTH_0_11) + resize(act_0_9_11, SUM_WIDTH_0_11) + resize(act_0_10_11, SUM_WIDTH_0_11) + resize(act_0_11_11, SUM_WIDTH_0_11);
        s1_1 <= resize(act_0_25_11, SUM_WIDTH_0_11) + resize(act_0_26_11, SUM_WIDTH_0_11) + resize(act_0_27_11, SUM_WIDTH_0_11) + resize(act_0_28_11, SUM_WIDTH_0_11);
        s1_2 <= resize(act_0_29_11, SUM_WIDTH_0_11) + resize(act_0_30_11, SUM_WIDTH_0_11) + resize(act_0_31_11, SUM_WIDTH_0_11) + resize(act_0_32_11, SUM_WIDTH_0_11);
        s1_3 <= resize(act_0_33_11, SUM_WIDTH_0_11) + resize(act_0_34_11, SUM_WIDTH_0_11) + resize(act_0_35_11, SUM_WIDTH_0_11) + resize(act_0_36_11, SUM_WIDTH_0_11);
        s1_4 <= resize(act_0_37_11, SUM_WIDTH_0_11) + resize(act_0_38_11, SUM_WIDTH_0_11) + resize(act_0_39_11, SUM_WIDTH_0_11) + resize(act_0_42_11, SUM_WIDTH_0_11);
        s1_5 <= resize(act_0_43_11, SUM_WIDTH_0_11) + resize(act_0_44_11, SUM_WIDTH_0_11) + resize(act_0_45_11, SUM_WIDTH_0_11) + resize(act_0_46_11, SUM_WIDTH_0_11);
        s1_6 <= resize(act_0_47_11, SUM_WIDTH_0_11) + resize(act_0_48_11, SUM_WIDTH_0_11) + resize(act_0_49_11, SUM_WIDTH_0_11) + resize(act_0_50_11, SUM_WIDTH_0_11);
        s1_7 <= resize(act_0_51_11, SUM_WIDTH_0_11) + resize(act_0_54_11, SUM_WIDTH_0_11) + resize(act_0_62_11, SUM_WIDTH_0_11) + resize(act_0_63_11, SUM_WIDTH_0_11);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        -- Stage 3
        sum_0_11 <= s2_0 + s2_1;
      end if;
    end process;
    out0_11 <= saturate(sum_0_11, 6);
  end block;

  -- LAYER 0, ch 12
  gen_l0c12 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7 : sum_t_0_12;
  signal s2_0, s2_1 : sum_t_0_12;
  signal sum_0_12 : sum_t_0_12;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_12.mem") port map (clk, input(8), act_0_8_12);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_12.mem") port map (clk, input(9), act_0_9_12);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_12.mem") port map (clk, input(10), act_0_10_12);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_12.mem") port map (clk, input(11), act_0_11_12);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_13_12.mem") port map (clk, input(13), act_0_13_12);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_12.mem") port map (clk, input(14), act_0_14_12);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_17_12.mem") port map (clk, input(17), act_0_17_12);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_12.mem") port map (clk, input(24), act_0_24_12);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_12.mem") port map (clk, input(26), act_0_26_12);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_12.mem") port map (clk, input(28), act_0_28_12);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_12.mem") port map (clk, input(30), act_0_30_12);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_12.mem") port map (clk, input(31), act_0_31_12);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_12.mem") port map (clk, input(32), act_0_32_12);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_12.mem") port map (clk, input(33), act_0_33_12);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_12.mem") port map (clk, input(34), act_0_34_12);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_12.mem") port map (clk, input(35), act_0_35_12);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_12.mem") port map (clk, input(37), act_0_37_12);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_12.mem") port map (clk, input(38), act_0_38_12);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_12.mem") port map (clk, input(40), act_0_40_12);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_12.mem") port map (clk, input(41), act_0_41_12);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_12.mem") port map (clk, input(43), act_0_43_12);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_12.mem") port map (clk, input(44), act_0_44_12);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_12.mem") port map (clk, input(48), act_0_48_12);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_12.mem") port map (clk, input(49), act_0_49_12);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_12.mem") port map (clk, input(50), act_0_50_12);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_12.mem") port map (clk, input(51), act_0_51_12);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_12.mem") port map (clk, input(52), act_0_52_12);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_12.mem") port map (clk, input(54), act_0_54_12);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_12.mem") port map (clk, input(59), act_0_59_12);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_12.mem") port map (clk, input(60), act_0_60_12);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_12.mem") port map (clk, input(61), act_0_61_12);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_12.mem") port map (clk, input(62), act_0_62_12);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_12, SUM_WIDTH_0_12) + resize(act_0_9_12, SUM_WIDTH_0_12) + resize(act_0_10_12, SUM_WIDTH_0_12) + resize(act_0_11_12, SUM_WIDTH_0_12);
        s1_1 <= resize(act_0_13_12, SUM_WIDTH_0_12) + resize(act_0_14_12, SUM_WIDTH_0_12) + resize(act_0_17_12, SUM_WIDTH_0_12) + resize(act_0_24_12, SUM_WIDTH_0_12);
        s1_2 <= resize(act_0_26_12, SUM_WIDTH_0_12) + resize(act_0_28_12, SUM_WIDTH_0_12) + resize(act_0_30_12, SUM_WIDTH_0_12) + resize(act_0_31_12, SUM_WIDTH_0_12);
        s1_3 <= resize(act_0_32_12, SUM_WIDTH_0_12) + resize(act_0_33_12, SUM_WIDTH_0_12) + resize(act_0_34_12, SUM_WIDTH_0_12) + resize(act_0_35_12, SUM_WIDTH_0_12);
        s1_4 <= resize(act_0_37_12, SUM_WIDTH_0_12) + resize(act_0_38_12, SUM_WIDTH_0_12) + resize(act_0_40_12, SUM_WIDTH_0_12) + resize(act_0_41_12, SUM_WIDTH_0_12);
        s1_5 <= resize(act_0_43_12, SUM_WIDTH_0_12) + resize(act_0_44_12, SUM_WIDTH_0_12) + resize(act_0_48_12, SUM_WIDTH_0_12) + resize(act_0_49_12, SUM_WIDTH_0_12);
        s1_6 <= resize(act_0_50_12, SUM_WIDTH_0_12) + resize(act_0_51_12, SUM_WIDTH_0_12) + resize(act_0_52_12, SUM_WIDTH_0_12) + resize(act_0_54_12, SUM_WIDTH_0_12);
        s1_7 <= resize(act_0_59_12, SUM_WIDTH_0_12) + resize(act_0_60_12, SUM_WIDTH_0_12) + resize(act_0_61_12, SUM_WIDTH_0_12) + resize(act_0_62_12, SUM_WIDTH_0_12);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        -- Stage 3
        sum_0_12 <= s2_0 + s2_1;
      end if;
    end process;
    out0_12 <= saturate(sum_0_12, 6);
  end block;

  -- LAYER 0, ch 13
  gen_l0c13 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_13;
  signal s2_0, s2_1, s2_2 : sum_t_0_13;
  signal sum_0_13 : sum_t_0_13;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_13.mem") port map (clk, input(8), act_0_8_13);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_13.mem") port map (clk, input(9), act_0_9_13);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_13.mem") port map (clk, input(10), act_0_10_13);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_13.mem") port map (clk, input(11), act_0_11_13);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_13.mem") port map (clk, input(14), act_0_14_13);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_15_13.mem") port map (clk, input(15), act_0_15_13);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_19_13.mem") port map (clk, input(19), act_0_19_13);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_21_13.mem") port map (clk, input(21), act_0_21_13);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_13.mem") port map (clk, input(23), act_0_23_13);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_13.mem") port map (clk, input(24), act_0_24_13);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_13.mem") port map (clk, input(26), act_0_26_13);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_13.mem") port map (clk, input(27), act_0_27_13);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_13.mem") port map (clk, input(28), act_0_28_13);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_13.mem") port map (clk, input(29), act_0_29_13);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_13.mem") port map (clk, input(30), act_0_30_13);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_13.mem") port map (clk, input(31), act_0_31_13);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_13.mem") port map (clk, input(32), act_0_32_13);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_13.mem") port map (clk, input(33), act_0_33_13);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_13.mem") port map (clk, input(34), act_0_34_13);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_13.mem") port map (clk, input(35), act_0_35_13);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_40_13.mem") port map (clk, input(40), act_0_40_13);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_13.mem") port map (clk, input(41), act_0_41_13);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_13.mem") port map (clk, input(42), act_0_42_13);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_13.mem") port map (clk, input(43), act_0_43_13);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_13.mem") port map (clk, input(44), act_0_44_13);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_13.mem") port map (clk, input(46), act_0_46_13);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_13.mem") port map (clk, input(47), act_0_47_13);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_48_13.mem") port map (clk, input(48), act_0_48_13);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_13.mem") port map (clk, input(49), act_0_49_13);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_13.mem") port map (clk, input(51), act_0_51_13);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_13.mem") port map (clk, input(53), act_0_53_13);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_13.mem") port map (clk, input(55), act_0_55_13);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_56_13.mem") port map (clk, input(56), act_0_56_13);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_58_13.mem") port map (clk, input(58), act_0_58_13);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_13.mem") port map (clk, input(59), act_0_59_13);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_13.mem") port map (clk, input(62), act_0_62_13);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_13.mem") port map (clk, input(63), act_0_63_13);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_13, SUM_WIDTH_0_13) + resize(act_0_9_13, SUM_WIDTH_0_13) + resize(act_0_10_13, SUM_WIDTH_0_13) + resize(act_0_11_13, SUM_WIDTH_0_13);
        s1_1 <= resize(act_0_14_13, SUM_WIDTH_0_13) + resize(act_0_15_13, SUM_WIDTH_0_13) + resize(act_0_19_13, SUM_WIDTH_0_13) + resize(act_0_21_13, SUM_WIDTH_0_13);
        s1_2 <= resize(act_0_23_13, SUM_WIDTH_0_13) + resize(act_0_24_13, SUM_WIDTH_0_13) + resize(act_0_26_13, SUM_WIDTH_0_13) + resize(act_0_27_13, SUM_WIDTH_0_13);
        s1_3 <= resize(act_0_28_13, SUM_WIDTH_0_13) + resize(act_0_29_13, SUM_WIDTH_0_13) + resize(act_0_30_13, SUM_WIDTH_0_13) + resize(act_0_31_13, SUM_WIDTH_0_13);
        s1_4 <= resize(act_0_32_13, SUM_WIDTH_0_13) + resize(act_0_33_13, SUM_WIDTH_0_13) + resize(act_0_34_13, SUM_WIDTH_0_13) + resize(act_0_35_13, SUM_WIDTH_0_13);
        s1_5 <= resize(act_0_40_13, SUM_WIDTH_0_13) + resize(act_0_41_13, SUM_WIDTH_0_13) + resize(act_0_42_13, SUM_WIDTH_0_13) + resize(act_0_43_13, SUM_WIDTH_0_13);
        s1_6 <= resize(act_0_44_13, SUM_WIDTH_0_13) + resize(act_0_46_13, SUM_WIDTH_0_13) + resize(act_0_47_13, SUM_WIDTH_0_13) + resize(act_0_48_13, SUM_WIDTH_0_13);
        s1_7 <= resize(act_0_49_13, SUM_WIDTH_0_13) + resize(act_0_51_13, SUM_WIDTH_0_13) + resize(act_0_53_13, SUM_WIDTH_0_13) + resize(act_0_55_13, SUM_WIDTH_0_13);
        s1_8 <= resize(act_0_56_13, SUM_WIDTH_0_13) + resize(act_0_58_13, SUM_WIDTH_0_13) + resize(act_0_59_13, SUM_WIDTH_0_13) + resize(act_0_62_13, SUM_WIDTH_0_13);
        s1_9 <= resize(act_0_63_13, SUM_WIDTH_0_13);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_13 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_13 <= saturate(sum_0_13, 6);
  end block;

  -- LAYER 0, ch 14
  gen_l0c14 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8, s1_9 : sum_t_0_14;
  signal s2_0, s2_1, s2_2 : sum_t_0_14;
  signal sum_0_14 : sum_t_0_14;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_14.mem") port map (clk, input(8), act_0_8_14);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_14.mem") port map (clk, input(9), act_0_9_14);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_10_14.mem") port map (clk, input(10), act_0_10_14);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_11_14.mem") port map (clk, input(11), act_0_11_14);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_14.mem") port map (clk, input(23), act_0_23_14);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_14.mem") port map (clk, input(24), act_0_24_14);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_26_14.mem") port map (clk, input(26), act_0_26_14);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_14.mem") port map (clk, input(27), act_0_27_14);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_14.mem") port map (clk, input(28), act_0_28_14);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_14.mem") port map (clk, input(29), act_0_29_14);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_14.mem") port map (clk, input(31), act_0_31_14);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_14.mem") port map (clk, input(32), act_0_32_14);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_14.mem") port map (clk, input(33), act_0_33_14);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_34_14.mem") port map (clk, input(34), act_0_34_14);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_35_14.mem") port map (clk, input(35), act_0_35_14);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_36_14.mem") port map (clk, input(36), act_0_36_14);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_14.mem") port map (clk, input(37), act_0_37_14);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_38_14.mem") port map (clk, input(38), act_0_38_14);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_39_14.mem") port map (clk, input(39), act_0_39_14);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_41_14.mem") port map (clk, input(41), act_0_41_14);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_14.mem") port map (clk, input(42), act_0_42_14);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_43_14.mem") port map (clk, input(43), act_0_43_14);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_44_14.mem") port map (clk, input(44), act_0_44_14);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_14.mem") port map (clk, input(45), act_0_45_14);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_14.mem") port map (clk, input(46), act_0_46_14);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_14.mem") port map (clk, input(47), act_0_47_14);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_14.mem") port map (clk, input(49), act_0_49_14);
    i27 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_14.mem") port map (clk, input(50), act_0_50_14);
    i28 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_52_14.mem") port map (clk, input(52), act_0_52_14);
    i29 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_14.mem") port map (clk, input(53), act_0_53_14);
    i30 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_54_14.mem") port map (clk, input(54), act_0_54_14);
    i31 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_14.mem") port map (clk, input(55), act_0_55_14);
    i32 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_57_14.mem") port map (clk, input(57), act_0_57_14);
    i33 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_58_14.mem") port map (clk, input(58), act_0_58_14);
    i34 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_59_14.mem") port map (clk, input(59), act_0_59_14);
    i35 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_14.mem") port map (clk, input(60), act_0_60_14);
    i36 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_14.mem") port map (clk, input(61), act_0_61_14);
    i37 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_14.mem") port map (clk, input(62), act_0_62_14);
    i38 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_14.mem") port map (clk, input(63), act_0_63_14);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_8_14, SUM_WIDTH_0_14) + resize(act_0_9_14, SUM_WIDTH_0_14) + resize(act_0_10_14, SUM_WIDTH_0_14) + resize(act_0_11_14, SUM_WIDTH_0_14);
        s1_1 <= resize(act_0_23_14, SUM_WIDTH_0_14) + resize(act_0_24_14, SUM_WIDTH_0_14) + resize(act_0_26_14, SUM_WIDTH_0_14) + resize(act_0_27_14, SUM_WIDTH_0_14);
        s1_2 <= resize(act_0_28_14, SUM_WIDTH_0_14) + resize(act_0_29_14, SUM_WIDTH_0_14) + resize(act_0_31_14, SUM_WIDTH_0_14) + resize(act_0_32_14, SUM_WIDTH_0_14);
        s1_3 <= resize(act_0_33_14, SUM_WIDTH_0_14) + resize(act_0_34_14, SUM_WIDTH_0_14) + resize(act_0_35_14, SUM_WIDTH_0_14) + resize(act_0_36_14, SUM_WIDTH_0_14);
        s1_4 <= resize(act_0_37_14, SUM_WIDTH_0_14) + resize(act_0_38_14, SUM_WIDTH_0_14) + resize(act_0_39_14, SUM_WIDTH_0_14) + resize(act_0_41_14, SUM_WIDTH_0_14);
        s1_5 <= resize(act_0_42_14, SUM_WIDTH_0_14) + resize(act_0_43_14, SUM_WIDTH_0_14) + resize(act_0_44_14, SUM_WIDTH_0_14) + resize(act_0_45_14, SUM_WIDTH_0_14);
        s1_6 <= resize(act_0_46_14, SUM_WIDTH_0_14) + resize(act_0_47_14, SUM_WIDTH_0_14) + resize(act_0_49_14, SUM_WIDTH_0_14) + resize(act_0_50_14, SUM_WIDTH_0_14);
        s1_7 <= resize(act_0_52_14, SUM_WIDTH_0_14) + resize(act_0_53_14, SUM_WIDTH_0_14) + resize(act_0_54_14, SUM_WIDTH_0_14) + resize(act_0_55_14, SUM_WIDTH_0_14);
        s1_8 <= resize(act_0_57_14, SUM_WIDTH_0_14) + resize(act_0_58_14, SUM_WIDTH_0_14) + resize(act_0_59_14, SUM_WIDTH_0_14) + resize(act_0_60_14, SUM_WIDTH_0_14);
        s1_9 <= resize(act_0_61_14, SUM_WIDTH_0_14) + resize(act_0_62_14, SUM_WIDTH_0_14) + resize(act_0_63_14, SUM_WIDTH_0_14);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6 + s1_7;
        s2_2 <= s1_8 + s1_9;
        -- Stage 3
        sum_0_14 <= s2_0 + s2_1 + s2_2;
      end if;
    end process;
    out0_14 <= saturate(sum_0_14, 6);
  end block;

  -- LAYER 0, ch 15
  gen_l0c15 : block
  signal s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6 : sum_t_0_15;
  signal s2_0, s2_1 : sum_t_0_15;
  signal sum_0_15 : sum_t_0_15;
  begin
    i00 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_2_15.mem") port map (clk, input(2), act_0_2_15);
    i01 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_8_15.mem") port map (clk, input(8), act_0_8_15);
    i02 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_9_15.mem") port map (clk, input(9), act_0_9_15);
    i03 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_14_15.mem") port map (clk, input(14), act_0_14_15);
    i04 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_23_15.mem") port map (clk, input(23), act_0_23_15);
    i05 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_24_15.mem") port map (clk, input(24), act_0_24_15);
    i06 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_27_15.mem") port map (clk, input(27), act_0_27_15);
    i07 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_28_15.mem") port map (clk, input(28), act_0_28_15);
    i08 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_29_15.mem") port map (clk, input(29), act_0_29_15);
    i09 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_30_15.mem") port map (clk, input(30), act_0_30_15);
    i10 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_31_15.mem") port map (clk, input(31), act_0_31_15);
    i11 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_32_15.mem") port map (clk, input(32), act_0_32_15);
    i12 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_33_15.mem") port map (clk, input(33), act_0_33_15);
    i13 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_37_15.mem") port map (clk, input(37), act_0_37_15);
    i14 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_42_15.mem") port map (clk, input(42), act_0_42_15);
    i15 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_45_15.mem") port map (clk, input(45), act_0_45_15);
    i16 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_46_15.mem") port map (clk, input(46), act_0_46_15);
    i17 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_47_15.mem") port map (clk, input(47), act_0_47_15);
    i18 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_49_15.mem") port map (clk, input(49), act_0_49_15);
    i19 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_50_15.mem") port map (clk, input(50), act_0_50_15);
    i20 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_51_15.mem") port map (clk, input(51), act_0_51_15);
    i21 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_53_15.mem") port map (clk, input(53), act_0_53_15);
    i22 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_55_15.mem") port map (clk, input(55), act_0_55_15);
    i23 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_60_15.mem") port map (clk, input(60), act_0_60_15);
    i24 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_61_15.mem") port map (clk, input(61), act_0_61_15);
    i25 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_62_15.mem") port map (clk, input(62), act_0_62_15);
    i26 : entity work.LUT_0 generic map (MEMFILE=>"lut_0_63_15.mem") port map (clk, input(63), act_0_63_15);
    adder_tree : process(clk)
    begin
      if rising_edge(clk) then
        -- Stage 1
        s1_0 <= resize(act_0_2_15, SUM_WIDTH_0_15) + resize(act_0_8_15, SUM_WIDTH_0_15) + resize(act_0_9_15, SUM_WIDTH_0_15) + resize(act_0_14_15, SUM_WIDTH_0_15);
        s1_1 <= resize(act_0_23_15, SUM_WIDTH_0_15) + resize(act_0_24_15, SUM_WIDTH_0_15) + resize(act_0_27_15, SUM_WIDTH_0_15) + resize(act_0_28_15, SUM_WIDTH_0_15);
        s1_2 <= resize(act_0_29_15, SUM_WIDTH_0_15) + resize(act_0_30_15, SUM_WIDTH_0_15) + resize(act_0_31_15, SUM_WIDTH_0_15) + resize(act_0_32_15, SUM_WIDTH_0_15);
        s1_3 <= resize(act_0_33_15, SUM_WIDTH_0_15) + resize(act_0_37_15, SUM_WIDTH_0_15) + resize(act_0_42_15, SUM_WIDTH_0_15) + resize(act_0_45_15, SUM_WIDTH_0_15);
        s1_4 <= resize(act_0_46_15, SUM_WIDTH_0_15) + resize(act_0_47_15, SUM_WIDTH_0_15) + resize(act_0_49_15, SUM_WIDTH_0_15) + resize(act_0_50_15, SUM_WIDTH_0_15);
        s1_5 <= resize(act_0_51_15, SUM_WIDTH_0_15) + resize(act_0_53_15, SUM_WIDTH_0_15) + resize(act_0_55_15, SUM_WIDTH_0_15) + resize(act_0_60_15, SUM_WIDTH_0_15);
        s1_6 <= resize(act_0_61_15, SUM_WIDTH_0_15) + resize(act_0_62_15, SUM_WIDTH_0_15) + resize(act_0_63_15, SUM_WIDTH_0_15);
        -- Stage 2
        s2_0 <= s1_0 + s1_1 + s1_2 + s1_3;
        s2_1 <= s1_4 + s1_5 + s1_6;
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