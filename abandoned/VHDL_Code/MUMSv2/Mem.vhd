----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Norman Thien
-- 
-- Create Date: 29.11.2020 20:31:55
-- Design Name: 
-- Module Name: Mem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision: 0.04
-- Revision 0.01 - File Created
-- Revision 0.02 - Added Given memory set
-- Revision 0.03 - Commented out dataSize Generic and replaced the associated parts with fixed width 4 bits since instruction set is fixed
-- Revision 0.04 - Added part of read
-- Additional Comments:
-- Made using Vivado 2019.2 then changed on 2020.12.11 to 2020.2 due to issues with the software (random lags). 
-- Focusing currently on completing CPU.vhd first
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mem is
    Generic (
        --dataSize: Integer := 4;
        addrSize : Integer := 8;
        numMem : Integer := 256
    );
    Port (
        ini : in STD_LOGIC;
--        DataIn : in STD_LOGIC_VECTOR(dataSize-1 downto 0);
--        DataOut : out STD_LOGIC_VECTOR(dataSize-1 downto 0);
        DataIn : in STD_LOGIC_VECTOR(3 downto 0);
        DataOut : out STD_LOGIC_VECTOR(3 downto 0);
        AddrIn : in STD_LOGIC_VECTOR(addrSize-1 downto 0);
        RW : in STD_LOGIC; --Read/Write flag, Read:0, Write: 1
        rst : in STD_LOGIC
        );
end Mem;

architecture Behavioral of Mem is

--    Type mem_arr is array (0 to numMem-1) of STD_LOGIC_VECTOR(dataSize-1 downto 0);
    Type mem_arr is array (0 to numMem-1) of STD_LOGIC_VECTOR(3 downto 0);
    Signal mem_data : mem_arr;

begin

    main : process(AddrIn, RW, DataIn, ini) --Do for Read only first then adjust for read/write later
    
    variable mem_sel : integer := 0;
    
    begin
        
        mem_Sel := to_integer(unsigned(AddrIn));
        
        if ini = '1' or rst = '1' then   
        --setup inital values of ram
            mem_data(0) <= "1010"; --Load
            mem_data(1) <= "0001"; --NibA
            mem_data(2) <= "1101"; --NibB
            mem_data(3) <= "0100"; --rotate left
            mem_data(4) <= "0011"; --Complement
            mem_data(5) <= "1000"; --BRC
            mem_data(6) <= "0001"; --NibA
            mem_data(7) <= "0000"; --Stop
            mem_data(8) <= "1011"; --Store
            mem_data(9) <= "0001"; --NibA
            mem_data(10) <= "1110"; --NibB
            mem_data(11) <= "0001"; --Clear
            mem_data(12) <= "1111"; --Jump
            mem_data(13) <= "0001"; --NibA
            mem_data(14) <= "0000"; --NibB
            mem_data(15) <= "0000"; --Stop
            mem_data(16) <= "0010"; --Incr
            mem_data(17) <= "1100"; --add
            mem_data(18) <= "0001"; --NibA
            mem_data(19) <= "1101"; --NibB
            mem_data(20) <= "1101"; --Subtract
            mem_data(21) <= "0001"; --NibA
            mem_data(22) <= "1110"; --NibB
            mem_data(23) <= "0001"; --Clear
            mem_data(24) <= "0100"; --rotate left
            mem_data(25) <= "1001"; --BRZ
            mem_data(26) <= "0100"; --NibA
            mem_data(27) <= "1110"; --NibB
            mem_data(28) <= "0000"; --stop
            mem_data(29) <= "1100"; --Data
            mem_data(30) <= "0000"; --Data
            mem_data(31) <= "0001"; --clear
            mem_data(32) <= "0000"; --stop
        end if;
        
        for I in numMem-1 downto 0 loop
            if mem_Sel = I then
                dataOut <= mem_data(I);            
            end if;
            
        end loop;
    end process main;

end Behavioral;
