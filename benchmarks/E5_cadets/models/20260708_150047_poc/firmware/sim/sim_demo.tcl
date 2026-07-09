# sim_demo.tcl : run the classification demo testbench (tb_kan_demo)
#   vivado -mode batch -source sim_demo.tcl
set PROJ "KAN_DEMO"
set DIR  [file normalize [pwd]]
set PART "xcvu9p-flgb2104-2-i"

create_project -name $PROJ -part $PART -dir "$DIR/$PROJ" -force
set_property target_language VHDL [current_project]
set_property default_lib work [current_project]

add_files -norecurse [glob -nocomplain $DIR/../src/*.vhd]
set mems [glob -nocomplain $DIR/../mem/*.mem]
if {[llength $mems] > 0} {
  add_files -norecurse $mems
  foreach f $mems { set_property used_in_synthesis true [get_files $f] }
}
set_property top KAN [get_filesets sources_1]

if {[llength [get_filesets sim_1]] == 0} { create_fileset -simset sim_1 }
add_files -fileset sim_1 [glob $DIR/tb_kan_demo.vhd]
set_property top tb_kan_demo [get_filesets sim_1]

foreach f [list "$DIR/demo_in_hex.txt" "$DIR/demo_label.txt"] {
  if {![file exists $f]} { error "Demo data file not found: $f (run make_demo_vectors.py)" }
  add_files -fileset sim_1 -norecurse $f
}

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_simulation
run 2 ms
quit
