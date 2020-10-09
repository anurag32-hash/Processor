----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2020 12:20:51 AM
-- Design Name: 
-- Module Name: control - control_behaviour
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

entity control is
    Port ( 
           clk : in STD_LOGIC;
           halt : in STD_LOGIC;
           opcode : in STD_LOGIC_VECTOR(5 downto 0);
           func : in STD_LOGIC_VECTOR(5 downto 0);
           instruction : in STD_LOGIC_VECTOR(31 downto 0);
           multi_cycle : out STD_LOGIC;
           reg_write, mem_write, mem_read, load, read_offset, shift : out STD_LOGIC;
           jump, branch, jal, jr : out STD_LOGIC;
           alu_func : out STD_LOGIC_VECTOR(3 downto 0);
           offset : out STD_LOGIC_VECTOR(15 downto 0);
           shamt : out STD_LOGIC_VECTOR(4 downto 0);
           rt : out STD_LOGIC_VECTOR(4 downto 0);
           rd : out STD_LOGIC_VECTOR(4 downto 0);
           rs : out STD_LOGIC_VECTOR(4 downto 0)

--           multi_cycle : out STD_LOGIC
         );
end control;

architecture control_behaviour of control is
signal temp_mc : STD_LOGIC := '0';
signal temp_rw, temp_mw, temp_mr, temp_l, temp_ro, temp_s: STD_LOGIC := '0';
signal temp_j, temp_b, temp_jal, temp_jr : STD_LOGIC := '0';
signal temp_offset : STD_LOGIC_VECTOR(15 downto 0) := x"1111";
signal temp_af : STD_LOGIC_VECTOR(3 downto 0):= "0000";
signal temp_shamt : STD_LOGIC_VECTOR(4 downto 0) := "11111";
signal temp_rs : STD_LOGIC_VECTOR(4 downto 0) := "11111";
signal temp_rt : STD_LOGIC_VECTOR(4 downto 0) := "11111";
signal temp_rd : STD_LOGIC_VECTOR(4 downto 0) := "11111";

