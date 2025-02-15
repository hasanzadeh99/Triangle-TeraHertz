library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_Test is
    Port ( 
        clk_in  : in  STD_LOGIC;  -- 12MHz clock from CMOD S7
        reset   : in  STD_LOGIC;  -- Active high reset
        uart_tx : out STD_LOGIC;  -- UART TX pin
        led_0   : out STD_LOGIC   -- LED for status
    );
end UART_Test;

architecture Behavioral of UART_Test is
    -- Constants for UART
    constant CLKS_PER_BIT : integer := 1250;    -- 12MHz/9600 baud
    constant TEST_STRING  : std_logic_vector(31 downto 0) := X"74657374"; -- "test"
    constant ONE_SEC     : integer := 12_000_000; -- 1 second at 12MHz
    
    -- State machine
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT, WAIT_INTERVAL);
    signal state : state_type := IDLE;
    
    -- Control signals
    signal bit_counter   : integer range 0 to 7 := 0;
    signal char_counter  : integer range 0 to 3 := 0;
    signal clk_counter   : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal interval_counter : integer range 0 to ONE_SEC := 0;
    signal current_byte  : std_logic_vector(7 downto 0);
    
begin
    -- LED indicates transmission
    led_0 <= '1' when state /= IDLE and state /= WAIT_INTERVAL else '0';
    
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                state <= IDLE;
                uart_tx <= '1';
                bit_counter <= 0;
                char_counter <= 0;
                clk_counter <= 0;
                interval_counter <= 0;
                current_byte <= TEST_STRING(31 downto 24);
                
            else
                case state is
                    when IDLE =>
                        uart_tx <= '1';
                        if char_counter < 4 then
                            state <= START_BIT;
                            clk_counter <= 0;
                            case char_counter is
                                when 0 => current_byte <= TEST_STRING(31 downto 24);
                                when 1 => current_byte <= TEST_STRING(23 downto 16);
                                when 2 => current_byte <= TEST_STRING(15 downto 8);
                                when 3 => current_byte <= TEST_STRING(7 downto 0);
                                when others => null;
                            end case;
                        end if;
                        
                    when START_BIT =>
                        uart_tx <= '0';
                        if clk_counter < CLKS_PER_BIT-1 then
                            clk_counter <= clk_counter + 1;
                        else
                            state <= DATA_BITS;
                            clk_counter <= 0;
                            bit_counter <= 0;
                        end if;
                        
                    when DATA_BITS =>
                        uart_tx <= current_byte(bit_counter);
                        if clk_counter < CLKS_PER_BIT-1 then
                            clk_counter <= clk_counter + 1;
                        else
                            clk_counter <= 0;
                            if bit_counter < 7 then
                                bit_counter <= bit_counter + 1;
                            else
                                state <= STOP_BIT;
                            end if;
                        end if;
                        
                    when STOP_BIT =>
                        uart_tx <= '1';
                        if clk_counter < CLKS_PER_BIT-1 then
                            clk_counter <= clk_counter + 1;
                        else
                            clk_counter <= 0;
                            if char_counter < 3 then
                                char_counter <= char_counter + 1;
                                state <= IDLE;
                            else
                                char_counter <= 0;
                                state <= WAIT_INTERVAL;
                                interval_counter <= 0;
                            end if;
                        end if;

                    when WAIT_INTERVAL =>
                        uart_tx <= '1';
                        if interval_counter < ONE_SEC - 1 then
                            interval_counter <= interval_counter + 1;
                        else
                            interval_counter <= 0;
                            state <= IDLE;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
end Behavioral;