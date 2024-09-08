library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ComputeModule_tb is
end ComputeModule_tb;

architecture Behavioral of ComputeModule_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT ComputeModule
        PORT (
            clk_in           : IN  std_logic;
            reset            : IN  std_logic;
            pulse            : IN  std_logic;
            calculate_pulse  : IN  std_logic;
            A                : IN  UNSIGNED(11 downto 0);
            dividend_tvalid  : OUT std_logic;
            diviser_tvalid   : OUT std_logic;
            dout_tvalid      : OUT std_logic;
            dout_tdata       : OUT std_logic_vector(12 downto 0);
            locked           : OUT std_logic

        );
    END COMPONENT;

    -- Inputs
    signal clk_in           : std_logic := '0';
    signal reset            : std_logic := '1';  -- Start with reset active
    signal pulse            : std_logic := '0';
    signal calculate_pulse  : std_logic := '0';
    signal A                : UNSIGNED(11 downto 0) := "000000000000";

    -- Outputs
    signal dividend_tvalid  : std_logic;
    signal diviser_tvalid   : std_logic;
    signal dout_tvalid      : std_logic;
    signal dout_tdata       : std_logic_vector(12 downto 0);
    
    signal locked           : std_logic:= '0';


    -- Clock period definitions
    constant clk_period : time := 83.34 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    UUT: ComputeModule PORT MAP (
        clk_in           => clk_in,
        reset            => reset,
        pulse            => pulse,
        calculate_pulse  => calculate_pulse,
        A                => A,
        dividend_tvalid  => dividend_tvalid,
        diviser_tvalid   => diviser_tvalid,
        dout_tvalid      => dout_tvalid,
        dout_tdata       => dout_tdata,
        locked  => locked

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

 
        A <= "000000000000";  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
 
 
         A <= "000000000000";  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
        A <= "000000000000";  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                A <= "000000000000";  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                A <= "000000000000";  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                A <= "000000000000";  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
        A <= "000000000000";  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
        A <= "000000000000";  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
        A <= to_unsigned(16,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
 
 
         A <= to_unsigned(474,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                A <= to_unsigned(1922,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
        
                A <= to_unsigned(1055,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                A <= to_unsigned(78,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                A <= to_unsigned(1,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                A <= to_unsigned(0,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
                        A <= to_unsigned(0,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                        A <= to_unsigned(0,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                        A <= to_unsigned(0,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                        A <= to_unsigned(0,  A'length);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                        A <= to_unsigned(0,  A'length);  -- Example input  
--                A <= to_unsigned(1055,  A'length);  -- Example input       
     
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
        
        
        calculate_pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        calculate_pulse <= '0';
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
        
        
        A <= "000000000000";  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
 
 
 
        A <= to_unsigned(16#C00#, 12);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
        
        A <= to_unsigned(16#D00#, 12);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
 
 
 
         A <= to_unsigned(16#E00#, 12);  -- Example input       
        wait for 200 ns;
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        
                
        calculate_pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        calculate_pulse <= '0';
        wait for 100 ns;  -- Hold pulse for 100 ns
        
        -- Wait for the end of simulation
        wait for 2000000 us;
        assert false report "End of simulation reached" severity failure;
    end process;

END Behavioral;
