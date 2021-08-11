-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "01/20/2021 09:52:07"
                                                            
-- Vhdl Test Bench template for design  :  codec_init
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY codec_init_vhd_tst IS
END codec_init_vhd_tst;
ARCHITECTURE codec_init_arch OF codec_init_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL CLOCK_50 : STD_LOGIC;
SIGNAL RES_N : STD_LOGIC;
SIGNAL SCLK : STD_LOGIC;
SIGNAL SDIN : STD_LOGIC;
COMPONENT codec_init
	PORT (
	CLOCK_50 : IN STD_LOGIC;
	RES_N : IN STD_LOGIC;
	SCLK : OUT STD_LOGIC;
	SDIN : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : codec_init
	PORT MAP (
	CLOCK_50 => CLOCK_50,
	RES_N => RES_N,
	SCLK => SCLK,
	SDIN => SDIN
	);
-- Clock with frequency 50MHz
clk: PROCESS
variable i : integer;
BEGIN 
for i in 1 to 160000 loop
CLOCK_50 <= '0';
wait for 10 ns;
CLOCK_50 <= '1';
wait for 10 ns;
end loop;
WAIT;
END PROCESS;

-- Reset goes high and then remains low
stim : PROCESS
BEGIN
RES_N <= '0';
wait for 45 ns;
RES_N <= '1';
wait for 45 ns;
RES_N <= '0';
WAIT; 
END PROCESS;
END codec_init_arch;
