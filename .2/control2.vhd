library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control2 is
    Port (
        clk_50mhz : in  STD_LOGIC; 
        clk_1hz   : in  STD_LOGIC; 
        btn_start : in  STD_LOGIC;
        btn_stop  : in  STD_LOGIC;
        btn_reset : in  STD_LOGIC;
        v_min, v_secd, v_secu : out integer range 0 to 9
    );
end control2;

architecture Behavioral of control2 is
    signal corriendo : std_logic := '0';
    signal min, sd, su : integer range 0 to 9 := 0;
begin

    -- PROCESO RÁPIDO: Lee los botones 50 millones de veces por segundo
    process(clk_50mhz, btn_reset)
    begin
        if btn_reset = '0' then -- Reinicio asíncrono (actúa al instante)
            corriendo <= '0';
        elsif rising_edge(clk_50mhz) then
            if btn_start = '0' then 
                corriendo <= '1'; 
            elsif btn_stop = '0' then 
                corriendo <= '0'; 
            end if;
        end if;
    end process;

    -- PROCESO LENTO: Mueve el cronómetro usando el reloj literal de 1 Hz
    process(clk_1hz, btn_reset)
    begin
        if btn_reset = '0' then
            min <= 0; sd <= 0; su <= 0;
        elsif rising_edge(clk_1hz) then
            if corriendo = '1' then
                if su = 9 then su <= 0;
                    if sd = 5 then sd <= 0;
                        if min /= 9 then min <= min + 1; end if;
                    else sd <= sd + 1; end if;
                else su <= su + 1; end if;
            end if;
        end if;
    end process;
    
    v_min <= min; v_secd <= sd; v_secu <= su;
end Behavioral;