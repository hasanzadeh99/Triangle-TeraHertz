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
        led_3           : out STD_LOGIC;
        uart_tx         : out STD_LOGIC
    );
end ComputeModule;

architecture Behavioral of ComputeModule is
    -- Constants
    constant MAX_PULSES : integer := 1023;  -- For 1024 pulses (0 to 1023)
    constant ALL_ZEROS : unsigned(10 downto 0) := (others => '0');
    constant CLKS_PER_BIT : integer := 1042;  -- 115200 baud at 120MHz
    constant TIMEOUT_COUNT : integer := 1000;  -- Timeout for division
    
    -- Debug signals
    signal debug_S : unsigned(63 downto 0);
    signal debug_P : unsigned(55 downto 0);
    signal timeout_counter : integer range 0 to TIMEOUT_COUNT;
    signal division_timeout : std_logic;
    
    -- UART output formatting
    constant MAX_CHARS : integer := 11;  -- M=XXX.XXX\r\n format
    type char_array is array (0 to MAX_CHARS-1) of std_logic_vector(7 downto 0);
    signal output_chars : char_array;
    
    -- State machines
    type state_type is (IDLE, WAITING_CAPTURE, CAPTURING, DIVIDING, FORMATTING, TRANSMITTING);
    signal current_state : state_type;
    
    type uart_state_type is (UART_IDLE, UART_START_BIT, UART_DATA_BITS, UART_STOP_BIT);
    signal uart_state : uart_state_type;
    
    -- Calculation signals
    signal pulse_counter : unsigned(10 downto 0);
    signal S : unsigned(63 downto 0);  -- For ?(A�i � i)
    signal P : unsigned(55 downto 0);  -- For ?(A�i)
    signal result : unsigned(19 downto 0);
    
    -- Edge detection
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
    signal m_axis_dout_tdata : std_logic_vector(71 downto 0);
    
    -- UART control signals
    signal uart_data : std_logic_vector(7 downto 0);
    signal uart_busy : std_logic := '0';
    signal bit_counter : integer range 0 to 7 := 0;
    signal clk_counter : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal char_counter : integer range 0 to MAX_CHARS-1 := 0;
    signal start_transmission : std_logic := '0';
    signal transmission_done : std_logic := '0';
    signal char_to_send : integer range 0 to MAX_CHARS-1 := 0;
    signal uart_tx_start : std_logic := '0';
    signal uart_tx_busy : std_logic := '0';
    signal uart_tx_data : std_logic_vector(7 downto 0);

    -- Clock management
    signal clk_out : std_logic;
    signal clk_ready : std_logic;
    
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
            m_axis_dout_tdata => m_axis_dout_tdata
        );

    -- Main process
    process(clk_out, reset)
        variable temp_fraction : integer;
        variable digit1, digit2, digit3 : integer;
        variable integer_part : integer;
        variable next_S : unsigned(63 downto 0);  -- Add this variable
    begin
        if reset = '1' then
            current_state <= IDLE;
            pulse_counter <= (others => '0');
            S <= (others => '0');
            P <= (others => '0');
            result <= (others => '0');
            last_pulse <= '0';
            last_calc <= '0';
            capture_done <= '0';
            s_axis_divisor_tvalid <= '0';
            s_axis_dividend_tvalid <= '0';
            char_to_send <= 0;
            uart_tx_start <= '0';
            
        elsif rising_edge(clk_out) and clk_ready = '1' then
            -- Default values
            uart_tx_start <= '0';
            
            -- Edge detection
            last_pulse <= pulse;
            last_calc <= calculate_pulse;
            
            case current_state is
                when IDLE =>
                    if calculate_pulse = '1' and last_calc = '0' then
                        current_state <= WAITING_CAPTURE;
                        pulse_counter <= (others => '0');
                        S <= (others => '0');
                        P <= (others => '0');
                        capture_done <= '0';
                    end if;
                    
                when WAITING_CAPTURE =>
                    if pulse = '1' and last_pulse = '0' then
                        current_state <= CAPTURING;
                        -- Initialize with first value
                        S <= (others => '0');  -- Start from zero
                        P <= (others => '0');  -- Start from zero
                        pulse_counter <= to_unsigned(0, 11);  -- Start from 0
                    end if;
                    
                when CAPTURING =>
                    if pulse = '1' and last_pulse = '0' then
                        -- Improved calculation with overflow protection
                        if pulse_counter < MAX_PULSES then
                            -- Calculate next S value without overflow checking
                            next_S := resize(A * A * pulse_counter, 64);
                            S <= S + next_S;
                            P <= P + resize(A * A, 56);
                            pulse_counter <= pulse_counter + 1;
                        end if;

                        if pulse_counter = MAX_PULSES then
                            current_state <= DIVIDING;
                            capture_done <= '1';
                            timeout_counter <= 0;  -- Reset timeout counter
                            -- Save debug values
                            debug_S <= S;
                            debug_P <= P;
                            -- Start division
                            s_axis_divisor_tdata <= std_logic_vector(P);
                            s_axis_dividend_tdata <= std_logic_vector(S);
                            s_axis_divisor_tvalid <= '1';
                            s_axis_dividend_tvalid <= '1';
                        end if;
                    end if;

                when DIVIDING =>
                    -- Fixed timeout check
                    if timeout_counter >= TIMEOUT_COUNT then
                        division_timeout <= '1';
                        current_state <= IDLE;
                    else
                        timeout_counter <= timeout_counter + 1;
                    end if;

                    if s_axis_divisor_tready = '1' and s_axis_dividend_tready = '1' then
                        s_axis_divisor_tvalid <= '0';
                        s_axis_dividend_tvalid <= '0';
                    end if;
                    
                    if m_axis_dout_tvalid = '1' then
                        division_timeout <= '0';
                        result <= unsigned(m_axis_dout_tdata(19 downto 0));
                        
                        -- Format output chars for decimal output
                        output_chars(0) <= X"4D";  -- 'M'
                        output_chars(1) <= X"3D";  -- '='
                        
                        -- Convert integer part (13 bits)
                        digit1 := to_integer(unsigned(m_axis_dout_tdata(19 downto 7)))/100;
                        digit2 := (to_integer(unsigned(m_axis_dout_tdata(19 downto 7)))/10) mod 10;
                        digit3 := to_integer(unsigned(m_axis_dout_tdata(19 downto 7))) mod 10;
                        
                        -- Convert digits to ASCII
                        output_chars(2) <= std_logic_vector(to_unsigned(48 + digit1, 8));
                        output_chars(3) <= std_logic_vector(to_unsigned(48 + digit2, 8));
                        output_chars(4) <= std_logic_vector(to_unsigned(48 + digit3, 8));
                        output_chars(5) <= X"2E";  -- '.'
                        
                        -- Convert fraction part (7 bits to 3 decimal places)
                        temp_fraction := to_integer(unsigned(m_axis_dout_tdata(6 downto 0)));
                        temp_fraction := (temp_fraction * 1000) / 128;
                        
                        digit1 := temp_fraction/100;
                        digit2 := (temp_fraction/10) mod 10;
                        digit3 := temp_fraction mod 10;
                        
                        output_chars(6) <= std_logic_vector(to_unsigned(48 + digit1, 8));
                        output_chars(7) <= std_logic_vector(to_unsigned(48 + digit2, 8));
                        output_chars(8) <= std_logic_vector(to_unsigned(48 + digit3, 8));
                        output_chars(9) <= X"0D";   -- CR
                        output_chars(10) <= X"0A";  -- LF
                        
                        char_to_send <= 0;
                        current_state <= TRANSMITTING;
                    end if;

                when TRANSMITTING =>
                    if uart_busy = '0' then
                        if char_to_send < MAX_CHARS then
                            uart_data <= output_chars(char_to_send);
                            start_transmission <= '1';
                            char_to_send <= char_to_send + 1;
                        else
                            current_state <= IDLE;
                        end if;
                    else
                        start_transmission <= '0';  -- Clear start signal after UART starts
                    end if;
                    
                when others =>
                    current_state <= IDLE;
            end case;
        end if;
    end process;

    -- UART transmission process
    process(clk_out, reset)
    begin
        if reset = '1' then
            uart_state <= UART_IDLE;
            uart_tx <= '1';  -- Idle high
            uart_busy <= '0';
            bit_counter <= 0;
            clk_counter <= 0;
            
        elsif rising_edge(clk_out) and clk_ready = '1' then
            case uart_state is
                when UART_IDLE =>
                    uart_tx <= '1';  -- Idle high
                    bit_counter <= 0;
                    clk_counter <= 0;
                    
                    if start_transmission = '1' then
                        uart_state <= UART_START_BIT;
                        uart_busy <= '1';
                    end if;
                    
                when UART_START_BIT =>
                    uart_tx <= '0';  -- Start bit
                    if clk_counter = CLKS_PER_BIT - 1 then
                        uart_state <= UART_DATA_BITS;
                        clk_counter <= 0;
                    else
                        clk_counter <= clk_counter + 1;
                    end if;
                    
                when UART_DATA_BITS =>
                    uart_tx <= uart_data(bit_counter);  -- Send data bits
                    if clk_counter = CLKS_PER_BIT - 1 then
                        clk_counter <= 0;
                        if bit_counter = 7 then
                            uart_state <= UART_STOP_BIT;
                        else
                            bit_counter <= bit_counter + 1;
                        end if;
                    else
                        clk_counter <= clk_counter + 1;
                    end if;
                    
                when UART_STOP_BIT =>
                    uart_tx <= '1';  -- Stop bit
                    if clk_counter = CLKS_PER_BIT - 1 then
                        uart_state <= UART_IDLE;
                        uart_busy <= '0';
                    else
                        clk_counter <= clk_counter + 1;
                    end if;
            end case;
        end if;
    end process;

    -- LED indicators with improved debug info
    led_0 <= '1' when current_state = CAPTURING else '0';
    led_1 <= uart_busy;
    led_2 <= '1' when division_timeout = '1' else '0';  -- Fixed boolean comparison
    led_3 <= '1' when capture_done = '1' else '0';     -- Fixed boolean comparison

    -- Output assignments with additional debug info
    dout_tdata <= std_logic_vector(result);
    data_ready <= '1' when (current_state = TRANSMITTING and division_timeout = '0') else '0';  -- Fixed boolean comparison

end Behavioral;