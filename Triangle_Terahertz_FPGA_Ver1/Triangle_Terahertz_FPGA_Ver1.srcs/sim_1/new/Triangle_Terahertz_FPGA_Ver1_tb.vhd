-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Triangle_Terahertz_FPGA_Ver1_tb is
end;

architecture bench of Triangle_Terahertz_FPGA_Ver1_tb is

  component Triangle_Terahertz_FPGA_Ver1
      Port ( input_value : in STD_LOGIC_VECTOR (11 downto 0);
             input_clock : in STD_LOGIC;  
             sampling_pulse : in STD_LOGIC;
             sync_pin : in STD_LOGIC;
             output_value : out STD_LOGIC_VECTOR (95 downto 0));
  end component;

  signal input_value: STD_LOGIC_VECTOR (11 downto 0);
  signal input_clock: STD_LOGIC;
  signal sampling_pulse: STD_LOGIC;
  signal sync_pin: STD_LOGIC;
  signal output_value: STD_LOGIC_VECTOR (95 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean :=false;

begin

  uut: Triangle_Terahertz_FPGA_Ver1 port map ( input_value    => input_value,
                                               input_clock    => input_clock,
                                               sampling_pulse => sampling_pulse,
                                               sync_pin       => sync_pin,
                                               output_value   => output_value );

  stimulus: process
  begin
  
    -- Put initialisation code here
input_value<="000000000001";
wait for 10ns;

    -- Put test bench stimulus code here

--    stop_the_clock <= false;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      input_clock <= '0', '1'  after clock_period / 2;
      sampling_pulse<='0','1'  after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  



