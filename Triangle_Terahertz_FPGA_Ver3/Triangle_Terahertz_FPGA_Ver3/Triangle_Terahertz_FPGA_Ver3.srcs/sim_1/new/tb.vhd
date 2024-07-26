----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/16/2024 11:41:03 PM
-- Design Name: 
-- Module Name: tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity tb is

end tb;

architecture tb of tb is
    -- Signals for UUT
    signal aclk : STD_LOGIC := '0';
    signal s_axis_divisor_tvalid : STD_LOGIC := '0';
    signal s_axis_divisor_tdata : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal s_axis_dividend_tvalid : STD_LOGIC := '0';
    signal s_axis_dividend_tdata : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal m_axis_dout_tvalid : STD_LOGIC;
    signal m_axis_dout_tdata : STD_LOGIC_VECTOR(31 downto 0);

    -- UUT
    component Triangle_Terahertz_FPGA_Ver3
    port(
        aclk : in STD_LOGIC;
        s_axis_divisor_tvalid : inout STD_LOGIC;
        s_axis_divisor_tdata : in STD_LOGIC_VECTOR(15 downto 0);
        s_axis_dividend_tvalid : inout STD_LOGIC;
        s_axis_dividend_tdata : in STD_LOGIC_VECTOR(15 downto 0);
        m_axis_dout_tvalid : inout STD_LOGIC;
        m_axis_dout_tdata : out STD_LOGIC_VECTOR(31 downto 0)
    );
    end component;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: Triangle_Terahertz_FPGA_Ver3 port map (
        aclk => aclk,
        s_axis_divisor_tvalid => s_axis_divisor_tvalid,
        s_axis_divisor_tdata => s_axis_divisor_tdata,
        s_axis_dividend_tvalid => s_axis_dividend_tvalid,
        s_axis_dividend_tdata => s_axis_dividend_tdata,
        m_axis_dout_tvalid => m_axis_dout_tvalid,
        m_axis_dout_tdata => m_axis_dout_tdata
    );

    -- Clock process
    clk_process: process
    begin
        aclk <= '0';
        wait for 10 ns;
        aclk <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        s_axis_divisor_tvalid <= '1';
        s_axis_divisor_tdata <= std_logic_vector(to_unsigned(2, s_axis_divisor_tdata'length));
        s_axis_dividend_tvalid <= '1';
        s_axis_dividend_tdata <= std_logic_vector(to_unsigned(30, s_axis_dividend_tdata'length));
        wait for 200 ns;

        s_axis_divisor_tvalid <= '0'; -- End of operation
        s_axis_dividend_tvalid <= '0';
        wait for 1000 ns;

        -- Finish simulation
        wait;
    end process;
end tb;
        
