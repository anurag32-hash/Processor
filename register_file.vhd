----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2020 11:01:52 PM
-- Design Name: 
-- Module Name: register_file - register_file_behaviour
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_file is
    Port ( clk : in STD_LOGIC;
           reg_in_write_enable : in STD_LOGIC;
           reg_in_write_addr : in STD_LOGIC_VECTOR(4 downto 0);
           reg_in_write_data : in STD_LOGIC_VECTOR(31 downto 0);
           reg_in_read_addr_rs : in STD_LOGIC_VECTOR(4 downto 0);
           reg_in_read_addr_rt : in STD_LOGIC_VECTOR(4 downto 0);
           reg_out_data_rs : out STD_LOGIC_VECTOR(31 downto 0);
           reg_out_data_rt : out STD_LOGIC_VECTOR(31 downto 0));
end register_file;

architecture register_file_behaviour of register_file is
type reg_file_type is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
signal reg_file: reg_file_type := ( 28 => x"0000_0fff",
                                    others => (others => '0'));
begin
    process(clk)
    begin
        if(falling_edge(clk)) then
            if(reg_in_write_enable = '1') then
                if reg_in_write_addr /= x"0000_0000" then
                    reg_file(to_integer(unsigned(reg_in_write_addr))) <= reg_in_write_data;
                end if;
            end if;
        end if;
    end process;
    reg_out_data_rs <= x"0000_0000" when reg_in_read_addr_rs = "0000" else reg_file(to_integer(unsigned(reg_in_read_addr_rs)));
    reg_out_data_rt <= x"0000_0000" when reg_in_read_addr_rt = "0000" else reg_file(to_integer(unsigned(reg_in_read_addr_rt)));

end register_file_behaviour;
