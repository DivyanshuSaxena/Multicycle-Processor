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
  instr: in std_logic_vector(31 downto 0) );
end main;

architecture Behavioral of main is

begin

end Behavioral;

----------------------------------------------------------------------------------

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
begin
output(31 downto 0) <= std_logic_vector(signed(operand1(31 downto 0)) * signed(operand2(31 downto 0)));
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
begin
    process(clk)
    begin
        if(wren='1') then
            output(31 downto 0) <= input(31 downto 0);
        end if;
    end process;
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
  pc: out std_logic );
end register_file;

architecture Behavioral of register_file is
type arr1 is array(0 to 15) of std_logic_vector(31 downto 0);
type arr2 is array(0 to 15) of std_logic;
signal outputarr: arr1;
signal inputarr: arr2;
signal writepc: std_logic_vector(31 downto 0);
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
    output => outputarr(15) );

iterate: for i in 0 to 14 generate
    inputarr(i) <= '1' when i=conv_integer(write_addr(3 downto 0)) else '0';
end generate;

output1 <= outputarr(conv_integer(addr1(3 downto 0)));
output2 <= outputarr(conv_integer(addr2(3 downto 0)));

process(reset,write_addr)
begin
    if(reset='1') then
        writepc <= "00000000000000000000000000000000";
        inputarr(15) <= '1';
    elsif (write_addr(3 downto 0)="1111") then
        writepc <= write_data;
        inputarr(15) <= '1'; 
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

entity prempath is
  Port (
  from_proc: in std_logic_vector(31 downto 0);
  from_mem: in std_logic_vector(31 downto 0);
  instr_type: in std_logic_vector(3 downto 0);
  offset: in std_logic_vector(11 downto 0);
  to_proc: out std_logic_vector(31 downto 0);
  to_mem: out std_logic_vector(31 downto 0);
  mem_wren: out std_logic );
end prempath;

architecture Behavioral of prempath is
begin
    to_proc(31 downto 0) <= from_mem(31 downto 0) when instr_type="0000" else        --ldr
                            "000000000000000000000000" & from_mem(7 downto 0) when instr_type="0001" else       --ldrb
                            "0000000000000000" & from_mem(15 downto 0) when instr_type="0010" else      --ldrh
                            from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&
                            from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&
                            from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)&from_mem(7)& from_mem(7 downto 0) when instr_type="0011" else       --ldrsb
                            from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&
                            from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)&from_mem(15)& from_mem(15 downto 0) when instr_type="0100" else
                            "00000000000000000000000000000000";
end Behavioral;
