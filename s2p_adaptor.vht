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
-- Generated on "01/24/2021 20:46:49"
                                                            
-- Vhdl Test Bench template for design  :  s2p_adaptor
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY s2p_adaptor_vhd_tst IS
END s2p_adaptor_vhd_tst;
ARCHITECTURE s2p_adaptor_arch OF s2p_adaptor_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL ADCDAT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ADCrdy : STD_LOGIC;
SIGNAL ADCstb : STD_LOGIC;
SIGNAL AUD_ADCDAT : STD_LOGIC;
SIGNAL AUD_ADCLRCK : STD_LOGIC;
SIGNAL AUD_BCLK : STD_LOGIC;
SIGNAL AUD_DACDAT : STD_LOGIC;
SIGNAL AUD_DACLRCK : STD_LOGIC;
SIGNAL CLOCK_50 : STD_LOGIC;
SIGNAL DACDAT : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL DACrdy : STD_LOGIC;
SIGNAL DACstb : STD_LOGIC;
SIGNAL RST_N : STD_LOGIC;
COMPONENT s2p_adaptor
	PORT (
	ADCDAT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	ADCrdy : IN STD_LOGIC;
	ADCstb : OUT STD_LOGIC;
	AUD_ADCDAT : IN STD_LOGIC;
	AUD_ADCLRCK : IN STD_LOGIC;
	AUD_BCLK : IN STD_LOGIC;
	AUD_DACDAT : OUT STD_LOGIC;
	AUD_DACLRCK : IN STD_LOGIC;
	CLOCK_50 : IN STD_LOGIC;
	DACDAT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	DACrdy : OUT STD_LOGIC;
	DACstb : IN STD_LOGIC;
	RST_N : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : s2p_adaptor
	PORT MAP (
-- list connections between master ports and signals
	ADCDAT => ADCDAT,
	ADCrdy => ADCrdy,
	ADCstb => ADCstb,
	AUD_ADCDAT => AUD_ADCDAT,
	AUD_ADCLRCK => AUD_ADCLRCK,
	AUD_BCLK => AUD_BCLK,
	AUD_DACDAT => AUD_DACDAT,
	AUD_DACLRCK => AUD_DACLRCK,
	CLOCK_50 => CLOCK_50,
	DACDAT => DACDAT,
	DACrdy => DACrdy,
	DACstb => DACstb,
	RST_N => RST_N
	);
	
-- Clock of 50 MHz	
clk: PROCESS
variable i : integer;
BEGIN -- code that executes only once
for i in 1 to 100000 loop -- specify here the length of the simulation run
CLOCK_50 <= '0';
wait for 10 ns;
CLOCK_50 <= '1';
wait for 10 ns;
end loop;
WAIT;
END PROCESS;

-- Reset goes high once and then remains low 
stim : PROCESS
BEGIN
RST_N <= '0';
wait for 45 ns;
RST_N <= '1';
wait for 45 ns;
RST_N <= '0';
WAIT; -- do not repeat once finished
END PROCESS;

-- BCLK is at a frequency 2.8MHz - 64*44.1KHz - time period 354ns
bclk_LRCK_process: PROCESS
variable j : integer;
BEGIN
for j in 1 to 100000 loop -- specify here the length of the simulation run
AUD_BCLK <= '0';
wait for 177 ns;
AUD_BCLK <= '1';
wait for 177 ns;
end loop;
WAIT;
END PROCESS;

-- LRCK for DAC and ADC are same
lrck_process: PROCESS
variable k : integer;
BEGIN
AUD_ADCLRCK <= '0';
AUD_DACLRCK <= '0';
wait for 354 ns;
for k in 1 to 16 loop 
AUD_ADCLRCK <= '1';
AUD_DACLRCK <= '1';
wait for 354 ns;
AUD_ADCLRCK <= '0';
AUD_DACLRCK <= '0';
wait for 22656 ns;	-- after 64 Bclk signals
end loop;
WAIT;
END PROCESS;

-- ADCrdy signal from FIR is provided to s2p 
ready_process: PROCESS
variable l : integer;
BEGIN
ADCrdy <= '0';
wait for 6372 ns; -- a period to have all 16 bits in reg and a bclk gap after stb goes high
for l in 1 to 16 loop
ADCrdy <= '1';
wait for 20 ns;
ADCrdy <= '0';
wait for 23030 ns; -- to the next ready signal
end loop;
WAIT;
END PROCESS;

-- AUD_ADCDAT is provided as a stream of data.
AUD_ADCDAT_process: PROCESS
variable m: integer;
variable n: integer;
BEGIN
AUD_ADCDAT <= '0';
wait for 354 ns;
for n in 1 to 16 loop
for m in 1 to 16 loop
AUD_ADCDAT <= '1';
wait for 354 ns;
AUD_ADCDAT <= '0';
wait for 354 ns;
end loop;
wait for 11682 ns;
end loop;
WAIT;
END PROCESS;

-- DACstb from FIR after filteration is provided to S2P
DAC_Stb: PROCESS
variable o: integer;
BEGIN
DACstb <= '0';
wait for 23364 ns;
for o in 1 to 16 loop
DACstb <= '1';
wait for 20 ns;
DACstb <= '0';
wait for 22990 ns; 
end loop;
WAIT;
END PROCESS;

-- DACDAT is filtered 16 bit data from FIR filter
DACdata: PROCESS
variable p: integer;
BEGIN
wait for 11682 ns;
for p in 1 to 8 loop
DACDAT <= b"1010101010101010";
wait for 23010 ns;
DACDAT <= b"0101010101010101";
wait for 23010 ns;
end loop;
END PROCESS;

END s2p_adaptor_arch;
