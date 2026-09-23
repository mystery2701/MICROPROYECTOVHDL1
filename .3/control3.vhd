library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control3 is
    Port (
        clk, btn : in  STD_LOGIC;
        v_min, v_secd, v_secu : out integer range 0 to 9
    );
end control3;

architecture Behavioral of control3 is
    signal cont_1ms : integer range 0 to 49999 := 0;
    signal en_1ms, en_1s : std_logic := '0';
    signal cont_1s : integer range 0 to 999 := 0;
    signal btn_estado, btn_prev, estado_run, reset_sig : std_logic := '0';
    signal cont_presion : integer range 0 to 2500 := 0;
    signal min, sd, su : integer range 0 to 9 := 0;
begin
    process(clk) begin
        if rising_edge(clk) then
            if cont_1ms = 49999 then cont_1ms <= 0; en_1ms <= '1'; else cont_1ms <= cont_1ms + 1; en_1ms <= '0'; end if;
            if en_1ms = '1' then if cont_1s = 999 then cont_1s <= 0; en_1s <= '1'; else cont_1s <= cont_1s + 1; en_1s <= '0'; end if; else en_1s <= '0'; end if;
        end if;
    end process;

    process(clk) begin
        if rising_edge(clk) then
            if en_1ms = '1' then
                btn_prev <= btn_estado; btn_estado <= not btn;
                if btn_estado = '1' then
                    if cont_presion < 2500 then cont_presion <= cont_presion + 1; end if;
                    if cont_presion = 2000 then reset_sig <= '1'; estado_run <= '0'; else reset_sig <= '0'; end if;
                else
                    reset_sig <= '0';
                    if btn_prev = '1' and cont_presion > 20 and cont_presion < 2000 then estado_run <= not estado_run; end if;
                    cont_presion <= 0;
                end if;
            end if;
        end if;
    end process;

    process(clk) begin
        if rising_edge(clk) then
            if reset_sig = '1' then min <= 0; sd <= 0; su <= 0;
            elsif en_1s = '1' and estado_run = '1' then
                if su = 9 then su <= 0;
                    if sd = 5 then sd <= 0; if min /= 9 then min <= min + 1; end if; else sd <= sd + 1; end if;
                else su <= su + 1; end if;
            end if;
        end if;
    end process;
    v_min <= min; v_secd <= sd; v_secu <= su;
end Behavioral;