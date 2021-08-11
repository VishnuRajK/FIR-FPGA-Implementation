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
-- Generated on "01/26/2021 18:17:45"
                                                            
-- Vhdl Test Bench template for design  :  fir
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY fir_vhd_tst IS
END fir_vhd_tst;
ARCHITECTURE fir_arch OF fir_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL ADCDAT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ADCrdy : STD_LOGIC;
SIGNAL ADCstb : STD_LOGIC;
SIGNAL CLOCK_50 : STD_LOGIC;
SIGNAL DACDAT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL DACrdy : STD_LOGIC;
SIGNAL DACstb : STD_LOGIC;
SIGNAL RST_N : STD_LOGIC;
COMPONENT fir
	PORT (
	ADCDAT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	ADCrdy : OUT STD_LOGIC;
	ADCstb : IN STD_LOGIC;
	CLOCK_50 : IN STD_LOGIC;
	DACDAT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	DACrdy : IN STD_LOGIC;
	DACstb : OUT STD_LOGIC;
	RST_N : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : fir
	PORT MAP (
-- list connections between master ports and signals
	ADCDAT => ADCDAT,
	ADCrdy => ADCrdy,
	ADCstb => ADCstb,
	CLOCK_50 => CLOCK_50,
	DACDAT => DACDAT,
	DACrdy => DACrdy,
	DACstb => DACstb,
	RST_N => RST_N
	);

-- Clock 50 MHz	
clock : PROCESS
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

--Reset goes high once and then remain low
stim : PROCESS
BEGIN
RST_N <= '0';
wait for 45 ns;
RST_N <= '1';
wait for 45 ns;
RST_N <= '0';
WAIT; -- do not repeat once finished
END PROCESS;

-- ADCDAT from s2p is manually provided
ADCdata: PROCESS
variable p: integer;
BEGIN
wait for 200 ns;
for p in 1 to 8 loop
ADCDAT <= b"1010101010101010";
wait for 1000 ns;
ADCDAT <= b"0101010101010101";
wait for 1000 ns;
end loop;
END PROCESS;

-- DACrdy from s2p is manually provided
DACready: PROCESS
variable o: integer;
BEGIN
DACrdy <= '0';
wait for 370 ns; -- keeping a gap for 8 taps
for o in 1 to 16 loop
DACrdy <= '1';
wait for 20 ns;
DACrdy <= '0';
wait for 1000 ns; 
end loop;
WAIT;
END PROCESS;

-- ADCstb from s2p is manually provided
ADCstrobe: PROCESS
variable o: integer;
BEGIN
ADCstb <= '0';
wait for 200 ns;
for o in 1 to 16 loop
ADCstb <= '1';
wait for 20 ns;
ADCstb <= '0';
wait for 1000 ns; 
end loop;
WAIT;
END PROCESS;

                                              
--clock : PROCESS
--variable i : integer;
--BEGIN -- code that executes only once
--for i in 1 to 160000 loop -- specify here the length of the simulation run
--CLOCK_50 <= '0';
--wait for 10 ns;
--CLOCK_50 <= '1';
--wait for 10 ns;
--end loop;
--WAIT;
--END PROCESS;
--
--stim : PROCESS
--BEGIN
--RST_N <= '0';
--wait for 45 ns;
--RST_N <= '1';
--wait for 45 ns;
--RST_N <= '0';
--WAIT; -- do not repeat once finished
--END PROCESS;
--
--ADCdata: PROCESS
--variable p: integer;
--BEGIN
--wait for 11700 ns;
--for p in 1 to 3 loop
--ADCDAT <= b"1010101010101010";
--wait for 23010 ns;
--ADCDAT <= b"0101010101010101";
--wait for 23010 ns;
--end loop;
--END PROCESS;
--
--DACready: PROCESS
--variable o: integer;
--BEGIN
--DACrdy <= '0';
--wait for 11900 ns; -- keeping a gap for 8 taps
--for o in 1 to 16 loop
--DACrdy <= '1';
--wait for 20 ns;
--DACrdy <= '0';
--wait for 23010 ns; 
--end loop;
--WAIT;
--END PROCESS;
--
--ADCstrobe: PROCESS
--variable o: integer;
--BEGIN
--ADCstb <= '0';
--wait for 11720 ns;
--for o in 1 to 16 loop
--ADCstb <= '1';
--wait for 20 ns;
--ADCstb <= '0';
--wait for 23010 ns; 
--end loop;
--WAIT;
--END PROCESS;
															 
END fir_arch;