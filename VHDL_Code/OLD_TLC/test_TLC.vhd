--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:35:03 10/30/2018
-- Design Name:   
-- Module Name:   H:/ELEC343/TLC/test_TLC.vhd
-- Project Name:  TLC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TLC
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test_TLC IS
END test_TLC;
 
ARCHITECTURE behavior OF test_TLC IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TLC
    PORT(
         clk : IN  std_logic;
         sensors : IN  std_logic_vector(3 downto 0);
         AL : OUT  std_logic_vector(2 downto 0);
         AT : OUT  std_logic_vector(2 downto 0);
         AR : OUT  std_logic_vector(2 downto 0);
         BR : OUT  std_logic_vector(2 downto 0);
         BT : OUT  std_logic_vector(2 downto 0);
         BL : OUT  std_logic_vector(2 downto 0);
         CT : OUT  std_logic_vector(2 downto 0);
         CR : OUT  std_logic_vector(2 downto 0);
         DT : OUT  std_logic_vector(2 downto 0);
         DR : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal sensors : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal AL : std_logic_vector(2 downto 0);
   signal AT : std_logic_vector(2 downto 0);
   signal AR : std_logic_vector(2 downto 0);
   signal BR : std_logic_vector(2 downto 0);
   signal BT : std_logic_vector(2 downto 0);
   signal BL : std_logic_vector(2 downto 0);
   signal CT : std_logic_vector(2 downto 0);
   signal CR : std_logic_vector(2 downto 0);
   signal DT : std_logic_vector(2 downto 0);
   signal DR : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns; --1/50MHZ = 20ns
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TLC PORT MAP (
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
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

--		long simulation		
		sensors <= "0000";
      wait for 5000 ms;	
		sensors <= "0001";
		wait for 15000 ms;
		sensors <= "0100";
      wait for 1000 ms;
		sensors <= "1111";
		wait;
   end process;

END;
