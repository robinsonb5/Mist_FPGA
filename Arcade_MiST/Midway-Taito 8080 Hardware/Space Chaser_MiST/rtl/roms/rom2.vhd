library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity rom2 is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(10 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of rom2 is
	type rom is array(0 to  2047) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"CD",X"9A",X"41",X"CD",X"AA",X"0C",X"21",X"44",X"23",X"36",X"FF",X"D3",X"06",X"21",X"44",X"20",
		X"7E",X"FE",X"1C",X"DA",X"2C",X"40",X"36",X"00",X"2A",X"70",X"20",X"7E",X"32",X"05",X"20",X"23",
		X"7D",X"FE",X"81",X"DA",X"29",X"40",X"21",X"72",X"20",X"22",X"70",X"20",X"CD",X"37",X"02",X"3A",
		X"3D",X"20",X"A7",X"C2",X"A5",X"40",X"21",X"44",X"23",X"7E",X"A7",X"C2",X"0B",X"40",X"CD",X"BA",
		X"41",X"CD",X"08",X"46",X"CD",X"61",X"42",X"CD",X"F2",X"41",X"CD",X"34",X"0C",X"21",X"14",X"2C",
		X"11",X"2C",X"47",X"06",X"0C",X"CD",X"22",X"08",X"21",X"0A",X"2F",X"11",X"06",X"42",X"01",X"02",
		X"2C",X"CD",X"66",X"41",X"CD",X"9A",X"41",X"21",X"07",X"28",X"11",X"80",X"1F",X"06",X"13",X"CD",
		X"22",X"08",X"CD",X"AA",X"41",X"26",X"2F",X"06",X"A6",X"2E",X"EB",X"04",X"7E",X"B8",X"C2",X"3C",
		X"17",X"CD",X"08",X"46",X"CD",X"61",X"42",X"CD",X"34",X"0C",X"21",X"11",X"2C",X"11",X"93",X"1F",
		X"06",X"0B",X"CD",X"22",X"08",X"CD",X"9A",X"41",X"C3",X"41",X"00",X"3A",X"44",X"23",X"A7",X"CA",
		X"CC",X"0E",X"C3",X"98",X"14",X"21",X"44",X"23",X"36",X"00",X"CD",X"B0",X"40",X"C3",X"1F",X"40",
		X"F3",X"11",X"70",X"22",X"21",X"9E",X"1F",X"06",X"23",X"CD",X"41",X"0B",X"3E",X"01",X"32",X"70",
		X"22",X"32",X"78",X"22",X"32",X"80",X"22",X"32",X"88",X"22",X"32",X"90",X"22",X"2A",X"06",X"20",
		X"E5",X"22",X"8B",X"22",X"01",X"00",X"10",X"09",X"22",X"83",X"22",X"E1",X"11",X"20",X"00",X"19",
		X"22",X"73",X"22",X"09",X"22",X"7B",X"22",X"FB",X"21",X"00",X"C4",X"01",X"38",X"20",X"3E",X"01",
		X"CD",X"D2",X"08",X"2A",X"06",X"20",X"CD",X"A0",X"42",X"01",X"08",X"04",X"3E",X"07",X"CD",X"D0",
		X"08",X"21",X"92",X"22",X"36",X"01",X"2A",X"06",X"20",X"E5",X"7C",X"C6",X"08",X"67",X"7D",X"C6",
		X"08",X"6F",X"CD",X"27",X"0B",X"11",X"E0",X"1E",X"01",X"02",X"10",X"CD",X"66",X"41",X"CD",X"AF",
		X"42",X"E1",X"7C",X"FE",X"D8",X"D2",X"2B",X"41",X"C3",X"2D",X"41",X"26",X"E4",X"CD",X"27",X"0B",
		X"11",X"00",X"1F",X"01",X"04",X"20",X"CD",X"66",X"41",X"3A",X"90",X"22",X"A7",X"D3",X"06",X"C2",
		X"06",X"41",X"AF",X"D3",X"03",X"21",X"2E",X"23",X"36",X"00",X"C3",X"AA",X"41",X"5E",X"23",X"56",
		X"23",X"7E",X"23",X"4E",X"23",X"46",X"61",X"6F",X"EB",X"C9",X"4E",X"23",X"46",X"23",X"79",X"86",
		X"77",X"23",X"78",X"86",X"77",X"C9",X"C5",X"E5",X"1A",X"77",X"23",X"13",X"0D",X"C2",X"68",X"41",
		X"E1",X"01",X"20",X"00",X"09",X"C1",X"05",X"C2",X"66",X"41",X"C9",X"C5",X"D5",X"1A",X"CD",X"94",
		X"08",X"CD",X"AB",X"08",X"D1",X"C1",X"13",X"3E",X"07",X"32",X"91",X"22",X"3A",X"91",X"22",X"D3",
		X"06",X"3D",X"C2",X"8C",X"41",X"05",X"C2",X"7B",X"41",X"C9",X"3E",X"50",X"FB",X"32",X"91",X"22",
		X"3A",X"91",X"22",X"A7",X"D3",X"06",X"C2",X"A0",X"41",X"C9",X"3E",X"80",X"C3",X"9C",X"41",X"CD",
		X"A0",X"42",X"01",X"04",X"02",X"3E",X"05",X"C3",X"D2",X"08",X"11",X"70",X"22",X"21",X"9E",X"1F",
		X"06",X"23",X"C3",X"41",X"0B",X"11",X"80",X"00",X"71",X"19",X"05",X"C2",X"C8",X"41",X"C9",X"CD",
		X"4D",X"41",X"48",X"06",X"02",X"C3",X"B4",X"42",X"CD",X"27",X"0B",X"01",X"03",X"18",X"AF",X"C5",
		X"E5",X"77",X"23",X"0D",X"C2",X"E1",X"41",X"E1",X"01",X"20",X"00",X"09",X"C1",X"05",X"C2",X"DF",
		X"41",X"C9",X"21",X"07",X"C4",X"01",X"06",X"38",X"CD",X"C5",X"41",X"21",X"0A",X"CF",X"01",X"0C",
		X"02",X"3E",X"04",X"C3",X"D2",X"08",X"00",X"E0",X"00",X"D8",X"00",X"C6",X"80",X"C1",X"60",X"C0",
		X"10",X"A4",X"10",X"A4",X"D0",X"A7",X"10",X"A4",X"08",X"94",X"08",X"90",X"08",X"90",X"08",X"90",
		X"F4",X"88",X"44",X"89",X"44",X"89",X"F4",X"88",X"02",X"84",X"02",X"84",X"02",X"84",X"02",X"84",
		X"01",X"82",X"7D",X"82",X"01",X"82",X"02",X"84",X"02",X"84",X"02",X"84",X"02",X"85",X"04",X"89",
		X"F4",X"89",X"04",X"89",X"04",X"89",X"08",X"90",X"08",X"90",X"08",X"90",X"88",X"93",X"50",X"A4",
		X"50",X"A4",X"90",X"A3",X"10",X"A0",X"60",X"C0",X"80",X"C1",X"00",X"C6",X"00",X"D8",X"00",X"E0",
		X"00",X"21",X"11",X"CC",X"01",X"06",X"18",X"CD",X"C5",X"41",X"21",X"00",X"C5",X"01",X"05",X"0A",
		X"CD",X"C5",X"41",X"21",X"00",X"CA",X"01",X"04",X"08",X"CD",X"C5",X"41",X"21",X"1E",X"C4",X"01",
		X"04",X"12",X"CD",X"C5",X"41",X"21",X"1E",X"CD",X"01",X"05",X"14",X"CD",X"C5",X"41",X"21",X"1E",
		X"D7",X"01",X"03",X"12",X"CD",X"C5",X"41",X"21",X"00",X"CE",X"01",X"01",X"0C",X"C3",X"C5",X"41",
		X"7D",X"E6",X"07",X"D3",X"02",X"CD",X"27",X"0B",X"C5",X"01",X"00",X"A0",X"09",X"C1",X"C9",X"3E",
		X"20",X"C3",X"95",X"06",X"7D",X"E6",X"07",X"D3",X"02",X"CD",X"27",X"0B",X"C5",X"E5",X"1A",X"D3",
		X"04",X"DB",X"03",X"77",X"23",X"13",X"05",X"C2",X"BE",X"42",X"AF",X"D3",X"04",X"DB",X"03",X"77",
		X"E1",X"01",X"20",X"00",X"09",X"C1",X"0D",X"C2",X"BC",X"42",X"C9",X"06",X"06",X"C5",X"21",X"BE",
		X"1F",X"CD",X"EE",X"42",X"C1",X"05",X"C2",X"DD",X"42",X"3E",X"01",X"C3",X"89",X"06",X"7E",X"A7",
		X"C8",X"23",X"4E",X"47",X"07",X"DA",X"2F",X"43",X"E5",X"CD",X"05",X"43",X"E1",X"0D",X"C2",X"F8",
		X"42",X"23",X"C3",X"EE",X"42",X"21",X"F0",X"07",X"50",X"E5",X"D5",X"3E",X"01",X"CD",X"7E",X"06",
		X"D1",X"E1",X"2B",X"7C",X"A7",X"C8",X"15",X"C2",X"12",X"43",X"50",X"E5",X"D5",X"3E",X"01",X"CD",
		X"89",X"06",X"D1",X"E1",X"2B",X"7C",X"A7",X"C8",X"15",X"C2",X"24",X"43",X"C3",X"08",X"43",X"E5",
		X"21",X"FF",X"30",X"2B",X"7C",X"A7",X"C2",X"33",X"43",X"0D",X"C2",X"30",X"43",X"E1",X"23",X"C3",
		X"EE",X"42",X"CD",X"AC",X"06",X"C3",X"58",X"43",X"CD",X"03",X"46",X"CA",X"42",X"43",X"3A",X"0F",
		X"23",X"A7",X"C2",X"42",X"43",X"CD",X"C0",X"06",X"CD",X"08",X"46",X"CD",X"34",X"0C",X"CD",X"92",
		X"45",X"21",X"96",X"46",X"11",X"40",X"22",X"06",X"19",X"CD",X"41",X"0B",X"21",X"17",X"25",X"11",
		X"51",X"46",X"06",X"1B",X"CD",X"22",X"08",X"21",X"12",X"27",X"11",X"5C",X"1D",X"CD",X"F1",X"43",
		X"21",X"10",X"27",X"CD",X"F1",X"43",X"21",X"0E",X"27",X"0E",X"05",X"CD",X"F3",X"43",X"21",X"0E",
		X"33",X"11",X"47",X"1E",X"01",X"01",X"10",X"CD",X"66",X"41",X"21",X"0E",X"36",X"11",X"57",X"1E",
		X"01",X"01",X"10",X"CD",X"66",X"41",X"11",X"6C",X"46",X"21",X"06",X"2A",X"06",X"10",X"CD",X"22",
		X"08",X"06",X"0A",X"CD",X"81",X"04",X"3A",X"51",X"22",X"A7",X"CA",X"7F",X"45",X"3A",X"4F",X"22",
		X"FE",X"20",X"D2",X"7F",X"45",X"CD",X"04",X"44",X"CD",X"F2",X"0D",X"E6",X"0A",X"FE",X"08",X"CC",
		X"30",X"44",X"FE",X"02",X"CC",X"86",X"44",X"3A",X"56",X"22",X"A7",X"C2",X"7F",X"45",X"3A",X"41",
		X"22",X"A7",X"C2",X"D0",X"44",X"01",X"50",X"02",X"CD",X"81",X"04",X"CD",X"0F",X"44",X"C3",X"B1",
		X"43",X"0E",X"0B",X"C5",X"01",X"01",X"05",X"CD",X"66",X"41",X"01",X"60",X"01",X"09",X"C1",X"0D",
		X"C2",X"F3",X"43",X"C9",X"2A",X"52",X"22",X"3E",X"2D",X"CD",X"94",X"08",X"C3",X"AB",X"08",X"2A",
		X"52",X"22",X"3E",X"1B",X"CD",X"94",X"08",X"C3",X"AB",X"08",X"01",X"50",X"06",X"CD",X"F2",X"0D",
		X"E6",X"0A",X"CA",X"2E",X"44",X"0D",X"C2",X"1D",X"44",X"05",X"C2",X"1D",X"44",X"C9",X"E1",X"C9",
		X"CD",X"1A",X"44",X"CD",X"0F",X"44",X"2A",X"52",X"22",X"7D",X"FE",X"11",X"CA",X"61",X"44",X"FE",
		X"0F",X"CA",X"6A",X"44",X"7C",X"FE",X"33",X"CA",X"75",X"44",X"24",X"24",X"7C",X"FE",X"35",X"D2",
		X"55",X"44",X"C3",X"5B",X"44",X"CD",X"0F",X"44",X"21",X"0D",X"36",X"22",X"52",X"22",X"C3",X"04",
		X"44",X"7C",X"FE",X"3B",X"D2",X"7A",X"44",X"C3",X"70",X"44",X"7C",X"FE",X"3B",X"D2",X"80",X"44",
		X"24",X"24",X"C3",X"5B",X"44",X"26",X"34",X"C3",X"4A",X"44",X"21",X"0F",X"27",X"C3",X"5B",X"44",
		X"21",X"0D",X"27",X"C3",X"5B",X"44",X"CD",X"1A",X"44",X"CD",X"0F",X"44",X"2A",X"52",X"22",X"7D",
		X"FE",X"11",X"CA",X"AA",X"44",X"FE",X"0F",X"CA",X"BB",X"44",X"7C",X"FE",X"28",X"DA",X"C4",X"44",
		X"FE",X"34",X"C2",X"B0",X"44",X"26",X"33",X"C3",X"B0",X"44",X"7C",X"FE",X"28",X"DA",X"B5",X"44",
		X"25",X"25",X"C3",X"5B",X"44",X"21",X"11",X"27",X"C3",X"5B",X"44",X"7C",X"FE",X"28",X"DA",X"CA",
		X"44",X"C3",X"B0",X"44",X"21",X"0F",X"3B",X"C3",X"5B",X"44",X"21",X"11",X"3B",X"C3",X"5B",X"44",
		X"01",X"FF",X"20",X"CD",X"81",X"04",X"3A",X"50",X"22",X"FE",X"0A",X"D2",X"64",X"45",X"3A",X"52",
		X"22",X"FE",X"11",X"CA",X"FE",X"44",X"FE",X"0F",X"CA",X"04",X"45",X"3A",X"53",X"22",X"FE",X"32",
		X"D2",X"0C",X"45",X"CD",X"3F",X"45",X"C6",X"16",X"CD",X"46",X"45",X"C3",X"B1",X"43",X"CD",X"3F",
		X"45",X"C3",X"46",X"45",X"CD",X"3F",X"45",X"C6",X"0B",X"C3",X"46",X"45",X"FE",X"35",X"D2",X"7F",
		X"45",X"3A",X"50",X"22",X"A7",X"CA",X"35",X"45",X"2A",X"54",X"22",X"25",X"22",X"54",X"22",X"3E",
		X"1B",X"CD",X"94",X"08",X"CD",X"AB",X"08",X"21",X"50",X"22",X"35",X"21",X"44",X"22",X"3A",X"50",
		X"22",X"85",X"6F",X"36",X"1B",X"AF",X"32",X"40",X"22",X"32",X"41",X"22",X"C3",X"B1",X"43",X"3A",
		X"53",X"22",X"D6",X"27",X"0F",X"C9",X"21",X"44",X"22",X"F5",X"3A",X"50",X"22",X"85",X"6F",X"F1",
		X"77",X"2A",X"54",X"22",X"CD",X"94",X"08",X"CD",X"AB",X"08",X"22",X"54",X"22",X"21",X"50",X"22",
		X"34",X"C3",X"35",X"45",X"3A",X"52",X"22",X"FE",X"0D",X"C2",X"7F",X"45",X"3A",X"53",X"22",X"FE",
		X"32",X"D2",X"77",X"45",X"C3",X"7F",X"45",X"FE",X"36",X"D2",X"7F",X"45",X"C3",X"11",X"45",X"AF",
		X"32",X"51",X"22",X"32",X"0F",X"23",X"32",X"0E",X"23",X"CD",X"A8",X"45",X"CD",X"9B",X"45",X"C3",
		X"4C",X"04",X"01",X"01",X"50",X"21",X"1E",X"2D",X"C3",X"DE",X"41",X"2A",X"42",X"22",X"11",X"44",
		X"22",X"3A",X"50",X"22",X"47",X"C3",X"22",X"08",X"3A",X"50",X"22",X"A7",X"CA",X"BF",X"45",X"47",
		X"3E",X"0A",X"90",X"37",X"3F",X"1F",X"C6",X"2D",X"67",X"2E",X"1E",X"22",X"42",X"22",X"C9",X"21",
		X"1E",X"2D",X"22",X"42",X"22",X"3E",X"0A",X"32",X"50",X"22",X"C9",X"21",X"0E",X"07",X"11",X"2A",
		X"23",X"06",X"03",X"C3",X"41",X"0B",X"AF",X"D3",X"03",X"D3",X"05",X"D3",X"06",X"21",X"2D",X"23",
		X"77",X"CD",X"03",X"46",X"C0",X"C3",X"B2",X"06",X"CD",X"BA",X"41",X"CD",X"08",X"46",X"CD",X"F8",
		X"04",X"CD",X"B4",X"0B",X"C3",X"FA",X"45",X"CD",X"CA",X"08",X"CD",X"34",X"0C",X"CD",X"86",X"0C",
		X"C3",X"91",X"0C",X"DB",X"02",X"E6",X"40",X"C9",X"CD",X"CA",X"08",X"C3",X"D5",X"04",X"21",X"47",
		X"23",X"34",X"7E",X"FE",X"04",X"D2",X"3F",X"46",X"FE",X"02",X"21",X"47",X"46",X"DA",X"2B",X"46",
		X"FE",X"03",X"21",X"C8",X"1B",X"D2",X"2B",X"46",X"21",X"4C",X"46",X"11",X"06",X"21",X"06",X"05",
		X"CD",X"41",X"0B",X"2A",X"06",X"21",X"22",X"39",X"23",X"CD",X"DB",X"18",X"C3",X"58",X"00",X"36",
		X"00",X"21",X"47",X"46",X"C3",X"2B",X"46",X"40",X"58",X"40",X"58",X"8B",X"B8",X"98",X"B8",X"98",
		X"45",X"07",X"08",X"1C",X"12",X"02",X"0E",X"11",X"04",X"11",X"1B",X"0D",X"00",X"0C",X"04",X"1B",
		X"11",X"04",X"06",X"08",X"12",X"13",X"11",X"00",X"13",X"08",X"0E",X"0D",X"0D",X"00",X"0C",X"04",
		X"1B",X"1B",X"1C",X"1C",X"1C",X"1C",X"1C",X"1C",X"1C",X"1C",X"1C",X"1C",X"00",X"00",X"00",X"00",
		X"1B",X"1B",X"13",X"00",X"08",X"13",X"0E",X"1B",X"1B",X"1B",X"00",X"00",X"00",X"00",X"11",X"27",
		X"07",X"30",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"1B",X"1B",X"1B",X"1B",X"1B",X"1B",
		X"1B",X"1B",X"1B",X"1B",X"00",X"00",X"00",X"FF",X"11",X"27",X"07",X"30",X"00",X"00",X"00",X"00",
		X"03",X"00",X"72",X"28",X"D2",X"00",X"FD",X"BA",X"70",X"D2",X"FD",X"FF",X"42",X"70",X"BA",X"00",
		X"FD",X"5A",X"40",X"BA",X"03",X"00",X"A2",X"40",X"5A",X"00",X"03",X"8A",X"A0",X"5A",X"03",X"00",
		X"BA",X"A0",X"8A",X"00",X"FD",X"42",X"B8",X"8A",X"FD",X"FF",X"32",X"B8",X"42",X"00",X"03",X"8A",
		X"28",X"42",X"03",X"00",X"A2",X"28",X"8A",X"00",X"03",X"BA",X"A0",X"8A",X"FD",X"FF",X"4A",X"A0",
		X"BA",X"00",X"FD",X"8A",X"40",X"BA",X"FD",X"FF",X"2A",X"40",X"8A",X"00",X"03",X"D2",X"28",X"8A",
		X"28",X"D2",X"28",X"D2",X"46",X"72",X"0A",X"72",X"0A",X"03",X"00",X"72",X"28",X"D2",X"00",X"72",
		X"0A",X"28",X"D2",X"72",X"0A",X"02",X"0E",X"0D",X"06",X"11",X"00",X"13",X"14",X"0B",X"00",X"13",
		X"08",X"0E",X"0D",X"12",X"00",X"08",X"08",X"08",X"7F",X"08",X"08",X"08",X"12",X"0F",X"00",X"02",
		X"04",X"1B",X"02",X"07",X"00",X"12",X"04",X"11",X"2E",X"03",X"0E",X"13",X"2A",X"1B",X"1B",X"1B",
		X"0F",X"0E",X"08",X"0D",X"13",X"06",X"0E",X"0E",X"03",X"1B",X"0B",X"14",X"02",X"0A",X"0F",X"03",
		X"1E",X"FE",X"1E",X"03",X"0F",X"00",X"0F",X"14",X"12",X"07",X"C3",X"41",X"00",X"CD",X"DB",X"18",
		X"FE",X"07",X"3A",X"1D",X"20",X"DA",X"16",X"01",X"FE",X"4C",X"C3",X"18",X"01",X"CD",X"DB",X"18",
		X"FE",X"07",X"21",X"04",X"04",X"DA",X"35",X"01",X"21",X"05",X"05",X"C3",X"35",X"01",X"7E",X"A7",
		X"C2",X"FA",X"19",X"36",X"FF",X"3A",X"04",X"20",X"21",X"05",X"22",X"77",X"C3",X"A6",X"1A",X"CD",
		X"9C",X"47",X"0F",X"21",X"0D",X"2B",X"CD",X"9C",X"47",X"C3",X"60",X"47",X"D2",X"AC",X"47",X"F5",
		X"E5",X"3E",X"1D",X"CD",X"94",X"08",X"E1",X"CD",X"AB",X"08",X"F1",X"C9",X"01",X"08",X"00",X"C5",
		X"70",X"11",X"20",X"00",X"19",X"C1",X"0D",X"C2",X"AF",X"47",X"C9",X"00",X"DB",X"00",X"07",X"07",
		X"DA",X"D4",X"47",X"07",X"21",X"03",X"03",X"D2",X"CD",X"47",X"21",X"05",X"05",X"22",X"31",X"23",
		X"C9",X"00",X"00",X"00",X"07",X"21",X"04",X"04",X"D2",X"CD",X"47",X"21",X"06",X"06",X"C3",X"CD",
		X"47",X"DB",X"02",X"E6",X"08",X"CA",X"F4",X"47",X"21",X"04",X"23",X"36",X"90",X"2E",X"07",X"36",
		X"90",X"C3",X"4A",X"00",X"21",X"03",X"23",X"C3",X"6C",X"14",X"00",X"00",X"00",X"00",X"00",X"00");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;