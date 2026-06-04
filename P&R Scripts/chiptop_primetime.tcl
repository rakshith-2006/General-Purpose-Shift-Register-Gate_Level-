set_process_number 1.00
set_temperature 25
set_voltage 0.85
update_timing -full
save_block -as route_opt_done 

 

################ RC extraction using STARRC ######################## 
# SPEF : standard parasitic extraction format 
# NXTGRD : Has rules for extraction 
# def file : 
# lef file of standard cells and macros : 

mkdir STARRC
cd STARRC
mkdir outputs 
gvim star.cmd 

##### STARRC COMMANDS #######################
# star.cmd 
TCAD_GRD_FILE: /mnt/tools/SAED32_EDK/tech/starrc/nominal/saed32nm_1p9m_nominal.nxtgrd
MAPPING_FILE: /mnt/tools/SAED32_EDK/tech/starrc/saed32nm_tf_itf_tluplus.map
NETLIST_FORMAT: SPEF
BLOCK : route_opt_done
NDM_DATABASE : /home/chipin_11/chiptop_pnr/designs/gprs_top.nlib
OPERATING_TEMPERATURE: 25
SELECTED_CORNERS: Cnom
NETLIST_FILE: /home/chipin_11/chiptop_pnr/STARRC/outputs/gprs.spef
COUPLE_TO_GROUND: NO

# StarXtract star.cmd
########################## Primtime #######################################
# In ICC2 
open_block route_opt_done
write_verilog ./outputs/gprs_routed_netlist.v 
write_sdc -output ./outputs/gprs.top.sdc

# In pnr folder 
mkdir 	PT
cd PT
mkdir reports outputs scripts inputs

cd scripts 

gvim pt.tcl

###################################### pt .tcl ##############################
set search_path ./inputs 

set_app_var link_library "* saed32hvt_tt0p85v25c.db saed32rvt_tt0p85v25c.db saed32lvt_tt0p85v25c.db  saed32sramlp_tt0p85v25c_i0p85v_temp.db"


read_verilog ../outputs/gprs_routed_netlist.v
set link_create_black_boxes false


link_design gprs_top 
current_design gprs_top 

set_eco_options -physical_icc2_lib ../designs/gprs_top.nlib/  -physical_icc2_blocks route_opt_done

read_sdc ../outputs/gprs.top.sdc
set read_parasitics_load_locations true
read_parasitics -keep_capacitive_coupling ../STARRC/outputs/gprs.spef
check_eco
update_timing -full

save_session ./outputs/gprs.session


################ Fix violations in prime time ##########################

# max_trans violation and max_capacitance 
report_constraint -all_violators -max_transition
report_constraint -all_violators -max_capacitance 


# Fixing max_trans 
fix_eco_drc -type max_transition -buffer_list {NBUFFX2_HVT NBUFFX4_HVT NBUFFX8_HVT NBUFFX16_HVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT NBUFFX16_RVT NBUFFX2_LVT NBUFFX4_LVT NBUFFX8_LVT NBUFFX16_LVT} -physical_mode occupied_site


# Fixing max_cap
fix_eco_drc -type max_capacitance -buffer_list {NBUFFX2_HVT NBUFFX4_HVT NBUFFX8_HVT NBUFFX16_HVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT NBUFFX16_RVT NBUFFX2_LVT NBUFFX4_LVT NBUFFX8_LVT NBUFFX16_LVT} -physical_mode occupied_site



# Fix Setup Violations
fix_eco_timing -type setup -verbose -physical_mode occupied_site

set_eco_options -physical_enable_clock_data

fix_eco_timing -type setup -cell_type {clock_network} -buffer_list  {NBUFFX2_HVT NBUFFX4_HVT NBUFFX8_HVT NBUFFX16_HVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT NBUFFX16_RVT NBUFFX2_LVT NBUFFX4_LVT NBUFFX8_LVT NBUFFX16_LVT} -physical_mode occupied_site

## Hold violations 
fix_eco_timing -type hold -buffer_list  {DELLN1X2_HVT DELLN2X2_HVT DELLN3X2_HVT DELLN1X2_LVT DELLN2X2_LVT DELLN3X2_LVT DELLN1X2_RVT DELLN2X2_RVT DELLN3X2_RVT NBUFFX2_HVT NBUFFX4_HVT NBUFFX8_HVT NBUFFX16_HVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT NBUFFX16_RVT NBUFFX2_LVT NBUFFX4_LVT NBUFFX8_LVT NBUFFX16_LVT} -physical_mode occupied_site

# Write Changes 
write_changes -format icc2tcl -output ../inputs/change_pt.tcl 

# Go to ICC2 
	# open lib 
	# open routed block
	source ./inputs/change_pt.tcl
	legalize_placement -incremental
	connect_pg_net 
	route_eco -reuse_existing_global_route true -utilize_dangling_wires true -reroute modified_nets_first_then_others

	check_routes
	check_lvs

############ Write GDS #####################
set search_path {/mnt/tools/SAED32_EDK/lib/stdcell_hvt/gds /mnt/tools/SAED32_EDK/lib/stdcell_lvt/gds /mnt/tools/SAED32_EDK/lib/stdcell_rvt/gds /mnt/tools/SAED32_EDK/lib/sram_lp/gds}

set std_cell_gds {SRAMLP2RW64x32.gds saed32nm_hvt_oa.gds saed32nm_lvt_oa.gds saed32nm_rvt_oa.gds}

set map_file /mnt/tools/SAED32_EDK/tech/map/saed32nm_1p9m_gdsout_mw.map

write_gds -layer_map $map_file -merge_files $std_cell_gds -long_names ./outputs/gprs.gds

