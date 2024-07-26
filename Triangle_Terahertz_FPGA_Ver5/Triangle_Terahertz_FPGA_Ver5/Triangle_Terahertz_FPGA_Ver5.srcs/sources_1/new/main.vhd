library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC;
           reset : in STD_LOGIC;
           clk_out_temp : out INTEGER;
           clk_mid_sig : out STD_LOGIC  -- New port to expose mid_sig
         );
end main;

architecture Behavioral of main is

    signal m : integer range 0 to 100000000;
    signal mid_sig : STD_LOGIC := '0';

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out          : out    std_logic;
  clk_in           : in     std_logic
 );
end component;

begin

your_instance_name : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out => clk_out,
   -- Clock in ports
   clk_in => clk_in
 );

    clk_out_temp <= m;
    clk_mid_sig <= mid_sig;  -- Assign mid_sig to the new port

    process(mid_sig)
    begin
        if rising_edge(mid_sig) then
            if reset = '1' then
                m <= 0;
            else
                m <= m + 1;
            end if;
        end if;
    end process;

end Behavioral;
