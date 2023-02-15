----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:50 10/22/2018 
-- Design Name: 
-- Module Name:    flow - Behavioral 
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

entity flow is
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
end flow;

architecture Behavioral of flow is

	--state declaration
	type state is (X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,Z1,Z2,Z3,Z4,Z5,Z6,Y15,Y16);
	signal currentST, nextST : state;
	
	--flags
	signal specialFlag : STD_LOGIC := '0'; --flow 1 to 5 or 6
	
	--enable line
	signal en : STD_LOGIC := '0';
--	signal count_signal_DEBUG : integer;--for debugging, change to variable later?
	
begin
	
	timing_control : process (clk) --control the how long to stay in state via en line
	variable count : integer := 19;--for timing

	begin
	--Stub

		if clk'event and clk = '1' then
			if en = '1' then
				currentST <= nextST;
			end if;
			
		if count > 0 then
			count := count-1;
		end if;
		
			case nextSt is
				when X1 =>
					if en = '1' and not(currentSt = X1) then
						count := 19;--for 20s
						en <= '0';
					end if;
					
				when X2 =>
					if en = '1' then
						count := 6;--for 7s
						en <= '0';
					end if;
					
				when X3 =>
					if en = '1' then
						count := 4;--for 5s
						en <= '0';
					end if;
					
				when X4 =>
					if en = '1' then
						count := 6;--for 7s
						en <= '0';
					end if;
					
				when X5 =>
					if en = '1' then
						count := 6;--for 7s
						en <= '0';
					end if;
					
				when X6 =>
					if en = '1' then
						count := 6;--for 7s
						en <= '0';
					end if;
					
				when others => 
					if en = '1' then
						en <= '0';
						count := 0;--for 1s
					end if;
			end case;
		
		if count = 0 then
			en <= '1';
		end if;
		
		--count_signal_DEBUG <= count;--debugging
		
	end if;


	end process timing_control; 
	
--------------------------------------------------------------------------------
	
	state_control : process (sensors, en, currentST) --control which state to change to
	
	variable SAR : STD_LOGIC := sensors(3);
	variable SB : STD_LOGIC := sensors(2);
	variable SCR : STD_LOGIC := sensors(1);
	variable SD : STD_LOGIC := sensors(0);
	
	begin
	
	SAR := sensors(3);
	SB := sensors(2);
	SCR := sensors(1);
	SD := sensors(0);
	
		if en = '1' then 
				case currentST is
				--Flow 1
					when X1 =>						
						specialFlag <= '0';
						
						if SAR = '1' and SB = '0' and SCR = '0' and SD = '0' then
							nextSt <= Y15;
						elsif SAR = '0' and SB = '0' and SCR = '1' and SD = '0' then
							nextSt <= Y16;
						elsif sensors = "0000" then--if nothing high
							nextSt <= X1;--stay in state
						else nextSt <= Y1;
						end if;
						
					when Y1 =>						
						nextSt<= Z1;
												
					when Z1 =>			
						if SD = '1' then
							nextSt <= X2;
						elsif SB = '1' then
							nextSt <= X3;
						elsif SAR = '1' and SCR = '1' then
							nextSt <= X4;
						else nextSt <= X1;--in case of errors then back to flow 1
						end if;
				
				--Flow 2	
					when X2 =>						
						nextSt <= Y2;
						
					when Y2 =>
						nextSt <= Z2;
						
					when Z2 =>
						if SB = '1' then
							nextSt <= X3;
						elsif SAR = '1' and SCR = '1' then
							nextSt <= X4;
						elsif SAR = '1' and SCR = '0' then
							nextSt <= X5;
						elsif SCR = '1' then
							nextSt <= X6;
						else nextSt <= X1;--in case of errors then back to flow 1
						end if;
				
				--Flow 3
					when X3 =>			
						nextSt <= Y3;
						
					when Y3 =>
						nextSt <= Z3;
						
					when Z3 =>
						if SAR = '1' and SCR = '1' then
							nextSt <= X4;
						elsif SAR = '1' and SCR = '0' then
							nextSt <= X5;
						elsif SAR = '0' and SCR = '1' then
							nextSt <= X6;
						else nextSt <= X1;--in case of errors then back to flow 1
						end if;
						
				--Flow 4
					when X4 =>					
						nextSt <= Y4;
					
					when Y4 =>					
						nextSt <= Z4;
						
					when Z4 =>						
						nextSt <= X1;
						
				--Flow 5
					when X5 =>						
						nextSt <= Y5;
					
					when Y5 =>						
						nextSt <= Z5;
					
					when Y15 => --from Flow 1 to 5
						specialFlag <= '1';
						nextSt <= Z5;
					
					when Z5 =>
						if specialFlag = '1' then
							nextSt <= X5;
							specialFlag <= '0';
						else nextSt <= X1;
						end if;
				
				--Flow 6
					when X6 =>
						nextSt <= Y6;
					
					when Y6 =>
						nextSt <= Z6;

					when Y16 =>
						specialFlag <= '1';
						nextSt <= Z6;

					when Z6 =>
						if specialFlag = '1' then
							nextSt <= X6;
							specialFlag <= '0';
						else nextSt <= X1;
						end if;
				
				--reset to Flow 1 in error cases
					when others => nextSt <= X1;
				end case;
		end if;
	
	end process state_control;
	
