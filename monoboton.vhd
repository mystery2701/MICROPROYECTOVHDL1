library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity monoboton is
    Port (
        clk, btn : in  STD_LOGIC;
        disp_min, disp_secd, disp_secu : out STD_LOGIC_VECTOR(6 downto 0)
    );
end monoboton;

architecture Estructural of monoboton is
    component control3 is
        Port ( clk, btn : in STD_LOGIC; v_min, v_secd, v_secu : out integer range 0 to 9 );
    end component;
    component contador is
        Port ( valor : in integer range 0 to 9; seg : out STD_LOGIC_VECTOR(6 downto 0) );
    end component;
    signal n_min, n_sd, n_su : integer range 0 to 9;
begin
    CEREBRO: control3 port map (clk=>clk, btn=>btn, v_min=>n_min, v_secd=>n_sd, v_secu=>n_su);
    D1: contador port map (valor=>n_min, seg=>disp_min);
    D2: contador port map (valor=>n_sd, seg=>disp_secd);
    D3: contador port map (valor=>n_su, seg=>disp_secu);
end Estructural;