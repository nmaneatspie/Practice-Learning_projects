----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:37 10/22/2018 
-- Design Name: 
-- Module Name:    TLC - Behavioral 
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

entity TLC is
    Port ( clk : in  STD_LOGIC;
           sensors : in  STD_LOGIC_VECTOR (3 downto 0);
           AL : out std_logic_vector (2 downto 0);
			  AT : out std_logic_vector (2 downto 0);
			  AR : out std_logic_vector (2 downto 0);
			  BR : out std_logic_vector (2 downto 0);
			  BT : out std_logic_vector (2 downto 0);
			  BL : out std_logic_vector (2 downto 0);
			  CT : out std_logic_vector (2 downto 0);
			  CR : out std_logic_vector (2 downto 0);
			  DT : out std_logic_vector (2 downto 0);
			  DR : out std_logic_vector (2 downto 0));

end TLC;

architecture Behavioral of TLC is

	Component flow is
		Port ( clk : in  STD_LOGIC;
           sensors : in  STD_LOGIC_VECTOR (3 downto 0);
           AL : out std_logic_vector (2 downto 0);
			  AT : out std_logic_vector (2 downto 0);
			  AR : out std_logic_vector (2 downto 0);
			  BR : out std_logic_vector (2 downto 0);
			  BT : out std_logic_vector (2 downto 0);
			  BL : out std_logic_vector (2 downto 0);
			  CT : out std_logic_vector (2 downto 0);
			  CR : out std_logic_vector (2 downto 0);
			  DT : out std_logic_vector (2 downto 0);
			  DR : out std_logic_vector (2 downto 0));
	END Component;
	
	Component clk_control is
		Port ( clk : in  STD_LOGIC;
           s : out  STD_LOGIC);
	END Component;
	
	signal clk_nw : STD_LOGIC;
	
begin
	
	controller_instance : flow port map (clk_nw, sensors, AL, AT, AR, BR, BT, BL, CT, CR, DT, DR);
	clk_controller_instance : clk_control port map (clk, clk_nw);

end Behavioral;

