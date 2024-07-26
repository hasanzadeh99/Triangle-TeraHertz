library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Triangle_Terahertz_FPGA_Ver3 is
    Port (
        aclk : in STD_LOGIC;
        s_axis_divisor_tvalid : in STD_LOGIC;
        s_axis_divisor_tdata : in STD_LOGIC_VECTOR(15 downto 0);
        s_axis_dividend_tvalid : in STD_LOGIC;
        s_axis_dividend_tdata : in STD_LOGIC_VECTOR(15 downto 0);
        m_axis_dout_tvalid : out STD_LOGIC;
        m_axis_dout_tdata : out STD_LOGIC_VECTOR(31 downto 0)     
        
    );
end Triangle_Terahertz_FPGA_Ver3;

architecture Behavioral of Triangle_Terahertz_FPGA_Ver3 is
   
COMPONENT div_gen_0
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
   

    signal start_internal : STD_LOGIC := '0';
    signal divide_by_zero_signal : STD_LOGIC;
begin


your_instance_name : div_gen_0
  PORT MAP (
  
    aclk => aclk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );
  
  
end Behavioral;

