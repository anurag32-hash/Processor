----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2020 09:21:28 PM
-- Design Name: 
-- Module Name: program_counter - Behavioral
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

entity program_counter is
    Port ( clk         : in  STD_LOGIC;
           halt        : in  STD_LOGIC;
           jump        : in  STD_LOGIC;
           branch      : in  STD_LOGIC;
           first       : in  STD_LOGIC;
           jr          : in  STD_LOGIC;
           alu_branch  : in  STD_LOGIC;
           jump_addr   : in  STD_LOGIC_VECTOR(31 downto 0);
           instruction : in  STD_LOGIC_VECTOR(31 downto 0);
           pc_in       : in  STD_LOGIC_VECTOR(31 downto 0);
           pc_out      : out STD_LOGIC_VECTOR(31 downto 0);
           link_pc     : out STD_LOGIC_VECTOR(31 downto 0));
end program_counter;

architecture Behavioral of program_counter is
    signal latch_instr : STD_LOGIC_VECTOR(31 downto 0)      := x"0000_0000";
    signal branch_offset : STD_LOGIC_VECTOR(31 downto 0)    := x"0000_0000";
    signal jump_offset : STD_LOGIC_VECTOR(31 downto 0)      := x"0000_0000";
    signal opcode : STD_LOGIC_VECTOR(5 downto 0)            :=     "000000";
    signal temp_pc_in : STD_LOGIC_VECTOR(31 downto 0)       := x"0000_0000";
    signal next_pc : STD_LOGIC_VECTOR(31 downto 0)          := x"0000_0000";
    signal temp_pc_out : STD_LOGIC_VECTOR(31 downto 0)      := x"0000_0000";
    signal temp_add : STD_LOGIC_VECTOR(31 downto 0)         := x"0000_0000";
    signal multi_cycle :STD_LOGIC                           :=          '0';
begin
    opcode <= instruction(31 downto 26);
--    jump_offset <= "000000" & instruction(25 downto 0);
--    branch_offset(31 downto 16) <= (others => instruction(15));
--    branch_offset(15 downto 0) <= instruction(15 downto 0);

--    opcode <= latch_instr(31 downto 26);
--    jump_offset <= "000000" & latch_instr(25 downto 0);
--    branch_offset(31 downto 16) <= (others => latch_instr(15));
--    branch_offset(15 downto 0) <= latch_instr(15 downto 0);
    process(clk)
    begin       
        if rising_edge(clk) then
            jump_offset <= "000000" & instruction(25 downto 0);
            branch_offset(31 downto 16) <= (others => instruction(15));
            branch_offset(15 downto 0) <= instruction(15 downto 0);

            temp_pc_in <= pc_in;
--            latch_instr <= instruction;
            if multi_cycle ='0' and (opcode="100011" or opcode="101011") then
                multi_cycle <= '1';
            elsif multi_cycle = '1' then
                multi_cycle <= '0';
            end if;
        end if;
    end process;
--    process(clk)
--    begin
--        if falling_edge(clk) then
--        if halt='0' and first='0' then
--            if branch = '1' then
--                temp_pc_out<= std_logic_vector(signed(branch_offset)+signed(temp_pc_in+1));
--            elsif multi_cycle='0' then
--                temp_pc_out <= temp_pc_in +1;
--            else
--               temp_pc_out <= temp_pc_in;
--            end if;
--        end if; end if;
--    end process;
--    pc_out<=temp_pc_out;
    pc_out <= std_logic_vector(signed(branch_offset)+signed(temp_pc_in+1)) 
                            when (halt='0' and first='0' and branch='1' and alu_branch='1') else
              jump_offset   when (halt='0' and first='0' and jump='1'   )                   else
              jump_addr     when (halt='0' and first='0' and jr='1'     )                   else
              temp_pc_in +1 when (halt='0' and first='0' and multi_cycle='0')               else
              temp_pc_in;

    link_pc <= temp_pc_in;
--    process(clk)
--    begin
--        if (halt='0') and (first='0') then
--            if (multi_cycle='0') then -- and first='0' then
--                if (instruction(31 downto 26)="100011") or (instruction(31 downto 26)="101011") then
--                    multi_cycle <= '1';
--                else
--                    if (branch='1') then
--                        temp_add(15 downto 0) <= instruction(15 downto 0);
--                        temp_add(31 downto 16) <= (others => instruction(15));
--                        temp_pc <= std_logic_vector(signed(std_logic_vector(unsigned(temp_pc_in) + 1)) + signed(temp_add));
--                    elsif (jump='1') then
--                        temp_pc(25 downto 0) <= instruction(25 downto 0);
--                        temp_pc(31 downto 26) <= (others => '0');
--                    else
--                        temp_pc <= std_logic_vector(unsigned(temp_pc_in) + 1);
--                    end if;
--                end if;
--            else
--                multi_cycle <= '0';
--                temp_pc <= std_logic_vector(unsigned(temp_pc_in) + 1);
--            end if;
--        else
--            temp_pc <= temp_pc_in;
--        end if;
--        pc_out <= temp_pc;
--    end process;
end Behavioral;