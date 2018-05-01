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
        hwdata: in std_logic_vector(31 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(31 downto 0) );
end slaveswitch;

architecture Behavioral of slaveswitch is
type state_type is (idlest,writest,readst);
signal state: state_type;
signal address: std_logic_vector(15 downto 0);
signal write_data: std_logic_vector(31 downto 0);
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
            hrdata <= "0000000000000000" & switchin;
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
        hwdata: in std_logic_vector(31 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(31 downto 0);
        ledout: out std_logic_vector(15 downto 0) );
end slaveled;

architecture Behavioral of slaveled is
type state_type is (idlest,writest,readst);
signal state: state_type;
signal address: std_logic_vector(15 downto 0);
signal write_data, fetch_data: std_logic_vector(31 downto 0);
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

ledout <= write_data(15 downto 0);
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
        hwdata: in std_logic_vector(31 downto 0);
        hready: out std_logic;
        hrdata: out std_logic_vector(31 downto 0);
        cathode: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(3 downto 0) );
end slavessd;

architecture Behavioral of slavessd is
type state_type is (idlest,writest,readst);
signal state: state_type;
signal address: std_logic_vector(15 downto 0);
signal write_data, fetch_data: std_logic_vector(31 downto 0);
signal hclock: std_logic;
signal bout,anode_int: std_logic_vector(3 downto 0);
begin
bcd: entity work.bcd
    Port map ( bin => bout,
          output => cathode);

binsel: entity work.bin_select
    Port map ( b_in => write_data(15 downto 0),
           b_out => bout,
           anode => anode_int);

anoden: entity work.anode_decoder
    Port map ( anode_sel => anode_sel,
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
signal address: std_logic_vector(15 downto 0);
signal write_data, fetch_data, extraddr: std_logic_vector(31 downto 0);
signal row,hread: std_logic;
begin
ram: entity work.ram
    Port map (
    addr => extraddr,
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
extraddr <= "0000000000000000" & address;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity master is
    Port (
        hclk: in std_logic;
        intover: in std_logic;
        hready: in std_logic;
        hrdata: in std_logic_vector(31 downto 0);
        hwrite: out std_logic; 
        htrans: out std_logic;
        memwren: out std_logic_vector(3 downto 0);
        haddr: out std_logic_vector(15 downto 0);
        hwdata: out std_logic_vector(31 downto 0) );
end master;

architecture Behavioral of master is
type state_type is (idlest,readywait);
signal state: state_type;
signal address: std_logic_vector(15 downto 0);
signal extraddr,rdata,wdata: std_logic_vector(31 downto 0);
signal start, row, interrupt: std_logic;
begin
processor: entity work.common
    Port map (
        clk => hclk,
        interrupt => interrupt, 
        fromem => rdata,
        maddr => extraddr,
        tomem => wdata,
        wren => memwren);

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

process(intover,hready)
begin
    if (hready='0' and address(11 downto 3)="111111111" and address(2)='0') then
        interrupt <= '1';
    elsif (intover='0' and address(11 downto 2)="1111111111") then 
        interrupt <= '1';
    else
        interrupt <= '0';
    end if;
end process;
extraddr <= "0000000000000000" & address;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decoder is
    Port ( 
        haddr: in std_logic_vector(15 downto 0);
        hsel1: out std_logic;
        hsel2: out std_logic;
        hsel3: out std_logic;
        hsel4: out std_logic;
        muxsel: out std_logic_vector(1 downto 0) );
end decoder;

architecture Behavioral of decoder is
signal sel: std_logic_vector(3 downto 0);
begin
    process(haddr)
    begin
        if haddr(15 downto 2)="00000011111111" then
            if haddr(1 downto 0)="00" then
                sel <= "0001";
            elsif haddr(1 downto 0)="01" then
                sel <= "0010";
            elsif haddr(1 downto 0)="10" then
                sel <= "0100";
            else
                sel <= "1000";
            end if;
        else
            sel <= "0000";
        end if;
    end process;
hsel1 <= sel(0);
hsel2 <= sel(1);
hsel3 <= sel(2);
hsel4 <= sel(3);
muxsel <= haddr(1 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplexor is
    Port ( 
        sel: in std_logic_vector(1 downto 0);
        data1: in std_logic_vector(31 downto 0);
        data2: in std_logic_vector(31 downto 0);
        data3: in std_logic_vector(31 downto 0);
        data4: in std_logic_vector(31 downto 0);
        ready1: in std_logic;
        ready2: in std_logic;
        ready3: in std_logic;
        ready4: in std_logic;
        data: out std_logic_vector(31 downto 0);
        ready: out std_logic );
end multiplexor;

architecture Behavioral of multiplexor is
begin
    data <= data1 when sel="00" else
            data2 when sel="01" else
            data3 when sel="10" else
            data4;
    ready <= ready1 when sel="00" else
            ready2 when sel="01" else
            ready3 when sel="10" else
            ready4;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity toplevel is
    Port (
        clk: in std_logic;
        pushbutton: in std_logic;
        intover: in std_logic;
        switches: in std_logic_vector(15 downto 0);
        led: out std_logic_vector(15 downto 0);
        cathode: out std_logic_vector(6 downto 0);
        anode: out std_logic_vector(3 downto 0) );
end toplevel;

architecture Behavioral of toplevel is
signal slowclk,ready,buswrite,bustrans,selswitch,selled,selssd,selmem: std_logic;
signal readyswitch,readyled,readyssd,readymem: std_logic;
signal buswd,busrd: std_logic_vector(31 downto 0);
signal busaddr: std_logic_vector(15 downto 0);
signal switchdata,leddata,ssddata: std_logic_vector(31 downto 0);
signal memdata: std_logic_vector(31 downto 0);
signal memwren: std_logic_vector(3 downto 0);
signal muxsel,anode_sel: std_logic_vector(1 downto 0);
begin
count: entity work.counter
    Port map ( clk => clk,
           pushbutton => pushbutton,
           clock => slowclk,
           y => anode_sel);

master: entity work.master
    Port map (
        hclk => slowclk,
        intover => intover,
        hready => ready,
        hrdata => busrd,
        hwrite => buswrite, 
        memwren => memwren,
        htrans => bustrans,
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

leden: entity work.slaveled
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

memory: entity work.slavemem
    Port map (
        hclk => slowclk,
        hsel => selmem,
        hwrite => buswrite,
        htrans => bustrans,
        memwren => memwren,
        haddr => busaddr,
        hwdata => buswd,
        hready => ready,
        hrdata => memdata );

sevseg: entity work.slavessd
    Port map (
        hclk => slowclk,
        hsel => selssd,
        hwrite => buswrite,
        htrans => bustrans,
        anode_sel => anode_sel,
        haddr => busaddr,
        hwdata => buswd,
        hready => readyssd,
        hrdata => ssddata,
        cathode => cathode,
        anode => anode );
 
mux: entity work.multiplexor
    Port map (
        sel => muxsel,
        data1 => switchdata,
        data2 => leddata,
        data3 => ssddata,
        data4 => memdata,
        ready1 => readyswitch,
        ready2 => readyled,
        ready3 => readyssd,
        ready4 => readymem,
        data => busrd,
        ready => ready );

decoder: entity work.decoder
    Port map (
        haddr => busaddr,
        hsel1 => selswitch,
        hsel2 => selled,
        hsel3 => selssd,
        hsel4 => selmem,
        muxsel => muxsel );

end Behavioral;
