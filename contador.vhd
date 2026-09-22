library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador is
    Port (
        valor : in  integer range 0 to 9  -- ERROR AQUÍ
        seg   : out STD_LOGIC_VECTOR(6 downto 0)
    );
end contador;

architecture Comportamental of contador is
begin
    process(valor)
    begin
        case valor is
            when 0 => seg <= "1000000"; 
            when 1 => seg <= "1111001"; 
            when others => seg <= "1111111"; 
        end case;
    end process;
end Comportamental;