--------------------------------------------------------------------------------

	lights_control : process(currentST) --change light output depending on currentST
	begin
	
	--Lights: Red-Yellow-Green
	
	case currentST is
				--Flow 1
					when X1 =>
						AL <= "001";						
						AT <="001";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="001";
						CR <="100";
						DT <="100";
						DR <="100";
						
					when Y1 =>
						AL <= "010";						
						AT <="010";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="010";
						CR <="100";
						DT <="100";
						DR <="100";
	
					when Z1 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
				
				--Flow 2	
					when X2 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="001";
						DR <="001";
						
					when Y2 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="010";
						DR <="010";
						
					when Z2 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
				
				--Flow 3
					when X3 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="001";
						BT <="001";
						BR <="001";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
						
					when Y3 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="010";
						BT <="010";
						BR <="010";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
						
					when Z3 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
						
				--Flow 4
					when X4 =>
						AL <="100";						
						AT <="100";
						AR <="001";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="001";
						DT <="100";
						DR <="100";
						
					when Y4 =>
						AL <="100";						
						AT <="100";
						AR <="010";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="010";
						DT <="100";
						DR <="100";
						
					when Z4 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
						
				--Flow 5
					when X5 =>
						AL <="001";						
						AT <="001";
						AR <="001";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
						
					when Y5 =>
						AL <="001";						
						AT <="001";
						AR <="010";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
						
					when Y15 => --from Flow 1 to 5
						AL <="001";						
						AT <="001";
						AR <="010";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
						
					when Z5 =>
						AL <="001";						
						AT <="001";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="100";
						CR <="100";
						DT <="100";
						DR <="100";
				
				--Flow 6
					when X6 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="001";
						CR <="001";
						DT <="100";
						DR <="100";
					
					when Y6 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="001";
						CR <="010";
						DT <="100";
						DR <="100";

					when Y16 =>
						AL <="010";						
						AT <="010";
						AR <="010";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="001";
						CR <="100";
						DT <="100";
						DR <="100";

					when Z6 =>
						AL <="100";						
						AT <="100";
						AR <="100";
						BL <="100";
						BT <="100";
						BR <="100";
						CT <="001";
						CR <="100";
						DT <="100";
						DR <="100";
				
					when others =>
						AL <= "001";						
						AT <="001";
						AR <="001";
						BL <="001";
						BT <="001";
						BR <="001";
						CT <="001";
						CR <="001";
						DT <="001";
						DR <="001";
				end case;
	
	end process lights_control;

end Behavioral;

