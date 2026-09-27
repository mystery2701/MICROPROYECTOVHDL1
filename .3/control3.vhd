library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control3 is
    Port (
        clk_50mhz : in  STD_LOGIC;
        btn       : in  STD_LOGIC;
        v_min     : out integer range 0 to 9;
        v_secd    : out integer range 0 to 9;
        v_secu    : out integer range 0 to 9
    );
end control3;

architecture Behavioral of control3 is
  
    signal div_1ms    : integer range 0 to 49999 := 0;
    
    
    signal btn_hold   : integer range 0 to 2500 := 0;
    
    
    signal cont_1seg  : integer range 0 to 49999999 := 0;
    
    
    signal estado_num : integer range 0 to 1 := 0;
    signal reset_num  : integer range 0 to 1 := 0;
    
    signal min, sd, su : integer range 0 to 9 := 0;

begin
    process(clk_50mhz)
    begin
        if rising_edge(clk_50mhz) then

           
            if div_1ms < 49999 then
                div_1ms <= div_1ms + 1;
            else
                div_1ms <= 0; 
                
                if btn = '0' then 
                 
                    if btn_hold < 2500 then
                        btn_hold <= btn_hold + 1;
                    end if;
                    
                   
                    if btn_hold = 30 then
                        if estado_num = 0 then
                            estado_num <= 1; 
                        else
                            estado_num <= 0;
                        end if;
                    end if;
                    
                   
                    if btn_hold = 2000 then
                        reset_num <= 1;
                        estado_num <= 0; 
                    end if;
                    
                else
                
                    btn_hold <= 0;
                    reset_num <= 0;
                end if;
            end if;

            if reset_num = 1 then
                min <= 0; sd <= 0; su <= 0;
                cont_1seg <= 0;
            elsif estado_num = 1 then
                if cont_1seg = 49999999 then
                    cont_1seg <= 0;
                    if su = 9 then
                        su <= 0;
                        if sd = 5 then
                            sd <= 0;
                            if min /= 9 then min <= min + 1; end if;
                        else
                            sd <= sd + 1;
                        end if;
                    else
                        su <= su + 1;
                    end if;
                else
                    cont_1seg <= cont_1seg + 1;
                end if;
            end if;

        end if;
    end process;

    v_min <= min; 
    v_secd <= sd; 
    v_secu <= su;
    
end Behavioral;