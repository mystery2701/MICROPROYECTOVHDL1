library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity temporizador is
    Port (
        clk               : in  STD_LOGIC;
        reset             : in  STD_LOGIC;
        sensor_persona    : in  STD_LOGIC;
        alarma_led        : out STD_LOGIC;
        felicita_led      : out STD_LOGIC;
        display_base_dec  : out STD_LOGIC_VECTOR(6 downto 0); 
        display_base_uni  : out STD_LOGIC_VECTOR(6 downto 0);
        display_extra_dec : out STD_LOGIC_VECTOR(6 downto 0);
        display_extra_uni : out STD_LOGIC_VECTOR(6 downto 0)
    );
end temporizador;

architecture Estructural of top_espacio is

    component control_tiempos is
        Port ( clk_1hz, reset, sensor_persona : in STD_LOGIC;
               alarma_led, felicita_led       : out STD_LOGIC;
               b_dec, b_uni, e_dec, e_uni     : out integer range 0 to 9 );
    end component;

    
    component contador is
        Port ( valor : in integer range 0 to 9; seg : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;

    signal clk_1hz_int : STD_LOGIC := '0';
    signal cont_clk    : integer range 0 to 25000000 := 0;
    signal num_b_d, num_b_u, num_e_d, num_e_u : integer range 0 to 9;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if cont_clk = 25000000 then cont_clk <= 0; clk_1hz_int <= not clk_1hz_int;
            else cont_clk <= cont_clk + 1; end if;
        end if;
    end process;

    MODULO_CONTROL: temporizador port map (
        clk_1hz => clk_1hz_int, reset => reset, sensor_persona => sensor_persona,
        alarma_led => alarma_led, felicita_led => felicita_led,
        b_dec => num_b_d, b_uni => num_b_u, e_dec => num_e_d, e_uni => num_e_u
    );

    
    DISP_B_DEC: contador port map (valor => num_b_d, seg => display_base_dec);
    DISP_B_UNI: contador port map (valor => num_b_u, seg => display_base_uni);
    DISP_E_DEC: contador port map (valor => num_e_d, seg => display_extra_dec);
    DISP_E_UNI: contador port map (valor => num_e_u, seg => display_extra_uni);

end Estructural;