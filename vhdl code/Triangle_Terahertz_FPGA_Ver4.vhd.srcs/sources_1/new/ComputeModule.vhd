library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_system is
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        uart_tx_pin   : out STD_LOGIC;
        -- Debug LEDs
        led_0         : out STD_LOGIC;
        led_1         : out STD_LOGIC;
        led_2         : out STD_LOGIC;
        led_3         : out STD_LOGIC
    );
end uart_system;

architecture Behavioral of uart_system is
    -- Constants for UART configuration
    constant CLK_FREQ    : integer := 100_000_000;  -- 100 MHz
    constant BAUD_RATE   : integer := 115_200;
    constant BIT_PERIOD  : integer := CLK_FREQ / BAUD_RATE;
    
    -- UART transmitter states
    type uart_state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal uart_state : uart_state_type := IDLE;
    
    -- UART control signals
    signal tx_start      : STD_LOGIC := '0';
    signal tx_busy       : STD_LOGIC := '0';
    signal tx_done       : STD_LOGIC := '0';
    signal tx_data       : STD_LOGIC_VECTOR(7 downto 0) := x"41"; -- Default 'A'
    signal uart_tx_reg   : STD_LOGIC := '1';  -- Internal register for UART TX
    
    -- Counters and internal registers
    signal bit_counter   : integer range 0 to 7 := 0;
    signal period_counter: integer range 0 to BIT_PERIOD-1 := 0;
    signal tx_data_reg   : STD_LOGIC_VECTOR(7 downto 0);
    
    -- Test pattern signals
    signal send_counter  : integer range 0 to CLK_FREQ := 0;  -- 1-second counter
    signal test_pattern  : STD_LOGIC_VECTOR(31 downto 0) := x"41424344"; -- "ABCD"
    signal pattern_index : integer range 0 to 3 := 0;

begin
    -- Connect internal register to output pin
    uart_tx_pin <= uart_tx_reg;

    -- Main UART transmission process
    process(clk, reset)
    begin
        if reset = '1' then
            uart_state <= IDLE;
            uart_tx_reg <= '1';  -- Line idle state is high
            tx_busy <= '0';
            tx_done <= '0';
            bit_counter <= 0;
            period_counter <= 0;
            led_0 <= '0';
            led_1 <= '0';
            led_2 <= '0';
            led_3 <= '0';
            
        elsif rising_edge(clk) then
            -- Default LED states
            led_0 <= tx_busy;      -- Shows when transmitting
            led_1 <= uart_tx_reg;  -- Shows actual UART output
            led_2 <= '0';
            led_3 <= tx_done;      -- Pulses when byte is sent
            
            case uart_state is
                when IDLE =>
                    uart_tx_reg <= '1';
                    tx_done <= '0';
                    
                    if tx_start = '1' then
                        uart_state <= START_BIT;
                        tx_data_reg <= tx_data;
                        tx_busy <= '1';
                        period_counter <= 0;
                        led_2 <= '1';  -- Indicates start of new byte
                    end if;

                when START_BIT =>
                    uart_tx_reg <= '0';
                    
                    if period_counter < BIT_PERIOD-1 then
                        period_counter <= period_counter + 1;
                    else
                        uart_state <= DATA_BITS;
                        period_counter <= 0;
                        bit_counter <= 0;
                    end if;

                when DATA_BITS =>
                    uart_tx_reg <= tx_data_reg(bit_counter);
                    
                    if period_counter < BIT_PERIOD-1 then
                        period_counter <= period_counter + 1;
                    else
                        period_counter <= 0;
                        
                        if bit_counter < 7 then
                            bit_counter <= bit_counter + 1;
                        else
                            uart_state <= STOP_BIT;
                        end if;
                    end if;

                when STOP_BIT =>
                    uart_tx_reg <= '1';
                    
                    if period_counter < BIT_PERIOD-1 then
                        period_counter <= period_counter + 1;
                    else
                        uart_state <= IDLE;
                        tx_busy <= '0';
                        tx_done <= '1';
                    end if;
            end case;
        end if;
    end process;

    -- Test pattern generation process
    process(clk, reset)
    begin
        if reset = '1' then
            send_counter <= 0;
            pattern_index <= 0;
            tx_start <= '0';
            
        elsif rising_edge(clk) then
            tx_start <= '0';  -- Default state
            
            if tx_busy = '0' then  -- Only start new transmission when not busy
                if send_counter < CLK_FREQ/4 then  -- Send every 0.25 seconds
                    send_counter <= send_counter + 1;
                else
                    send_counter <= 0;
                    tx_data <= test_pattern(31-8*pattern_index downto 24-8*pattern_index);
                    tx_start <= '1';
                    
                    if pattern_index < 3 then
                        pattern_index <= pattern_index + 1;
                    else
                        pattern_index <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;