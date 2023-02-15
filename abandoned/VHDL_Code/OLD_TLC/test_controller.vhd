--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:08:44 10/22/2018
-- Design Name:   
-- Module Name:   C:/Users/Admin/Desktop/Mq uni/2018 S2/ELEC343/TLC/test_controller.vhd
-- Project Name:  TLC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: flow
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test_controller IS
END test_controller;
 
ARCHITECTURE behavior OF test_controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT flow
    PORT(
         clk : IN  std_logic;
         sensors : IN  std_logic_vector(3 downto 0);
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
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal sensors : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal AL : std_logic_vector (2 downto 0);
	signal AT : std_logic_vector (2 downto 0);
	signal AR : std_logic_vector (2 downto 0);
	signal BR : std_logic_vector (2 downto 0);
	signal BT : std_logic_vector (2 downto 0);
	signal BL : std_logic_vector (2 downto 0);
	signal CT : std_logic_vector (2 downto 0);
	signal CR : std_logic_vector (2 downto 0);
	signal DT : std_logic_vector (2 downto 0);
	signal DR : std_logic_vector (2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: flow PORT MAP (
          clk => clk,
          sensors => sensors,
          AL => AL,
			 AT => AT,
			 AR => AR,
			 BR => BR,
			 BT => BT,
			 BL => BL,
			 CT => CT,
			 CR => CR,
			 DT => DT,
			 DR => DR
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= not(clk);
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- flow simulation
		sensors <= "0000";
      wait for 30*clk_period;	--flow 1
		
		--flow 1-X
		sensors <= "0001";
		wait for 28*clk_period; --flow 1-2 then back to flow 1
		sensors <= "0100";
      wait for 26*clk_period; --flow 1-3 then back to flow 1
		sensors <= "1010";
      wait for 28*clk_period; --flow 1-4 then back to flow 1
		sensors <= "1000";
      wait for 26*clk_period; --flow 1-5 then back to flow 1
		sensors <= "0010";
      wait for 28*clk_period; --flow 1-6 then back to flow 1
		
		--flow 1-2-X
		sensors <= "0101";
      wait for 40*clk_period; --flow 1-2-3 then back to flow 1
		sensors <= "1011";
      wait for 40*clk_period; --flow 1-2-4 then back to flow 1
		sensors <= "1001";
      wait for 40*clk_period; --flow 1-2-5 then back to flow 1
		sensors <= "0011";
      wait for 40*clk_period; --flow 1-2-6 then back to flow 1
		
		--flow 1-3-X
		sensors <= "1110";
      wait for 40*clk_period; --flow 1-3-4 then back to flow 1
		sensors <= "1100";
      wait for 40*clk_period; --flow 1-3-5 then back to flow 1
		sensors <= "0110";
      wait for 40*clk_period; --flow 1-3-6 then back to flow 1
		
		--flow 1-2-3-X
		sensors <= "1111";
      wait for 50*clk_period; --flow 1-2-3-4 then back to flow 1
		sensors <= "1101";
      wait for 50*clk_period; --flow 1-2-3-5 then back to flow 1
		sensors <= "0111";
      wait for 50*clk_period; --flow 1-2-3-6 then back to flow 1
		
		sensors <= "0000";--flow 1
		wait;
   end process;

END;