begin
    process(clk)
    begin
    if rising_edge(clk) then
        if(halt = '1') then
            temp_rw <= '0';
            temp_l  <= '0';
            temp_mw <= '0';
            temp_mr <= '0';
            temp_ro <= '0';
            temp_s  <= '0';
            temp_j  <= '0';
            temp_b  <= '0';
            temp_mc <= '0';
            temp_jal <= '0';
            temp_jr <= '0';
            temp_af <= "0000";
            temp_offset <= x"0000";
            temp_shamt <= "00000"; 
            temp_rt <= "00000";
            temp_rs <= "00000";
            temp_rd <= "00000";

        else
            temp_rs     <= instruction(25 downto 21);
            temp_rt     <= instruction(20 downto 16);
            temp_rd     <= instruction(15 downto 11);
            temp_offset <= instruction(15 downto 0);
            temp_shamt  <= instruction(10 downto 6);
            case opcode is
            when "000000" => -- logical and arithematic operations
                temp_rw <= '1';
                temp_l  <= '0';
                temp_mw <= '0';
                temp_mr <= '0';
                temp_ro <= '0';
                temp_s  <= '0';
                temp_j  <= '0';
                temp_b  <= '0';
                temp_mc <= '0';
                temp_jal <= '0';
                temp_jr <= '0';
                if(func = "100000")    then -- add
                    temp_af <= "0000";
                elsif(func = "100010") then -- sub
                    temp_af <= "0001";
                elsif(func = "000000") then -- sll
                    temp_af <= "0010";
                    temp_s  <= '1';
                elsif(func = "000010") then -- srl
                    temp_af <= "0011";
                    temp_s  <= '1';
                elsif(func = "100001") then -- addu
                    temp_af <= "0100";
                elsif(func = "100011") then -- subu
                    temp_af <= "0101";
                elsif(func = "001000") then -- jr
                    temp_af <= "0000";
                    temp_jr <= '1';
                else -- default add
                    temp_rw <= '0';
                    temp_af <= "0000";
                end if;
            when "000100" =>                --beq
                temp_rw <= '0';
                temp_l  <= '0';
                temp_mw <= '0';
                temp_mr <= '0';
                temp_ro <= '0';
                temp_s  <= '0';
                temp_j  <= '0';
                temp_b  <= '1';
                temp_mc <= '0';
                temp_jal <= '0';
                temp_jr <= '0';
                temp_af <= "0110";
            when "000101" =>                --bne
                temp_rw <= '0';
                temp_l  <= '0';
                temp_mw <= '0';
                temp_mr <= '0';
                temp_ro <= '0';
                temp_s  <= '0';
                temp_j  <= '0';
                temp_b  <= '1';
                temp_mc <= '0';
                temp_jal <= '0';
                temp_jr <= '0';
                temp_af <= "0111";
            when "000110" =>                --blez
                temp_rw <= '0';
                temp_l  <= '0';
                temp_mw <= '0';
                temp_mr <= '0';
                temp_ro <= '0';
                temp_s  <= '0';
                temp_j  <= '0';
                temp_b  <= '1';
                temp_mc <= '0';
                temp_jal <= '0';
                temp_jr <= '0';
                temp_af <= "1000";
            when "000111" =>                --bgtz
                temp_rw <= '0';
                temp_l  <= '0';
                temp_mw <= '0';
                temp_mr <= '0';
                temp_ro <= '0';
                temp_s  <= '0';
                temp_j  <= '0';
                temp_b  <= '1';
                temp_mc <= '0';
                temp_jal <= '0';
                temp_jr <= '0';
                temp_af <= "1001";
            when "000010" =>                --j
                temp_rw <= '0';
                temp_l  <= '0';
                temp_mw <= '0';
                temp_mr <= '0';
                temp_ro <= '0';
                temp_s  <= '0';
                temp_j  <= '1';
                temp_b  <= '0';
                temp_mc <= '0';
                temp_jal <= '0';
                temp_jr <= '0';
                temp_af <= "1010";
            when "000011" =>                --jal
                temp_rw <= '1';
                temp_l  <= '0';
                temp_mw <= '0';
                temp_mr <= '0';
                temp_ro <= '0';
                temp_s  <= '0';
                temp_j  <= '1';
                temp_b  <= '0';
                temp_mc <= '0';
                temp_jal <= '1';
                temp_jr <= '0';
                temp_af <= "1011";
            when "100011" =>              -- lw
                temp_rw <= '1';
                temp_l  <= '1';
                temp_mw <= '0';
                temp_mr <= '1';
                temp_ro <= '1';
                temp_s  <= '0';
                temp_j  <= '0';
                temp_b  <= '0';
                temp_mc <= not(temp_mc);
                temp_jal <= '0';
                temp_jr <= '0';
                temp_af <= "0000";
            when "101011" =>               -- sw
                temp_rw <= '0';
                temp_l <= '0';
                temp_mw <= '1';
                temp_mr <= '0';
                temp_ro <= '1';
                temp_s <= '0';
                temp_j  <= '0';
                temp_b  <= '0';
                temp_jal <= '0';
                temp_jr <= '0';
                temp_mc <= not(temp_mc);
                temp_af <= "0000";
            when others => -- default add
                temp_rw <= '0';
                temp_l <= '0';
                temp_mw <= '0';
                temp_mr <= '0';
                temp_s <= '0';
                temp_ro <= '0';
                temp_j  <= '0';
                temp_b  <= '0';
                temp_mc <= '0';
                temp_jal <= '0';
                temp_jr <= '0';
                temp_af <= "0000";
            end case;
        end if;
    end if;
    end process;
    reg_write <= temp_rw;
    mem_write <= temp_mw;
    mem_read <= temp_mr;
    load <= temp_l;
    read_offset <= temp_ro;
    shift <= temp_s;
    alu_func <= temp_af;
    shamt <= temp_shamt;
    offset <= temp_offset;
    jump <= temp_j;
    jal <= temp_jal;
    jr <= temp_jr;
    branch <= temp_b;
    rs <= temp_rs;
    rt <= temp_rt;
    rd <= temp_rd;
    multi_cycle <= temp_mc;
end control_behaviour;
