# Copyright (C) 2018  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details.

# Quartus Prime: Generate Tcl File for Project
# File: mips_multi_cycle.tcl
# Generated on: Sat Mar 02 14:59:20 2019

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "mips_multi_cycle"]} {
		puts "Project mips_multi_cycle is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists mips_multi_cycle]} {
		project_open -revision mips_multi_cycle mips_multi_cycle
	} else {
		project_new -revision mips_multi_cycle mips_multi_cycle
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name DEVICE EP4CE115F29C7
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 15.1.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "15:47:41  DECEMBER 19, 2017"
	set_global_assignment -name LAST_QUARTUS_VERSION "18.1.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (VHDL)"
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
	set_global_assignment -name VHDL_SHOW_LMF_MAPPING_MESSAGES OFF
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name VHDL_FILE ALUcontrol.vhd
	set_global_assignment -name VHDL_FILE ALU32.vhd
	set_global_assignment -name VHDL_FILE SignExtend.vhd
	set_global_assignment -name VHDL_FILE DP_Memory.vhd
	set_global_assignment -name VHDL_FILE RegFile.vhd
	set_global_assignment -name VHDL_FILE InstrSplitter.vhd
	set_global_assignment -name VHDL_FILE InstructionMemory.vhd
	set_global_assignment -name VHDL_FILE DataMemory.vhd
	set_global_assignment -name VHDL_FILE Mux2N.vhd
	set_global_assignment -name VHDL_FILE DisplayUnit.vhd
	set_global_assignment -name VHDL_FILE DebounceUnit.vhd
	set_global_assignment -name VHDL_FILE DisplayUnit_pkg.vhd
	set_global_assignment -name VHDL_FILE MIPS_pkg.vhd
	set_global_assignment -name VHDL_FILE PCupdate.vhd
	set_global_assignment -name VHDL_FILE Mux4N.vhd
	set_global_assignment -name VECTOR_WAVEFORM_FILE Waveform.vwf
	set_global_assignment -name VHDL_FILE LeftShifter.vhd
	set_global_assignment -name VHDL_FILE Register32.vhd
	set_global_assignment -name VHDL_FILE ControlUnit.vhd
	set_global_assignment -name VHDL_FILE mips_multi_cycle.vhd
	set_global_assignment -name VECTOR_WAVEFORM_FILE Waveform1.vwf
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
