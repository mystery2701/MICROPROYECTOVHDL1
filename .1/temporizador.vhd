library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity temporizador is
    Port (
        clk_50mhz, reset, sensor : in  STD_LOGIC;
        alarma, felicita         : out STD_LOGIC;
        disp_b_d, disp_b_u       : out STD_LOGIC_VECTOR(6 downto 0);
        disp_e_d, disp_e_u       : out STD_LOGIC_VECTOR(6 downto 0)
    );
end temporizador;

architecture Estructural of temporizador is
    component control is
        Port ( 
            clk_50mhz, clk_1hz, reset, sensor : in STD_LOGIC; 
            alarma_led, felicita_led : out STD_LOGIC; 
            b_d, b_u, e_d, e_u : out integer range 0 to 9 
        );
    end component;
    
    component contador is
        Port ( valor : in integer range 0 to 9; seg : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;

    signal clk_1hz_int : STD_LOGIC := '0';
    signal cont_divisor: integer range 0 to 24999999 := 0;
    signal n_bd, n_bu, n_ed, n_eu : integer range 0 to 9;
begin

    
    process(clk_50mhz) begin
        if rising_edge(clk_50mhz) then
            if cont_divisor = 24999999 then 
                cont_divisor <= 0; 
                clk_1hz_int <= not clk_1hz_int;
            else 
                cont_divisor <= cont_divisor + 1; 
            end if;
        end if;
    end process;

    
    CEREBRO: control port map (
        clk_50mhz    => clk_50mhz,
        clk_1hz      => clk_1hz_int, 
        reset        => reset, 
        sensor       => sensor, 
        alarma_led   => alarma, 
        felicita_led => felicita, 
        b_d=>n_bd, b_u=>n_bu, e_d=>n_ed, e_u=>n_eu
    );
    
    D1: contador port map (valor=>n_bd, seg=>disp_b_d);
    D2: contador port map (valor=>n_bu, seg=>disp_b_u);
    D3: contador port map (valor=>n_ed, seg=>disp_e_d);
    D4: contador port map (valor=>n_eu, seg=>disp_e_u);
end Estructural;