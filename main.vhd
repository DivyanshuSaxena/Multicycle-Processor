library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity alu is
  Port (
  operand1: in std_logic_vector(31 downto 0);
  operand2: in std_logic_vector(31 downto 0);
  operation: in std_logic_vector(3 downto 0);
  carry: in std_logic;
  output: out std_logic_vector(31 downto 0);
  flag: out std_logic_vector(3 downto 0) );
end alu;

architecture Behavioral of alu is
signal temp: std_logic_vector(31 downto 0);
signal carry_temp: std_logic;
begin
    temp(31 downto 0) <= operand1(31 downto 0) and operand2(31 downto 0) when (operation(3 downto 0)="0000" or operation(3 downto 0)="1000") else       --and
                         operand1(31 downto 0) xor operand2(31 downto 0) when (operation(3 downto 0)="0001" or operation(3 downto 0)="1001") else       --xor
                         std_logic_vector(signed(operand1(31 downto 0)) + signed(operand2(31 downto 0))) when (operation(3 downto 0)="0100" or operation(3 downto 0)="1011") else         -- add
                         std_logic_vector((signed(operand1(31 downto 0)) + signed(not operand2(31 downto 0))) + 1) when (operation(3 downto 0)="0010" or operation(3 downto 0)="1010") else -- sub
                         std_logic_vector((signed(not operand2(31 downto 0)) + signed(operand1(31 downto 0))) + 1) when operation(3 downto 0)="0011" else --rsb
                         std_logic_vector(signed(operand1(31 downto 0)) + signed(operand2(31 downto 0)) + 1) when (operation(3 downto 0)="0101" and carry='1') else --adc
                         std_logic_vector(signed(operand1(31 downto 0)) + signed(operand2(31 downto 0))) when (operation(3 downto 0)="0101" and carry='0') else --adc
                         std_logic_vector(signed(operand1(31 downto 0)) + signed(not operand2(31 downto 0)) + 1) when (operation(3 downto 0)="0110" and carry='1') else --sbc
                         std_logic_vector(signed(operand1(31 downto 0)) + signed(not operand2(31 downto 0))) when (operation(3 downto 0)="0110" and carry='0') else --sbc
                         std_logic_vector(signed(not operand1(31 downto 0)) + signed(operand2(31 downto 0)) + 1) when (operation(3 downto 0)="0111" and carry='1') else --rsc
                         std_logic_vector(signed(not operand1(31 downto 0)) + signed(operand2(31 downto 0))) when (operation(3 downto 0)="0111" and carry='0') else --rsc
                         operand1(31 downto 0) or operand2(31 downto 0) when operation(3 downto 0)="1100" else      --orr
                         operand2(31 downto 0) when operation(3 downto 0)="1101" else  --mov
                         operand1(31 downto 0) and not operand2(31 downto 0) when operation(3 downto 0)="1110" else     --bic
                         not operand2(31 downto 0);     --mvn
    output(31 downto 0) <= temp(31 downto 0);
    flag(3) <= temp(31);        --N
    flag(2) <= '1' when signed(temp(31 downto 0))=0 else '0';       --Z
    carry_temp <= operand1(31) xor operand2(31) xor temp(31);
    flag(1) <= carry_temp xor ((operand1(31) and operand2(31)) or (operand1(31) and carry_temp) or (carry_temp and operand2(31)));
                                --V
    flag(0) <= (operand1(31) and operand2(31)) or (operand1(31) and carry_temp) or (carry_temp and operand2(31));
                                --C
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift1 is
  Port (
  data: in std_logic_vector(31 downto 0);
  sel: in std_logic;
  shift_type: in std_logic_vector(1 downto 0);
  carry_in: in std_logic;
  output: out std_logic_vector(31 downto 0);
  carry_out: out std_logic );
end shift1;

architecture Behavioral of shift1 is
begin
    output(31 downto 0) <= data(31 downto 0) when sel='0' else
                           data(0) & data(31 downto 1) when (sel='1' and shift_type="00") else
                           data(31) & data(31 downto 1) when (sel='1' and shift_type="01") else
                           '0' & data(31 downto 1);
    carry_out <= carry_in when sel='0' else data(0);

