library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ComputeModule_tb is
end ComputeModule_tb;

architecture Behavioral of ComputeModule_tb is 

    -- Component Declaration for the Unit Under Test (UUT)
    component ComputeModule
        port (
            clk_in           : in  std_logic;
            reset            : in  std_logic;
            pulse            : in  std_logic;
            calculate_pulse  : in  std_logic;
            A                : in  unsigned(11 downto 0);
            LED              : out std_logic;
            dividend_tvalid  : out std_logic;
            diviser_tvalid   : out std_logic;
            dout_tvalid      : out std_logic;
            dout_tdata       : out std_logic_vector(71 downto 0)
        );
    end component;

    -- Inputs
    signal clk_in           : std_logic := '0';
    signal reset            : std_logic := '1';  -- Start with reset active
    signal pulse            : std_logic := '0';
    signal calculate_pulse  : std_logic := '0';
    signal A                : unsigned(11 downto 0) := (others => '0');

    -- Outputs
    signal LED              : std_logic;
    signal dividend_tvalid  : std_logic;
    signal diviser_tvalid   : std_logic;
    signal dout_tvalid      : std_logic;
    signal dout_tdata       : std_logic_vector(71 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : ComputeModule
        port map (
            clk_in           => clk_in,
            reset            => reset,
            pulse            => pulse,
            calculate_pulse  => calculate_pulse,
            A                => A,
            LED              => LED,
            dividend_tvalid  => dividend_tvalid,
            diviser_tvalid   => diviser_tvalid,
            dout_tvalid      => dout_tvalid,
            dout_tdata       => dout_tdata
        );

    -- Clock process definitions
    clk_process : process
    begin
        while now < 500 ns loop  -- Run for 500 ns
            clk_in <= '0';
            wait for clk_period/2;
            clk_in <= '1';
            wait for clk_period/2;
        end loop;
        wait;  -- Wait indefinitely after simulation ends
    end process;

    -- Stimulus process
    stim_proc : process
    begin        
        -- Initialize Inputs
        reset <= '1';  -- Start with reset active
        wait for 20 ns;
        reset <= '0';  -- Deassert reset

        -- Test Scenario 1: Apply pulse and observe LED
        pulse <= '1';
        wait for 100 ns;  -- Hold pulse for 100 ns
        pulse <= '0';     -- Deassert pulse

        -- Test Scenario 2: Apply calculate_pulse and set A
        calculate_pulse <= '1';
        A <= "100000000000";  -- Example input
        wait for 200 ns;       -- Hold calculate_pulse and A
        calculate_pulse <= '0'; -- Deassert calculate_pulse

        -- Add more test scenarios here
        
        -- Wait for the end of simulation
        wait for 200 ns;
        assert false report "End of simulation reached" severity failure;
    end process;

end Behavioral;
