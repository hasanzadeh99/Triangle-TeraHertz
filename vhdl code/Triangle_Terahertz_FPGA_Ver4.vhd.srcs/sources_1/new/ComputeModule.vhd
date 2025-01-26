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
        -- Status LEDs
        led_0           : out STD_LOGIC;
        led_1           : out STD_LOGIC;
        led_2           : out STD_LOGIC;
        led_3           : out STD_LOGIC
    );
end ComputeModule;

architecture Behavioral of ComputeModule is
    -- Internal signals for calculation
    signal s                      : UNSIGNED(63 downto 0);
    signal p                      : UNSIGNED(55 downto 0);
    signal i                      : UNSIGNED(10 downto 0);
    signal A_squared              : UNSIGNED(23 downto 0);
    
    -- Control signals
    signal last_pulse            : STD_LOGIC := '0';
    signal last_calculate_pulse  : STD_LOGIC := '0';
    signal calculation_active    : STD_LOGIC := '0';
    signal data_ready_internal   : STD_LOGIC := '0';
    
    -- LED control signals
    signal led_0_reg            : STD_LOGIC := '0';
    signal led_1_reg            : STD_LOGIC := '0';
    signal led_2_reg            : STD_LOGIC := '0';
    signal led_3_reg            : STD_LOGIC := '0';
    
    -- Clock and reset signals
    signal clk_out              : STD_LOGIC;
    signal clock_gen_ready      : STD_LOGIC;
    
    -- Divider interface signals
    signal divisor_valid        : STD_LOGIC;
    signal dividend_valid       : STD_LOGIC;
    signal divisor_data         : STD_LOGIC_VECTOR(55 downto 0);
    signal dividend_data        : STD_LOGIC_VECTOR(63 downto 0);
    signal dout_valid          : STD_LOGIC;
    signal dout_data           : STD_LOGIC_VECTOR(71 downto 0);
    
    -- State machine definition
    type state_type is (IDLE, ACCUMULATE, DIVIDE, OUTPUT);
    signal state               : state_type;

    -- Component declarations
    component div_gen_0
        port (
            aclk                    : in  STD_LOGIC;
            s_axis_divisor_tvalid   : in  STD_LOGIC;
            s_axis_divisor_tdata    : in  STD_LOGIC_VECTOR(55 downto 0);
            s_axis_dividend_tvalid  : in  STD_LOGIC;
            s_axis_dividend_tdata   : in  STD_LOGIC_VECTOR(63 downto 0);
            m_axis_dout_tvalid     : out STD_LOGIC;
            m_axis_dout_tdata      : out STD_LOGIC_VECTOR(71 downto 0)
        );
    end component;

    component clk_wiz_0
        port (
            clk_out    : out STD_LOGIC;
            reset      : in  STD_LOGIC;
            locked     : out STD_LOGIC;
            clk_in     : in  STD_LOGIC
        );
    end component;

begin
    -- Component instantiations
    divider: div_gen_0
        port map (
            aclk                    => clk_out,
            s_axis_divisor_tvalid   => divisor_valid,
            s_axis_divisor_tdata    => divisor_data,
            s_axis_dividend_tvalid  => dividend_valid,
            s_axis_dividend_tdata   => dividend_data,
            m_axis_dout_tvalid     => dout_valid,
            m_axis_dout_tdata      => dout_data
        );

    clock_gen: clk_wiz_0
        port map (
            clk_out    => clk_out,
            reset      => reset,
            locked     => clock_gen_ready,
            clk_in     => clk_in
        );

    -- Continuous assignments
    

    
    
    A_squared <= A * A;
    divisor_data <= std_logic_vector(p);
    dividend_data <= std_logic_vector(s);
    data_ready <= data_ready_internal;
    
    -- Connect LED registers to outputs
    led_0 <= led_0_reg;
    led_1 <= led_1_reg;
    led_2 <= led_2_reg;
    led_3 <= led_3_reg;

    -- Main process
    process(clk_out, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            s <= (others => '0');
            p <= (others => '0');
            i <= (others => '0');
            calculation_active <= '0';
            data_ready_internal <= '0';
            divisor_valid <= '0';
            dividend_valid <= '0';
            
            -- Reset LED registers
            led_0_reg <= '0';
            led_1_reg <= '0';
            led_2_reg <= '0';
            led_3_reg <= '0';
            
        elsif rising_edge(clk_out) and clock_gen_ready = '1' then
            -- Default assignments
            last_pulse <= pulse;
            last_calculate_pulse <= calculate_pulse;
            
            case state is
                when IDLE =>
                    if calculate_pulse = '1' and last_calculate_pulse = '0' then
                        calculation_active <= '1';
                        state <= ACCUMULATE;
                        -- Initialize calculation variables
                        s <= (others => '0');
                        p <= (others => '0');
                        i <= (others => '0');
                        led_0_reg <= '1'; -- Indicate calculation started
                    end if;

                when ACCUMULATE =>
                    if pulse = '1' and last_pulse = '0' and calculation_active = '1' then
                        if i <= 1023 then
                        
                            i <= i + 1;
                            s <= s + (A_squared * i);
                            p <= p + A_squared;
                            led_1_reg <= not led_1_reg; -- Toggle to show activity
                        else
                            state <= DIVIDE;
                            divisor_valid <= '1';
                            dividend_valid <= '1';
                            led_2_reg <= '1'; -- Indicate division started
                        end if;
                    end if;

                when DIVIDE =>
                    if dout_valid = '1' then
--                        dout_tdata <= dout_data(19 downto 0);
                        dout_tdata <= std_logic_vector(resize(A, 20));

                        data_ready_internal <= not data_ready_internal;
                        state <= OUTPUT;
                        led_3_reg <= '1'; -- Indicate result ready
                    end if;

                when OUTPUT =>
                    -- Reset for next calculation
                    divisor_valid <= '0';
                    dividend_valid <= '0';
                    calculation_active <= '0';
                    state <= IDLE;
                    -- Reset LEDs for next cycle
                    led_0_reg <= '0';
                    led_1_reg <= '0';
                    led_2_reg <= '0';
                    led_3_reg <= '0';
            end case;
        end if;
    end process;

end Behavioral;