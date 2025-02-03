library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ComputeModule is
    Port (   
        clk_in          : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        pulse           : in  STD_LOGIC;
        calculate_pulse : in  STD_LOGIC;
        A               : in  UNSIGNED(11 downto 0);
        dout_tdata      : out STD_LOGIC_VECTOR(19 DOWNTO 0);
        data_ready      : out STD_LOGIC;
        led_0           : out STD_LOGIC;
        led_1           : out STD_LOGIC;
        led_2           : out STD_LOGIC;
        led_3           : out STD_LOGIC
    );
end ComputeModule;

architecture Behavioral of ComputeModule is
  
    -- Constants
    constant MAX_PULSES : integer := 1023;
    constant ALL_ZEROS : unsigned(10 downto 0) := (others => '0');
    
    -- Storage for A values
    type a_storage_type is array (0 to MAX_PULSES) of UNSIGNED(11 downto 0);
    signal a_storage     : a_storage_type;
    
    -- Counters and control
    signal pulse_counter : unsigned(10 downto 0);
    signal read_index    : unsigned(10 downto 0);
    signal last_pulse    : STD_LOGIC;
    signal last_calc     : STD_LOGIC;
    signal last_A        : UNSIGNED(11 downto 0);
    signal data_ready_i  : STD_LOGIC;
    signal capture_done  : STD_LOGIC;
    
    -- Debug signals for ILA that only need eq/neq
    signal p_1_in        : unsigned(11 downto 0);  -- Current A value being processed
    signal is_max_count  : std_logic;              -- Flag for max count reached
    signal is_reading    : std_logic;              -- Flag for read operation
    
    -- Clock signals
    signal clk_out       : STD_LOGIC;
    signal clk_ready     : STD_LOGIC;
    
    -- Debug attributes matching ILA configuration
    attribute mark_debug : string;
    attribute mark_debug of p_1_in : signal is "true";          -- probe0
    attribute mark_debug of read_index : signal is "true";      -- probe1
    attribute mark_debug of dout_tdata : signal is "true";      -- probe2
    attribute mark_debug of pulse_counter : signal is "true";   -- probe3
    attribute mark_debug of last_A : signal is "true";          -- probe4
    attribute mark_debug of capture_done : signal is "true";    -- probe5
    attribute mark_debug of data_ready_i : signal is "true";    -- probe6
    
    component clk_wiz_0
        port (
            clk_out    : out STD_LOGIC;
            reset      : in  STD_LOGIC;
            locked     : out STD_LOGIC;
            clk_in     : in  STD_LOGIC
        );
    end component;

begin
    -- Debug signal assignments (using only equality)
    p_1_in <= A;  -- Track current input value
    is_max_count <= '1' when pulse_counter = to_unsigned(MAX_PULSES, pulse_counter'length) else '0';
    is_reading <= '1' when capture_done = '1' else '0';

    clock_gen: clk_wiz_0
        port map (
            clk_out    => clk_out,
            reset      => reset,
            locked     => clk_ready,
            clk_in     => clk_in
        );

    -- Connect internal signal to output
    data_ready <= data_ready_i;

    -- LED assignments (using only equality)
    led_0 <= not capture_done;     -- In capture mode
    led_1 <= pulse;                -- Show pulse directly
    led_2 <= not is_max_count;     -- Not at max count
    led_3 <= capture_done;         -- In output mode

    process(clk_out, reset)
    begin
        if reset = '1' then
            pulse_counter <= ALL_ZEROS;
            read_index <= ALL_ZEROS;
            last_pulse <= '0';
            last_calc <= '0';
            last_A <= (others => '0');
            data_ready_i <= '0';
            dout_tdata <= (others => '0');
            capture_done <= '0';
            
        elsif rising_edge(clk_out) and clk_ready = '1' then
            -- Default assignments
            last_pulse <= pulse;
            last_calc <= calculate_pulse;
            last_A <= A;
            
            -- Capture phase
            if capture_done = '0' then
                if pulse = '1' and last_pulse = '0' then
                    -- Store A value
                    a_storage(to_integer(pulse_counter)) <= A;
                    
                    -- Update counter and check for completion
                    if pulse_counter = MAX_PULSES then
                        capture_done <= '1';
                        read_index <= ALL_ZEROS;
                    else
                        pulse_counter <= pulse_counter + 1;
                    end if;
                end if;
            
            -- Output phase
            else
                if calculate_pulse = '1' and last_calc = '0' then
                    -- Output stored value
                    dout_tdata <= std_logic_vector(resize(a_storage(to_integer(read_index)), 20));
                    data_ready_i <= not data_ready_i;
                    
                    -- Update read index and check for completion
                    if read_index = MAX_PULSES then
                        capture_done <= '0';
                        pulse_counter <= ALL_ZEROS;
                        read_index <= ALL_ZEROS;
                    else
                        read_index <= read_index + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;