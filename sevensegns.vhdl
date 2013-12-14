-----------------------------------------
---- SevenSegNS.vhdl
---- Seven segment driver with 4 input
---- buttons

---- Author: Derby Russell
---- Date: 12-13-2013
-----------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity main_7_seg is
     port(b1,b2,b3,b4 : in std_logic;
          clk         : in std_logic;
          sseg        : out std_logic_vector(0 to 6);
          anodes      : out std_logic_vector (3 downto 0);
          reset       : in std_logic
          );
end main_7_seg;

architecture behavioral of main_7_seg is
    signal bcd1, bcd2, bcd3, bcd4 : unsigned (3 downto 0) := "0000";
    signal clk2 : std_logic := '0';
    signal pushbuttons : std_logic_vector(3 downto 0) := "0000";
    signal db_pushbuttons : std_logic_vector(3 downto 0) := "0000";
    signal counter : unsigned (1 downto 0) := "00";
    component Debounce is
        port( cclk : in std_logic;
                inp : in std_logic_vector(3 downto 0);
                cclr : in std_logic;
                db  : out std_logic_vector(3 downto 0)
                );
    end component;
begin
    pushbuttons <= b4 & b3 & b2 & b1;
    Db : Debounce port map
            ( cclk => clk2,
              inp => pushbuttons,
              cclr => reset,
              db  => db_pushbuttons);

-----------------------------------------
---- To actually use this code on
---- an FPGA processor, the clock below
---- needs to be restored to the 
---- commentted out code.
---- 
-----------------------------------------
process (clk)
begin
    -- Comment the next four lines
    -- for actually running the code
    -- on real hardware.
    if rising_edge(clk) then
        clk2 <= '1';
    else
        clk2 <= '0';

    -- Uncomment the next 6 lines
    -- for actually running the code
    -- on real hardware.
    --    if clk_divider <= "1100001101010000" then
    --        clk_divider <= clk_divider + 1;
    --        clk2 <= '0';
    --    else
    --        clk_divider <= (others => '0');
    --        clk2 <= '1';
    end if;
end process;

P2: process (clk2, reset)
begin
    if reset = '1' then
        -- do something here
        bcd1 <= "0000";
        bcd2 <= "0000";
        bcd3 <= "0000";
        bcd4 <= "0000";
    elsif rising_edge(clk2) then
        counter <= counter + 1;
        if db_pushbuttons(0) = '1' then -- db_b1
            if bcd1 <= "0010" then
                if bcd1 = "0000" then
                    bcd1 <= bcd1 + 1;
                end if;
            else
                bcd1 <= "0000";
            end if;
        elsif db_pushbuttons(1) = '1' then -- db_b2
            if bcd2 <= "0010" then
                if bcd2 = "0000" then
                    bcd2 <= bcd2 + 1;
                end if;
            else
                bcd2 <= "0000";
            end if;
        elsif db_pushbuttons(2) = '1' then -- db_b3
            if bcd3 <= "0010" then
                if bcd3 = "0000" then
                    bcd3 <= bcd3 + 1;
                end if;
            else
                bcd3 <= "0000";
            end if;
        elsif db_pushbuttons(3) = '1' then --db_b4
            if bcd4 <= "0010" then
                if bcd4 = "0000" then
                    bcd4 <= bcd4 + 1;
                end if;
            else
                bcd4 <= "0000";
            end if;
        end if;
    end if;
end process P2;

P3: process (counter, bcd1, bcd2, bcd3, bcd4)
    variable display : unsigned (3 downto 0);
begin
    case counter is
        when "00" => anodes <= "1110"; display := bcd1;
        when "01" => anodes <= "1101"; display := bcd2;
        when "10" => anodes <= "1011"; display := bcd3;
        when "11" => anodes <= "0111"; display := bcd4;
        when others => null;
    end case;

    case display is
        when "0000" => sseg <= "0000001"; --0
        when "0001" => sseg <= "1001111"; --1
        when "0010" => sseg <= "0010010"; --2
        when "0011" => sseg <= "0000110"; --3
        when "0100" => sseg <= "1001100"; --4
        when "0101" => sseg <= "0100100"; --5
        when "0110" => sseg <= "0100000"; --6
        when "0111" => sseg <= "0001111"; --7
        when "1000" => sseg <= "0000000"; --8
        when "1001" => sseg <= "0000100"; --9
        when others => sseg <= "0010000"; --e, represents error
    end case;
end process P3;
end behavioral;



