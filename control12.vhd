library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control2 is
    Port (
        clk, en_1hz, btn_start, btn_stop, btn_reset : in  STD_LOGIC;
        v_min, v_secd, v_secu : out integer range 0 to 9
    );
end control2;

architecture Behavioral of control2 is
    signal corriendo : std_logic := '0';
    signal min, sd, su : integer range 0 to 9 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_reset = '0' then -- Lógica activa en bajo para la DE0
                corriendo <= '0'; min <= 0; sd <= 0; su <= 0;
            else
                if btn_start = '0' then corriendo <= '1'; end if;
                if btn_stop = '0' then corriendo <= '0'; end if;
                
                if en_1hz = '1' and corriendo = '1' then
                    if su = 9 then su <= 0;
                        if sd = 5 then sd <= 0;
                            if min /= 9 then min <= min + 1; end if;
                        else sd <= sd + 1; end if;
                    else su <= su + 1; end if;
                end if;
            end if;
        end if;
    end process;
    v_min <= min; v_secd <= sd; v_secu <= su;
end Behavioral;