
set search_path  /home/chipin_01/core_pd/lib


set a {saed32_hvt.ndm saed32_lvt.ndm saed32_rvt.ndm saed32_sram_lp.ndm}
create_lib  -ref_libs $a ./designs/gprs_top.nlib
save_lib


## Read Netlist (Design) : Automatically block is formed with top module name (gprs_top.design) 
read_verilog ./inputs/gprs_top.v
save_block

list_blocks

## Read tlu+ Files 
 read_parasitic_tech -tlup saed32nm_1p9m_nominal.tluplus  -name Cnom
 set_parasitic_parameters -early_spec Cnom -late_spec Cnom

## Read SDC 
source ./inputs/gprs_top.sdc

save_block -as import_design_done

############# From next ##################
# Open library 
open_lib ./designs/gprs_top.nlib
# Open blocks
list_blocks 
open_block import_design_done.:design
initialize_floorplan -core_utilization 0.6 -core_offset 5 -shape R -side_ratio {1 1} -use_site_row -site_def unit
save_block -as ./designs/core_area_done
start_gui


# get all inputports 
get_ports -filter "direction == in"
all_inputs 

# get count of all output ports 
get_ports -filter "direction == out"
all_outputs

## Metal layers used to place ports M5 and M6
# Place input ports within {0.0000 212.3280} {5.0000 318.5000}
create_pin_guide -boundary {{0.0000 212.3280} {5.0000 318.5000}} -layers M5 -pin_spacing 1 [all_inputs] -name pg1 

place_pins -ports [all_inputs]

# Place output ports within {444.1280 0.0000} {616.8770 5.0000}
create_pin_guide -boundary {{444.1280 0.0000} {616.8770 5.0000}} -layers M6 -pin_spacing 1 [all_outputs] -name pg2

place_pins -ports [all_outputs]

 # Check pin placement
check_pin_placement -wire_track true

 save_block -as port_placement_done
#to create placement
set_fix_cells [get_flat_cells -filter "is_hard_macro==true"]
create_keepout_margin -outer {1 1 1 1} -type hard [get_flat_cells -filter "is_hard_macro==true"]
derive_placement_blockages -force
create_placement
legalize_placement
report_congestion -rerun_global_router
set_fix_cells [get_flat_cells -filter "is_hard_macro==true"] -unfix


#to set physical cells
set_boundary_cell_rules -left_boundary_cell DCAP_HVT -right_boundary_cell DCAP_HVT -at_va_boundary

compile_boundary_cells
check_boundary_cells

create_tap_cells -lib_cell DCAP_HVT -distance 30 -pattern stagger

skip_fixed_cells
save_block -as physical_cell_placed
source ./scripts/powerplan.tcl

#to check any drc errors
source ./scripts/powerplan.tcl #find powerplan.tcl in home/core_pd/PnR/scripts/powerplan.tcl
check_pg_connectivity -check_std_cell_pins none
check_pg_missing_vias
check_pg_drc

#### placement 
set_attribute [get_flat_cells -filter " is_hard_macro == true "] physical_status -value fixed
report_utilization
set_attribute [get_lib_cells TIE*_HVT ] dont_use  -value false
set_attribute [get_lib_cells TIE*_HVT ] dont_touch -value false	

set_ignored_layers -min_routing_layer M2 -max_routing_layer M6 

# 
# above m6 layers should not be used for congestion analysis make them hard 
set_app_options -name route.common.net_max_layer_mode -value hard

# m1 is for pin connection 
set_app_options -name route.common.net_min_layer_mode -value allow_pin_connection

## to enable global router during placement optimization stage -global routing -estimation of routing from one cell to another cell
set_app_options -name opt.common.enable_rde -value true

set_app_options -name opt.common.max_fanout -value 30
		
## set the prefix to all the cells added durig placement optimization stage 
set_app_options -name opt.common.user_instance_name_prefix -value place_opt_


## enable advanced_legalizer and search_and_rapair options to true
set_app_options -name place.legalize.enable_advanced_legalizer -value true				
set_app_options -name place.legalize.legalizer_search_and_repair -value true
set_app_options -name place.coarse.continue_on_missing_scandef -value true
# read_def ./inputs/scan_chain.def

## Rough  placement 
create_placement

# Legalize placement
legalize_placement

# Placement optimization
place_opt
report_congestion -rerun_global_router > ./outputs/reports/placement/congestion.txt

