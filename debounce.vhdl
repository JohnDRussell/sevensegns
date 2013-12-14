library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity Debounce is
    port(cclk       :   in std_logic;
          inp    :  in std_logic_vector(3 downto 0);
          cclr  :  in std_logic;
          db     :  out std_logic_vector(3 downto 0)
         );
end Debounce;

architecture behavioral_2 of Debounce is
    signal delay1, delay2, delay3 : std_logic_vector(3 downto 0);
begin
    process (cclk, cclr)
    begin
        if cclr = '1' then
            delay1 <= "0000";
            delay2 <= "0000";
            delay3 <= "0000";
        elsif rising_edge(cclk) then
            delay1 <= inp;
            delay2 <= delay1;
            delay3 <= delay2;
        end if;
    end process;
    db <= delay1 and delay2 and delay3;
end behavioral_2;

