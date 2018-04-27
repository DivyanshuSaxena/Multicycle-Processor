----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2018 14:49:29
-- Design Name: 
-- Module Name: bus - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

entity slave is
    Port ( 
        hclk: in std_logic;
        hsel: in std_logic;
        hwrite: in std_logic;
        htrans: in std_logic;
        haddr: in std_logic_vector(31 downto 0);
        hwdata: in std_logic_vector(31 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(31 downto 0) );
end slave;

architecture Behavioral of slave is
type state_type is (idlest,writest,readst);
signal state: state_type;
signal address: std_logic_vector(31 downto 0);
signal write_data, fetch_data: std_logic_vector(31 downto 0);
begin
    process(clk)
    begin
        if state=idlest then
            if htrans='1' and hsel='1' then
                address <= haddr;
                if hwrite='1' then
                    state <= writest;
                else
                    state <= readst;
                end if;
            else
                state <= idlest;
            end if;
        elsif state=writest then
            write_data <= hwdata;
            state <= idlest;
        else
            hready <= '1';
            hrdata <= fetch_data;
            state <= idlest;
        end if;
    end process;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity slavemem is
    Port ( 
        hclk: in std_logic;
        hsel: in std_logic;
        hwrite: in std_logic;
        htrans: in std_logic;
        haddr: in std_logic_vector(31 downto 0);
        hwdata: in std_logic_vector(31 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(31 downto 0) );
end slavemem;

architecture Behavioral of slavemem is
type state_type is (idlest,wait1,wait2,writest,readst);
signal state: state_type;
signal address: std_logic_vector(31 downto 0);
signal write_data, fetch_data: std_logic_vector(31 downto 0);
begin
    process(clk)
    begin
        if state=idlest then
            if htrans='1' and hsel='1' then
                address <= haddr;
                state <= wait1;
            else
                state <= idlest;
            end if;
        elsif state=wait1 then
            state <= wait2;
        elsif state=wait2 then
            if hwrite='1' then
                state <= writest;
            else
                state <= readst;
            end if;
        elsif state=writest then
            write_data <= hwdata;
            state <= idlest;
        else
            hready <= '1';
            hrdata <= fetch_data;
            state <= idlest;
        end if;
    end process;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
--  Port ( );
end main;

architecture Behavioral of main is

begin


end Behavioral;