end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift2 is
  Port (
  data: in std_logic_vector(31 downto 0);
  sel: in std_logic;
  shift_type: in std_logic_vector(1 downto 0);
  carry_in: in std_logic;
  output: out std_logic_vector(31 downto 0);
  carry_out: out std_logic );
end shift2;

architecture Behavioral of shift2 is
begin
    output(31 downto 0) <= data(31 downto 0) when sel='0' else
                           data(1 downto 0) & data(31 downto 2) when (sel='1' and shift_type="00") else
                           data(31) & data(31) & data(31 downto 2) when (sel='1' and shift_type="01") else
                           "00" & data(31 downto 2);
    carry_out <= carry_in when sel='0' else data(1);


end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift4 is
  Port (
  data: in std_logic_vector(31 downto 0);
  sel: in std_logic;
  shift_type: in std_logic_vector(1 downto 0);
  carry_in: in std_logic;
  output: out std_logic_vector(31 downto 0);
  carry_out: out std_logic );
end shift4;

architecture Behavioral of shift4 is
begin
    output(31 downto 0) <= data(31 downto 0) when sel='0' else
                           data(3 downto 0) & data(31 downto 4) when (sel='1' and shift_type="00") else
                           data(31)&data(31)&data(31)&data(31) & data(31 downto 4) when (sel='1' and shift_type="01") else
                           "0000" & data(31 downto 4);
    carry_out <= carry_in when sel='0' else data(3);


end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift8 is
  Port (
  data: in std_logic_vector(31 downto 0);
  sel: in std_logic;
  shift_type: in std_logic_vector(1 downto 0);
  carry_in: in std_logic;
  output: out std_logic_vector(31 downto 0);
  carry_out: out std_logic );
end shift8;

architecture Behavioral of shift8 is
begin
    output(31 downto 0) <= data(31 downto 0) when sel='0' else
                           data(7 downto 0) & data(31 downto 8) when (sel='1' and shift_type="00") else
                           data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31) & 
                           data(31 downto 8) when (sel='1' and shift_type="01") else
                           "00000000" & data(31 downto 8);
    carry_out <= carry_in when sel='0' else data(7);

end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift16 is
  Port (
  data: in std_logic_vector(31 downto 0);
  sel: in std_logic;
  shift_type: in std_logic_vector(1 downto 0);
  carry_in: in std_logic;
  output: out std_logic_vector(31 downto 0);
  carry_out: out std_logic );
end shift16;

architecture Behavioral of shift16 is
begin
    output(31 downto 0) <= data(31 downto 0) when sel='0' else
                           data(15 downto 0) & data(31 downto 16) when (sel='1' and shift_type="00") else
                           data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31)&data(31) & 
                           data(31 downto 16) when (sel='1' and shift_type="01") else
                           "0000000000000000" & data(31 downto 16);
    carry_out <= carry_in when sel='0' else data(15);

end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reverse is
  Port (
  input: in std_logic_vector(31 downto 0);
  output: out std_logic_vector(31 downto 0) );
end reverse;

architecture Behavioral of reverse is
begin
iterate: for i in 0 to 31 generate
    output(31-i) <= input(i);
end generate;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter is
  Port (
  data: in std_logic_vector(31 downto 0);
  shift_amount: in std_logic_vector(4 downto 0);
  shift_type: in std_logic_vector(1 downto 0);
  output: out std_logic_vector(31 downto 0);
  shifter_carry: out std_logic );
end shifter;

architecture Behavioral of shifter is
signal datain,data1,data2,data4,data8,data16,reverse,tempout,tempout1: std_logic_vector(31 downto 0);
signal carry1,carry2,carry4,carry8: std_logic;
signal shifttype: std_logic_vector(1 downto 0);
begin
s1: entity work.shift1
    port map(
        data => datain,
        sel => shift_amount(0),
        shift_type => shifttype,
        carry_in => '0',
        output => data1,
        carry_out => carry1);
s2: entity work.shift2
    port map(
        data => data1,
        sel => shift_amount(1),
        shift_type => shifttype,
        carry_in => carry1,
        output => data2,
        carry_out => carry2);
