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
    constant MAX_PULSES : integer := 500;
    constant ALL_ZEROS : unsigned(10 downto 0) := (others => '0');
    -- Assuming 100MHz clock, 1ms = 100,000 clock cycles
    constant DELAY_1MS : integer := 100_000;
    
    -- Storage for A values
    type a_storage_type is array (0 to MAX_PULSES) of UNSIGNED(11 downto 0);
    signal a_storage     : a_storage_type;
    
    -- State type definition
    type state_type is (IDLE, WAITING_CAPTURE, CAPTURING, OUTPUTTING);
    signal current_state : state_type;
    
    -- Counters and control
    signal pulse_counter : unsigned(10 downto 0);
    signal read_index    : unsigned(10 downto 0);
    signal delay_counter : integer range 0 to DELAY_1MS;
    signal last_pulse    : STD_LOGIC;
    signal last_calc     : STD_LOGIC;
    signal last_A        : UNSIGNED(11 downto 0);
    signal data_ready_i  : STD_LOGIC;
    signal capture_done  : STD_LOGIC;
    
    -- Debug signals for ILA
    signal is_max_count  : std_logic;
    signal is_reading    : std_logic;
    
    -- Clock signals
    signal clk_out       : STD_LOGIC;
    signal clk_ready     : STD_LOGIC;
    
    -- Debug attributes
    attribute mark_debug : string;
    attribute mark_debug of read_index : signal is "true";
    attribute mark_debug of dout_tdata : signal is "true";
    attribute mark_debug of pulse_counter : signal is "true";
    attribute mark_debug of capture_done : signal is "true";
    attribute mark_debug of data_ready_i : signal is "true";
    
    component clk_wiz_0
        port (
            clk_out    : out STD_LOGIC;
            reset      : in  STD_LOGIC;
            locked     : out STD_LOGIC;
            clk_in     : in  STD_LOGIC
        );
    end component;

begin
    is_max_count <= '1' when pulse_counter = to_unsigned(MAX_PULSES, pulse_counter'length) else '0';
    is_reading <= '1' when current_state = OUTPUTTING else '0';

    clock_gen: clk_wiz_0
        port map (
            clk_out    => clk_out,
            reset      => reset,
            locked     => clk_ready,
            clk_in     => clk_in
        );

    -- Connect internal signal to output
    data_ready <= data_ready_i;

    -- LED assignments
    led_0 <= '1' when current_state = CAPTURING else '0';
    led_1 <= pulse;
    led_2 <= '1' when current_state = OUTPUTTING else '0';
    led_3 <= capture_done;

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
            delay_counter <= 0;
            current_state <= IDLE;
            
        elsif rising_edge(clk_out) and clk_ready = '1' then
            -- Default assignments
            last_pulse <= pulse;
            last_calc <= calculate_pulse;
            last_A <= A;
            
            case current_state is
                when IDLE =>
                    -- Wait for rising edge of calculate_pulse to start capture
                    if calculate_pulse = '1' and last_calc = '0' then
                        current_state <= WAITING_CAPTURE;
                        pulse_counter <= ALL_ZEROS;
                        capture_done <= '0';
                    end if;
                    
                when WAITING_CAPTURE =>
                    -- Wait for first pulse
                    if pulse = '1' and last_pulse = '0' then
                        current_state <= CAPTURING;
                        a_storage(to_integer(pulse_counter)) <= A;
                        pulse_counter <= pulse_counter + 1;
                    end if;
                    
                when CAPTURING =>
                    -- Store A value on each pulse rising edge
                    if pulse = '1' and last_pulse = '0' then
                        a_storage(to_integer(pulse_counter)) <= A;
                        
                        if pulse_counter = MAX_PULSES then
                            -- Finished capturing, prepare for output
                            current_state <= OUTPUTTING;
                            capture_done <= '1';
                            read_index <= ALL_ZEROS;
                            delay_counter <= 0;
                            -- First output will occur after delay
                            dout_tdata <= (others => '0');
                        else
                            pulse_counter <= pulse_counter + 1;
                        end if;
                    end if;
                    
                when OUTPUTTING =>
                    -- Output each value with 1ms delay
                    if delay_counter = DELAY_1MS - 1 then
                        -- Delay complete
                        delay_counter <= 0;
                        
                        -- Output current value and toggle data_ready
                        dout_tdata <= std_logic_vector(resize(a_storage(to_integer(read_index)), 20));
                        data_ready_i <= not data_ready_i;
                        
                        if read_index = MAX_PULSES then
                            -- All values output, return to IDLE
                            current_state <= IDLE;
                            read_index <= ALL_ZEROS;
                            pulse_counter <= ALL_ZEROS;
                        else
                            -- Prepare for next value
                            read_index <= read_index + 1;
                        end if;
                    else
                        delay_counter <= delay_counter + 1;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;