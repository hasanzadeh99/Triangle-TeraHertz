library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ComputeModule is

    Port (   
        clk_in         : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        pulse          : in  STD_LOGIC;
        calculate_pulse: in  STD_LOGIC;
        A              : in  UNSIGNED(11 downto 0); -- 12-bit input               
--        dividend_tvalid : out STD_LOGIC; 
--        diviser_tvalid  : out STD_LOGIC;
--        dout_tvalid     : out STD_LOGIC;
        dout_tdata      : out STD_LOGIC_VECTOR(19 DOWNTO 0);      
--        locked          : OUT STD_LOGIC


        data_ready      :out STD_Logic;

        -- Add LED signals as outputs
        led_0          : out STD_LOGIC;
        led_1          : out STD_LOGIC;
        led_2          : out STD_LOGIC;
        led_3          : out STD_LOGIC
        
        
        
    );

end ComputeModule;

architecture Behavioral of ComputeModule is

    signal s: UNSIGNED(63 downto 0) := (others => '0');
    signal p: UNSIGNED(55 downto 0) := (others => '0'); 
--    signal i: INTEGER range 0 to 1024 := 0;
    signal i: unsigned(10 downto 0) := (others => '0');
    signal A_squared: UNSIGNED(23 downto 0) := (others => '0'); -- Holds squared A value, considering overflow
    signal last_pulse: STD_LOGIC := '0'; -- Signal to hold the previous state of pulse
    signal last_calculate_pulse : STD_LOGIC :='0';
    signal s_axis_divisor_tvalid :  STD_LOGIC := '0';
    signal s_axis_dividend_tvalid :  STD_LOGIC := '0';
    signal s_axis_divisor_tdata:  STD_LOGIC_VECTOR(55 downto 0) := (others => '0');
    signal s_axis_dividend_tdata :  STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal m_axis_dout_tvalid :  STD_LOGIC := '0';
    signal m_axis_dout_tdata : STD_LOGIC_VECTOR(71 downto 0) := (others => '0');
    signal clock_gen_is_ready : std_logic := '0';
    signal clk_out            : std_logic := '0';   
    type state_type is (IDLE, CALCULATE, WAIT_RESULT, RESET_STATE);
    signal state: state_type := IDLE;
    
    

    
    constant CLOCK_FREQUENCY : integer := 120000000;  -- 120 MHz clock
    constant HALF_SECOND_CYCLES : integer := CLOCK_FREQUENCY / 2;  -- Number of cycles for 500 ms 
    signal led_state : std_logic := '1';  -- Internal signal to hold LED state
    signal counter   : integer := 0;      -- Counter to keep track of clock cycles
--    signal clock_counter : integer range 0 to 1000 := 0;  -- Counter for 1000 cycles
    signal temp : UNSIGNED (11 downto 0);
   
    
        -- Signals for internal logic
    signal internal_led_0 : STD_LOGIC := '1';
    signal internal_led_1 : STD_LOGIC := '0';
    signal internal_led_2 : STD_LOGIC := '1';
    signal internal_led_3 : STD_LOGIC := '0';
    signal internal_led_signal : std_logic_vector(3 downto 0);
    
    
    signal flag_data_ready : STD_LOGIC := '0'; -- Intermediate signal
    signal data_ready_sig : STD_LOGIC := '0'; -- Intermediate signal
    
------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_0
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(55 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(71 DOWNTO 0)   
  );
END COMPONENT;

component clk_wiz_0
port(

    clk_out          : out    std_logic;
    reset            : in     std_logic;
    locked           : out    std_logic;
    clk_in           : in     std_logic
    
 );
end component;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------
begin
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
divider_ip_instance : div_gen_0
  PORT MAP (
    aclk => clk_out,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => std_logic_vector(p), -- Pad MSBs with 7 '0's to match 56 bits
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => std_logic_vector(s), -- Convert to STD_LOGIC_VECTOR
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
 );

 your_instance_name : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out => clk_out,
  -- Status and control signals                
   reset => reset,
   locked => clock_gen_is_ready,
   -- Clock in ports
   clk_in => clk_in
 );
 


 -- INST_TAG_END ------ End INSTANTIATION Template ---------