s4: entity work.shift4
    port map(
        data => data2,
        sel => shift_amount(2),
        shift_type => shifttype,
        carry_in => carry2,
        output => data4,
        carry_out => carry4);
s8: entity work.shift8
    port map(
        data => data4,
        sel => shift_amount(3),
        shift_type => shifttype,
        carry_in => carry4,
        output => data8,
        carry_out => carry8);
s16: entity work.shift16
    port map(
        data => data8,
        sel => shift_amount(4),
        shift_type => shifttype,
        carry_in => carry8,
        output => tempout,
        carry_out => shifter_carry);
rev: entity work.reverse
    port map(
        input => data,
        output => reverse);
outrev: entity work.reverse
    port map(
        input => tempout,
        output => tempout1);
        
shifttype(1 downto 0) <= "10" when shift_type="11" else shift_type(1 downto 0);
datain(31 downto 0) <= reverse(31 downto 0) when shift_type="11" else data(31 downto 0);
output(31 downto 0) <= tempout1(31 downto 0) when shift_type="11" else tempout(31 downto 0);

end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier is
  Port (
  operand1: in std_logic_vector(31 downto 0);
  operand2: in std_logic_vector(31 downto 0);
  output: out std_logic_vector(31 downto 0) );
end multiplier;

architecture Behavioral of multiplier is
signal temp: std_logic_vector(63 downto 0);
begin
temp(63 downto 0) <= std_logic_vector(signed(operand1(31 downto 0)) * signed(operand2(31 downto 0)));
output(31 downto 0) <= temp(31 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registr is
  Port (
  clk: in std_logic;
  input: in std_logic_vector(31 downto 0);
  wren: in std_logic;
  output: out std_logic_vector(31 downto 0) );
end registr;

architecture Behavioral of registr is
signal temp: std_logic_vector(31 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if(wren='1' and rising_edge(clk)) then
            temp(31 downto 0) <= input(31 downto 0);
        end if;
    end process;

    output(31 downto 0) <= temp(31 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_file is
  Port (
  write_data: in std_logic_vector(31 downto 0);
  addr1: in std_logic_vector(3 downto 0);
  addr2: in std_logic_vector(3 downto 0);
  write_addr: in std_logic_vector(3 downto 0);
  clock: in std_logic;
  reset: in std_logic;
  wren: in std_logic; 
  output1: out std_logic_vector(31 downto 0);
  output2: out std_logic_vector(31 downto 0);
  pc: out std_logic_vector(31 downto 0) );
end register_file;

architecture Behavioral of register_file is
type arr1 is array(0 to 14) of std_logic_vector(31 downto 0);
type arr2 is array(0 to 15) of std_logic;
signal outputarr: arr1;
signal inputarr: arr2;
signal writepc,pctemp: std_logic_vector(31 downto 0);
begin
registerloop: for i in 0 to 14 generate
    registr: entity work.registr
              port map(
              clk => clock,
              input => write_data,
              wren => inputarr(i),
              output => outputarr(i) );
end generate;

regpc: entity work.registr
    port map(
    clk => clock,
    input => writepc,
    wren => inputarr(15),
    output => pctemp );

iterate: for i in 0 to 14 generate
    inputarr(i) <= '1' when i=conv_integer(write_addr(3 downto 0)) else '0';
end generate;

writepc <= "00000000000000000000000000000000" when reset='1' else write_data;
inputarr(15) <= '1' when (not reset='1' and write_addr(3 downto 0)="1111") else '0';
output1 <= outputarr(conv_integer(addr1(3 downto 0)));
output2 <= outputarr(conv_integer(addr2(3 downto 0)));
pc(31 downto 0) <= pctemp(31 downto 0);

-- process(reset,write_addr)
-- begin
--     if(reset='1') then
--         writepc <= "00000000000000000000000000000000";
--         inputarr(15) <= '1';
--     elsif (write_addr(3 downto 0)="1111") then
--         writepc <= write_data;
--         inputarr(15) <= '1'; 
--     else
--         inputarr(15) <= '0';
--     end if;
-- end process;

end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity extension12 is
  Port (
  input: in std_logic_vector(11 downto 0);
  output: out std_logic_vector(31 downto 0) );
end extension12;

architecture Behavioral of extension12 is
begin
    output(31 downto 0) <= "00000000000000000000" & input(11 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity extension8 is
  Port (
  input: in std_logic_vector(7 downto 0);
  output: out std_logic_vector(31 downto 0) );
end extension8;

architecture Behavioral of extension8 is
begin
    output(31 downto 0) <= "000000000000000000000000" & input(7 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity signext24 is
  Port (
  input: in std_logic_vector(23 downto 0);
  output: out std_logic_vector(31 downto 0) );
end signext24;

architecture Behavioral of signext24 is
begin
    output(31 downto 0) <= input(23)&input(23)&input(23)&input(23)&input(23)&input(23)&input(23)&input(23)&
                           input(23 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity prempath is
  Port (
  from_proc: in std_logic_vector(31 downto 0);
  from_mem: in std_logic_vector(31 downto 0);
  instr_type: in std_logic_vector(2 downto 0);
  offset: in std_logic_vector(2 downto 0);
  to_proc: out std_logic_vector(31 downto 0);
  to_mem: out std_logic_vector(31 downto 0);
  mem_wren: out std_logic_vector(3 downto 0) );
end prempath;

architecture Behavioral of prempath is
begin
    to_proc(31 downto 0) <= from_mem(31 downto 0) when instr_type="000" else        --ldr
                            "000000000000000000000000" & from_mem(7 downto 0) when (instr_type="001" and offset="001") else       --ldrb off0001
                            "000000000000000000000000" & from_mem(15 downto 8) when (instr_type="001" and offset="010") else    -- off0010
                            "000000000000000000000000" & from_mem(23 downto 16) when (instr_type="001" and offset="011") else   -- off0100
                            "000000000000000000000000" & from_mem(31 downto 24) when (instr_type="001" and offset="110") else   -- off1000
                            "0000000000000000" & from_mem(15 downto 0) when (instr_type="011" and offset="100") else      --ldrh -- off0011
                            "0000000000000000" & from_mem(31 downto 16) when (instr_type="011" and offset="101") else           -- off1100
                            from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&
                            from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&
                            from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)& from_mem(7 downto 0) when (instr_type="001" and offset="001") else       --ldrsb   --off0001
                            from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&
                            from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&
                            from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)& from_mem(15 downto 8) when (instr_type="001" and offset="010") else    -- off0010
                            from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&
                            from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&
                            from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)&from_mem(23)& from_mem(23 downto 16) when (instr_type="001" and offset="011") else   -- off0100
                            from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&
                            from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&
                            from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)& from_mem(31 downto 24) when (instr_type="001" and offset="110") else   -- off1000
                            from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&
                            from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)& from_mem(15 downto 0) when (instr_type="100" and offset="100") else    -- off0011
                            from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&
                            from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)&from_mem(31)& from_mem(31 downto 16) when (instr_type="100" and offset="101") else   -- off1100
                            "00000000000000000000000000000000";
                            
    to_mem(31 downto 0) <= from_proc(31 downto 0) when instr_type="101" else
                           from_proc(15 downto 0)&from_proc(15 downto 0) when instr_type="110" else
                           from_proc(7 downto 0)&from_proc(7 downto 0)&from_proc(7 downto 0)&from_proc(7 downto 0);
                           
    mem_wren(3 downto 0) <= "0001" when instr_type="010" else "0011";
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram is
  Port (
  clk: in std_logic;
  addr: in std_logic_vector(31 downto 0);
  din: in std_logic_vector(31 downto 0);
  mr: in std_logic;
  wren: in std_logic_vector(3 downto 0);
  dout: out std_logic_vector(31 downto 0) );
