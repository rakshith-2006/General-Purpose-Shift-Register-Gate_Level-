set_units -time ns -capacitance fF

# Clock declaration
create_clock -period 4 -name mclk [get_ports clock]
create_clock -period 4 -name vclk 

#Define input_transition driving/ driving cell 
 set_driving_cell -lib_cell NBUFFX8_RVT [all_inputs]

#Define Load
set_load 8 [all_outputs] 

# set input delay
set po [remove_from_collection [all_inputs] [get_ports clock]]
set_input_delay 0.6 [get_ports $po] -clock vclk 

#set output delay 
 set_output_delay 0.6 [all_outputs] -clock vclk

# Define clock uncertainity
set_clock_uncertainty 0.2 [get_clock *]

group_path -from [all_registers -data_pins] -to [all_register -data_pins] -name r2r
