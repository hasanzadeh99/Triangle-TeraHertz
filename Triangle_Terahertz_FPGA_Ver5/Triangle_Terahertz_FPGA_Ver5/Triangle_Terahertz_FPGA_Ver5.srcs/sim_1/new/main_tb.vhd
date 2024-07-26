library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main_tb is
end entity main_tb;

architecture Behavioral of main_tb is

    component main is
        port (
            clk_in : in  STD_LOGIC;
            clk_out : out STD_LOGIC;
            reset : in  STD_LOGIC;
            clk_out_temp : out INTEGER;
            clk_mid_sig : out STD_LOGIC  -- New port to expose mid_sig
        );
    end component;

    signal clk_out : STD_LOGIC;
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal clk_out_temp : INTEGER;
    signal clk_mid_sig : STD_LOGIC;

begin

    -- DUT (Device Under Test) instantiation
    UUT: main port map (
        clk_in => clk,
        reset => reset,
        clk_out => clk_out,
        clk_out_temp => clk_out_temp,
        clk_mid_sig => clk_mid_sig  -- Connect the new port
    );

    -- Clock generation process
    clk_gen: process
    begin
        while true loop
            clk <= '1';
            wait for 25 ns;
            clk <= '0';
            wait for 25 ns;
        end loop;
    end process clk_gen;

    -- Reset generation process
    reset_gen: process
    begin
        reset <= '1';
        wait for 50 ns;
        reset <= '0';
        wait for 300 ns;  -- Adjust reset hold/release times if needed
        reset <= '1';
        wait for 1000 ns;
        -- Add further stimuli if necessary
        wait;
    end process reset_gen;

end Behavioral;
