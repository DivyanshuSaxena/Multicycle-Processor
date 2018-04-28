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

entity counter is
    Port ( clk : in std_logic;
           pushbutton : in std_logic;
           clock : out std_logic;
           y: out std_logic_vector(1 downto 0));
end counter;

architecture behavioral of counter is
signal c : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
begin
    process (clk)
    begin
        if clk = '1' and clk'event then 
            c <= std_logic_vector(unsigned(c) + 1);
            if pushbutton ='0' then
                y <= c(15 downto 14);
                clock <= c(24);
            else 
                y <= c(1 downto 0);
                clock <= c(0);
            end if;         
        end if;
    end process;
    
end behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd is
    Port( bin : in std_logic_vector(3 downto 0);
          output : out std_logic_vector(6 downto 0));
end bcd;

architecture behavioral of bcd is
begin
with bin select
output <= "1111001" when "0001",
          "0100100" when "0010",
          "0110000" when "0011",
          "0011001" when "0100",
          "0010010" when "0101",
          "0000010" when "0110",
          "1111000" when "0111",
          "0000000" when "1000",
          "0010000" when "1001",
          "0001000" when "1010",
          "0000011" when "1011",
          "1000110" when "1100",
          "0100001" when "1101",
          "0000110" when "1110",
          "0001110" when "1111",
          "1000000" when others;
          
end behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin_select is
    Port ( b_in : in std_logic_vector(15 downto 0);
           b_out : out std_logic_vector(3 downto 0);
           anode : in std_logic_vector(3 downto 0));
end bin_select;

architecture behavioral of bin_select is
begin
with anode select
    b_out <= b_in(15 downto 12) when "0111",
             b_in(11 downto 8) when "1011",
             b_in(7 downto 4) when "1101",
             b_in(3 downto 0) when others;
             
end behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity anode_decoder is
    Port ( anode_sel : in std_logic_vector(1 downto 0);
           anode_out : out std_logic_vector(3 downto 0));
end anode_decoder; 
          
architecture behavioral of anode_decoder is
begin
with anode_sel select
    anode_out <= "0111" when "00",
                 "1011" when "01",
                 "1101" when "10",
                 "1110" when others;
end behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity slaveswitch is
    Port ( 
        hclk: in std_logic;
        hsel: in std_logic;
        hwrite: in std_logic;
        htrans: in std_logic;
        haddr: in std_logic_vector(15 downto 0);
        switchin: in std_logic_vector(15 downto 0);
        hwdata: in std_logic_vector(15 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(15 downto 0) );
end slaveswitch;

architecture Behavioral of slaveswitch is
type state_type is (idlest,writest,readst);
signal state: state_type;
signal address: std_logic_vector(15 downto 0);
signal write_data: std_logic_vector(15 downto 0);
begin
    process(hclk)
    begin
        if state=idlest then
            hready <= '0';
            if htrans='1' and hsel='1' then
                address <= haddr;
                if hwrite='1' then
                    write_data <= hwdata;
                    state <= writest;
                else
                    state <= readst;
                end if;
            else
                state <= idlest;
            end if;
        elsif state=writest then
            hready <= '1';
            state <= idlest;
        else
            hready <= '1';
            hrdata <= switchin;
            state <= idlest;
        end if;
    end process;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity slaveled is
    Port ( 
        hclk: in std_logic;
        hsel: in std_logic;
        hwrite: in std_logic;
        htrans: in std_logic;
        haddr: in std_logic_vector(15 downto 0);
        hwdata: in std_logic_vector(15 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(15 downto 0);
        ledout: out std_logic_vector(15 downto 0) );
end slaveled;

architecture Behavioral of slaveled is
type state_type is (idlest,writest,readst);
signal state: state_type;
signal address: std_logic_vector(31 downto 0);
signal write_data, fetch_data: std_logic_vector(15 downto 0);
begin
    process(hclk)
    begin
        if state=idlest then
            hready <= '0';
            if htrans='1' and hsel='1' then
                address <= haddr;
                if hwrite='1' then
                    write_data <= hwdata;
                    state <= writest;
                else
                    state <= readst;
                end if;
            else
                state <= idlest;
            end if;
        elsif state=writest then
            hready <= '1';
            state <= idlest;
        else
            hready <= '1';
            hrdata <= fetch_data;
            state <= idlest;
        end if;
    end process;

ledout <= write_data;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity slavessd is
    Port ( 
        hclk: in std_logic;
        hsel: in std_logic;
        hwrite: in std_logic;
        htrans: in std_logic;
        anode_sel: in std_logic_vector(1 downto 0);
        haddr: in std_logic_vector(15 downto 0);
        hwdata: in std_logic_vector(15 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(15 downto 0);
        cathode: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(3 downto 0) );
end slavessd;

architecture Behavioral of slavessd is
type state_type is (idlest,writest,readst);
signal state: state_type;
signal address: std_logic_vector(15 downto 0);
signal write_data, fetch_data: std_logic_vector(15 downto 0);
signal hclock: std_logic;
signal bout,anode_int: std_logic_vector(3 downto 0);
begin
bcd: entity work.bcd
    Port map ( bin => bout
          output => cathode);

binsel: entity work.bin_select
    Port map ( b_in => write_data,
           b_out => bout,
           anode => anode_int);

anode: entity work.anode_decoder
    Port ( anode_sel => anode_sel
           anode_out => anode_int);

    process(hclk)
    begin
        if state=idlest then
            hready <= '0';
            if htrans='1' and hsel='1' then
                address <= haddr;
                if hwrite='1' then
                    write_data <= hwdata;
                    state <= writest;
                else
                    state <= readst;
                end if;
            else
                state <= idlest;
            end if;
        elsif state=writest then
            hready <= '1';
            state <= idlest;
        else
            hready <= '1';
            hrdata <= fetch_data;
            state <= idlest;
        end if;
    end process;
anode <= anode_int;
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
        memwren: in std_logic_vector(3 downto 0);
        haddr: in std_logic_vector(15 downto 0);
        hwdata: in std_logic_vector(31 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(31 downto 0) );
end slavemem;

architecture Behavioral of slavemem is
type state_type is (idlest,wait1,wait2,writest,readst);
signal state: state_type;
signal address: std_logic_vector(31 downto 0);
signal write_data, fetch_data: std_logic_vector(31 downto 0);
signal row: std_logic;
begin
ram: entity work.ram
    Port map (
    addr => address,
    clk => hclk,
    din => write_data,
    dout => fetch_data,
    mr => hread,
    wren => memwren);

    process(hclk)
    begin
        if state=idlest then
            hready <= '0';
            if htrans='1' and hsel='1' then
                address <= haddr;
                row <= hwrite;
                if row='1' then
                    write_data <= hwdata;
                end if;
                state <= wait1;
            else
                state <= idlest;
            end if;
        elsif state=wait1 then
            state <= wait2;
        elsif state=wait2 then
            if row='1' then
                state <= writest;
            else
                state <= readst;
            end if;
        elsif state=writest then
            hready <= '1';
            state <= idlest;
        else
            hready <= '1';
            hrdata <= fetch_data;
            state <= idlest;
        end if;
    end process;

hread <= '1' when row='0' else '0';
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity master is
    Port (
        hclk: in std_logic;
        hready: in std_logic;
        pushbutton: in std_logic;
        hrdata: in std_logic_vector(15 downto 0);
        hwrite: out std_logic; 
        htrans: out std_logic;
        haddr: out std_logic_vector(15 downto 0);
        hwdata: out std_logic_vector(15 downto 0) );
end master;

architecture Behavioral of master is
type state_type is (idlest,readywait);
signal state: state_type;
signal address,rdata,wdata: std_logic_vector(31 downto 0);
signal start, row: std_logic;
begin
processor: entity work.common
    Port map (
        clk => hclk,
        pushbutton => pushbutton );
        
process(hclk)
begin
    if state=idlest then
        if start='1' then
            htrans <= '1';
            haddr <= address;
            hwrite <= row;
            if row='1' then
                hwdata <= wdata;
            end if;
            state <= readywait;
        else
            state <= idlest;
        end if;
    else
        if hready='1' then
            if row='0' then
                rdata <= hrdata;
            end if;
            state <= idlest;
        else
            state <= readywait;
        end if;
    end if;
end process;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel is
    Port (
        clk: in std_logic;
        pushbutton: in std_logic;
        switches: in std_logic_vector(15 downto 0);
        led: out std_logic_vector(15 downto 0);
        cathode: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(3 downto 0) );
end toplevel;

architecture Behavioral of toplevel is
signal slowclk,ready,buswrite,bustrans,selswitch,selled,selssd: std_logic;
signal readyswitch,readyled,readyssd: std_logic;
signal buswd,busrd,busaddr: std_logic_vector(15 downto 0);
signal switchdata,leddata,ssddata: std_logic_vector(15 downto 0);
begin
count: entity work.counter
    Port map ( clk => clk,
           pushbutton => pushbutton,
           clock => slowclk,
           y => anode_sel);

master: entity work.master
    Port map (
        hclk => slowclk,
        hready => ready,
        hrdata => busrd,
        hwrite => buswrite, 
        htrans => nustrans,
        haddr => busaddr,
        hwdata => buswd );

switch: entity work.slaveswitch
    Port map (
        hclk => slowclk,
        hsel => selswitch,
        hwrite => buswrite,
        htrans => bustrans,
        haddr => busaddr,
        switchin => switches,
        hwdata => buswd,
        hready => readyswitch,
        hrdata => switchdata );

led: entity work.slaveled
    Port map (
        hclk => slowclk,
        hsel => selled,
        hwrite => buswrite,
        htrans => bustrans,
        haddr => busaddr,
        hwdata => buswd,
        hready => readyled,
        hrdata => leddata,
        ledout => led );

sevseg: entity work.slavessd
    Port map (
        hclk => slowclk,
        hsel => selmem,
        hwrite => buswrite,
        htrans => bustrans,
        memwren: in std_logic_vector(3 downto 0);
        haddr: in std_logic_vector(15 downto 0);
        hwdata: in std_logic_vector(31 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(31 downto 0)
    );

end Behavioral;
