library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity BlankROM is
generic (
	addrbits : integer :=14;
	databits : integer :=8
);
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(addrbits-1 downto 0);
	data : out std_logic_vector(databits-1 downto 0);
	dl_addr : in std_logic_vector(addrbits-1 downto 0);
	dl_data : in std_logic_vector(databits-1 downto 0);
	dl_wr : in std_logic
);
end entity;

architecture rtl of BlankROM is
	type rom is array(0 to ((2**addrbits)-1)) of std_logic_vector(databits-1 downto 0);
	signal rom_data: rom;
begin

process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;

process(clk)
begin
	if rising_edge(clk) then
		if dl_wr='1' then
			rom_data(to_integer(unsigned(dl_addr))) <= dl_data;
		end if;
	end if;
end process;

end architecture;