end ram;

architecture Behavioral of ram is
type memory_type is array(0 to 1024) of std_logic_vector(31 downto 0);
signal memory: memory_type  := ("11100011101000000010000000000011", "11100011101000000011000000000111", "11100000100000100001000000000011", "11100101100100100001000000000001", "11100000010000100001000000000011", others => (others => '0'));
begin
    process(clk)
    begin
        if mr='1' then
            dout(31 downto 0) <= memory(conv_integer(addr(3 downto 0)))(31 downto 0);
        elsif not wren="0000" then
            if wren(0)='1' then
                memory(conv_integer(addr(3 downto 0)))(7 downto 0) <= din(7 downto 0);
            else
                memory(conv_integer(addr(3 downto 0)))(7 downto 0) <= "00000000";
            end if;
            if wren(1)='1' then
                memory(conv_integer(addr(3 downto 0)))(15 downto 8) <= din(15 downto 8);
            else
                memory(conv_integer(addr(3 downto 0)))(15 downto 8) <= "00000000";
            end if;
            if wren(2)='1' then
                memory(conv_integer(addr(3 downto 0)))(23 downto 16) <= din(23 downto 16);
            else
                memory(conv_integer(addr(3 downto 0)))(23 downto 16) <= "00000000";
            end if;
            if wren(3)='1' then
                memory(conv_integer(addr(3 downto 0)))(31 downto 24) <= din(31 downto 24);
            else
                memory(conv_integer(addr(3 downto 0)))(31 downto 24) <= "00000000";
            end if;
        end if;
    end process;
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi2plex4 is
  Port (
  input1: in std_logic_vector(3 downto 0);
  input2: in std_logic_vector(3 downto 0);
  selector: in std_logic;
  output: out std_logic_vector(3 downto 0) );
