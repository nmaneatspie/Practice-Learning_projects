----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Norman Thien
-- 
-- Create Date: 29.11.2020 20:31:55
-- Design Name: 
-- Module Name: MUM_v2 - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: CPU.vhd, Mem.vhd
-- 
-- Revision: 1.01
-- Revision 0.01 - File Created
-- Revision 1.00 - Added the CPU and Mem components and their generic and port mapping
-- Revision 1.01 - Commented out dataSize Generic and replaced the associated parts with fixed width 4 bits
-- Additional Comments:
-- Made using Vivado 2019.2 then changed on 2020.12.11 to 2020.2 due to issues with the software (random lags). 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUM_v2 is
    Generic (
        --dataSize: Integer := 4;
        addrSize : Integer := 8;
        numMem : Integer := 256 --256 Words
    );
    Port (
        clk : in STD_LOGIC;
        ini : in STD_LOGIC
     );
end MUM_v2;

architecture Structural of MUM_v2 is

    component CPU
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
    end component CPU;
    
    component Mem is
        Generic (
            --dataSize: Integer := 4;
            addrSize : Integer := 8;
            numMem : Integer := 256 --256 Words
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
    end component Mem;

--    Signal dataBus1 : STD_LOGIC_VECTOR(dataSize-1 downto 0);
--    Signal dataBus2 : STD_LOGIC_VECTOR(dataSize-1 downto 0);
    Signal dataBus1 : STD_LOGIC_VECTOR(3 downto 0);
    Signal dataBus2 : STD_LOGIC_VECTOR(3 downto 0);
    Signal addrBus : STD_LOGIC_VECTOR(addrSize-1 downto 0);
    Signal rwLine : STD_LOGIC;
    Signal rstLine : STD_LOGIC;
    
begin

    CPU01 : CPU Generic Map(
            --dataSize => dataSize, 
            addrSize => addrSize
        ) 
        Port Map (
            clk => clk,
            ini => ini,
            DataIn => dataBus2,
            DataOut => dataBus1,
            AddrOut => addrBus,
            RW => rwLine,
            rstOut => rstLine
        );
    MEM01 : Mem Generic Map(
            --dataSize => dataSize,
            addrSize => addrSize,
            numMem => numMem
        )
        Port Map(
            ini => ini,
            DataIn => dataBus1,
            DataOut => dataBus2,
            AddrIn => addrBus,
            RW => rwLine,
            rst => rstLine
        );

end Structural;
