library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ComputeModule is
    Port (
        clk_in            : in  STD_LOGIC;
        reset             : in  STD_LOGIC;
        pulse             : in  STD_LOGIC;
        calculate_pulse   : in  STD_LOGIC;
        A                 : in  UNSIGNED(11 downto 0); -- 12-bit input
        
        LED               : out STD_LOGIC;
        
        dividend_tvalid   : in  STD_LOGIC; -- Changed to input
        diviser_tvalid    : in  STD_LOGIC; -- Changed to input
        dout_tvalid       : out STD_LOGIC;
        dout_tdata        : out STD_LOGIC_VECTOR(71 DOWNTO 0)
    );
end ComputeModule;
