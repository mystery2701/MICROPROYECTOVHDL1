library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
    Port (
        clk : in STD_LOGIC;
        btn : in STD_LOGIC; 
        ssd_min : out STD_LOGIC_VECTOR(6 downto 0); 
        ssd_sec_tens : out STD_LOGIC_VECTOR(6 downto 0); 
        ssd_sec_units : out STD_LOGIC_VECTOR(6 downto 0) 
    );
end contador;

architecture Behavioral of contador is
    signal min_count : integer range 0 to 9 := 0;
    signal sec_t_count : integer range 0 to 5 := 0;
    signal sec_u_count : integer range 0 to 9 := 0;
    signal running : boolean := false;

    signal btn_counter : integer range 0 to 3 := 0;
    signal btn_prev : STD_LOGIC := '0';

    function decode_7seg(bcd : integer) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        case bcd is
            when 0 => seg := "0111111"; 
            when 1 => seg := "0000110"; 
            when 2 => seg := "1011011"; 
            when 3 => seg := "1001111"; 
            when 4 => seg := "1100110"; 
            when 5 => seg := "1101101"; 
            when 6 => seg := "1111101"; 
            when 7 => seg := "0000111"; 
            when 8 => seg := "1111111"; 
            when 9 => seg := "1101111"; 
            when others => seg := "0000000";
        end case;
        return seg;
    end function;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn = '1' then
                if btn_counter < 3 then
                    btn_counter <= btn_counter + 1;
                end if;

                if btn_counter >= 2 then 
                    min_count <= 0;
                    sec_t_count <= 0;
                    sec_u_count <= 0;
                    running <= false;
                end if;
            else
                if btn_prev = '1' and btn_counter > 0 and btn_counter < 2 then
                    running <= not running;
                end if;
                btn_counter <= 0; 
            end if;

            btn_prev <= btn;

            if running = true and btn_counter < 2 then
                if sec_u_count = 9 then
                    sec_u_count <= 0;
                    if sec_t_count = 5 then
                        sec_t_count <= 0;
                        if min_count = 9 then
                            min_count <= 0; 
                        else
                            min_count <= min_count + 1;
                        end if;
                    else
                        sec_t_count <= sec_t_count + 1;
                    end if;
                else
                    sec_u_count <= sec_u_count + 1;
                end if;
            end if;
        end if;
    end process;

    ssd_min <= decode_7seg(min_count);
    ssd_sec_tens <= decode_7seg(sec_t_count);
    ssd_sec_units <= decode_7seg(sec_u_count);

end Behavioral;