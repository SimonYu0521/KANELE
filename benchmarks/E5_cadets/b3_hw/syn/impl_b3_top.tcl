# impl_b3_top.tcl : OOC synth + place + route of b3_top (preprocessing + folded KAN + decision)
# Usage (from b3_hw/syn):  vivado -mode batch -source impl_b3_top.tcl [-tclargs <period_ns>]
set DIR    [file normalize [pwd]]
set CORE   [file normalize "$DIR/../../models/20261013_145858_undersample_b3/firmware"]
set PERIOD [expr {[llength $argv] > 0 ? [lindex $argv 0] : 3.103}]
set OUT    "$DIR/b3_top_${PERIOD}ns"
file mkdir $OUT
create_project -in_memory -part xcvu9p-flgb2104-2-i
add_files -norecurse [glob $CORE/src/*.vhd]
add_files -norecurse [list $DIR/../rtl/b3_extract.vhd $DIR/../rtl/b3_top.vhd]
set mems [glob $CORE/mem/*.mem]
add_files -norecurse $mems
foreach f $mems { set_property used_in_synthesis true [get_files $f] }
set_property file_type {VHDL 2008} [get_files *.vhd]
synth_design -top b3_top -mode out_of_context -directive PerformanceOptimized -retiming
create_clock -name clk -period $PERIOD [get_ports clk]
opt_design
place_design
route_design
phys_opt_design
report_utilization -file "$OUT/util.rpt"
report_utilization -hierarchical -hierarchical_depth 2 -file "$OUT/util_hier.rpt"
report_timing_summary -file "$OUT/timing.rpt"
puts "IMPLB3DONE"
