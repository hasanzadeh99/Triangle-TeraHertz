library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simulation is
end simulation;

architecture Behavioral of simulation is

COMPONENT ComputeModule
    PORT (
    clk_in         : in  STD_LOGIC;
    reset          : in  STD_LOGIC;
    pulse          : in  STD_LOGIC;
    calculate_pulse: in  STD_LOGIC;
    A              : in  UNSIGNED(11 downto 0);    
--        dividend_tvalid : out STD_LOGIC; 
--        diviser_tvalid  : out STD_LOGIC;
--        dout_tvalid     : out STD_LOGIC;
    dout_tdata      : out STD_LOGIC_VECTOR(19 DOWNTO 0);      
--        locked          : OUT STD_LOGIC

    data_ready      :out STD_Logic;



    -- Add LED signals as outputs
    led_0          : out STD_LOGIC;
    led_1          : out STD_LOGIC;
    led_2          : out STD_LOGIC;
    led_3          : out STD_LOGIC

    );
END COMPONENT;
    
    -- Inputs
    signal clk_in           : std_logic := '0';
    signal reset            : std_logic := '1';  -- Start with reset active
    signal pulse            : std_logic := '0';
    signal calculate_pulse  : std_logic := '1';
    signal A                : UNSIGNED(11 downto 0) := "000000000000";
    signal m_monitor : integer range 0 to 1023 := 0;
    signal n_monitor : integer range 0 to 1023 := 0;

    -- Outputs
--    signal dividend_tvalid  : std_logic;
--    signal diviser_tvalid   : std_logic;
    signal dout_tvalid      : std_logic;
    signal dout_tdata       : std_logic_vector(19 downto 0);
    
--    signal locked           : std_logic:= '0';


    -- Clock period definitions
    constant clk_period : time := 83.34 ns;
--    constant clk_period : time := 40 ns;
    
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    UUT: ComputeModule PORT MAP (
        clk_in           => clk_in,
        reset            => reset,
        pulse            => pulse,
        calculate_pulse  => calculate_pulse,
        A                => A,
--        dividend_tvalid  => dividend_tvalid,
--        diviser_tvalid   => diviser_tvalid,
--        dout_tvalid      => dout_tvalid,
        dout_tdata       => dout_tdata
--        locked  => locked

    );

    -- Clock process definitions
    CLK_PROCESS: process
    begin

        while true loop  -- Run for 500 ns
            clk_in <= '0';
            wait for clk_period / 2;
            clk_in <= '1';
            wait for clk_period / 2;
        end loop;
        wait;  -- Wait indefinitely after simulation ends
    end process;

    -- Stimulus process
    STIM_PROC: process
    begin
        -- Initialize Inputs
         reset<='1';
         wait for 200 ns;
                
         reset<='0';
         wait for 200 ns;

         wait for 80000 ns;
 
-- from this start our original test....


--         A <= "111111111111";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns 
        
   for m in 0 to 1023 loop  
       m_monitor <= m;  -- Update monitoring signal
  
        for n in 0 to 1023 loop  -- Loop 1024 times (0 to 1023)
            n_monitor <= n;  -- Update monitoring signal
            
            
            if(n = 900) then
                A <= "101010101010";  -- Example input 
                
            else A <= "000000000010";  -- Example input

            end if;

            wait for 50 ns;
            pulse <= '1';
            wait for 50 ns;  -- Hold pulse for 10 ns
            pulse <= '0';     -- Deassert pulse
            
        end loop;
        
        
        calculate_pulse <= '0';
        wait for 250 ns;  -- Hold pulse for 100 ns
        
        calculate_pulse <= '1';
        wait for 300 ns;  -- Hold pulse for 100 ns
        
   end loop;
      
        
        
        
 
 
--        A <= "111111111111";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
 
--         A <= "111111111111";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns 
 
--        A <= "111111111111";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
 
--         A <= "111111111111";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns 
 
--        A <= "111111111111";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
 
--         A <= "111111111111";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--         A <= "000000000000";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--        A <= "000000000000";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                A <= "000000000000";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                A <= "000000000000";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                A <= "000000000000";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--        A <= "000000000000";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--        A <= "000000000000";  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--        A <= to_unsigned(16,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
 
 
--         A <= to_unsigned(474,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                A <= to_unsigned(1922,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
        
--                A <= to_unsigned(1055,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                A <= to_unsigned(78,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                A <= to_unsigned(1,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                A <= to_unsigned(0,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
--                        A <= to_unsigned(0,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                        A <= to_unsigned(0,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                        A <= to_unsigned(0,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                        A <= to_unsigned(0,  A'length);  -- Example input       
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
--                        A <= to_unsigned(0,  A'length);  -- Example input  
----                A <= to_unsigned(1055,  A'length);  -- Example input       
     
--        wait for 5 ns;
--        pulse <= '1';
--        wait for 10 ns;  -- Hold pulse for 100 ns
--        pulse <= '0';     -- Deassert pulse
--        wait for 10 ns;  -- Hold pulse for 100 ns
        
        
        calculate_pulse <= '0';
        wait for 250 ns;  -- Hold pulse for 100 ns
        
        calculate_pulse <= '1';
        wait for 300 ns;  -- Hold pulse for 100 ns
        
        -- Wait for the end of simulation
        wait for 2000000 us;
        assert false report "End of simulation reached" severity failure;
    end process;



end Behavioral;
