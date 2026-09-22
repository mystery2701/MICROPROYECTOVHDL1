library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity topmultiboton is
    Port (
        clk, start, stop, reset : in  STD_LOGIC;
        disp_min, disp_secd, disp_secu : out STD_LOGIC_VECTOR(6 downto 0)
    );
end topmultiboton;

architecture Estructural of topmultiboton is
    component control2 is
        Port ( clk, en_1hz, btn_start, btn_stop, btn_reset : in STD_LOGIC; v_min, v_secd, v_secu : out integer range 0 to 9 );
    end component;
    component contador is
        Port ( valor : in integer range 0 to 9; seg : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;

    signal en_1hz_int : STD_LOGIC := '0';
    signal cont_clk   : integer range 0 to 49999999 := 0;
    signal n_min, n_sd, n_su : integer range 0 to 9;
begin
    process(clk) begin
        if rising_edge(clk) then
            if cont_clk = 49999999 then cont_clk <= 0; en_1hz_int <= '1';
            else cont_clk <= cont_clk + 1; en_1hz_int <= '0'; end if;
        end if;
    end process;

    CEREBRO: control2 port map (clk=>clk, en_1hz=>en_1hz_int, btn_start=>start, btn_stop=>stop, btn_reset=>reset, v_min=>n_min, v_secd=>n_sd, v_secu=>n_su);
    D1: contador port map (valor=>n_min, seg=>disp_min);
    D2: contador port map (valor=>n_sd, seg=>disp_secd);
    D3: contador port map (valor=>n_su, seg=>disp_secu);
end Estructural;