library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is
    Port (
        clk_1hz        : in  STD_LOGIC;
        reset          : in  STD_LOGIC;
        alarma_led     : out STD_LOGIC
    );
end control;

architecture Behavioral of control is
begin
    process(clk_1hz, reset)
    begin
        if reset = '0' then
            alarma_led <= '0';
        elsif rising_edge(clk_1hz) then
            -- Lógica simplificada de los 35 segundos para el ejemplo
            alarma_led = '1'; -- ERROR AQUÍ
        end if;
    end process;
end Behavioral;