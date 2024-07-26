library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ComputeModule is
    Port (
    
    
        clk_in            : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        pulse          : in  STD_LOGIC;
        calculate_pulse: in  STD_LOGIC;
        A              : in  UNSIGNED(11 downto 0); -- 12-bit input
--        result         : out UNSIGNED(95 downto 0);   -- 87-bit output, for simplicity, treated as fixed-point 
        
        LED            : out STD_LOGIC;
        
        
        dividend_tvalid : out STD_LOGIC; 
        diviser_tvalid : out STD_LOGIC;
        dout_tvalid :  out STD_LOGIC;
        dout_tdata : out STD_LOGIC_VECTOR(71 DOWNTO 0)
        

        
    );
end ComputeModule;




architecture Behavioral of ComputeModule is
    signal s: UNSIGNED(63 downto 0) := (others => '0');
    signal p: UNSIGNED(55 downto 0) := (others => '0');
    
    signal i: INTEGER range 0 to 1023 := 0;
--    signal A_squared: UNSIGNED(23 downto 0) := (others => '0'); -- Holds squared A value, considering overflow
    signal last_pulse: STD_LOGIC := '0'; -- Signal to hold the previous state of pulse
    signal s_axis_divisor_tvalid :  STD_LOGIC := '0';
    signal s_axis_dividend_tvalid :  STD_LOGIC := '0';
    signal s_axis_divisor_tdata:  STD_LOGIC_VECTOR(55 downto 0);
    signal s_axis_dividend_tdata :  STD_LOGIC_VECTOR(63 downto 0);
    signal m_axis_dout_tvalid :  STD_LOGIC := '0';
--    signal m_axis_dout_tdata : STD_LOGIC_VECTOR(71 downto 0);

    signal clk_out : STD_LOGIC := '0';
    
    
    signal LED_Delay    : unsigned(25 downto 0) :=  (others=>'0');
    signal LED_Int      : std_logic             :=   '0';

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
port
 (-- Clock in ports
--   Clock out ports
  clk_out          : out    std_logic;
  clk_in           : in     std_logic
 );
end component;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------

 
--     Signals for interfacing with the div_gen_0
--    signal s_axis_divisor_tvalid, s_axis_dividend_tvalid, m_axis_dout_tvalid : STD_LOGIC := '0';
--    signal s_axis_divisor_tdata, s_axis_dividend_tdata : STD_LOGIC_VECTOR(55 downto 0);
    signal m_axis_dout_tdata : STD_LOGIC_VECTOR(71 downto 0); -- Adjust based on actual IP's output width
 
 
 
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
  
  
 
 clock_wizard_instance : clk_wiz_0
   port map ( 
--   Clock out ports  
   clk_out => clk_out,
--    Clock in ports
   clk_in => clk_in
 );
 
 


-- INST_TAG_END ------ End INSTANTIATION Template ---------

--    s_axis_divisor_tvalid <= '1';
--    s_axis_dividend_tvalid <= '1';

--    LED     <=      LED_Int;


--    process(clk_out)
--    begin
--        if rising_edge(clk_out) then
        
--            LED_Delay   <=  LED_Delay+1;
--            LED_Int     <=  LED_Delay(25);
        
--            diviser_tvalid <= s_axis_divisor_tvalid;
--            dout_tdata <= m_axis_dout_tdata;
--            dividend_tvalid <=s_axis_dividend_tvalid;
--            dout_tvalid <= m_axis_dout_tvalid;
----             Update the last_pulse signal
--            last_pulse <= pulse;
--            A_squared <= A * A; -- Directly use A
--            A_squared <= to_unsigned(102, A_squared'length);


--            if reset = '1' then
--                s <= (others => '0');
--                p <= (others => '0');
--                i <= 0;
--                A_squared <= (others => '0'); -- Reset squared A value
----                result <= (others => '0');
--                last_pulse <= '0'; -- Reset the last_pulse signal
                
                

                
                
--            else
--                -- Execute once for each pulse
--                if pulse = '1' and last_pulse = '0' then
--                    if i < 1023 then
--                        i <= i + 1;
--                        s <= s + (A_squared * i);
--                        p <= p + A_squared;
--                    end if;
--                end if;
                
                
                
--                -- Trigger division when calculate_pulse is asserted
--                if calculate_pulse = '1' then
--                    s<=s*1000;
--                    s_axis_dividend_tvalid <= '1'; -- Indicate dividend is valid
--                    s_axis_divisor_tvalid <= '1'; -- Indicate divisor is valid
--                else
--                    s_axis_dividend_tvalid <= '0';
--                    s_axis_divisor_tvalid <= '0';
--                end if;
                
                
--            end if;
            
            
--            -- Handling division result
----            if m_axis_dout_tvalid = '1' then
----                result <= unsigned(m_axis_dout_tdata);
----            end if;
            
--        end if;
--    end process;
end Behavioral;
