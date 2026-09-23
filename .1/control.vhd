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
    type estado_tipo is (LIBRE, OCUPADO, EXCESO);
    signal estado : estado_tipo := LIBRE;
    
    signal base_rst, extra_rst : std_logic := '1';
    signal limite_alcanzado : std_logic := '0';
    signal bd, bu, ed, eu : integer range 0 to 9 := 0;
begin

    
    process(clk_50mhz, reset)
    begin
        if reset = '0' then
            estado <= LIBRE;
            alarma_led <= '0';
            felicita_led <= '0';
            base_rst <= '1';
            extra_rst <= '1';
        elsif rising_edge(clk_50mhz) then
            case estado is
                when LIBRE =>
                    base_rst <= '1'; 
                    extra_rst <= '1';
                    alarma_led <= '0';
                    if sensor = '1' then
                        estado <= OCUPADO;
                        felicita_led <= '0';
                        base_rst <= '0'; 
                    end if;
                    
                when OCUPADO =>
                    if sensor = '0' then
                        estado <= LIBRE;
                        felicita_led <= '1'; 
                        base_rst <= '1';
                    elsif limite_alcanzado = '1' then
                        estado <= EXCESO;
                        alarma_led <= '1';   
                        extra_rst <= '0';    
                    end if;
                    
                when EXCESO =>
                    if sensor = '0' then
                        estado <= LIBRE;
                        alarma_led <= '0';
                        base_rst <= '1';
                        extra_rst <= '1';
                    end if;
            end case;
        end if;
    end process;

    
    process(clk_1hz, base_rst)
    begin
        if base_rst = '1' then 
            bu <= 0; bd <= 0; limite_alcanzado <= '0';
        elsif rising_edge(clk_1hz) then
            if bd = 3 and bu = 5 then
                limite_alcanzado <= '1';
            else
                if bu = 9 then 
                    bu <= 0; bd <= bd + 1;
                else 
                    bu <= bu + 1; 
                end if;
            end if;
        end if;
    end process;

    process(clk_1hz, extra_rst)
    begin
        if extra_rst = '1' then
            eu <= 0; ed <= 0;
        elsif rising_edge(clk_1hz) then
            if eu = 9 then 
                eu <= 0;
                if ed /= 9 then ed <= ed + 1; end if;
            else 
                eu <= eu + 1; 
            end if;
        end if;
    end process;

    b_d <= bd; b_u <= bu; e_d <= ed; e_u <= eu;
end Behavioral;