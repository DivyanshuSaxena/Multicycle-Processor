----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2018 14:12:35
-- Design Name: 
-- Module Name: controller - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
  Port (
  clk: in std_logic;
  control: out std_logic_vector(31 downto 0) );
end controller;

architecture Behavioral of controller is
type state_type is (fetch, read, decode, arith, mul, dt, brn, load, store);
signal state: state_type;
signal pw,iord,medc,idw,rsrc1,rsrc2,rsrc3,rfwren,asrc,shtypec,fset: std_logic;
signal bsrc,aluop1c,aluop2c,shamtc,resultc: std_logic_vector(1 downto 0);
-- Combine aw with aluop1c="11"
-- Combine bw with aluop2c="11"
-- Combine shdatac with shamtc="11"
-- Combine rew with resultc="11"
signal aluop: std_logic_vector(3 downto 0);
signal pminstr,pmbyte: std_logic_vector(2 downto 0);
begin
process (clk)
begin
    if state=fetch then
        iord <= '0';
    elsif state=read then
    elsif state=decode then
    elsif state=arith then
    elsif state=mul then
    elsif state=dt then
    elsif state=brn then
    elsif state=load then
    elsif state=store then
    end if;
end process;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inst_decoder is
    Port (
    instr: in std_logic_vector(15 downto 0);
    instr_type: out std_logic_vector(1 downto 0);
    instr_class: out std_logic_vector(2 downto 0);
    instr_variant: out std_logic );
end inst_decoder;

architecture Behavioral of inst_decoder is
begin
instr_type <= "00" when instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') else   -- dp
              "01" when instr(15 downto 14)="01" or (instr(15 downto 14)="00" and instr(3)='1' and not instr(2 downto 1)="00") else -- dt
              "10" when instr(15 downto 14)="00" and instr(3 downto 1)="100" else   -- mul or mla
              "11"; -- b
instr_class <= "000" when instr(15 downto 14)="01" and instr(10)='0' and instr(8)='1' else    -- ldr  
               "001" when instr(15 downto 14)="01" and instr(10)='0' and instr(8)='0' else    -- str  
               "010" when instr(15 downto 14)="00" and instr(8)='1' else    -- ldrh
               "011" when instr(15 downto 14)="00" and instr(8)='0' else    -- strh
               "100" when instr(15 downto 14)="01" and instr(10)='1' and instr(8)='1' else    -- ldrb
               "101" when instr(15 downto 14)="01" and instr(10)='1' and instr(8)='0';    -- strb  
               -- Do something for ldrsb and ldrsh
instr_variant <= '1' when instr(13)='1' else '0';
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flag_check is
    Port (
    flags: in std_logic_vector(3 downto 0);
    cond: in std_logic_vector(3 downto 0);
    predicate: out std_logic;
    undef: out std_logic);
end flag_check;

architecture Behavioral of flag_check is
begin
    process(flags)
    begin
        case cond is
            when "0000" => if flags(2)='1' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "0001" => if flags(2)='0' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "0010" => if flags(0)='1' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "0011" => if flags(0)='0' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "0100" => if flags(3)='1' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "0101" => if flags(3)='0' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "0110" => if flags(1)='1' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "0111" => if flags(1)='0' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "1000" => if flags(0)='1' and flags(2)='0' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "1001" => if flags(0)='0' or flags(2)='1' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "1010" => if flags(3)=flags(1) then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "1011" => if not flags(3)=flags(1) then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "1100" => if flags(3)=flags(1) and flags(2)='0' then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when "1101" => if flags(2)='1' or not flags(3)=flags(1) then
                            predicate <= '1';
                           else
                            predicate <= '0';
                           end if;
            when others => predicate <= '1';
        end case;
        
        if cond="1111" then
            undef <= '1';
        else
            undef <= '0';
        end if;
    end process;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_generator is
--    Port ();
end control_generator;

architecture Behavioral of control_generator is
begin

end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_fsm is
--    Port ();
end controller_fsm;

architecture Behavioral of controller_fsm is

begin

end Behavioral;
