----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2020 01:41:13 AM
-- Design Name: 
-- Module Name: processor - processor_behaviour
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

entity processor is
    port (
        output_switch : in STD_LOGIC := '0';
        clk : in STD_LOGIC;
        led_out : out STD_LOGIC_VECTOR(6 downto 0);
        anode_signals : out STD_LOGIC_VECTOR(3 downto 0)
    );
end processor;

architecture processor_behaviour of processor is
--signal clk : STD_LOGIC;
signal program_counter : STD_LOGIC_VECTOR(31 downto 0) := x"0000_0000";
signal link_pc : STD_LOGIC_VECTOR(31 downto 0) := x"0000_0000";
signal instruction : STD_LOGIC_VECTOR(31 downto 0);

signal mem_en_a : STD_LOGIC := '0';
signal mem_en_b : STD_LOGIC := '0';

signal alu_func : STD_LOGIC_VECTOR(3 downto 0) := "0000";
signal alu_out : STD_LOGIC_VECTOR(31 downto 0) := x"0000_0000";
signal alu_in_a, alu_in_b : STD_LOGIC_VECTOR(31 downto 0) := x"0000_0000";

signal mem_read, reg_write, load, read_offset, shift : STD_LOGIC := '0';
signal jump, branch, jal, jr : STD_LOGIC := '0';
signal mem_write : STD_LOGIC := '0';
signal opcode, func : STD_LOGIC_VECTOR(5 downto 0) := "000000";
signal offset : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal shamt : STD_LOGIC_VECTOR(4 downto 0):= "00000";
signal jump_offset : STD_LOGIC_VECTOR(25 downto 0) := (others => '0');
signal reg_addr_rs, reg_addr_rt : STD_LOGIC_VECTOR(4 downto 0) := "00000";
signal reg_read_data_rs, reg_read_data_rt : STD_LOGIC_VECTOR(31 downto 0):=x"0000_0000";
signal reg_addr_rd : STD_LOGIC_VECTOR(4 downto 0):="00000";
signal reg_write_addr : STD_LOGIC_VECTOR(4 downto 0):="00000";
signal reg_write_data : STD_LOGIC_VECTOR(31 downto 0):=x"0000_0000";

signal mem_out_data : STD_LOGIC_VECTOR(31 downto 0):=x"0000_0000";
--signal wait_cycle: STD_LOGIC_VECTOR(1 downto 0) := "00";
signal nclk : STD_LOGIC := '0';
signal first: STD_LOGIC := '1';
signal halt : STD_LOGIC := '0';
signal multi_cycle : STD_LOGIC := '0';
signal cycle_count : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal output : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
signal alu_zero : STD_LOGIC := '0';
signal pc_out : STD_LOGIC_VECTOR(31 downto 0) := x"0000_0000";
    COMPONENT blk_mem_gen_0
      PORT (
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        ena : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        clkb : IN STD_LOGIC;
        enb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
    END COMPONENT;
begin
   
    process(clk)
    begin
        if(rising_edge(clk)) then
            if first='1' then
                first <= '0';
            elsif instruction = x"0000_0000" then
                if halt = '0' then
                    if opcode="101011" then
                        output <= reg_read_data_rt(15 downto 0);
                    else
                        output <= reg_write_data(15 downto 0);
                    end if;
                    halt <= '1';
                else
                    output <= output;
                end if;
        end if;
        end if;
    end process;
    process(nclk)
    begin
        if rising_edge(nclk) then
            if (not (halt = '1')) then
                cycle_count <= STD_LOGIC_VECTOR(unsigned(cycle_count) +1);
            end if;
        end if;
    end process;


pc : entity work.program_counter
    port map (
        clk => clk,
        halt => halt,
--        multi_cycle => multi_cycle,
        jump => jump,
        jr => jr,
        jump_addr => reg_read_data_rs,
        branch => branch,
        alu_branch => alu_zero,
        instruction => instruction,
        pc_in => program_counter,
        pc_out => program_counter,
        first => first,
        link_pc => link_pc
    );

nclk <= not clk;
memory : blk_mem_gen_0
      PORT MAP (
        clka => clk,
        wea(0) => mem_write,
        ena => '1',
--        ena => mem_en_a,
        addra => alu_out(11 downto 0),
        dina => reg_read_data_rt,
        douta => mem_out_data,
        clkb => nclk,
        web => "0",
        enb => '1',
--        enb => mem_en_b,
        addrb => program_counter(11 downto 0),
        dinb => x"0000_0000",
        doutb => instruction
      );

--reg_read_addr_rt <= instruction(20 downto 16);
reg_write_addr <= reg_addr_rt  when read_offset = '1' else
                  "11111" when jal = '1'         else
                  reg_addr_rd;
reg_write_data <= mem_out_data       when load = '1' else
                  link_pc +1 when jal = '1'  else 
                  alu_out;

register_file: entity work.register_file
    port map (
        clk => clk,
        reg_in_write_enable => reg_write,
        reg_in_write_addr => reg_write_addr,
        reg_in_write_data => reg_write_data,
        reg_in_read_addr_rs => reg_addr_rs,
        reg_in_read_addr_rt => reg_addr_rt,
        reg_out_data_rs => reg_read_data_rs,
        reg_out_data_rt => reg_read_data_rt
    );


alu_in_a <= reg_read_data_rt when shift = '1' else 
            reg_read_data_rs;
alu_in_b <= (31 downto 16 => '0') & offset when read_offset = '1' else 
            (31 downto 5 => '0')  & shamt  when shift = '1'       else 
            reg_read_data_rt;

alu: entity work.alu
    port map (
        alu_in_a => alu_in_a,
        alu_in_b => alu_in_b,
        alu_func => alu_func,
        alu_out => alu_out,
        alu_zero => alu_zero
    );

opcode <= instruction(31 downto 26);
func <= instruction(5 downto 0);
control: entity work.control
    port map (
        clk => clk,
        halt => halt,
        opcode => opcode,
        func => func,
        instruction => instruction,
        alu_func => alu_func,
        mem_read => mem_read,
        mem_write => mem_write,
        reg_write => reg_write,
        load => load,
        read_offset => read_offset,
        shift => shift,
        offset => offset,
        shamt => shamt,
        rt => reg_addr_rt,
        rs => reg_addr_rs,
        rd => reg_addr_rd,
        jump => jump,
        jal => jal,
        jr => jr,
        branch => branch,
        multi_cycle => multi_cycle
    );
    

display: entity work.display
    port map (
        halt => halt,
        clk => clk,
        led_out => led_out,
        cycle_count => cycle_count,
        output => output,
        output_switch => output_switch,
        anode_signals => anode_signals
        );
end processor_behaviour;
