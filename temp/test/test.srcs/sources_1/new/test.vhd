library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity test is
  Port (
  
    clk_in         : in  STD_LOGIC;
      
    -- Add LED signals as outputs
    led_0          : out STD_LOGIC;
    led_1          : out STD_LOGIC;
    led_2          : out STD_LOGIC;
    led_3          : out STD_LOGIC
    );
end test;

architecture Behavioral of test is

        -- Signals for internal logic
    signal internal_led_0 : STD_LOGIC := '1';
    signal internal_led_1 : STD_LOGIC := '1';
    signal internal_led_2 : STD_LOGIC := '1';
    signal internal_led_3 : STD_LOGIC := '1';
    
    
    constant CLOCK_FREQUENCY : integer := 8000000;  -- 50 MHz clock
    constant HALF_SECOND_CYCLES : integer := CLOCK_FREQUENCY / 2;  -- Number of cycles for 500 ms 
    signal led_state : std_logic := '1';  -- Internal signal to hold LED state
    signal counter   : integer := 0;      -- Counter to keep track of clock cycles
    
begin

    process(clk_in)
    begin  
        if rising_edge(clk_in) then
                 
            
                if counter = HALF_SECOND_CYCLES - 1 then
                    counter   <= 0;           -- Reset counter
                    led_state <= not led_state;  -- Toggle LED state
                    
                    
                    
                    internal_led_0 <= not internal_led_0;  -- Toggle LED 0
                    internal_led_1 <= not internal_led_1;  -- Toggle LED 1
                    internal_led_2 <= not internal_led_2;  -- Toggle LED 2
                    internal_led_3 <= not internal_led_3;  -- Toggle LED 3
                
            
                 else
                    counter <= counter + 1;   -- Increment counter
                 end if;
        
        end if;
    end process;
    
    
        led_0 <= internal_led_0;
        led_1 <= internal_led_1;
        led_2 <= internal_led_2;
        led_3 <= internal_led_3; 
        
        
end Behavioral;