end multi2plex4;

architecture Behavioral of multi2plex4 is
begin
    output(3 downto 0) <= input1(3 downto 0) when selector='0' else input2(3 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi2plex32 is
  Port (
  input1: in std_logic_vector(31 downto 0);
  input2: in std_logic_vector(31 downto 0);
  selector: in std_logic;
  output: out std_logic_vector(31 downto 0) );
end multi2plex32;

architecture Behavioral of multi2plex32 is
begin
    output(31 downto 0) <= input1(31 downto 0) when selector='0' else input2(31 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi2plex2 is
  Port (
  input1: in std_logic_vector(1 downto 0);
  input2: in std_logic_vector(1 downto 0);
  selector: in std_logic;
  output: out std_logic_vector(1 downto 0) );
end multi2plex2;

architecture Behavioral of multi2plex2 is
begin
    output(1 downto 0) <= input1(1 downto 0) when selector='0' else input2(1 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi4plex32 is
  Port (
  input1: in std_logic_vector(31 downto 0);
  input2: in std_logic_vector(31 downto 0);
  input3: in std_logic_vector(31 downto 0);
  input4: in std_logic_vector(31 downto 0);
  selector: in std_logic_vector(1 downto 0);
  output: out std_logic_vector(31 downto 0) );
end multi4plex32;

architecture Behavioral of multi4plex32 is
begin
    output(31 downto 0) <= input1(31 downto 0) when selector="00" else 
                           input2(31 downto 0) when selector="01" else
                           input3(31 downto 0) when selector="10" else
                           input4(31 downto 0);
end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multi4plex5 is
  Port (
  input1: in std_logic_vector(4 downto 0);
  input2: in std_logic_vector(4 downto 0);
  input3: in std_logic_vector(4 downto 0);
  input4: in std_logic_vector(4 downto 0);
  selector: in std_logic_vector(1 downto 0);
  output: out std_logic_vector(4 downto 0) );
end multi4plex5;

architecture Behavioral of multi4plex5 is
begin
    output(4 downto 0) <= input1(4 downto 0) when selector="00" else 
                           input2(4 downto 0) when selector="01" else
                           input3(4 downto 0) when selector="10" else
                           input4(4 downto 0);
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
  Port (
--   pw: in std_logic;
--   iord: in std_logic;
--   iw: in std_logic;
--   dw: in std_logic;
--   rsrc1: in std_logic;
--   rsrc2: in std_logic;
--   rsrc3: in std_logic;
--   rfwren: in std_logic;
--   asrc: in std_logic;
--   bsrc: in std_logic_vector(1 downto 0);
--   aw: in std_logic;
--   bw: in std_logic;
--   aluop1c: in std_logic; 
--   aluop2c: in std_logic_vector(1 downto 0); 
--   aluop: in std_logic_vector(3 downto 0);
--   shdatac: in std_logic;
--   shamtc: in std_logic_vector(1 downto 0);
--   shtypec: in std_logic;
--   pminstr: in std_logic_vector(2 downto 0);
--   pmbyte: in std_logic_vector(2 downto 0);
--   fset: in std_logic;
--   rew: in std_logic;
--   resultc: in std_logic_vector(1 downto 0);
  control: in std_logic_vector(36 downto 0);
  clk: in std_logic;
  instr: out std_logic_vector(31 downto 0);
  wren_mem: out std_logic_vector(3 downto 0);
  flags: out std_logic_vector(3 downto 0) );
end main;

architecture Behavioral of main is
-- Control Signals
signal pw,iord,iw,dw,rsrc1,rsrc2,rsrc3,rsrc4,rfwren,asrc,shdatac,shtypec,fset,aw,bw,aluop1c,rew,mr: std_logic;
signal bsrc,aluop2c,shamtc,resultc: std_logic_vector(1 downto 0);
signal aluop: std_logic_vector(3 downto 0);
signal pminstr,pmbyte: std_logic_vector(2 downto 0);
-- ALU
signal aluop1, aluop2, aluout: std_logic_vector(31 downto 0);
signal alucarry: std_logic;
-- Shifter
signal shdata,shout: std_logic_vector(31 downto 0);
signal shamt: std_logic_vector(4 downto 0);
signal shtype: std_logic_vector(1 downto 0);
signal scar: std_logic;
-- Multiplier
signal multop1,multop2,multout: std_logic_vector(31 downto 0);
-- P-M Path
signal tom,from,top: std_logic_vector(31 downto 0);
-- Register File
signal rad1,rad2,wad,wrad: std_logic_vector(3 downto 0);
signal rd1,rd2,wd,rfpc: std_logic_vector(31 downto 0);
signal rf_reset: std_logic;
-- Memory
signal mad,mout: std_logic_vector(31 downto 0);
-- Registers
signal instruction,aout,bout,result,resout,pcout: std_logic_vector(31 downto 0);
-- Multiplexers
signal data1,data2: std_logic_vector(31 downto 0);
-- Extension and sign ext
signal ext8out,ext12out,signextout: std_logic_vector(31 downto 0);
signal memwren: std_logic_vector(3 downto 0);
signal ext4: std_logic_vector(4 downto 0);
-- Temporary Signal
signal instr_temp: std_logic_vector(31 downto 0);
begin
alu: entity work.alu
    Port map (
    operand1 => aluop1,
    operand2 => aluop2,
    operation => aluop,
    carry => alucarry,
    output => aluout,
    flag => flags);

multi: entity work.multiplier
    Port map (
    operand1 => data2,
    operand2 => data1,
    output => multout);
    
shifter: entity work.shifter
    Port map (
    data => shdata,
    shift_amount => shamt,
    shift_type => shtype,
    output => shout,
    shifter_carry => scar);
    
rf: entity work.register_file
    Port map (
    write_data => resout,
    addr1 => rad1,
    addr2 => rad2,
    write_addr => wrad,
    clock => clk,
    reset => rf_reset,
    wren => rfwren,
    output1 => rd1,
    output2 => rd2,
    pc => rfpc);
    
procmem: entity work.prempath
    Port map (
    from_proc => data2,
    from_mem => from,
    instr_type => pminstr,
    offset => pmbyte,
    to_proc => top,
    to_mem => tom,
    mem_wren => memwren);
    
pc: entity work.registr
    Port map (
    input => rfpc,
    clk => clk,
    wren => pw,
    output => pcout);
    
ir: entity work.registr
    Port map (
    input => mout,
    clk => clk,
    wren => iw,
    output => instruction);

dr: entity work.registr
    Port map (
    input => mout,
    clk => clk,
    wren => dw,
    output => from);
    
ar: entity work.registr
    Port map (
    input => rd1,
    clk => clk,
    wren => aw,
    output => aout);
    
br: entity work.registr
    Port map (
    input => rd2,
    clk => clk,
    wren => bw,
    output => bout);
    
res: entity work.registr
    Port map (
    input => result,
    clk => clk,
    wren => rew,
    output => resout);
    
memad: entity work.multi2plex32
    Port map (
    input1 => pcout,
    input2 => resout,
    selector => iord,
    output => mad);
        
rfrad1: entity work.multi2plex4
    Port map (
    input1 => instruction(11 downto 8),
    input2 => instruction(19 downto 16),
    selector => rsrc1,
    output => rad1);
    
rfrad2: entity work.multi2plex4
    Port map (
    input1 => instruction(15 downto 12),
    input2 => instruction(3 downto 0),
    selector => rsrc2,
    output => rad2);
    
rfrad3: entity work.multi2plex4
    Port map (
    input1 => instruction(19 downto 16),
    input2 => instruction(15 downto 12),
    selector => rsrc3,
    output => wad);

rfrad4: entity work.multi2plex4
    Port map (
    input1 => wad,
    input2 => "1111",
    selector => rsrc4,
    output => wrad);
    
rfrd1: entity work.multi2plex32
    Port map (
    input1 => pcout,
    input2 => aout,
    selector => asrc,
    output => data1);
    
rfrd2: entity work.multi4plex32
    Port map (
    input1 => bout,
    input2 => "00000000000000000000000000000001",
    input3 => ext12out,
    input4 => signextout,
    selector => bsrc,
    output => data2);
    
ext12: entity work.extension12
    Port map (
    input => instruction(11 downto 0),
    output => ext12out);
    
signext: entity work.signext24
    Port map (
    input => instruction(23 downto 0),
    output => signextout);
    
ext8: entity work.extension8
    Port map (
    input => instruction(7 downto 0),
    output => ext8out);
    
alumux1: entity work.multi2plex32
    Port map (
    input1 => data1,
    input2 => resout,
    selector => aluop1c,
    output => aluop1);
    
alumux2: entity work.multi4plex32
    Port map (
    input1 => data1,
    input2 => resout,
    input3 => data2,
    input4 => "00000000000000000000000000000000",
    selector => aluop2c,
    output => aluop2);

shiftdata: entity work.multi2plex32
    Port map (
    input1 => data2,
    input2 => ext8out,
    selector => shdatac,
    output => shdata);
    
shiftamt: entity work.multi4plex5
    Port map (
    input1 => instruction(11 downto 7),
    input2 => ext4,
    input3 => data1(4 downto 0),
    input4 => "00000",
    selector => shamtc,
    output => shamt);
    
shifttype: entity work.multi2plex2
    Port map (
    input1 => instruction(6 downto 5),
    input2 => "01",
    selector => shtypec,
    output => shtype);
    
resselect: entity work.multi4plex32
    Port map (
    input1 => multout,
    input2 => aluout,
    input3 => top,
    input4 => shout,
    selector => resultc,
    output => result);
    
ram: entity work.ram
    Port map (
    addr => mad,
    clk => clk,
    din => tom,
    dout => mout,
    mr => mr,
    wren => memwren);

-- bram: entity work.bram_wrapper
--     Port map (
--     bram_porta_addr => mad,
--     bram_porta_clk => clk,
--     bram_porta_din => tom,
--     bram_porta_dout => mout,
--     bram_porta_en => '1',
--     bram_porta_rst => '0',
--     bram_porta_we => memwren);
    
ext4 <= instruction(11 downto 8) & '0';
wren_mem(3 downto 0) <= memwren(3 downto 0);
instr <= instruction;

-- Control Signals

pw <= control(0);
iord <= control(1);
iw <= control(2);
dw <= control(3);
rsrc1 <= control(4);
rsrc2 <= control(5) ;
rsrc3 <= control(6) ;
rfwren <= control(7) ;
asrc <= control(8) ;
bsrc(1 downto 0) <=control(10 downto 9);
aw <=control(11);
bw <=control(12);
aluop1c <=control(13) ; 
aluop2c(1 downto 0)  <= control(15 downto 14) ; 
aluop(3 downto 0) <= control(19 downto 16);
shdatac <= control(20) ;
shamtc(1 downto 0) <= control(22 downto 21) ;
shtypec <= control(23) ;
pminstr <= control(26 downto 24) ;
pmbyte <= control(29 downto 27);
fset <= control(30) ;
rew <= control(31);
resultc(1 downto 0) <= control(33 downto 32) ;
rsrc4 <= control(34);
mr <= control(35);
rf_reset <= control(36);
--instruction(31 downto 0) <= "11100010100000000001000000011100";

end Behavioral;
----------------------------------------------------------------------------------