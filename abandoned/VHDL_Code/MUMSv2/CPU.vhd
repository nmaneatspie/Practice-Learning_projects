----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Norman Thien
-- 
-- Create Date: 29.11.2020 20:31:55
-- Design Name: 
-- Module Name: CPU - Mixed
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:0.05
-- Revision 0.01 - File Created 
-- Revision 0.02 - Added ports, signals and the states control
-- Revision 0.03 - Added reset and initialise
-- Revision 0.04 - Commented out dataSize Generic and replaced the associated parts with fixed width 4 bits since instruction set is fixed
-- Revision 0.05 - Added FO control logic and parts of the instruction set as comments and STP instr in EX state.
-- Additional Comments:
-- Made using Vivado 2019.2 then changed on 2020.12.11 to 2020.2 due to issues with the software (random lags). 
----------------------------------------------------------------------------------
--Instruction Set
-- OP Code -- Addressing --         Instructions        -- Symbol -- C -- Z
-- 0000    -- Inherent   --  Stop                       -- STP    -- 0 -- 0
-- 0001    -- Inherent   --  Clear A and C              -- CLR    -- 0 -- @
-- 0010    -- Inherent   --  Increment A                -- INC    -- # -- #
-- 0011    -- Inherent   --  Complement A               -- COM    -- @ -- #
-- 0100    -- Inherent   --  Rotate A left through C    -- ROL    -- # -- #

-- # : Set according to result of Instruction
-- @ : Unchanged 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
    Generic (
        --dataSize: Integer := 4; 
        addrSize : Integer := 8
    );
    Port (
        clk: in STD_LOGIC;
        ini : in STD_LOGIC; --Initialise signal
--        DataIn : in STD_LOGIC_VECTOR(dataSize-1 downto 0);
--        DataOut : out STD_LOGIC_VECTOR(dataSize-1 downto 0);
        DataIn : in STD_LOGIC_VECTOR(3 downto 0);
        DataOut : out STD_LOGIC_VECTOR(3 downto 0);
        AddrOut : out STD_LOGIC_VECTOR(addrSize-1 downto 0);
        RW : out STD_LOGIC; --Read/Write flag, Read:0, Write: 1
        rstOut : out STD_LOGIC
    );
end CPU;

architecture Mixed of CPU is

    --Registers
--    Signal AC : STD_LOGIC_VECTOR(dataSize-1 downto 0); --Accumulator
--    Signal FR : STD_LOGIC_VECTOR(dataSize-1 downto 0); --Special Register
--    Signal IR : STD_LOGIC_VECTOR(2*dataSize-1 downto 0); --Instruction Register for Relative and extended addressing
    Signal AC : STD_LOGIC_VECTOR(3 downto 0); --Accumulator
    Signal SR : STD_LOGIC_VECTOR(3 downto 0); --Special Register : - R C Z: Flags (- Run Carry Zero)
    Signal IR : STD_LOGIC_VECTOR(7 downto 0); --Instruction Register for Relative and extended addressing
    Signal PC : STD_LOGIC_VECTOR(addrSize-1 downto 0); --Program Counter
    Signal Mem_Addr : STD_LOGIC_VECTOR(addrSize-1 downto 0); --Memory address buffer
--    Signal Mem_data : STD_LOGIC_VECTOR(dataSize-1 downto 0); --Data from memory buffer
    Signal Mem_data : STD_LOGIC_VECTOR(3 downto 0); --Data from memory buffer
    
    Type state is (FO, FR, FE, EX); --current state of CPU: Fetch Opcode, fetch relative, fetch extended, execute.
    Signal currentst : state := FO;
    Signal rst : STD_LOGIC := '0';
    
begin
    
    with Currentst select 
                mem_addr <= PC when FO | FR | FE,
                            IR when others;
                            
    main : process(clk, ini)
    variable run : STD_LOGIC;
    variable carry : STD_LOGIC;
    variable zero : STD_LOGIC;
    begin
    
    run := SR(2);
    carry := SR(1);
    zero := SR(0);
    
    if ini = '1' or rst = '1' then 
    --reset registers
--        AC <= STD_LOGIC_VECTOR(to_unsigned(0, dataSize));
--        SR <= STD_LOGIC_VECTOR(to_unsigned(0, dataSize));
--        IR <= STD_LOGIC_VECTOR(to_unsigned(0, 2*dataSize));
        AC <= "0000";
        SR <= "0000";
        IR <= "00000000";
        PC <= STD_LOGIC_VECTOR(to_unsigned(0, addrSize));
        Mem_addr <= STD_LOGIC_VECTOR(to_unsigned(0, addrSize));
--        Mem_data <= STD_LOGIC_VECTOR(to_unsigned(0, dataSize));
        Mem_data <= "0000";
        
    --reset state
        Currentst <= FO;
        rst <= '0';
    elsif (clk'event and clk ='1') then    
        if run = '1' then
            case Currentst is
            
                when FO =>
                    AddrOut <= PC;
                    Mem_addr <= PC;
                    Mem_data <= DataIn;
                    
                    PC <= STD_LOGIC_VECTOR(unsigned(PC) + (to_unsigned(1, addrSize))); --PC = PC + 1
                    
                    --Next State Selection
            --        if Mem_data(dataSize-1) = '0' then --since using 4 bit instructions and given instruction set, last bit 0: Inherent addressing, 1:  Relative or extended.
                    if Mem_data(3) = '0' then
                        CurrentSt <= EX;
                    else
                        CurrentSt <= FR;
                    end if;
                    --To Do EX and FR
                when EX =>
                    --Check OP Codes
                    -- For now just Inherenent addressed opcodes
                    case Mem_data is
                        when "0000" => --STP
                            SR(2) <= '0';                
                        when others => null;
                         
                    end case;            
                        
                    --Get next Op Code
                    CurrentSt <= FO;         
                when others => rst <= '1';
            end case;
        end if;
    end if;
   
    SR(2) <= run;
    SR(1) <= carry;
    SR(0) <= zero;
    
    end process main;

end Mixed;
