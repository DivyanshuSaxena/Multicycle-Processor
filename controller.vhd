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
--  Port ( );
end controller;

architecture Behavioral of controller is

begin


end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inst_decoder is
    Port (
    instr: in std_logic_vector(9 downto 0);
    instr_type: out std_logic_vector(1 downto 0);
    instr_class: out std_logic_vector(2 downto 0);
    inst_variant: out std_logic );
end inst_decoder;

architecture Behavioral of inst_decoder is

begin

end Behavioral;

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flag_check is
--    Port ();
end flag_check;

architecture Behavioral of flag_check is

begin

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
