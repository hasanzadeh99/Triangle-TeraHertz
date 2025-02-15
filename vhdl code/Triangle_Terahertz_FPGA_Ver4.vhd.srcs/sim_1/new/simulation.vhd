STIM_PROC: process
begin
    -- Initialize Inputs
    reset <= '1';
    wait for 200 ns;
    reset <= '0';
    wait for 200 ns;

    -- Start computation
    A <= to_unsigned(10, A'length);  -- Example input
    wait for 50 ns;
    pulse <= '1';
    wait for 50 ns;
    pulse <= '0';

    -- Wait for computation to complete
    wait for 1000 ns;

    -- Trigger a new calculation to reset result_valid
    calculate_pulse <= '1';
    wait for 50 ns;
    calculate_pulse <= '0';

    -- Wait for the end of simulation
    wait for 2000000 us;
    assert false report "End of simulation reached" severity failure;
end process;