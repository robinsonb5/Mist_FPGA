
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity dacwrap is
	port (
		clk_i   : in  std_logic;
		res_n_i : in  std_logic;
		dac_i   : in  std_logic_vector(9 downto 0);
		dac_o   : out std_logic
	);
end entity;

architecture rtl of dacwrap is
begin
	dacinst : entity work.dac
	generic map (
		c_bits => 10
	)
	port map (
		clk_i => clk_i,
		res_n_i => res_n_i,
		dac_i => dac_i,
		dac_o => dac_o
	);

end rtl;
