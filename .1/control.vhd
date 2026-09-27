library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is
Port (
clk_50mhz    : in  STD_LOGIC;
clk_1hz      : in  STD_LOGIC;
reset        : in  STD_LOGIC;
sensor       : in  STD_LOGIC;
alarma_led   : out STD_LOGIC;
felicita_led : out STD_LOGIC;
b_d, b_u, e_d, e_u : out integer range 0 to 9
);
end control;

architecture Behavioral of control is
    signal bd, bu, ed, eu : integer range 0 to 9 := 0;
begin
process(clk_50mhz, reset)
begin
if reset = '0' then
alarma_led <= '0';
felicita_led <= '0';
        elsif rising_edge(clk_50mhz) then
            if sensor = '1' then
                felicita_led <= '0';
                if bd = 3 and bu = 5 then alarma_led <= '1'; else alarma_led <= '0'; end if;
            else
                alarma_led <= '0';
                if (bd > 0 or bu > 0) and not (bd = 3 and bu = 5) then
                    felicita_led <= '1';
                end if;
            end if;
        end if;
    end process;

    process(clk_1hz, reset)
    begin
        if reset = '0' then
            bu <= 0; bd <= 0; eu <= 0; ed <= 0;
        elsif rising_edge(clk_1hz) then
            if sensor = '1' then
                if bd = 3 and bu = 5 then
                    if eu = 9 then eu <= 0;
                        if ed /= 9 then ed <= ed + 1; end if;
                    else eu <= eu + 1; end if;
                else
                    if bu = 9 then bu <= 0; bd <= bd + 1;
                    else bu <= bu + 1; end if;
                end if;
   else
bu <= 0; bd <= 0; eu <= 0; ed <= 0;
  end if;
 end if;
end process;
    
    b_d <= bd; b_u <= bu; e_d <= ed; e_u <= eu;
end Behavioral;