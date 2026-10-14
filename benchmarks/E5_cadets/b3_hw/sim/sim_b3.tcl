# sim_b3.tcl : end-to-end xsim of b3_top (preprocessing + folded KAN core)
# Usage (from b3_hw/sim):  vivado -mode batch -source sim_b3.tcl [-tclargs <KAN_LAT>]
set DIR  [file normalize [pwd]]
set CORE [file normalize "$DIR/../../models/20261013_145858_undersample_b3/firmware"]
set LAT  [expr {[llength $argv] > 0 ? [lindex $argv 0] : 8}]
create_project -name B3_SIM -part xcvu9p-flgb2104-2-i -dir "$DIR/B3_SIM" -force
set_property target_language VHDL [current_project]
add_files -norecurse [glob $CORE/src/*.vhd]
add_files -norecurse [list $DIR/../rtl/b3_extract.vhd $DIR/../rtl/b3_top.vhd]
set mems [glob $CORE/mem/*.mem]
add_files -norecurse $mems
foreach f $mems { set_property used_in_synthesis true [get_files $f] }
set_property file_type {VHDL 2008} [get_files *.vhd]
set_property top b3_top [get_filesets sources_1]
add_files -fileset sim_1 -norecurse [list $DIR/tb_b3_top.vhd $DIR/stream.txt $DIR/expected.txt]
set_property file_type {VHDL 2008} [get_files tb_b3_top.vhd]
set_property top tb_b3_top [get_filesets sim_1]
set_property generic "KAN_LAT=$LAT" [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_simulation
quit