--    locked <= clock_gen_is_ready;
    A_squared <= A * A; 
--    A_squared <= x"71B8E4";
--    A_squared <= to_unsigned(16777025, 24); -- Max value of A^2 for 12-bit A

    data_ready <= data_ready_sig;

    
    process(clk_out,reset)
    begin  
    
    
        if (reset = '1') then  -- When reset input is asserted (active-high)
                    
            s <= (others => '0');
            p <= (others => '0');
            i <= "00000000000";  -- Using numeric_std

            last_pulse <= '0';                     -- Reset the last_pulse signal
            s_axis_divisor_tvalid <= '0';
            s_axis_dividend_tvalid <= '0';
            state <= IDLE;
            
        elsif rising_edge(clk_out) then
           
            if clock_gen_is_ready = '1' then
           
                            case state is
                                when IDLE =>         
                                                                                                                                 
--                                    if counter = HALF_SECOND_CYCLES - 1 then
--                                        counter   <= 0;           -- Reset counter                                       
--                                        internal_led_0 <= not internal_led_0;  -- Toggle LED 0
--                                        internal_led_1 <= not internal_led_1;  -- Toggle LED 1
--                                        internal_led_2 <= not internal_led_2;  -- Toggle LED 2
--                                        internal_led_3 <= not internal_led_3;  -- Toggle LED 3  
                                        
--                                        dout_tdata <= std_logic_vector(to_unsigned(3968, 20)); -- Convert integer to unsigned and then to std_logic_vector
                              
--                                    else
--                                        counter <= counter + 1;   -- Increment counter
--                                    end if;
                                                                                                                                       
                           
                                    if (calculate_pulse = '1' and last_calculate_pulse = '0') then  flag_data_ready <= '1' ;    end if;
    
                                    if (flag_data_ready = '1' and pulse = '1' and last_pulse = '0') then 
                                         
                                         data_ready_sig <= NOT data_ready_sig;

                                        if i <= 1022 then
                                        
--                                            if(i = 100) then
--                                                 A_squared <= x"01B8E4";
                                                
--                                            else     A_squared <= x"000000";
                               
--                                            end if;

                                            i <= i + 1;
                                            s <= s + (A_squared * i);       
                                            p <= p + A_squared;
                                      
                                      end if;
                                      


                                    
                                   end if;
                                                                               
                                                                     
                                    if(i= 1023) then                                      
                                        s_axis_divisor_tvalid <= '1';
                                        s_axis_dividend_tvalid <= '1';
                                        i <= "00000000000";
                                        flag_data_ready <= '0';
                                        state <= WAIT_RESULT;
                                    end if;
                                    
                                when WAIT_RESULT =>
                                
                                        if m_axis_dout_tvalid = '1' then
                                        
                                            dout_tdata <= m_axis_dout_tdata(19 downto 0);
--                                            dout_tdata <= "11111000000000000111";
--                                            dout_tdata <= std_logic_vector(A_squared(19 downto 0));         
--                                            dout_tdata <= std_logic_vector(s(19 downto 0));  
                                                   
                                            state <= RESET_STATE;    
                                            
                                            internal_led_0 <=  '1' ;
                                            internal_led_1 <=  '1' ;
                                            internal_led_2 <=  '1' ;
                                            internal_led_3 <=  '0' ;
                       
                                        
                                        end if;
                                when RESET_STATE =>
                                                               


                                        s <= (others => '0');
                                        p <= (others => '0');
                                        i <= "00000000000";
   --                                     A_squared <= (others => '0'); -- Reset squared A value
                                        last_pulse <= '0'; -- Reset the last_pulse signal
                                        s_axis_divisor_tvalid <= '0';
                                        s_axis_dividend_tvalid <= '0';
                                        state <= IDLE;
                                when Others =>


                                        s <=(others => '0');
                            end case;               

                        last_pulse <= pulse;
                        last_calculate_pulse <= calculate_pulse;            
            end if;
     
        end if;
             
     end process;

        led_0 <= internal_led_0;
        led_1 <= internal_led_1;
        led_2 <= internal_led_2;
        led_3 <= internal_led_3; 

end Behavioral;
