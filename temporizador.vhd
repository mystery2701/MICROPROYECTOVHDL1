library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity temporizador is
    Port (
        clk_50mhz      : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        alarma_led     : out STD_LOGIC
    );
end temporizador;

architecture Estructural of temporizador is

    component temporizador is
        Port ( 
            clk        : in  STD_LOGIC; 
            reset      : in  STD_LOGIC; 
            alarma_led : out STD_LOGIC 
        );
    end component;

    signal clk_1hz_int : STD_LOGIC := '0';

begin
    
    temporizador: control_tiempos port map (
        clk        => clk_1hz_int, 
        reset      => reset,
        alarma_led => alarma_led
    );
end Estructural;