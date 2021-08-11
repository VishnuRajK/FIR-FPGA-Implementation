library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fir is 
port(					
--	Input and output 
	ADCDAT:	in 	std_logic_vector(15 downto 0);
	DACDAT:	out	std_logic_vector(15 downto 0);	
	DACrdy: 	in		std_logic;
	ADCrdy: 	out 	std_logic;
	DACstb: 	out	std_logic;
	ADCstb: 	in 	std_logic;

--	Control Signals
	CLOCK_50:	in	std_logic;
	RST_N:		in	std_logic
);
end entity;

architecture rtl of fir is
--	Internal Signals
	signal old_ADCstb: std_logic;
	signal tap_cnt: integer range 7 downto -1;
	type tap_shift is array (7 downto 0) of signed (15 downto 0); 
	signal x: tap_shift;
	signal accumulator: signed (34 downto 0);
	-- Coefficients for the Filter
	constant b: tap_shift := (
			to_signed(integer(-1260 * 1.9999),16),
			to_signed(integer(7827 * 1.9999),16),
			to_signed(integer(12471 * 1.9999),16),
			to_signed(integer(16384 * 1.9999),16),
			to_signed(integer(16384 * 1.9999),16),
			to_signed(integer(12471 * 1.9999),16),
			to_signed(integer(7827 * 1.9999),16),
			to_signed(integer(-1260 * 1.9999),16));
	
begin

	process (CLOCK_50)
	variable i: integer;
	variable lame:integer;
	begin
		
		if (rising_edge(CLOCK_50)) then	-- for each rising edge of clock 50MHz
			
			if (RST_N = '1') then	-- Reset operation
				tap_cnt <= 7;
				DACDAT <= b"0000000000000000";
				ADCrdy <= '1';
				DACstb <= '0';
				for i in 0 to 7 loop
					x(i) <= b"0000000000000000";
				end loop;
			
			else 
				old_ADCstb <= ADCstb;
				if (old_ADCstb = '0' and ADCstb = '1') then			-- Start of input
					ADCrdy <= '0';
					
					x(7) <= signed(ADCDAT);		-- Input data register is moved to 7th element of array
					x(6 downto 0) <= x(7 downto 1);	-- shifting the array of registers
					tap_cnt <= 6;
					DACstb <= '0';
					lame:= 0;
					accumulator <= resize(b(7) * signed (ADCDAT),35); -- would not take in 32 bits instead of 35bits
					
				elsif (tap_cnt >= 0) then 	-- Time multiplexing the multiplier
					if (tap_cnt = 6) then
					accumulator <= signed(accumulator + ( b(tap_cnt)*x(tap_cnt))); 
					tap_cnt <= tap_cnt - 1;
					elsif (tap_cnt = 5) then
					accumulator <= signed(accumulator + ( b(tap_cnt)*x(tap_cnt)));
					tap_cnt <= tap_cnt - 1;
					elsif (tap_cnt = 4) then
					accumulator <= signed(accumulator + ( b(tap_cnt)*x(tap_cnt)));
					tap_cnt <= tap_cnt - 1;
					elsif (tap_cnt = 3) then
					accumulator <= signed(accumulator + ( b(tap_cnt)*x(tap_cnt)));
					tap_cnt <= tap_cnt - 1;
					elsif (tap_cnt = 2) then
					accumulator <= signed(accumulator + ( b(tap_cnt)*x(tap_cnt)));
					tap_cnt <= tap_cnt - 1;
					elsif (tap_cnt = 1) then
					accumulator <= signed(accumulator + ( b(tap_cnt)*x(tap_cnt)));
					tap_cnt <= tap_cnt - 1;
					elsif (tap_cnt = 0) then
					accumulator <= signed(accumulator + ( b(tap_cnt)*x(tap_cnt)));
					DACstb <= '1';
					lame := 1;
					ADCrdy <= '1';
					DACDAT <= std_logic_vector (accumulator (34 downto 19));	-- type conversion to std_logic_vector
					tap_cnt <= -1;
					end if;				
			
				end if;
			if (lame = 1 and DACrdy = '1')then	
				DACstb<='0';
				end if;
			end if;
		end if;
	end process;
end rtl;