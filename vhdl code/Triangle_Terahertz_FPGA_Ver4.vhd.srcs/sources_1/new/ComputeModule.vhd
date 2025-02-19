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
    constant MAX_PULSES : integer := 100;  -- For 100 pulses (0 to 99)
    constant ALL_ZEROS : unsigned(10 downto 0) := (others => '0');
    
    -- State machine
    type state_type is (IDLE, CAPTURING, DIVIDING);
    signal current_state : state_type;
    
    -- Calculation signals
    signal pulse_counter : unsigned(10 downto 0);
    signal S : unsigned(63 downto 0);  -- For ?(A²i)
    signal P : unsigned(55 downto 0);  -- For ?(A²)
    
    -- Debug signals
    signal debug_S : unsigned(63 downto 0);
    signal debug_P : unsigned(55 downto 0);
    signal debug_A_squared : unsigned(23 downto 0);
    signal debug_S_term : unsigned(63 downto 0);
    
    -- Edge detection and control
    signal last_pulse : std_logic;
    signal last_calc : std_logic;
    signal capture_done : std_logic;
    
    -- Division IP interface signals
    signal s_axis_divisor_tvalid : std_logic;
    signal s_axis_divisor_tready : std_logic;
    signal s_axis_divisor_tdata : std_logic_vector(55 downto 0);
    signal s_axis_dividend_tvalid : std_logic;
    signal s_axis_dividend_tready : std_logic;
    signal s_axis_dividend_tdata : std_logic_vector(63 downto 0);
    signal m_axis_dout_tvalid : std_logic;
    signal m_axis_dout_tready : std_logic := '1';
    signal m_axis_dout_tdata : std_logic_vector(71 downto 0);

    -- Clock management
    signal clk_out : std_logic;
    signal clk_ready : std_logic;
    
    -- Components
    component clk_wiz_0
        port (
            clk_out    : out STD_LOGIC;
            reset      : in  STD_LOGIC;
            locked     : out STD_LOGIC;
            clk_in     : in  STD_LOGIC
        );
    end component;
    
    component div_gen_0
        port (
            aclk : IN STD_LOGIC;
            s_axis_divisor_tvalid : IN STD_LOGIC;
            s_axis_divisor_tready : OUT STD_LOGIC;
            s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(55 DOWNTO 0);
            s_axis_dividend_tvalid : IN STD_LOGIC;
            s_axis_dividend_tready : OUT STD_LOGIC;
            s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
            m_axis_dout_tvalid : OUT STD_LOGIC;
            m_axis_dout_tready : IN STD_LOGIC;
            m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(71 DOWNTO 0)
        );
    end component;

    -- Debug attributes
    attribute mark_debug : string;
    attribute mark_debug of debug_S : signal is "true";
    attribute mark_debug of debug_P : signal is "true";
    attribute mark_debug of debug_A_squared : signal is "true";
    attribute mark_debug of debug_S_term : signal is "true";
    attribute mark_debug of current_state : signal is "true";
    attribute mark_debug of pulse_counter : signal is "true";

begin
    -- Clock wizard instantiation
    clock_gen: clk_wiz_0
        port map (
            clk_out    => clk_out,
            reset      => reset,
            locked     => clk_ready,
            clk_in     => clk_in
        );

    -- Divider instantiation
    div_inst: div_gen_0
        port map (
            aclk => clk_out,
            s_axis_divisor_tvalid => s_axis_divisor_tvalid,
            s_axis_divisor_tready => s_axis_divisor_tready,
            s_axis_divisor_tdata => s_axis_divisor_tdata,
            s_axis_dividend_tvalid => s_axis_dividend_tvalid,
            s_axis_dividend_tready => s_axis_dividend_tready,
            s_axis_dividend_tdata => s_axis_dividend_tdata,
            m_axis_dout_tvalid => m_axis_dout_tvalid,
            m_axis_dout_tready => m_axis_dout_tready,
            m_axis_dout_tdata => m_axis_dout_tdata
        );

    -- Main process
    process(clk_out, reset)
        variable a_squared : unsigned(23 downto 0);
        variable s_term : unsigned(63 downto 0);
    begin
        if reset = '1' then
            current_state <= IDLE;
            pulse_counter <= (others => '0');
            S <= (others => '0');
            P <= (others => '0');
            last_pulse <= '0';
            last_calc <= '0';
            capture_done <= '0';
            s_axis_divisor_tvalid <= '0';
            s_axis_dividend_tvalid <= '0';
            data_ready <= '0';
            dout_tdata <= (others => '0');
            debug_A_squared <= (others => '0');
            debug_S_term <= (others => '0');
            
        elsif rising_edge(clk_out) and clk_ready = '1' then
            -- Edge detection
            last_pulse <= pulse;
            last_calc <= calculate_pulse;
            
            case current_state is
                when IDLE =>
                    if calculate_pulse = '1' and last_calc = '0' then
                        current_state <= CAPTURING;
                        pulse_counter <= (others => '0');
                        S <= (others => '0');
                        P <= (others => '0');
                        capture_done <= '0';
                        data_ready <= '0';
                    end if;
                    
                when CAPTURING =>
                    if pulse = '1' and last_pulse = '0' then
                        -- Calculate A² first to prevent overflow
                        a_squared := resize(A * A, 24);
                        debug_A_squared <= a_squared;
                        
                        -- Calculate S term: A² * i
                        s_term := resize(a_squared * pulse_counter, 64);
                        debug_S_term <= s_term;
                        
                        if pulse_counter < MAX_PULSES then
                            -- Accumulate S and P
                            S <= S + s_term;
                            P <= P + resize(a_squared, 56);
                            pulse_counter <= pulse_counter + 1;
                            
                            -- Update debug values
                            debug_S <= S + s_term;
                            debug_P <= P + resize(a_squared, 56);
                        end if;

                        if pulse_counter = MAX_PULSES then
                            current_state <= DIVIDING;
                            capture_done <= '1';
                            
                            -- Start division with final values
                            s_axis_divisor_tdata <= std_logic_vector(P + resize(a_squared, 56));
                            s_axis_dividend_tdata <= std_logic_vector(S + s_term);
                            s_axis_divisor_tvalid <= '1';
                            s_axis_dividend_tvalid <= '1';
                        end if;
                    end if;

                when DIVIDING =>
                    -- Clear valid signals once ready is high
                    if s_axis_divisor_tready = '1' and s_axis_dividend_tready = '1' then
                        s_axis_divisor_tvalid <= '0';
                        s_axis_dividend_tvalid <= '0';
                    end if;
                    
                    -- When division result is valid
                    if m_axis_dout_tvalid = '1' then
                        -- Update output
                        dout_tdata <= m_axis_dout_tdata(19 downto 0);
                        data_ready <= '1';
                        -- Return to idle
                        current_state <= IDLE;
                    end if;
            end case;
        end if;
    end process;

    -- LED indicators
    led_0 <= '1' when current_state = CAPTURING else '0';
    led_1 <= pulse;
    led_2 <= '1' when current_state = DIVIDING else '0';
    led_3 <= capture_done;

end Behavioral;