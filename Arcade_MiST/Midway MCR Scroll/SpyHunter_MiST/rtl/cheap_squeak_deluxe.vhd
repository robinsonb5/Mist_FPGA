-- Midway Cheap Squeak Deluxe sound board

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.fx68k.all;

entity cheap_squeak_deluxe is
port(
	clock_40     : in std_logic;
	reset        : in std_logic;
	input        : in std_logic_vector(7 downto 0);
	rom_addr     : out std_logic_vector(14 downto 1);
	rom_do       : in std_logic_vector(15 downto 0);
	audio_out    : out std_logic_vector(9 downto 0)
);
end cheap_squeak_deluxe;

architecture rtl of cheap_squeak_deluxe is

signal cpu_ce1      : std_logic;
signal cpu_ce2      : std_logic;
signal cpu_ce_count : std_logic_vector( 4 downto 0);
signal cpu_addr     : std_logic_vector(23 downto 1);
signal cpu_rw       : std_logic;
signal cpu_irq      : std_logic;
signal cpu_data_in  : std_logic_vector(15 downto 0);
signal cpu_data_out : std_logic_vector(15 downto 0);
signal cpu_as_n     : std_logic;
signal cpu_lds_n    : std_logic;
signal cpu_uds_n    : std_logic;
signal cpu_dtack_n  : std_logic;
signal cpu_vpa_n    : std_logic;
signal cpu_fc       : std_logic_vector( 2 downto 0);
signal cpu_ipl2_N   : std_logic;
signal cpu_sel      : std_logic;

signal pia_data_out : std_logic_vector( 7 downto 0);
signal pia_pa_in    : std_logic_vector( 7 downto 0);
signal pia_pa_out   : std_logic_vector( 7 downto 0);
signal pia_pa_oe    : std_logic_vector( 7 downto 0);
signal pia_pb_in    : std_logic_vector( 7 downto 0);
signal pia_pb_out   : std_logic_vector( 7 downto 0);
signal pia_pb_oe    : std_logic_vector( 7 downto 0);
signal pia_ca1_in   : std_logic;
signal pia_ca2_out  : std_logic;
signal pia_cb1_in   : std_logic;
signal pia_cb2_out  : std_logic;
signal pia_irqa     : std_logic;
signal pia_irqb     : std_logic;

signal cs_rom       : std_logic;
signal cs_ram       : std_logic;
signal cs_pia       : std_logic;

signal ram_we       : std_logic;
signal ram_data_out : std_logic_vector(15 downto 0);

signal romd1        : std_logic;
signal romd         : std_logic;
signal rom_addr_out : std_logic_vector(14 downto 1);
signal rom_addr_old : std_logic_vector(14 downto 1);

begin

fx68k_inst: fx68k
port map (
	clk       => clock_40,
	extReset  => reset,
	pwrUp     => reset,
	enPhi1    => cpu_ce1,
	enPhi2    => cpu_ce2,

	eRWn      => cpu_rw,
	ASn       => cpu_as_n,
	LDSn      => cpu_lds_n,
	UDSn      => cpu_uds_n,
	E         => open,
	VMAn      => open,
	FC0       => cpu_fc(0),
	FC1       => cpu_fc(1),
	FC2       => cpu_fc(2),
	BGn       => open,
	oRESETn   => open,
	oHALTEDn  => open,
	DTACKn    => cpu_dtack_n,
	VPAn      => cpu_vpa_n,
	BERRn     => '1',
	BRn       => '1',
	BGACKn    => '1',
	IPL0n     => '1',
	IPL1n     => '1',
	IPL2n     => cpu_ipl2_n,
	iEdb      => cpu_data_in,
	oEdb      => cpu_data_out,
	eab       => cpu_addr
);

-- U6
u_wram : entity work.gen_ram
generic map( dWidth => 8, aWidth => 11)
port map(
	clk  => clock_40,
	we   => ram_we and not cpu_uds_n,
	addr => cpu_addr(11 downto 1),
	d    => cpu_data_out(15 downto 8),
	q    => ram_data_out(15 downto 8)
);

