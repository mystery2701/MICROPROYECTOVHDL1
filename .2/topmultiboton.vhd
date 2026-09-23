library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity topmultiboton is
    Port (
        clk_50mhz, start, stop, reset : in  STD_LOGIC;
        disp_min, disp_secd, disp_secu: out STD_LOGIC_VECTOR(6 downto 0)
    );
end topmultiboton;

architecture Estructural of topmultiboton is
    component control2 is
        Port ( 
            clk_50mhz, clk_1hz, btn_start, btn_stop, btn_reset : in STD_LOGIC; 
            v_min, v_secd, v_secu : out integer range 0 to 9 
        );
    end component;
    
    component contador is
        Port ( valor : in integer range 0 to 9; seg : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;

    signal clk_1hz_int : STD_LOGIC := '0';
    signal cont_divisor: integer range 0 to 24999999 := 0;
    signal n_min, n_sd, n_su : integer range 0 to 9;
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

    
    CEREBRO: control2 port map (
        clk_50mhz => clk_50mhz, 
        clk_1hz   => clk_1hz_int, 
        btn_start => start, 
        btn_stop  => stop, 
        btn_reset => reset, 
        v_min     => n_min, 
        v_secd    => n_sd, 
        v_secu    => n_su
    );
    
    D1: contador port map (valor=>n_min, seg=>disp_min);
    D2: contador port map (valor=>n_sd, seg=>disp_secd);
    D3: contador port map (valor=>n_su, seg=>disp_secu);
end Estructural;