# Check max_fanout 
report_net_fanout -threshold 31

# Check max_capacitance 
route_global 
report_constraints -all_violators -max_capacitance -significant_digits 4  -nosplit > ./reports/mc_apo.txt

# Check max_transition
report_constraints -all_violators -max_transition -significant_digits 4 -nosplit > ./reports/mt_apo.txt

# Check setup timing  
report_global_timing

# Check reg_to_reg path 
report_timing -from [all_registers] -to [all_registers]

# check pg connectivity 
check_pg_connectivity

# check_pg_drc 
connect_pg_net
check_pg_drc -do_not_check_shapes_in_hier_blocks

# Fix pg drc 
foreach_in_collection a [get_vias -filter "via_def_name == VIA12BAR_C"] {
set_attribute -objects [get_vias $a] -name via_def -value [get_via_defs -library [get_libs gprs_top.nlib] -quiet VIA12SQ]
} 

#Check legality 
check_legality 
legalize_placement 

save_block -as placement_final

#CLOCK TREE SYNTHESIS
remove_routes     -global_routes
set_clock_tree_options -target_skew 0.1
set_clock_tree_options -target_latency 0.6
set_max_transition 0.2 -clock_path [get_clocks]
set_lib_cell_purpose -include cts "*NBUFF*LVT *INV*LVT "

set_ignored_layers -max_routing_layer M6
set_ignored_layers -min_routing_layer M1

remove_routing_rules -all 
create_routing_rule dwds -default_reference_rule -multiplier_spacing 2 -multiplier_width 2 
set_clock_routing_rules -net_type root -rules dwds -min_routing_layer M4 -max_routing_layer M5
set_clock_routing_rules -net_type internal -rules dwds -min_routing_layer M4 -max_routing_layer M5
sizeof_collection [get_cells -hierarchical -filter "is_clock_network_cell == true && ref_name =~ *BUF*"]
clock_opt
#timing reports
report_clock_qor -nosplit -significant_digits 3 > ./reports/max_lat_gskew.txt
report_min_pulse_width > ./reports/pulse_width_check.txt
#overall setup and  
report_global_timing
report_timing -from [all_registers] -to [all_registers]
report_timing -from [all_registers] -to [all_registers] -delay_type min
report_timing -from [all_registers] -to [all_registers] -max_path 10 >./reports/reg_to_reg_setup_max10.txt
report_timing -from [all_registers] -to [all_registers] -delay_type min -max_path 10 >./reports/reg_to_reg_hold_max10.txt
#########routing###################
set_app_options -name route.global.timing_driven -value true

# App option for track assignment 
set_app_options -name route.track.timing_driven -value true

# App option for detail routing 
set_app_options -name route.detail.timing_driven -value true

# Set routinh layers 
	set_ignored_layers -max_routing_layer M6 -min_routing_layer M2		
	set_app_options -name route.common.net_max_layer_mode -value hard
	set_app_options -name route.common.net_min_layer_mode -value allow_pin_connection

# Do routing 
route_auto 
# This command is for automatic routing in such a way that it just repairs the short circuit and open circuit "route_eco"
# To perform optimization use route opt 
route_opt 

save_block -as route_opt_done 

# Check LVS 
check_lvs -max_errors 0

# check DRC
check_routes 

# See timing summary 
report_global_timing
#############################################################################################
set_process_number 1.00
set_temperature 25
set_voltage 0.85
update_timing -full
save_block -as route_opt_done
#############################################################################################
#copy these in a star.cmd file and run it (before that edit the paths)
#TCAD_GRD_FILE: /mnt/tools/SAED32_EDK/tech/starrc/nominal/saed32nm_1p9m_nominal.nxtgrd
#MAPPING_FILE: /mnt/tools/SAED32_EDK/tech/starrc/saed32nm_tf_itf_tluplus.map
#NETLIST_FORMAT: SPEF
#BLOCK : route_opt_final
#NDM_DATABASE : /home/chipin_11/chiptop_pnr/designs/gprs_top.nlib
#OPERATING_TEMPERATURE: 25
#SELECTED_CORNERS: Cnom
#NETLIST_FILE: /home/chipin_11/chiptop_pnr/STARRC/outputs/gprs.spef
#COUPLE_TO_GROUND: NO
#
#
#mkdir STARRC
#cd STARRC
#mkdir outputs 
#gvim star.cmd
#
#
#Command to run StarXtract ./star.cmd
