library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control is
    Port (
        clk            : in  STD_LOGIC; 
        reset          : in  STD_LOGIC;
        sensor_persona : in  STD_LOGIC;
        alarma_led     : out STD_LOGIC;
        felicita_led   : out STD_LOGIC;
        b_dec          : out integer range 0 to 9;
        b_uni          : out integer range 0 to 9; 
        e_dec          : out integer range 0 to 9;
        e_uni          : out integer range 0 to 9  
    );
end control;

architecture Behavioral of control is
    type estado_tipo is (LIBRE, OCUPADO_LIMITE, EXCESO_TIEMPO);
    signal estado_actual : estado_tipo := LIBRE;
    signal base_d, base_u, extra_d, extra_u : integer range 0 to 9 := 0;
begin
    process(clk, reset)
    begin
    if reset = '0' then
    estado_actual <= LIBRE;
    base_d <= 0; base_u <= 0; extra_d <= 0; extra_u <= 0;
    alarma_led <= '0'; felicita_led <= '0';
     elsif rising_edge(clk) then
    case estado_actual is
     when LIBRE =>
      base_d <= 0; base_u <= 0; extra_d <= 0; extra_u <= 0;
      alarma_led <= '0';
      if sensor_persona = '1' then
      estado_actual <= OCUPADO_LIMITE;
      felicita_led <= '0';
       end if;

       when OCUPADO_LIMITE =>
       if sensor_persona = '0' then
       estado_actual <= LIBRE;
       felicita_led <= '1';
    else
    if base_d = 3 and base_u = 5 then
    estado_actual <= EXCESO_TIEMPO;
    else
    if base_u = 9 then 
    base_u <= 0; base_d <= base_d + 1;
    else 
    base_u <= base_u + 1; 
    end if;
    end if;
    end if;

    when EXCESO_TIEMPO =>
    alarma_led <= '1';
    if sensor_persona = '0' then
    estado_actual <= LIBRE;
                    else
    if extra_u = 9 then 
    extra_u <= 0;
    if extra_d /= 9 then extra_d <= extra_d + 1; end if;
    else 
    extra_u <= extra_u + 1; 
    end if;
    end if;
    end case;
    end if;
    end process;
    
    b_dec <= base_d; 
    b_uni <= base_u; 
    e_dec <= extra_d; 
    e_uni <= extra_u;
end Behavioral;