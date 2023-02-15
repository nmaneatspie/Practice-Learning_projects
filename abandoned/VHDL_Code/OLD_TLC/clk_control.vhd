----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:21 10/22/2018 
-- Design Name: 
-- Module Name:    clk_control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity clk_control is
--timing adjusted after lab demonstration to correct timing
	Generic( sec : integer := 25000000); --essentially multiplier due to no support for very large numbers
				--n: integer := 1000); --25000x1000=25000000 = 25M = 1/2*50M for 1Hz
    Port ( clk : in  STD_LOGIC;
           s : out  STD_LOGIC := '0');
end clk_control;

architecture Behavioral of clk_control is

 
begin

	countdown : process(clk)
	
	variable clk_state : std_logic := '0';
	--variable countn : integer range 0 to n := 0;
	variable countSec : integer range 0 to sec := 0;
	
	begin
	if clk'event and clk = '1' then
		--if count then output is high
		if countSec = sec then
			countSec := 0;
			--if countn = n then
			--	countn := 0;
				clk_state := not(clk_state);
				s <= clk_state;
			--elsif countn > n then
			--	countSec := 0;
		--	else countn := countn + 1;
		--	end if;
			elsif countSec > Sec then
				countSec := 0;
		else countSec := countSec + 1;
		end if;
	end if;
	
	end process countdown;
	
end Behavioral;

