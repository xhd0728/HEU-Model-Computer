
library ieee;
use ieee.std_logic_1164.all;
entity SHEFT is
  port(clk,m,c0:in std_logic;
              s:in std_logic_vector(1 downto 0);
              d:in std_logic_vector(7 downto 0);
              q:out std_logic_vector(7 downto 0);
              cn:out std_logic);
end entity;
architecture behav of SHEFT is
  signal abc:std_logic_vector(2 downto 0);
begin
  abc<=s&m;
process(clk,s)
	variable reg8: std_logic_vector (8 downto 0);
	variable cy : std_logic;
begin
	if clk'event and clk = '1' then
		if abc = "000" or abc = "001" then --保持
			reg8:=reg8;
		end if;
		if abc= "010" then  --循环左移
			cy:=reg8(7);
			reg8(8 downto 1) :=reg8(7 downto 0);
			reg8(0):=cy;
		end if;
		if abc = "011" then  --带进位循环左移
			reg8(8 downto 1) := reg8(7 downto 0);
			reg8(0):=c0;
		end if;
		if abc = "100" then  --循环右移
			cy := reg8(0);
			reg8( 6 downto 0) :=reg8(7 downto 1);
			reg8(8):=cy;
			reg8(7):=cy;
		end if;
		if abc = "101" then --带进位循环右移
			cy:=reg8(0);
			reg8(6 downto 0):=reg8(7 downto 1);
			reg8(7):=c0;
			reg8(8):=cy;
		end if;
		if abc ="110" or abc="111" then --装数
			reg8(7 downto 0):=d(7 downto 0);
		end if;
	end if;
	q(7 downto 0) <= reg8(7 downto 0);
	cn<=reg8(8);
	end process;
end behav;