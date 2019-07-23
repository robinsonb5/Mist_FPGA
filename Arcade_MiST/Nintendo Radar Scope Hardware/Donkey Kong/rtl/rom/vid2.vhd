library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity vid2 is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(10 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of vid2 is
	type rom is array(0 to  2047) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"38",X"7C",X"C2",X"82",X"86",X"7C",X"38",X"00",X"02",X"02",X"FE",X"FE",X"42",X"02",X"00",X"00",
		X"62",X"F2",X"BA",X"9A",X"9E",X"CE",X"46",X"00",X"8C",X"DE",X"F2",X"B2",X"92",X"86",X"04",X"00",
		X"08",X"FE",X"FE",X"C8",X"68",X"38",X"18",X"00",X"1C",X"BE",X"A2",X"A2",X"A2",X"E6",X"E4",X"00",
		X"0C",X"9E",X"92",X"92",X"D2",X"7E",X"3C",X"00",X"C0",X"E0",X"B0",X"9E",X"8E",X"C0",X"C0",X"00",
		X"0C",X"6E",X"9A",X"9A",X"B2",X"F2",X"6C",X"00",X"78",X"FC",X"96",X"92",X"92",X"F2",X"60",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"3E",X"7E",X"C8",X"88",X"C8",X"7E",X"3E",X"00",
		X"6C",X"FE",X"92",X"92",X"92",X"FE",X"FE",X"00",X"44",X"C6",X"82",X"82",X"C6",X"7C",X"38",X"00",
		X"38",X"7C",X"C6",X"82",X"82",X"FE",X"FE",X"00",X"82",X"92",X"92",X"92",X"FE",X"FE",X"00",X"00",
		X"80",X"90",X"90",X"90",X"90",X"FE",X"FE",X"00",X"9E",X"9E",X"92",X"82",X"C6",X"7C",X"38",X"00",
		X"FE",X"FE",X"10",X"10",X"10",X"FE",X"FE",X"00",X"82",X"82",X"FE",X"FE",X"82",X"82",X"00",X"00",
		X"FC",X"FE",X"02",X"02",X"02",X"06",X"04",X"00",X"82",X"C6",X"6E",X"3C",X"18",X"FE",X"FE",X"00",
		X"02",X"02",X"02",X"02",X"FE",X"FE",X"00",X"00",X"FE",X"FE",X"70",X"38",X"70",X"FE",X"FE",X"00",
		X"FE",X"FE",X"1C",X"38",X"70",X"FE",X"FE",X"00",X"7C",X"FE",X"82",X"82",X"82",X"FE",X"7C",X"00",
		X"70",X"F8",X"88",X"88",X"88",X"FE",X"FE",X"00",X"7A",X"FC",X"8E",X"8A",X"82",X"FE",X"7C",X"00",
		X"72",X"F6",X"9E",X"8C",X"88",X"FE",X"FE",X"00",X"0C",X"5E",X"D2",X"92",X"92",X"F6",X"64",X"00",
		X"80",X"80",X"FE",X"FE",X"80",X"80",X"00",X"00",X"FC",X"FE",X"02",X"02",X"02",X"FE",X"FC",X"00",
		X"F0",X"F8",X"1C",X"0E",X"1C",X"F8",X"F0",X"00",X"F8",X"FE",X"1C",X"38",X"1C",X"FE",X"F8",X"00",
		X"C6",X"EE",X"7C",X"38",X"7C",X"EE",X"C6",X"00",X"C0",X"F0",X"1E",X"1E",X"F0",X"C0",X"00",X"00",
		X"C2",X"E2",X"F2",X"BA",X"9E",X"8E",X"86",X"00",X"00",X"00",X"00",X"00",X"06",X"06",X"00",X"00",
		X"00",X"10",X"10",X"10",X"10",X"10",X"10",X"00",X"00",X"40",X"40",X"40",X"40",X"40",X"40",X"00",
		X"00",X"00",X"00",X"00",X"28",X"00",X"00",X"00",X"40",X"40",X"40",X"40",X"40",X"40",X"40",X"40",
		X"00",X"00",X"82",X"C6",X"6C",X"38",X"00",X"00",X"00",X"00",X"38",X"6C",X"C6",X"82",X"00",X"00",
		X"00",X"00",X"82",X"FE",X"FE",X"82",X"00",X"00",X"82",X"FE",X"FE",X"82",X"82",X"FE",X"FE",X"82",
		X"00",X"28",X"28",X"28",X"28",X"28",X"28",X"00",X"00",X"10",X"10",X"10",X"10",X"10",X"10",X"00",
		X"F6",X"F6",X"00",X"00",X"F6",X"F6",X"00",X"00",X"FA",X"FA",X"00",X"00",X"FA",X"FA",X"00",X"00",
		X"00",X"00",X"00",X"F6",X"F6",X"00",X"00",X"00",X"00",X"00",X"00",X"FA",X"FA",X"00",X"00",X"00",
		X"00",X"00",X"00",X"E0",X"C0",X"00",X"00",X"00",X"00",X"E0",X"C0",X"00",X"E0",X"C0",X"00",X"00",
		X"00",X"60",X"E0",X"00",X"60",X"E0",X"00",X"00",X"00",X"00",X"C0",X"00",X"C0",X"00",X"00",X"00",
		X"FF",X"01",X"01",X"01",X"01",X"01",X"01",X"01",X"FF",X"80",X"80",X"80",X"80",X"80",X"80",X"80",
		X"01",X"01",X"01",X"01",X"01",X"01",X"01",X"FF",X"80",X"80",X"80",X"80",X"80",X"80",X"80",X"FF",
		X"00",X"00",X"00",X"00",X"06",X"06",X"00",X"00",X"00",X"00",X"00",X"00",X"07",X"06",X"00",X"00",
		X"38",X"28",X"3E",X"00",X"00",X"00",X"00",X"00",X"3E",X"00",X"3C",X"02",X"02",X"3C",X"00",X"0E",
		X"22",X"2A",X"3E",X"00",X"00",X"0E",X"3A",X"2A",X"22",X"3E",X"00",X"3E",X"08",X"10",X"3E",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"1C",X"22",X"A5",X"BD",X"81",X"42",X"3C",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"3C",X"42",X"81",X"A5",X"7C",X"40",X"00",X"38",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"28",X"38",X"00",X"40",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"00",X"00",X"00",X"00",X"00",X"80",X"C0",X"A2",X"00",X"F0",X"FC",X"FE",X"FF",X"FF",X"FF",X"FF",
		X"00",X"01",X"0F",X"3F",X"FF",X"FF",X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"03",X"07",X"0F",
		X"54",X"A6",X"02",X"02",X"62",X"73",X"77",X"FF",X"FF",X"8F",X"76",X"7C",X"4E",X"A6",X"D7",X"A3",
		X"FF",X"FF",X"FE",X"FD",X"7F",X"87",X"03",X"80",X"1F",X"3F",X"78",X"F0",X"F1",X"F6",X"F8",X"6F",
		X"BF",X"5F",X"AF",X"4F",X"2A",X"90",X"40",X"A8",X"C1",X"61",X"51",X"25",X"35",X"A1",X"B2",X"AE",
		X"CE",X"9A",X"31",X"3B",X"BF",X"3F",X"1D",X"08",X"1F",X"33",X"61",X"C0",X"C0",X"C7",X"C7",X"65",
		X"40",X"A8",X"50",X"AA",X"4F",X"AF",X"5F",X"BF",X"AE",X"AE",X"B2",X"A1",X"25",X"55",X"41",X"61",
		X"05",X"07",X"03",X"02",X"80",X"00",X"81",X"C1",X"61",X"C5",X"C7",X"C7",X"C0",X"61",X"33",X"1F",
		X"FF",X"77",X"73",X"62",X"02",X"02",X"A6",X"54",X"51",X"E3",X"92",X"66",X"CC",X"76",X"0F",X"FF",
		X"81",X"00",X"81",X"41",X"E0",X"FE",X"FF",X"FF",X"6F",X"F8",X"F6",X"F1",X"F0",X"78",X"3F",X"1F",
		X"A2",X"C0",X"80",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",X"FF",X"FF",X"FE",X"FC",X"F0",X"00",
		X"FF",X"FF",X"FF",X"7F",X"1F",X"07",X"01",X"00",X"0F",X"07",X"01",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"72",X"02",X"52",X"AA",X"AA",X"FA",X"FA",X"FA",X"FA",X"FA",X"02",X"72",X"8A",X"8A",X"FA",X"FA",
		X"FA",X"FA",X"F2",X"02",X"FA",X"12",X"22",X"7A",X"BA",X"AA",X"EA",X"6A",X"02",X"F2",X"0A",X"0A",
		X"38",X"7C",X"C2",X"82",X"86",X"7C",X"38",X"00",X"02",X"02",X"FE",X"FE",X"42",X"02",X"00",X"00",
		X"62",X"F2",X"BA",X"9A",X"9E",X"4E",X"46",X"00",X"8C",X"DE",X"F2",X"B2",X"92",X"86",X"04",X"00",
		X"08",X"FE",X"FE",X"C8",X"68",X"38",X"18",X"00",X"1C",X"BE",X"B2",X"B2",X"B2",X"E6",X"E4",X"00",
		X"0C",X"9E",X"92",X"92",X"D2",X"7E",X"3C",X"00",X"C0",X"E0",X"B0",X"9E",X"8E",X"C0",X"C0",X"00",
		X"0C",X"6E",X"9A",X"9A",X"B2",X"F2",X"6C",X"00",X"78",X"FC",X"96",X"92",X"92",X"F2",X"60",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"A0",X"A0",X"A0",X"A0",X"A0",X"A0",X"A0",X"A0",X"00",X"00",X"FF",X"00",X"FF",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FF",X"00",X"FF",X"00",X"00",X"00",
		X"00",X"3C",X"7E",X"52",X"4A",X"7E",X"3C",X"00",X"00",X"02",X"02",X"7E",X"7E",X"22",X"02",X"00",
		X"00",X"22",X"72",X"5A",X"4E",X"66",X"22",X"00",X"00",X"44",X"6E",X"7A",X"52",X"46",X"44",X"00",
		X"00",X"04",X"7E",X"7E",X"34",X"1C",X"0C",X"00",X"00",X"4C",X"5E",X"52",X"52",X"76",X"74",X"00",
		X"00",X"0C",X"5E",X"52",X"52",X"7E",X"3C",X"00",X"00",X"60",X"70",X"58",X"4E",X"46",X"40",X"00",
		X"00",X"2C",X"7E",X"52",X"52",X"7E",X"2C",X"00",X"00",X"38",X"7C",X"56",X"52",X"72",X"20",X"00",
		X"7E",X"7E",X"30",X"18",X"30",X"7E",X"7E",X"00",X"1E",X"20",X"20",X"1E",X"20",X"20",X"3E",X"00",
		X"00",X"00",X"C0",X"20",X"A0",X"A0",X"A0",X"A0",X"00",X"00",X"7F",X"80",X"83",X"82",X"02",X"B2",
		X"A0",X"A0",X"A0",X"20",X"C0",X"00",X"00",X"00",X"02",X"82",X"83",X"80",X"7F",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"BE",X"A6",X"82",X"82",X"82",X"82",X"A6",X"BE",X"81",X"81",X"81",X"81",X"81",X"81",X"81",X"81",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"80",X"80",X"80",X"80",X"80",X"80",X"80",X"80",X"86",X"FF",X"FF",X"3F",X"3F",X"FF",X"FF",X"8E",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"FF",X"44",X"44",X"44",X"44",X"44",X"44",X"FF",X"7F",X"44",X"44",X"44",X"44",X"44",X"44",X"7F",
		X"BF",X"84",X"84",X"84",X"84",X"84",X"84",X"BF",X"DF",X"C4",X"44",X"44",X"44",X"44",X"44",X"DF",
		X"6F",X"E4",X"A4",X"24",X"24",X"24",X"A4",X"EF",X"37",X"74",X"D4",X"94",X"14",X"94",X"D4",X"77",
		X"1B",X"38",X"68",X"C8",X"88",X"C8",X"68",X"3B",X"0D",X"1C",X"34",X"64",X"44",X"64",X"34",X"1D",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"86",X"8E",X"9A",X"B2",X"A2",X"B2",X"9A",X"8E",X"C3",X"47",X"4D",X"59",X"51",X"59",X"4D",X"C7",
		X"E1",X"63",X"66",X"6C",X"68",X"6C",X"66",X"E3",X"F0",X"51",X"53",X"56",X"54",X"56",X"53",X"F1",
		X"F8",X"48",X"49",X"4B",X"4A",X"4B",X"49",X"F8",X"FC",X"44",X"44",X"45",X"45",X"45",X"44",X"FC",
		X"FE",X"46",X"46",X"46",X"46",X"46",X"46",X"FE",X"FF",X"45",X"45",X"45",X"45",X"45",X"45",X"FF",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FE",X"FE",X"00",X"FE",X"10",X"10",X"FF",X"FF",
		X"00",X"08",X"0C",X"FC",X"FC",X"00",X"A4",X"A6",X"00",X"C0",X"E8",X"00",X"40",X"A0",X"F8",X"F8",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"80",X"80",X"80",X"80",X"80",X"80",X"80",X"80",X"C0",X"C0",X"40",X"40",X"40",X"40",X"40",X"C0",
		X"60",X"E0",X"A0",X"20",X"20",X"20",X"A0",X"E0",X"30",X"70",X"D0",X"90",X"10",X"90",X"D0",X"70",
		X"18",X"38",X"68",X"C8",X"88",X"C8",X"68",X"38",X"0C",X"1C",X"34",X"64",X"44",X"64",X"34",X"1C",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"F8",X"F0",X"00",X"F0",X"40",X"40",X"E0",X"E0",
		X"00",X"04",X"04",X"FC",X"F8",X"00",X"A8",X"A8",X"E0",X"F8",X"7D",X"01",X"70",X"88",X"FE",X"FE",
		X"86",X"8E",X"9A",X"B2",X"A2",X"B2",X"9A",X"8E",X"43",X"47",X"4D",X"59",X"51",X"59",X"4D",X"47",
		X"21",X"23",X"26",X"2C",X"28",X"2C",X"26",X"23",X"10",X"11",X"13",X"16",X"14",X"16",X"13",X"11",
		X"08",X"08",X"09",X"0B",X"0A",X"0B",X"09",X"08",X"04",X"04",X"04",X"05",X"05",X"05",X"04",X"04",
		X"02",X"02",X"02",X"02",X"02",X"02",X"02",X"02",X"01",X"01",X"01",X"01",X"01",X"01",X"01",X"01",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"60",X"90",X"90",X"8A",X"80",X"40",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"42",X"24",X"00",X"00",X"24",X"42",X"00",X"26",X"6F",X"71",X"78",X"78",X"71",X"35",X"00");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;