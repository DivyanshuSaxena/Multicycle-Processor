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
instr_class <= "000" when (instr(15 downto 14)="01" and instr(10)='0' and instr(8)='1') or 
                        (instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') and instr(24 downto 21)="1000") else    -- ldr or tst 
               "001" when (instr(15 downto 14)="01" and instr(10)='0' and instr(8)='0') or 
                        (instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') and instr(24 downto 21)="1001") else    -- str or teq
               "010" when (instr(15 downto 14)="00" and instr(3)='1' and not instr(2 downto 1)="00" and instr(8)='1') or 
                        (instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') and instr(24 downto 21)="1010") else    -- ldrh or cmp
               "011" when (instr(15 downto 14)="00" and instr(3)='1' and not instr(2 downto 1)="00" and instr(8)='0') or 
                        (instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') and instr(24 downto 21)="1011") else    -- strh or cmn
               "100" when (instr(15 downto 14)="01" and instr(10)='1') and instr(8)='1' else    -- ldrb
               "101" when (instr(15 downto 14)="01" and instr(10)='1') and instr(8)='0';    -- strb  
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
  instruction: in std_logic_vector(31 downto 0);
  flags: in std_logic_vector(3 downto 0);
  control: out std_logic_vector(31 downto 0) );
end controller;

architecture Behavioral of controller is
-- fsm
type state_type is (fetch, readreg, decode, arith_imm, arith_reg, mul, dt, brn, load, store, writerf);
signal state: state_type;
signal state_out: std_logic_vector(3 downto 0);
-- control signals
signal pw,iord,medc,idw,rsrc1,rsrc2,rsrc3,rfwren,asrc,shdatac,shtypec,fset,aw,bw: std_logic;
signal bsrc,aluop1c,aluop2c,shamtc,resultc: std_logic_vector(1 downto 0);
-- Combine aw with aluop1c="11"
-- Combine bw with aluop2c="11"
-- Combine shdatac with shamtc="11"
-- Combine rew with resultc="11"
signal aluop: std_logic_vector(3 downto 0);
signal pminstr,pmbyte: std_logic_vector(2 downto 0);
-- map inst_decoder
signal instr: std_logic_vector(15 downto 0);
signal instr_type: std_logic_vector(1 downto 0);
signal instr_class: std_logic_vector(2 downto 0);
signal instr_variant: std_logic;
-- map flag_check
signal pred,undef: std_logic;
begin

decoder: entity work.inst_decoder
    Port map (
        instr => instr,
        instr_type => instr_type,
        instr_class => instr_class,
        instr_variant => instr_variant
    );
flag_control: entity work.flag_check
    Port map (
        flags => flags,
        cond => instruction(31 downto 28),
        predicate => pred,
        undef => undef
    );

instr <= instruction(27 downto 20) & instruction(11 downto 4);
process (clk)
begin
    if state=fetch then
        pw <= '0';
        iord <= '0';
        asrc <= '0';
        bsrc <= "01";
        aluop1c <= "00";
        aluop2c <= "10";
        resultc <= "01";
        state <= readreg;
    elsif state=readreg then
        idw <= '1';
        rsrc1 <= '1';
        rsrc2 <= '1';
        rsrc3 <= '1';
        state <= decode;
    elsif state=decode then
        idw <= '0';
        if instr_type="00" then
            if instr_variant='0' then
                state <= arith_imm;
            else
                state <= arith_reg;
            end if;
        elsif instr_type="01" then
            state <= dt;
        elsif instr_type="10" then
            state <= mul;
        else
            state <= brn;
        end if;
    elsif state=arith_imm then
        aw <= '1';
        asrc <= '1';
        shamtc <= "01";
        shdatac <= '1';
        shtypec <= '1';
        aluop1c <= "00";
        aluop2c <= "01";
        resultc <= "01";
        state <= writerf;
    elsif state=mul then
    elsif state=dt then
    elsif state=brn then
    elsif state=load then
    elsif state=store then
    end if;
end process;
end Behavioral;

----------------------------------------------------------------------------------
