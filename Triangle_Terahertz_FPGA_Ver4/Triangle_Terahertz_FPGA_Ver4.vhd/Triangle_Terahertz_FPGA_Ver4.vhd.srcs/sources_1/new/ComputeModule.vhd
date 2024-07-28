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
        dividend_tvalid : out STD_LOGIC; 
        diviser_tvalid  : out STD_LOGIC;
        dout_tvalid     : out STD_LOGIC;
        dout_tdata      : out STD_LOGIC_VECTOR(12 DOWNTO 0);      
        locked          : OUT STD_LOGIC
    );

end ComputeModule;

architecture Behavioral of ComputeModule is

    signal s: UNSIGNED(63 downto 0) := (others => '0');
    signal p: UNSIGNED(55 downto 0) := (others => '0'); 
    signal i: INTEGER range 0 to 1023 := 0;
    signal A_squared: UNSIGNED(23 downto 0) := (others => '0'); -- Holds squared A value, considering overflow
    signal last_pulse: STD_LOGIC := '0'; -- Signal to hold the previous state of pulse
    signal last_calculate_pulse : STD_LOGIC :='0';
    signal s_axis_divisor_tvalid :  STD_LOGIC := '0';
    signal s_axis_dividend_tvalid :  STD_LOGIC := '0';
    signal s_axis_divisor_tdata:  STD_LOGIC_VECTOR(55 downto 0);
    signal s_axis_dividend_tdata :  STD_LOGIC_VECTOR(63 downto 0);
    signal m_axis_dout_tvalid :  STD_LOGIC := '0';
    signal m_axis_dout_tdata : STD_LOGIC_VECTOR(71 downto 0) := (others => '0');
    signal clock_gen_is_ready : std_logic := '0';
    signal clk_out            : std_logic := '0';   
    type state_type is (IDLE, CALCULATE, WAIT_RESULT, RESET_STATE);
    signal state: state_type := IDLE;  
    
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
    locked <= clock_gen_is_ready;
    process(clk_out)
    begin   
--        if clock_gen_is_ready = '1' then
                if rising_edge(clk_out) then       
                        if reset = '1' then
                            s <= (others => '0');
                            p <= (others => '0');
                            i <= 0;
--                            A_squared <= (others => '0'); -- Reset squared A value
                            last_pulse <= '0'; -- Reset the last_pulse signal
                            s_axis_divisor_tvalid <= '0';
                            s_axis_dividend_tvalid <= '0';
                            state <= IDLE;                            
                        else                       
                            case state is
                                when IDLE =>
                                    if (i = 0) then A_squared <= A * A;  -- Resize to ensure the result fits in A_squared

                                    elsif (pulse = '1' and last_pulse = '0') then
                                        if i < 1023 then
                                            i <= i + 1;
--                                            A_squared <= A * A;  -- Resize to ensure the result fits in A_squared
                                            s <= s + (A_squared * i);
                                            p <= p + A_squared;

                                        end if;
                                    end if;                            
                                    if (calculate_pulse = '1' and last_calculate_pulse = '0') then                                   
                                        s_axis_divisor_tvalid <= '1';
                                        s_axis_dividend_tvalid <= '1';
                                        state <= WAIT_RESULT;
                                    end if;
                                when WAIT_RESULT =>
                                        if m_axis_dout_tvalid = '1' then
                                            dout_tdata <= m_axis_dout_tdata(12 downto 0);
                                            state <= RESET_STATE;
                                        end if;
                                when RESET_STATE =>
                                        s <= (others => '0');
                                        p <= (others => '0');
                                        i <= 0;
                                        A_squared <= (others => '0'); -- Reset squared A value
                                        last_pulse <= '0'; -- Reset the last_pulse signal
                                        s_axis_divisor_tvalid <= '0';
                                        s_axis_dividend_tvalid <= '0';
                                        state <= IDLE;
                                when Others =>
                                        s <=(others => '0');
                            end case;               
                        end if;
                        diviser_tvalid <= s_axis_divisor_tvalid;
                        dividend_tvalid <=s_axis_dividend_tvalid;
                        dout_tvalid <= m_axis_dout_tvalid;
                        last_pulse <= pulse;
                        last_calculate_pulse <= calculate_pulse;            
                end if;
     end process;
end Behavioral;