-- U16
l_wram : entity work.gen_ram
generic map( dWidth => 8, aWidth => 11)
port map(
	clk  => clock_40,
	we   => ram_we and not cpu_lds_n,
	addr => cpu_addr(11 downto 1),
	d    => cpu_data_out(7 downto 0),
	q    => ram_data_out(7 downto 0)
);

-- U9
pia6821 : entity work.pia6821
port map (
	clk => clock_40,
	rst => reset,
	cs  => cs_pia,
	rw  => cpu_rw,
	addr => cpu_addr(1)&cpu_addr(2), -- wired in reverse order
	data_in => cpu_data_out(15 downto 8),
	data_out => pia_data_out,
	irqa => pia_irqa,
	irqb => pia_irqb,
	pa_i => pia_pa_in,
	pa_o => pia_pa_out,
	pa_oe => open,
	ca1 => pia_ca1_in,
	ca2_i => '0',
	ca2_o => open,
	ca2_oe => open,
	pb_i => pia_pb_in,
	pb_o => pia_pb_out,
	pb_oe => open,
	cb1 => pia_cb1_in,
	cb2_i => '0',
	cb2_o => open,
	cb2_oe => open
);

-- clock enable generation: 40/5 = 8 MHz effective clock (original: 7.5 MHz)
process (clock_40, reset)
begin
	if reset = '1' then
		cpu_ce1 <= '0';
		cpu_ce2 <= '0';
		cpu_ce_count <= (others => '0');
	elsif rising_edge(clock_40) then
		cpu_ce1 <= '0';
		cpu_ce2 <= '0';
		cpu_ce_count <= cpu_ce_count + 1;
		if cpu_ce_count = 2 then
			cpu_ce1 <= '1';
		end if;
		if cpu_ce_count = 4 then
			cpu_ce2 <= '1';
			cpu_ce_count <= (others => '0');
		end if;
	end if;
end process;

process (clock_40, reset)
begin
	if reset = '1' then
		rom_addr_old <= (others => '1');
	elsif rising_edge(clock_40) then

		rom_addr_old <= rom_addr_out;

		-- ROMD signal - DTACK_N delay for ROM access
		if cpu_as_n = '1' then
			romd1 <= '0';
			romd <= '0';
		elsif cpu_ce1 = '1' then
			romd1 <= '1';
			romd <= romd1;
		end if;
	end if;
end process;

cpu_sel <= '1' when cpu_as_n = '0' and (cpu_uds_n = '0' or cpu_lds_n = '0') else '0';
cpu_dtack_n <= not ((cs_rom and romd) or cs_ram or cs_pia);

-- auto-vectored interrupt handling
cpu_vpa_n <= '0' when cpu_fc = "111" else '1';
cpu_ipl2_n <= not (pia_irqa or pia_irqb);

cs_rom <= '1' when cpu_sel = '1' and cpu_addr(16 downto 15) = "00" else '0';
cs_ram <= '1' when cpu_sel = '1' and cpu_addr(16 downto 14) = "111" else '0';
-- PIA uses 6800 bus cycle originally with VMA, VPA and E clock
cs_pia <= '1' when cpu_sel = '1' and cpu_addr(16 downto 14) = "110" else '0';

ram_we <= '1' when cs_ram = '1' and cpu_rw = '0' else '0';

cpu_data_in <= rom_do when cs_rom = '1' else
               ram_data_out when cs_ram = '1' else
               pia_data_out&x"FF" when cs_pia = '1' else
               (others => '1');

rom_addr_out <= cpu_addr(14 downto 1) when cs_rom = '1' else rom_addr_old;
rom_addr <= rom_addr_out;

audio_out <= pia_pa_out(7 downto 0)&pia_pb_out(7 downto 6);
pia_pb_in(5 downto 0) <= "00"&input(3 downto 0); -- stat1-stat0, sr3-sr0
pia_ca1_in <= not input(4); -- sirq
pia_pa_in <= pia_pa_out;
pia_cb1_in <= '0'; -- spare


end rtl;
