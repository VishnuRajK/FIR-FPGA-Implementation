library ieee;
use ieee.std_logic_1164.all;

entity codec_init is
	port 
	(
		CLOCK_50	: in  std_logic;	-- master clock
		RES_N		: in  std_logic;	-- reset, active 0
		SCLK		: out std_logic;	-- serial clock
		SDIN		: out std_logic		-- serial data
	);

end entity;

architecture rtl of codec_init is

	constant sdin_load : std_logic_vector (11*24-1 downto 0) := 
	b"0011010_0_0001111_000000000"&
	b"0011010_0_0000000_000011111"&
	b"0011010_0_0000001_000110111"&
	b"0011010_0_0000010_001111001"&
	b"0011010_0_0000011_000110000"&
	b"0011010_0_0000100_011010010"&
	b"0011010_0_0000101_000000001"&
	b"0011010_0_0000110_001100010"&
	b"0011010_0_0000111_001000011"&
	b"0011010_0_0001000_000100000"&
	b"0011010_0_0001001_000000001";
	
-- 11 words, the first is reset (R15), the others are registers R0-9.
-- each word is 24 bit constructed as
-- chip address, r/w bit, reg address, reg data
-- these words do not include start, stop and ack bits, see packet format below


-- Packet format:				(bit number) 

---- start bit					28
-- 7 bits chip address,
-- 1 r/w bit,
--** ack					19
-- 8 high bits of reg. data,
--** ack					10
-- 8 low bits of reg. data,	
--** ack					1
---- stop bit					0



-- reg. data = 7 bit address + 9 bit config data, 16 bits total,
-- split as 8+8 bits in the packet, MSB go first.


-- declaring a shift register
	signal sr : std_logic_vector (11*24-1 downto 0); 
	
-- declaring an internal signal to be copied into SDIN
	signal temp : std_logic;


-- declare the bit counter;  -- bit counter, runs at 100kHz,
-- bits 28, 19, 10, 1 and 0 are special bits
	signal b_cnt : integer;

-- declare the word counter; -- word counter, runs at about 5kHz
	signal w_cnt : integer;

-- declare the counter for the bit length; -- frequency divider counter,
-- runs at 50MHz
	signal f_div : integer;



begin

	process (CLOCK_50)
	begin
		if (rising_edge(CLOCK_50)) then
		-----------------------------
		-- reset actions
			if (RES_N = '1') then
			-- reset the counters to an appropriate state
				f_div <= 499;	-- load the frequency divider,
					-- 50MHz/500=100kHz bus speed
				sr <= sdin_load;	-- load the shift register
				b_cnt <= 28;	-- load the bit counter,
					-- 29 bits in the word protocol
				w_cnt <= 10;	-- load the word counter, 11 words
			-- reset the outputs to an appropriate state
				SCLK <= '0';
				temp <= '1';
		
			elsif (f_div = 0 and b_cnt = 0 and w_cnt = 0) then -- deadlock in the end
				-- do nothing, wait for the next reset

		-- modify reference counters
		-- for frequency divider, bits and words
			elsif (f_div = 0) then -- at the end of each bit 
				f_div <= 499; -- reload the frequency divider counter
				
				if (b_cnt = 0) then -- at the end of each word
					b_cnt <= 28;	-- reset the bit counter
					w_cnt <= w_cnt - 1;	--modify the word counter
				else	-- the bit is not the end of a word
					b_cnt <= b_cnt - 1;	--modify the bit counter
				end if;
				
			else	-- if not the end of the bit
				f_div <= f_div - 1; -- modify the frequency divider
			end if;
			
		-- generating SCLK, it is going up and then down inside each bit
			if (f_div = 374) then	-- condition when SCLK goes up
				SCLK <= '1';
			elsif (f_div = 124) then	-- condition when SCLK goes down
				SCLK <= '0';
			end if;
			
		-- generating serial data output
			if (b_cnt = 28 and f_div = 249) then -- start transition condition
				temp <= '0';
			elsif ((b_cnt = 19 and f_div = 499) or (b_cnt = 10 and f_div = 499) or (b_cnt = 1 and f_div = 499)) then -- ack bit condition
				temp <= '0';
			elsif (b_cnt = 0 and f_div = 249) then -- stop transition condition
				temp <= '1';
			elsif (b_cnt /= 28 and b_cnt /= 19 and b_cnt /= 10 and b_cnt /= 1 and b_cnt /= 0 and f_div = 499) then -- condition for the non-special bits
				temp <= sr(11*24-1);
				sr (11*24-1 downto 1) <= sr (11*24-2 downto 0); -- shifting
			end if;
			
		-----------------------------		
		end if;
	end process;

	-- forming the output with high impedance states for ack-s
	SDIN <= 'Z' when (b_cnt = 19 or b_cnt = 10 or b_cnt = 1) 
					else (temp);

end rtl;