----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2020 02:58:08 PM
-- Design Name: 
-- Module Name: display - Behavioral
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

entity display is
    Port (
           clk : in STD_LOGIC;
           input_vector : in STD_LOGIC_VECTOR(16 downto 0);
           output_vector : out STD_LOGIC_VECTOR(6 downto 0)
           );
end display;

architecture display_behaviour of display is
signal hex : STD_LOGIC_VECTOR(3 downto 0);
signal active_counter : STD_LOGIC_VECTOR(1 downto 0);

begin
    process(hex)
        begin
        case hex is
            when x"0" =>
                output_vector <= "0000001";
            when x"1" =>
                output_vector <= "0110000";
            when x"2" =>
                output_vector <= "1101101";
            when x"3" =>
                output_vector <= "1111001";
            when x"4" =>
                output_vector <= "0110011";
            when x"5" =>
                output_vector <= "1011011";
            when x"6" =>
                output_vector <= "1011111";
            when x"7" =>
                output_vector <= "1110000";
            when x"8" =>
                output_vector <= "1111111";
            when x"9" =>
                output_vector <= "1111011";
            when x"a" =>
                output_vector <= "1111101";
            when x"b" =>
                output_vector <= "0011111";
            when x"c" =>
                output_vector <= "1001110";
            when x"d" =>
                output_vector <= "0111101";
            when x"e" =>
                output_vector <= "1101101";
            when x"f" =>
                output_vector <= "1000111";
        end case;
    end process;     
                                        
end display_behaviour;
