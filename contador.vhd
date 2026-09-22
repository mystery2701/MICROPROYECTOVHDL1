library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador is
    Port (
        clk_50mhz      : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        alarma_led     : out STD_LOGIC
    );
end contador;

architecture Estructural of contador is

    
    component contador is
        Port ( 
            clk        : in  STD_LOGIC; 
            reset      : in  STD_LOGIC; 
            alarma_led : out STD_LOGIC 
        );
    end component;

    signal clk_1hz_int : STD_LOGIC := '0';

begin
    -- ERROR AQUÍ en el port map: Intentando mapear un nombre que no está en el componente
    MODULO_CONTROL: control_tiempos port map (
        clk_1hz    => clk_1hz_int, 
        reset      => reset,
        alarma_led => alarma_led
    );
end Estructural;