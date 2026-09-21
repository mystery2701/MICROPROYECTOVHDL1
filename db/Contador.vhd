library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contador is
    Port (
        valor : in  integer range 0 to 9;
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
            when 2 => seg <= "0100100"; 
            when 3 => seg <= "0110000"; 
            when 4 => seg <= "0011001"; 
            when 5 => seg <= "0010010"; 
            when 6 => seg <= "0000010"; 
            when 7 => seg <= "1111000"; 
            when 8 => seg <= "0000000"; 
            when 9 => seg <= "0010000"; 
            when others => seg <= "1111111"; 
        end case;
    end process;
end Comportamental;