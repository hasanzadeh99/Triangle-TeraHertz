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
    -- Clock wizard component declaration
    component clk_wiz_0 
        port ( 
            clk_out : out STD_LOGIC;
            reset   : in  STD_LOGIC;
            locked  : out STD_LOGIC;
            clk_in  : in  STD_LOGIC
        );
    end component;

    -- Constants
    constant NUM_PIXELS      : integer := 1024;
    constant CLOCK_FREQ      : integer := 120_000_000;

    constant INTERVAL_COUNT2  : integer := CLOCK_FREQ/100;  -- 10ms interval (0.01s)
    
    -- Clock signals
    signal clk_out     : STD_LOGIC;
    signal clk_ready   : STD_LOGIC;
    
    -- State machine types
    type state_type is (IDLE, CAPTURE_FRAME, SEND_DATA, WAIT_INTERVAL);
    signal current_state : state_type;
    
    -- Frame storage memory
    type frame_memory is array (0 to NUM_PIXELS-1) of unsigned(11 downto 0);
    signal frame_buffer : frame_memory;
    
    -- Counters and control signals
    signal capture_count    : integer range 0 to NUM_PIXELS-1;
    signal output_count     : integer range 0 to NUM_PIXELS-1;
    signal interval_count   : integer range 0 to INTERVAL_COUNT2-1;  -- Removed := 0
    signal capture_done     : std_logic;
    signal send_done        : std_logic;

begin
    -- Clock wizard instantiation
    clock_gen: clk_wiz_0 
    port map ( 
        clk_out => clk_out,
        reset   => reset,
        locked  => clk_ready,
        clk_in  => clk_in
    );

    -- Frame capture process
    process(pulse, reset)
    begin
        if reset = '1' then
            capture_count <= 0;
            capture_done <= '0';
            frame_buffer <= (others => (others => '0'));
        elsif rising_edge(pulse) then
            if current_state = CAPTURE_FRAME then
                if capture_count < NUM_PIXELS-1 then
                    frame_buffer(capture_count) <= A;
                    capture_count <= capture_count + 1;
                else
                    frame_buffer(capture_count) <= A;
                    capture_done <= '1';
                    capture_count <= 0;
                end if;
            else
                capture_done <= '0';
            end if;
        end if;
    end process;

    -- Data output and timing control process
    process(clk_out, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
            output_count <= 0;
            interval_count <= 0;
            send_done <= '0';
            dout_tdata <= (others => '0');
                     
        elsif rising_edge(clk_out) then
            case current_state is
                when IDLE =>
                    if calculate_pulse = '0' then
                        current_state <= CAPTURE_FRAME;
                    end if;
                    output_count <= 0;
                    interval_count <= 0;
                    send_done <= '0';
                    
                when CAPTURE_FRAME =>
                    if capture_done = '1' then
                        current_state <= SEND_DATA;
                    end if;
                    
                when SEND_DATA =>
                    -- Extend 12-bit data to 20-bit output
                    dout_tdata <= std_logic_vector(resize(frame_buffer(output_count), 20));
                    current_state <= WAIT_INTERVAL;
                    
                when WAIT_INTERVAL =>
                    if interval_count < INTERVAL_COUNT-1 then
                        interval_count <= interval_count + 1;
                    else
                        interval_count <= 0;
                        if output_count < NUM_PIXELS-1 then
                            output_count <= output_count + 1;
                            current_state <= SEND_DATA;
                        else
                            output_count <= 0;
                            send_done <= '1';
                            current_state <= IDLE;
                        end if;
                    end if;
            end case;
        end if;
    end process;

    -- Debug output
--    dbg_state <= std_logic_vector(to_unsigned(state_type'pos(current_state), 4));

end Behavioral;