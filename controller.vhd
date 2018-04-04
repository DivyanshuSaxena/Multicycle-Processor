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
    instr_variant: out std_logic;
    instr_shift: out std_logic );
end inst_decoder;

architecture Behavioral of inst_decoder is
begin
instr_type <= "00" when instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') else   -- dp
              "01" when instr(15 downto 14)="01" or (instr(15 downto 14)="00" and instr(3)='1' and not instr(2 downto 1)="00") else -- dt
              "10" when instr(15 downto 14)="00" and instr(3 downto 1)="100" else   -- mul or mla
              "11"; -- b
instr_class <= "000" when (instr(15 downto 14)="01" and instr(10)='0' and instr(8)='1') or 
                        (instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') and instr(24 downto 21)="1000") or
                        (instr(15 downto 14)="00" and instr(3 downto 1)="100" and instr(9)='0') else    -- ldr or tst or simple mul 
               "001" when (instr(15 downto 14)="01" and instr(10)='0' and instr(8)='0') or 
                        (instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') and instr(24 downto 21)="1001") or
                        (instr(15 downto 14)="00" and instr(3 downto 1)="100" and instr(9)='1') else    -- str or teq or mla
               "010" when (instr(15 downto 14)="00" and instr(3)='1' and not instr(2 downto 1)="00" and instr(8)='1') or 
                        (instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') and instr(24 downto 21)="1010") else    -- ldrh or cmp
               "011" when (instr(15 downto 14)="00" and instr(3)='1' and not instr(2 downto 1)="00" and instr(8)='0') or 
                        (instr(15 downto 14)="00" and (instr(13)='1' or instr(3)='0' or instr(0)='0') and instr(24 downto 21)="1011") else    -- strh or cmn
               "100" when ((instr(15 downto 14)="01" and instr(10)='1') and instr(8)='1') else    -- ldrb
               "101" when (instr(15 downto 14)="01" and instr(10)='1') and instr(8)='0';    -- strb  
               -- Do something for ldrsb and ldrsh
instr_variant <= '1' when instr(13)='1' else '0';
instr_shift <= '1' when instr(0)='1' else '0'; -- '1' when shift is from reg
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
  control: out std_logic_vector(33 downto 0) );
end controller;

architecture Behavioral of controller is
-- fsm
type state_type is (fetch, readreg, decode, arith_imm, arith_reg, arith_sh_imm, arith_sh_reg,
alu, mul, mla, mla_alu, dt_imm, dt_reg, dt_alu, dt, brn, load, store, writerf, pcincr, pcupdate);
signal state: state_type;
signal state_out: std_logic_vector(3 downto 0);
-- control signals
signal pw,iord,iw,dw,rsrc1,rsrc2,rsrc3,rfwren,asrc,shdatac,shtypec,fset,aw,bw,aluop1c,rew: std_logic;
signal bsrc,aluop2c,shamtc,resultc: std_logic_vector(1 downto 0);
signal aluop: std_logic_vector(3 downto 0);
signal pminstr,pmbyte: std_logic_vector(2 downto 0);
-- map inst_decoder
signal instr: std_logic_vector(15 downto 0);
signal instr_type: std_logic_vector(1 downto 0);
signal instr_class: std_logic_vector(2 downto 0);
signal instr_variant,instr_shift: std_logic;
-- map flag_check
signal pred,undef: std_logic;
begin

decoder: entity work.inst_decoder
    Port map (
        instr => instr,
        instr_type => instr_type,
        instr_class => instr_class,
        instr_variant => instr_variant,
        instr_shift => instr_shift
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
        -- MR=1 is to be done here.
        pw <= '1';
        rfwren <= '0';
        rew <= '0';
        iord <= '0';
        state <= readreg;
    elsif state=readreg then
        pw <= '0';
        iw <= '1';
        rsrc1 <= '1';
        rsrc2 <= '1';
        rsrc3 <= '1';
        state <= decode;
    elsif state=decode then
        iw <= '0';
        if instr_type="00" then
            if instr_variant='0' then
                state <= arith_imm;
            else
                state <= arith_reg;
            end if;
        elsif instr_type="01" then
            if instr_variant='1' then
                state <= dt_reg;
            else
                state <= dt_imm;
            end if;
        elsif instr_type="10" then
            rsrc1 <= '0';
            rsrc3 <= '0';
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
        resultc <= "11";
        rew <= '1';
        state <= alu;
    elsif state=arith_reg then
        aw <= '1';
        bw <= '1';
        asrc <= '1';
        bsrc <= "00";
        if instr_shift='1' then
            rsrc1 <= '0';
            state <= arith_sh_reg;
        else
            state <= arith_sh_imm;
        end if;
    elsif state=arith_sh_imm then
        aw <= '0';
        shamtc <= "00";
        shtypec <= '0';
        shdatac <= '0';
        resultc <= "11";
        rew <= '1';
        state <= alu;
    elsif state=arith_sh_reg then
        aw <= '0';
        rsrc1 <= '1';
        shamtc <= "10";
        shdatac <= '0';
        shtypec <= '0';
        resultc <= "11";
        rew <= '1';
        state <= alu;
    -- elsif state=arith_shreg_alu then
    --     aw <= '1';
    --     aluop1c <= '0';
    --     aluop2c <= "01";
    --     resultc <= "01";
    --     state <= writerf;
    elsif state=alu then
        aw <= '1';
        rew <= '0';
        aluop1c <= '0';
        aluop2c <= "01";
        aluop <= instruction(24 downto 21);
        resultc <= "01";
        state <= writerf;
    elsif state=mul then
        aw <= '1';
        bw <= '1';
        asrc <= '1';
        bsrc <= "00";
        resultc <= "00";
        if instr_class="000" then
            state <= writerf;
        else
            state <= mla;
        end if;
    elsif state=mla then
        bw <= '0';
        rsrc2 <= '0';
        rew <= '1';
        rfwren <= '0';
        state <= mla_alu;
    elsif state=mla_alu then
        rew <= '0';
        bw <= '1';
        bsrc <= "00";
        aluop1c <= '1';
        aluop2c <= "10";
        aluop <= "0100";
        resultc <= "01";
        state <= writerf;
    elsif state=dt_imm then
        aw <= '1';
        asrc <= '1';
        bsrc <= "10";
        aluop1c <= '0';
        aluop2c <= "10";
        if instruction(23)='1' then
            aluop <= "0100";
        else
            aluop <= "0110";
        end if;
        -- Do something for next state
        state <= dt;
    elsif state=dt_reg then
        bw <= '1';
        bsrc <= "00";
        shdatac <= '0';
        shamtc <= "00";
        shtypec <= '0';
        resultc <= "10";
        rew <='1';
        state <= dt_alu;
    elsif state=dt_alu then
        aw <= '1';
        rew <= '0';
        aluop1c <= '0';
        aluop2c <= "01";
        if instruction(23)='1' then
            aluop <= "0100";
        else
            aluop <= "0110";
        end if;
        resultc <= "01";
        -- Do something for next state
        state <= dt;
    elsif state=dt then
        if instr_class="000" or instr_class="010" or instr_class="100" then
            rew <= '1';
            rfwren <= '0';
            iord <= '1';
            iw <= '0';
            dw <= '0';
            state <= load;
        else
            rew <= '1';
            iord <= '1';
            rsrc2 <= '0';
            state <= store;
        end if;
    elsif state=brn then
        asrc <= '0';
        bsrc <= "11";
        aluop1c <= '0';
        aluop2c <= "10";
        aluop <= "0100";
        resultc <= "01";
        if pred='1' then
            state <= pcupdate;
        else
            state <= pcincr;
        end if;
    elsif state=load then
        dw <= '1';
        pminstr <= "000"; -- Supports only ldr presently
        pmbyte <= "000"; -- No need presently
        resultc <= "10";
        state <= writerf;
    elsif state=store then
        rew <= '0';
        bw <= '1';
        bsrc <= "00";
        pminstr <= "101";
        state <= pcincr;
    elsif state=writerf then
        rew <= '1';
        if instr_type="00" and 
        (instr_class="000" or instr_class="001" or instr_class="010" or instr_class="011") then
            -- If cmp/cmn/tst/teq
            rfwren <= '0';
        else
            rfwren <= pred;
        end if;
        if instr_type="10" then
            rsrc3 <= '0';
        else
            rsrc3 <= '1';
        end if;
        state <= pcincr;
    elsif state=pcincr then
        rew <= '1';
        rfwren <= '0';
        asrc <= '0';
        bsrc <= "01";
        aluop1c <= '0';
        aluop2c <= "10";
        aluop <= "0100";
        resultc <= "01";
        state <= fetch;
    elsif state=pcupdate then
        rew <= '1';
        rfwren <= '0';
        state <= fetch;
    end if;
end process;

control(0) <= pw;
control(1) <= iord;
control(2) <= iw;
control(3) <= dw;
control(4) <= rsrc1;
control(5) <= rsrc2;
control(6) <= rsrc3;
control(7) <= rfwren;
control(8) <= asrc;
control(10 downto 9) <= bsrc(1 downto 0);
control(11) <= aw;
control(12) <= bw;
control(13) <= aluop1c; 
control(15 downto 14) <= aluop2c(1 downto 0); 
control(19 downto 16) <= aluop(3 downto 0);
control(20) <= shdatac;
control(22 downto 21) <= shamtc(1 downto 0);
control(23) <= shtypec;
control(26 downto 24) <= pminstr;
control(29 downto 27) <= pmbyte;
control(30) <= fset;
control(31) <= rew;
control(33 downto 32) <= resultc(1 downto 0);

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

entity common is
  Port (
  clk: in std_logic );
end common;

architecture Behavioral of common is
signal controls: std_logic_vector(33 downto 0);
signal instruction: std_logic_vector(31 downto 0);
signal wren,flags: std_logic_vector(3 downto 0);
begin
datapath: entity work.main
    Port map (
        control => controls,
        clk => clk,  
        instr => instruction,
        wren_mem => wren,
        flags => flags
    );

controller: entity work.controller
    Port map (
        clk => clk,
        instruction => instruction,
        flags => flags,
        control => controls
    );

end Behavioral;