----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2023 02:23:33 PM
-- Design Name: 
-- Module Name: Triangle_Terahertz_FPGA_Ver1 - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Triangle_Terahertz_FPGA_Ver1 is
    Port ( input_value : in STD_LOGIC_VECTOR (11 downto 0);
           input_clock : in STD_LOGIC;  
           sampling_pulse : in STD_LOGIC;   --- for sampling from inputs
           sync_pin : in STD_LOGIC;
           output_value : out STD_LOGIC_VECTOR (95 downto 0));
end Triangle_Terahertz_FPGA_Ver1;

architecture Behavioral of Triangle_Terahertz_FPGA_Ver1 is

signal P: STD_LOGIC_VECTOR(39 downto 0)      := (others => '0');
signal S: STD_LOGIC_VECTOR(45 downto 0)      := (others => '0');
signal S_Multiplied: STD_LOGIC_VECTOR(55 downto 0)      := (others => '0');
constant Multiplied : integer := 10#1000#;  --  You can specify a base for integers by using the format base#value#:
signal index: STD_LOGIC_VECTOR (9 downto 0)  := (others => '0');
signal result: STD_LOGIC_VECTOR (95 DOWNTO 0)  := (others => '0');

signal s_axis_divisor_tvalid: STD_LOGIC;
signal s_axis_dividend_tvalid: STD_LOGIC;
signal m_axis_dout_tvalid: STD_LOGIC;
signal m_axis_dout_tuser: STD_LOGIC_VECTOR(0 DOWNTO 0);

--type Voltage_Level is range -5.5 to +5.5;

COMPONENT div_gen_1
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(55 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(95 DOWNTO 0)
  );
END COMPONENT;

begin

    
    
your_instance_name : div_gen_1
  PORT MAP (
    aclk => input_clock,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => P,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => S_Multiplied,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tuser => m_axis_dout_tuser,
    m_axis_dout_tdata => result
  );

process(input_clock)
begin

  if rising_edge(sampling_pulse) then
  
   if(index < 1024) then
   
        S<= (input_value * input_value * index + S);
        P<= (input_value * input_value+P);

        index<= index + 1 ;

    else 
       
        S_Multiplied <= S*std_logic_vector(to_unsigned(Multiplied,10#10#));
        output_value <= result;
        
    end if;
              
  end if;
  
end process;
     
end Behavioral;
