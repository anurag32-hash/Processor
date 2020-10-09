----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2020 08:49:48 PM
-- Design Name: 
-- Module Name: alu - alu_behavior
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
use ieee.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    port(
        -- inputs
        alu_in_a, alu_in_b :in std_logic_vector(31 downto 0);
        -- bits for selecting function
        -- 00 add
        -- 01 sub
        -- 10 logical left shift
        -- 11 logical right shift
        alu_func : in std_logic_vector(3 downto 0);
        alu_out : out std_logic_vector(31 downto 0);
        alu_zero : out std_logic
    );
end alu;

architecture alu_behavior of alu is
signal temp_out : std_logic_vector(31 downto 0) := x"0000_0000"; 
begin
    process(alu_in_a, alu_in_b, alu_func)
    begin
        case(alu_func) is
        when("0000") => -- signed addition
            temp_out <= alu_in_a + alu_in_b;
        when("0001") => -- signed subtraction
            temp_out <= alu_in_a - alu_in_b;
        when("0010") =>  -- logical left shift
            temp_out <= std_logic_vector(shift_left(unsigned(alu_in_a), to_integer(unsigned(alu_in_b))));
        when("0011") => -- logical right shift
            temp_out <= std_logic_vector(shift_right(unsigned(alu_in_a), to_integer(unsigned(alu_in_b))));
        when("0100") => -- unsigned addition
            temp_out <= std_logic_vector(unsigned(alu_in_a) + unsigned(alu_in_b));
        when("0101") => --unsigned subtraction
            temp_out <= std_logic_vector(unsigned(alu_in_a) - unsigned(alu_in_b));
        when("0110") => -- equality
            temp_out <= alu_in_a xor alu_in_b;
        when("0111") => -- not equality
            temp_out <= alu_in_a xnor alu_in_b;
        when("1000") => --less than or equal to zero
            if (alu_in_a(31) = '1') or (alu_in_a = x"0000_0000") then
                temp_out <= x"0000_0000";
            else
                temp_out <= x"1111_1111";
            end if;
        when("1001") => --greater than zero
            if (alu_in_a(31) = '0') and (alu_in_a /= x"0000_0000") then
                temp_out <= x"0000_0000";
            else
                temp_out <= x"1111_1111";
            end if;
        when others =>
            temp_out <= alu_in_a + alu_in_b;
        end case;
   end process;
   alu_out <= temp_out;
   alu_zero <= '1' when temp_out = x"0000_0000" else '0';
end alu_behavior;
