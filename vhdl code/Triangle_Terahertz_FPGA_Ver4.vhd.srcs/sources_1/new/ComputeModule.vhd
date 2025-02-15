library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ComputeModule is
    Port (   
        clk_in          : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        pulse           : in  STD_LOGIC;
        calculate_pulse : in  STD_LOGIC;
        A               : in  UNSIGNED(11 downto 0);  -- Direct A input use
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
    
    -- State type definition
    type state_type is (IDLE, WAITING_CAPTURE, CAPTURING, DIVIDING, HOLD_RESULT);
    signal current_state : state_type;
    
    -- Counters and control
    signal pulse_counter : unsigned(10 downto 0);
    signal last_pulse    : STD_LOGIC;
    signal last_calc     : STD_LOGIC;
    signal capture_done  : STD_LOGIC;
    
    -- Result storage
    signal result_valid  : STD_LOGIC;
    signal stored_result : STD_LOGIC_VECTOR(19 DOWNTO 0);
    
    -- Accumulator signals for S and P
    signal S : unsigned(63 downto 0);  -- For sum of A*A*pulse_number
    signal P : unsigned(55 downto 0);  -- For sum of A*A
    
    -- Division IP interface signals
    signal s_axis_divisor_tvalid  : STD_LOGIC;
    signal s_axis_divisor_tready  : STD_LOGIC;
    signal s_axis_divisor_tdata   : STD_LOGIC_VECTOR(55 DOWNTO 0);
    signal s_axis_dividend_tvalid : STD_LOGIC;
    signal s_axis_dividend_tready : STD_LOGIC;
    signal s_axis_dividend_tdata  : STD_LOGIC_VECTOR(63 DOWNTO 0);
    signal m_axis_dout_tvalid     : STD_LOGIC;
    signal m_axis_dout_tdata      : STD_LOGIC_VECTOR(71 DOWNTO 0);
    
    -- Clock signals
    signal clk_out       : STD_LOGIC;
    signal clk_ready     : STD_LOGIC;
    
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
            m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(71 DOWNTO 0)
        );
    end component;

begin
    clock_gen: clk_wiz_0
        port map (
            clk_out    => clk_out,
            reset      => reset,
            locked     => clk_ready,
            clk_in     => clk_in
        );

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
            m_axis_dout_tdata => m_axis_dout_tdata
        );

    -- LED assignments
    led_0 <= '1' when current_state = CAPTURING else '0';
    led_1 <= pulse;
    led_2 <= '1' when current_state = DIVIDING else '0';
    led_3 <= capture_done;

    -- Connect data_ready to result_valid
    data_ready <= result_valid;

    process(clk_out, reset)
        variable A_squared : unsigned(23 downto 0);  -- For A*A calculation
        variable S_increment : unsigned(63 downto 0); -- For A*A*pulse_number
    begin
        if reset = '1' then
            pulse_counter <= ALL_ZEROS;
            last_pulse <= '0';
            last_calc <= '0';
            capture_done <= '0';
            current_state <= IDLE;
            S <= (others => '0');
            P <= (others => '0');
            s_axis_divisor_tvalid <= '0';
            s_axis_dividend_tvalid <= '0';
            dout_tdata <= (others => '0');
            result_valid <= '0';
            stored_result <= (others => '0');
            
        elsif rising_edge(clk_out) and clk_ready = '1' then
            -- Default assignments
            last_pulse <= pulse;
            last_calc <= calculate_pulse;
            
            case current_state is
                when IDLE =>
                    s_axis_divisor_tvalid <= '0';
                    s_axis_dividend_tvalid <= '0';
                    
                    if calculate_pulse = '1' and last_calc = '0' then
                        current_state <= WAITING_CAPTURE;
                        pulse_counter <= ALL_ZEROS;
                        S <= (others => '0');  -- Reset accumulators
                        P <= (others => '0');
                        capture_done <= '0';
                        result_valid <= '0';
                    end if;
                    
                when WAITING_CAPTURE =>
                    if pulse = '1' and last_pulse = '0' then
                        current_state <= CAPTURING;
                        -- Calculate first values using input A directly
                        A_squared := A * A;
                        S_increment := resize(A_squared * pulse_counter, 64);
                        S <= S_increment;
                        P <= resize(A_squared, 56);
                        pulse_counter <= pulse_counter + 1;
                    end if;
                    
                when CAPTURING =>
                    if pulse = '1' and last_pulse = '0' then
                        -- Calculate using input A directly
                        A_squared := A * A;
                        S_increment := resize(A_squared * pulse_counter, 64);
                        
                        -- Accumulate values
                        S <= S + S_increment;
                        P <= P + resize(A_squared, 56);
                        
                        if pulse_counter = MAX_PULSES then
                            current_state <= DIVIDING;
                            capture_done <= '1';
                            
                            -- Start division
                            s_axis_divisor_tdata <= std_logic_vector(P);
                            s_axis_dividend_tdata <= std_logic_vector(S);
                            s_axis_divisor_tvalid <= '1';
                            s_axis_dividend_tvalid <= '1';
                        else
                            pulse_counter <= pulse_counter + 1;
                        end if;
                    end if;
                    
                when DIVIDING =>
                    -- Keep valid signals high until ready
                    if s_axis_divisor_tready = '1' and s_axis_dividend_tready = '1' then
                        s_axis_divisor_tvalid <= '0';
                        s_axis_dividend_tvalid <= '0';
                    end if;
                    
                    -- When division result is ready
                    if m_axis_dout_tvalid = '1' then
                        -- Store the result and set valid flag
                        stored_result <= m_axis_dout_tdata(19 downto 0);
                        dout_tdata <= m_axis_dout_tdata(19 downto 0);
                        result_valid <= '1';
                        current_state <= HOLD_RESULT;
                    end if;

                when HOLD_RESULT =>
                    -- Stay in this state until new calculation is requested
                    if calculate_pulse = '1' and last_calc = '0' then
                        current_state <= WAITING_CAPTURE;
                        pulse_counter <= ALL_ZEROS;
                        S <= (others => '0');
                        P <= (others => '0');
                        capture_done <= '0';
                        result_valid <= '0';
                    end if;
            end case;
        end if;
    end process;

end Behavioral;