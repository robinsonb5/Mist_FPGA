library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity skyskip_ch_bits is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(10 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of skyskip_ch_bits is
	type rom is array(0 to  2047) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"00",X"1C",X"32",X"63",X"63",X"63",X"26",X"1C",X"00",X"18",X"1C",X"18",X"18",X"18",X"18",X"7E",
		X"00",X"3E",X"63",X"70",X"3C",X"1E",X"07",X"7F",X"00",X"7E",X"30",X"18",X"3C",X"60",X"63",X"3E",
		X"00",X"38",X"3C",X"36",X"33",X"7F",X"30",X"30",X"00",X"3F",X"03",X"3F",X"60",X"60",X"63",X"3E",
		X"00",X"3C",X"06",X"03",X"3F",X"63",X"63",X"3E",X"00",X"7F",X"63",X"30",X"18",X"0C",X"0C",X"0C",
		X"00",X"1E",X"23",X"27",X"1C",X"7B",X"61",X"3E",X"00",X"3E",X"63",X"63",X"7E",X"60",X"30",X"1E",
		X"00",X"1C",X"36",X"63",X"63",X"7F",X"63",X"63",X"00",X"3F",X"63",X"63",X"3F",X"63",X"63",X"3F",
		X"00",X"3C",X"66",X"03",X"03",X"03",X"66",X"3C",X"00",X"1F",X"33",X"63",X"63",X"63",X"33",X"1F",
		X"00",X"7E",X"06",X"06",X"3E",X"06",X"06",X"7E",X"00",X"7F",X"03",X"03",X"3F",X"03",X"03",X"03",
		X"00",X"7C",X"06",X"03",X"73",X"63",X"66",X"7C",X"00",X"63",X"63",X"63",X"7F",X"63",X"63",X"63",
		X"00",X"7E",X"18",X"18",X"18",X"18",X"18",X"7E",X"00",X"60",X"60",X"60",X"60",X"60",X"63",X"3E",
		X"00",X"63",X"33",X"1B",X"0F",X"1F",X"3B",X"73",X"00",X"06",X"06",X"06",X"06",X"06",X"06",X"7E",
		X"00",X"63",X"77",X"7F",X"7F",X"6B",X"63",X"63",X"00",X"63",X"67",X"6F",X"7F",X"7B",X"73",X"63",
		X"00",X"3E",X"63",X"63",X"63",X"63",X"63",X"3E",X"00",X"3F",X"63",X"63",X"63",X"3F",X"03",X"03",
		X"00",X"3E",X"63",X"63",X"63",X"7B",X"33",X"5E",X"00",X"3F",X"63",X"63",X"73",X"1F",X"3B",X"73",
		X"00",X"1E",X"33",X"03",X"3E",X"60",X"63",X"3E",X"00",X"7E",X"18",X"18",X"18",X"18",X"18",X"18",
		X"00",X"63",X"63",X"63",X"63",X"63",X"63",X"3E",X"00",X"63",X"63",X"63",X"77",X"3E",X"1C",X"08",
		X"00",X"63",X"63",X"6B",X"7F",X"7F",X"36",X"22",X"00",X"63",X"77",X"3E",X"1C",X"3E",X"77",X"63",
		X"00",X"66",X"66",X"24",X"3C",X"18",X"18",X"18",X"00",X"7F",X"70",X"38",X"1C",X"0E",X"07",X"7F",
		X"00",X"40",X"20",X"10",X"08",X"04",X"02",X"01",X"00",X"00",X"00",X"18",X"18",X"10",X"10",X"08",
		X"00",X"00",X"00",X"00",X"00",X"18",X"18",X"00",X"00",X"63",X"55",X"49",X"22",X"22",X"14",X"08",
		X"00",X"08",X"49",X"2A",X"1C",X"2A",X"49",X"08",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"24",X"12",X"36",X"36",X"00",X"00",X"00",X"00",X"6C",X"6C",X"48",X"24",X"00",X"00",X"00",
		X"00",X"00",X"00",X"DE",X"96",X"9E",X"86",X"86",X"00",X"00",X"00",X"3B",X"09",X"39",X"21",X"B9",
		X"00",X"00",X"00",X"3E",X"36",X"3E",X"06",X"3E",X"00",X"3C",X"2C",X"2C",X"0C",X"3E",X"0C",X"0C",
		X"00",X"00",X"00",X"00",X"3E",X"36",X"36",X"3E",X"30",X"36",X"3E",X"00",X"00",X"00",X"00",X"00",
		X"00",X"06",X"06",X"06",X"3E",X"36",X"36",X"36",X"00",X"00",X"18",X"00",X"18",X"18",X"18",X"18",
		X"00",X"00",X"30",X"00",X"30",X"30",X"30",X"30",X"36",X"36",X"3E",X"00",X"00",X"00",X"00",X"00",
		X"00",X"06",X"06",X"06",X"36",X"1E",X"36",X"36",X"00",X"08",X"18",X"18",X"18",X"18",X"18",X"18",
		X"00",X"00",X"06",X"7E",X"56",X"56",X"56",X"56",X"00",X"00",X"06",X"3E",X"36",X"36",X"36",X"36",
		X"00",X"00",X"00",X"3E",X"36",X"36",X"36",X"3E",X"00",X"00",X"00",X"00",X"3E",X"36",X"36",X"3E",
		X"06",X"06",X"06",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"3E",X"36",X"36",X"3E",
		X"30",X"30",X"30",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"36",X"3E",X"06",X"06",X"06",
		X"00",X"00",X"00",X"3E",X"06",X"3E",X"30",X"3E",X"00",X"00",X"00",X"0C",X"1E",X"0C",X"2C",X"3C",
		X"00",X"00",X"00",X"36",X"36",X"36",X"36",X"7E",X"00",X"00",X"00",X"36",X"36",X"36",X"36",X"1C",
		X"00",X"00",X"00",X"5A",X"5A",X"5A",X"7E",X"66",X"00",X"00",X"00",X"36",X"1C",X"08",X"1C",X"36",
		X"00",X"00",X"00",X"00",X"36",X"36",X"36",X"3E",X"30",X"36",X"3E",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"3E",X"30",X"1C",X"06",X"3E",X"08",X"04",X"00",X"3C",X"30",X"3E",X"36",X"7E",
		X"00",X"00",X"3C",X"30",X"30",X"3E",X"36",X"7E",X"00",X"06",X"06",X"06",X"3E",X"36",X"36",X"3E",
		X"00",X"00",X"00",X"3E",X"26",X"06",X"26",X"3E",X"00",X"30",X"30",X"30",X"3E",X"36",X"36",X"3E",
		X"08",X"10",X"00",X"3E",X"36",X"3E",X"06",X"3E",X"08",X"14",X"00",X"3E",X"36",X"3E",X"06",X"3E",
		X"00",X"22",X"00",X"3E",X"36",X"3E",X"06",X"3E",X"08",X"04",X"00",X"3E",X"36",X"36",X"36",X"3E",
		X"08",X"14",X"00",X"3E",X"36",X"36",X"36",X"3E",X"00",X"22",X"00",X"3E",X"36",X"36",X"36",X"3E",
		X"08",X"10",X"00",X"36",X"36",X"36",X"36",X"7E",X"08",X"14",X"00",X"36",X"36",X"36",X"36",X"7E",
		X"00",X"22",X"00",X"36",X"36",X"36",X"36",X"7E",X"00",X"3C",X"42",X"99",X"85",X"99",X"42",X"3C",
		X"00",X"00",X"00",X"00",X"3E",X"00",X"00",X"00",X"00",X"36",X"36",X"7F",X"36",X"36",X"7F",X"36",
		X"00",X"1C",X"22",X"22",X"18",X"08",X"00",X"08",X"00",X"60",X"70",X"38",X"18",X"04",X"01",X"03",
		X"00",X"08",X"18",X"08",X"04",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"0C",X"0C",
		X"00",X"00",X"4C",X"4C",X"4C",X"4C",X"7C",X"38",X"00",X"00",X"0F",X"1B",X"1B",X"1B",X"0F",X"03",
		X"FF",X"FF",X"50",X"5C",X"50",X"50",X"1C",X"1C",X"FF",X"FF",X"99",X"99",X"99",X"99",X"99",X"11",
		X"FF",X"FF",X"87",X"E7",X"87",X"87",X"E7",X"87",X"FF",X"FF",X"2E",X"24",X"20",X"2A",X"2E",X"2E",
		X"FF",X"FF",X"0C",X"99",X"99",X"9C",X"9F",X"9F",X"FF",X"FF",X"ED",X"ED",X"E1",X"F3",X"F3",X"F3",
		X"00",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",
		X"00",X"41",X"01",X"03",X"03",X"7F",X"3F",X"0F",X"00",X"82",X"80",X"C0",X"C0",X"FE",X"FC",X"F0",
		X"E0",X"E0",X"70",X"30",X"18",X"0C",X"00",X"01",X"07",X"07",X"0E",X"0C",X"18",X"30",X"00",X"80",
		X"00",X"00",X"08",X"00",X"01",X"01",X"2F",X"07",X"00",X"00",X"10",X"00",X"80",X"80",X"F4",X"E0",
		X"C0",X"E0",X"60",X"10",X"00",X"04",X"00",X"00",X"03",X"07",X"06",X"08",X"00",X"20",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"01",X"09",X"07",X"00",X"00",X"00",X"00",X"00",X"00",X"20",X"C0",
		X"80",X"40",X"20",X"00",X"00",X"00",X"00",X"00",X"03",X"05",X"08",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"08",X"00",X"02",X"00",X"00",X"00",X"00",X"00",X"10",X"00",X"40",X"00",
		X"00",X"40",X"00",X"10",X"00",X"00",X"00",X"00",X"00",X"02",X"00",X"08",X"00",X"00",X"00",X"00",
		X"00",X"00",X"18",X"18",X"00",X"00",X"18",X"18",X"00",X"7F",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"F0",X"FC",X"FE",X"CE",X"C7",X"FF",X"FF",X"FF",X"99",X"FF",X"FF",X"99",X"99",X"FF",X"FF",X"FF",
		X"0F",X"3F",X"7F",X"73",X"E3",X"FF",X"FF",X"FF",X"FF",X"C6",X"C6",X"FF",X"FF",X"C6",X"C6",X"FF",
		X"FF",X"63",X"63",X"FF",X"FF",X"63",X"63",X"FF",X"FF",X"FF",X"F7",X"E7",X"C7",X"FF",X"FF",X"FF",
		X"FF",X"FF",X"EF",X"E7",X"E3",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"99",X"99",X"FF",X"FF",X"FF",
		X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"03",X"03",X"03",X"03",X"03",X"03",X"03",X"03",
		X"00",X"00",X"00",X"E7",X"A4",X"A7",X"A5",X"AF",X"00",X"00",X"00",X"7B",X"6A",X"6A",X"6A",X"6A",
		X"00",X"98",X"98",X"C0",X"98",X"98",X"98",X"98",X"00",X"01",X"01",X"03",X"01",X"01",X"C1",X"C3",
		X"00",X"8F",X"86",X"46",X"06",X"06",X"06",X"0F",X"00",X"44",X"CC",X"CC",X"CC",X"CC",X"CC",X"CC",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"FF",X"7F",X"3F",X"1F",X"0F",X"07",X"03",X"01",X"01",X"61",X"73",X"3F",X"1F",X"0F",X"FF",
		X"00",X"7F",X"7F",X"7E",X"7C",X"78",X"70",X"60",X"40",X"40",X"43",X"67",X"7E",X"7C",X"78",X"7F",
		X"00",X"FF",X"09",X"1D",X"3F",X"7F",X"FF",X"FF",X"FD",X"FD",X"F9",X"F1",X"E1",X"C1",X"81",X"FF",
		X"00",X"7F",X"48",X"5C",X"7E",X"7F",X"7F",X"7F",X"5F",X"5F",X"4F",X"47",X"43",X"41",X"40",X"7F",
		X"00",X"FF",X"3F",X"1F",X"0F",X"1F",X"37",X"63",X"41",X"01",X"41",X"63",X"77",X"1F",X"07",X"FF",
		X"00",X"7F",X"7E",X"7C",X"78",X"7C",X"76",X"63",X"41",X"40",X"41",X"63",X"77",X"7C",X"70",X"7F",
		X"00",X"FF",X"81",X"C1",X"E1",X"F1",X"F9",X"FD",X"FF",X"FD",X"F9",X"F1",X"E1",X"C1",X"81",X"FF",
		X"00",X"7F",X"40",X"41",X"43",X"47",X"4F",X"5F",X"7F",X"5F",X"4F",X"47",X"43",X"41",X"40",X"7F",
		X"10",X"0C",X"06",X"FF",X"FF",X"06",X"0C",X"10",X"08",X"30",X"60",X"FF",X"FF",X"60",X"30",X"08",
		X"7E",X"FF",X"DD",X"DD",X"D5",X"C9",X"DD",X"FF",X"7E",X"FF",X"C1",X"F9",X"E1",X"F9",X"C1",X"FF",
		X"7E",X"FF",X"C1",X"F9",X"C1",X"CF",X"C1",X"FF",X"7E",X"FF",X"C1",X"F7",X"F7",X"F7",X"F7",X"7E",
		X"7E",X"FF",X"E3",X"C9",X"DD",X"C1",X"DD",X"FF",X"7E",X"FF",X"D9",X"D1",X"C9",X"C9",X"D9",X"FF",
		X"7E",X"FF",X"E1",X"C9",X"D9",X"C9",X"E1",X"FF",X"63",X"33",X"1B",X"1F",X"37",X"63",X"43",X"00",
		X"1C",X"22",X"63",X"63",X"73",X"2A",X"5C",X"00",X"3C",X"18",X"18",X"18",X"19",X"1B",X"0E",X"00",
		X"1C",X"3E",X"7F",X"7F",X"49",X"08",X"1C",X"00",X"36",X"77",X"7F",X"7F",X"3E",X"1C",X"08",X"00",
		X"1C",X"1C",X"08",X"7F",X"6B",X"08",X"1C",X"00",X"08",X"1C",X"3E",X"7F",X"3E",X"1C",X"08",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"DB",X"A8",X"88",X"00",X"00",X"00",X"00",X"00",X"E0",X"80",X"80",X"00",X"00",X"00",
		X"86",X"87",X"83",X"C3",X"E3",X"71",X"3F",X"1F",X"03",X"03",X"03",X"07",X"07",X"06",X"06",X"06",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"0C",X"0E",X"07",X"07",X"83",X"81",X"80",X"00",
		X"FC",X"3C",X"18",X"18",X"18",X"18",X"18",X"1C",X"00",X"00",X"00",X"00",X"00",X"00",X"18",X"FC",
		X"0F",X"03",X"00",X"81",X"83",X"C7",X"FE",X"7C",X"3F",X"77",X"61",X"61",X"60",X"70",X"38",X"1E",
		X"00",X"00",X"00",X"00",X"00",X"00",X"0E",X"1F",X"C7",X"E3",X"F0",X"B8",X"9F",X"0F",X"00",X"00",
		X"03",X"87",X"C7",X"CF",X"CE",X"CE",X"CE",X"CF",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",
		X"01",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"E7",X"F3",X"7B",X"1B",X"F9",X"E1",X"01",X"01",
		X"F8",X"1C",X"0C",X"0C",X"0E",X"0E",X"06",X"06",X"00",X"00",X"00",X"00",X"00",X"00",X"E0",X"F0",
		X"70",X"30",X"38",X"18",X"1C",X"1C",X"1E",X"1E",X"80",X"C0",X"C0",X"C0",X"E0",X"60",X"60",X"70",
		X"3F",X"1F",X"03",X"E0",X"FF",X"9F",X"80",X"80",X"1F",X"38",X"38",X"78",X"70",X"70",X"70",X"78",
		X"00",X"00",X"00",X"00",X"00",X"00",X"07",X"0F",X"03",X"01",X"01",X"00",X"00",X"00",X"00",X"00",
		X"0C",X"0E",X"06",X"06",X"07",X"03",X"03",X"03",X"38",X"98",X"D8",X"DC",X"CE",X"0F",X"0D",X"0C",
		X"C1",X"E0",X"60",X"60",X"70",X"70",X"70",X"30",X"01",X"03",X"01",X"00",X"00",X"01",X"01",X"01",
		X"80",X"80",X"C0",X"C0",X"E0",X"E0",X"F0",X"F0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",
		X"3C",X"36",X"33",X"39",X"38",X"18",X"F8",X"F8",X"E0",X"E0",X"E0",X"F0",X"70",X"70",X"78",X"38",
		X"80",X"C0",X"80",X"00",X"00",X"C0",X"C0",X"E0",X"3C",X"0F",X"03",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"F0",X"03",X"01",X"00",X"00",X"00",X"00",X"00",X"00",
		X"03",X"83",X"C3",X"61",X"31",X"19",X"0D",X"07",X"00",X"1C",X"1C",X"0E",X"07",X"07",X"07",X"03",
		X"31",X"31",X"1F",X"1F",X"1F",X"07",X"00",X"00",X"C0",X"E0",X"F0",X"D8",X"CC",X"66",X"63",X"71",
		X"86",X"C7",X"C3",X"E3",X"A6",X"BE",X"9C",X"C0",X"00",X"70",X"78",X"38",X"1C",X"1C",X"0C",X"8E",
		X"C0",X"C0",X"C0",X"80",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",
		X"19",X"00",X"00",X"80",X"C0",X"63",X"3F",X"1F",X"7E",X"F7",X"E1",X"E0",X"E0",X"73",X"37",X"1D",
		X"0F",X"03",X"01",X"01",X"00",X"00",X"38",X"7C",X"00",X"00",X"00",X"00",X"0F",X"1F",X"1F",X"1F",
		X"99",X"D9",X"DD",X"CD",X"CC",X"CC",X"8E",X"86",X"60",X"70",X"F0",X"F0",X"30",X"30",X"39",X"99",
		X"87",X"87",X"C3",X"C0",X"C0",X"C0",X"E0",X"E0",X"00",X"01",X"07",X"0F",X"0F",X"0E",X"0E",X"87",
		X"C0",X"C0",X"E0",X"E0",X"F8",X"7F",X"3F",X"1F",X"07",X"0F",X"1F",X"3F",X"7E",X"FC",X"F1",X"E1",
		X"E4",X"FC",X"FC",X"F8",X"00",X"00",X"00",X"01",X"00",X"F0",X"FE",X"FF",X"0F",X"01",X"00",X"00",
		X"FE",X"1E",X"0E",X"1E",X"3C",X"FC",X"F8",X"F0",X"E0",X"C0",X"80",X"00",X"00",X"70",X"FC",X"FC",
		X"70",X"70",X"70",X"70",X"70",X"70",X"F0",X"E0",X"00",X"00",X"00",X"80",X"C0",X"C0",X"E0",X"E0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FE",X"03",X"C1",X"61",X"31",X"31",X"01",X"01",X"81",X"81",X"81",X"01",X"81",X"81",X"03",X"FE",
		X"7F",X"C0",X"83",X"86",X"8C",X"8C",X"86",X"87",X"81",X"81",X"81",X"80",X"81",X"81",X"C0",X"7F",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;