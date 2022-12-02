library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity rom_k is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(11 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of rom_k is
	type rom is array(0 to  4095) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"38",X"7C",X"C2",X"82",X"86",X"7C",X"38",X"00",X"02",X"02",X"FE",X"FE",X"42",X"02",X"00",X"00",
		X"62",X"F2",X"BA",X"9A",X"9E",X"CE",X"46",X"00",X"8C",X"DE",X"F2",X"B2",X"92",X"86",X"04",X"00",
		X"08",X"FE",X"FE",X"C8",X"68",X"38",X"18",X"00",X"1C",X"BE",X"A2",X"A2",X"A2",X"E6",X"E4",X"00",
		X"0C",X"9E",X"92",X"92",X"D2",X"7E",X"3C",X"00",X"C0",X"E0",X"B0",X"9E",X"8E",X"C0",X"C0",X"00",
		X"0C",X"6E",X"9A",X"9A",X"B2",X"F2",X"6C",X"00",X"78",X"FC",X"96",X"92",X"92",X"F2",X"60",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"02",X"00",X"00",X"02",X"02",X"00",X"00",X"02",
		X"22",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"22",
		X"22",X"44",X"44",X"22",X"22",X"44",X"44",X"22",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",
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
		X"C2",X"E2",X"F2",X"BA",X"9E",X"8E",X"86",X"00",X"10",X"10",X"10",X"10",X"10",X"10",X"10",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"22",X"22",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"02",X"04",X"04",X"22",X"22",X"44",X"44",X"22",X"22",X"44",X"44",X"22",X"22",X"04",X"04",X"02",
		X"02",X"04",X"04",X"02",X"02",X"04",X"04",X"22",X"22",X"04",X"04",X"02",X"02",X"04",X"04",X"02",
		X"00",X"00",X"00",X"00",X"00",X"00",X"40",X"22",X"22",X"40",X"00",X"00",X"00",X"00",X"00",X"00",
		X"20",X"40",X"40",X"20",X"20",X"44",X"44",X"22",X"22",X"44",X"44",X"20",X"20",X"40",X"40",X"20",
		X"20",X"40",X"40",X"20",X"20",X"40",X"44",X"22",X"22",X"44",X"40",X"20",X"20",X"40",X"40",X"20",
		X"00",X"00",X"00",X"00",X"00",X"00",X"40",X"20",X"02",X"00",X"00",X"02",X"02",X"00",X"00",X"02",
		X"00",X"40",X"40",X"22",X"22",X"44",X"44",X"22",X"02",X"04",X"04",X"22",X"22",X"44",X"44",X"22",
		X"00",X"00",X"40",X"20",X"20",X"44",X"44",X"22",X"02",X"00",X"00",X"02",X"02",X"44",X"44",X"22",
		X"20",X"40",X"00",X"00",X"00",X"00",X"00",X"00",X"02",X"00",X"00",X"02",X"02",X"00",X"00",X"02",
		X"22",X"44",X"44",X"22",X"22",X"40",X"40",X"00",X"22",X"44",X"44",X"22",X"22",X"04",X"04",X"02",
		X"22",X"44",X"44",X"20",X"20",X"40",X"00",X"00",X"22",X"44",X"44",X"02",X"02",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"40",X"40",X"22",X"02",X"00",X"00",X"02",X"02",X"04",X"04",X"22",
		X"22",X"40",X"40",X"00",X"00",X"00",X"00",X"00",X"22",X"04",X"04",X"02",X"02",X"00",X"00",X"02",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"02",X"00",X"00",X"02",X"02",X"00",X"00",X"02",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"22",X"22",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"01",X"07",X"0E",X"1E",X"1B",X"31",X"00",X"00",X"E0",X"80",X"00",X"00",X"00",X"80",
		X"30",X"20",X"20",X"00",X"00",X"00",X"00",X"00",X"C0",X"60",X"30",X"18",X"0C",X"00",X"00",X"00",
		X"22",X"44",X"44",X"22",X"22",X"44",X"44",X"22",X"00",X"00",X"00",X"00",X"00",X"38",X"3C",X"00",
		X"00",X"00",X"06",X"06",X"06",X"02",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"02",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"00",
		X"00",X"0C",X"1C",X"18",X"10",X"00",X"00",X"00",X"3C",X"1C",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"02",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"00",
		X"00",X"04",X"0C",X"18",X"18",X"00",X"00",X"00",X"3C",X"1C",X"08",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",
		X"00",X"0E",X"1C",X"18",X"00",X"00",X"00",X"00",X"00",X"38",X"1C",X"0C",X"00",X"00",X"00",X"00",
		X"00",X"01",X"07",X"01",X"00",X"00",X"07",X"00",X"00",X"FE",X"FF",X"FE",X"70",X"E0",X"FC",X"00",
		X"07",X"00",X"00",X"01",X"07",X"01",X"00",X"00",X"FC",X"E0",X"70",X"FE",X"FF",X"FE",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"7E",X"3C",X"08",X"1C",X"FE",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FE",X"1C",X"08",X"3C",X"7E",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"07",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"08",X"07",X"00",X"0F",X"00",X"00",X"7F",X"80",X"80",X"00",X"00",X"80",X"00",X"00",X"FF",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"1F",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FF",
		X"C3",X"FF",X"FF",X"7E",X"00",X"00",X"C3",X"C3",X"00",X"00",X"7E",X"FF",X"FF",X"C3",X"C3",X"C3",
		X"00",X"00",X"00",X"02",X"05",X"00",X"03",X"0C",X"00",X"00",X"00",X"10",X"50",X"68",X"88",X"C8",
		X"03",X"0A",X"03",X"01",X"04",X"03",X"00",X"00",X"F4",X"A0",X"C0",X"70",X"40",X"20",X"00",X"00",
		X"00",X"00",X"00",X"00",X"02",X"0A",X"04",X"00",X"00",X"00",X"00",X"00",X"50",X"A0",X"00",X"20",
		X"00",X"09",X"01",X"02",X"00",X"00",X"00",X"00",X"38",X"10",X"00",X"40",X"20",X"00",X"00",X"00",
		X"00",X"02",X"01",X"01",X"01",X"40",X"13",X"01",X"00",X"00",X"00",X"04",X"0C",X"18",X"80",X"90",
		X"00",X"08",X"00",X"00",X"02",X"04",X"00",X"00",X"82",X"CC",X"00",X"10",X"98",X"84",X"00",X"00",
		X"08",X"04",X"00",X"02",X"8C",X"0E",X"07",X"0F",X"01",X"12",X"00",X"04",X"00",X"C0",X"C8",X"E0",
		X"07",X"03",X"21",X"00",X"80",X"21",X"48",X"81",X"C2",X"80",X"01",X"00",X"22",X"00",X"02",X"01",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"20",X"20",X"20",X"C0",X"00",X"C0",X"20",
		X"0A",X"0A",X"0E",X"00",X"00",X"0F",X"04",X"00",X"20",X"20",X"40",X"00",X"20",X"E0",X"20",X"00",
		X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"08",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",X"20",
		X"07",X"00",X"06",X"09",X"08",X"08",X"04",X"00",X"C0",X"00",X"20",X"20",X"A0",X"60",X"20",X"00",
		X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"08",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",X"20",
		X"07",X"00",X"08",X"0D",X"0B",X"09",X"08",X"00",X"C0",X"00",X"C0",X"20",X"20",X"20",X"20",X"00",
		X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"08",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",X"20",
		X"07",X"00",X"06",X"09",X"09",X"09",X"06",X"00",X"C0",X"00",X"C0",X"20",X"20",X"20",X"C0",X"00",
		X"00",X"00",X"00",X"00",X"07",X"08",X"08",X"07",X"00",X"00",X"00",X"00",X"C0",X"20",X"20",X"C0",
		X"00",X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"00",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",
		X"08",X"07",X"00",X"00",X"0F",X"04",X"00",X"00",X"20",X"C0",X"00",X"20",X"E0",X"20",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"06",X"09",X"08",X"08",X"04",X"20",X"C0",X"00",X"20",X"20",X"A0",X"60",X"20",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"00",X"0F",X"40",X"20",X"10",X"20",X"C0",X"00",X"40",X"E0",X"40",X"40",X"40",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"06",X"09",X"09",X"09",X"06",X"20",X"C0",X"00",X"C0",X"20",X"20",X"20",X"C0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"00",X"09",X"09",X"09",X"07",X"20",X"C0",X"00",X"C0",X"20",X"20",X"20",X"C0",
		X"00",X"00",X"0F",X"04",X"00",X"00",X"00",X"00",X"00",X"20",X"E0",X"20",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"06",X"09",X"08",X"08",X"04",X"20",X"C0",X"00",X"20",X"20",X"A0",X"60",X"20",
		X"00",X"0C",X"0B",X"09",X"08",X"08",X"00",X"00",X"00",X"C0",X"20",X"20",X"20",X"40",X"00",X"00",
		X"23",X"43",X"4E",X"3E",X"7F",X"5F",X"4F",X"63",X"F2",X"FC",X"FE",X"7E",X"FE",X"FE",X"FE",X"FE",
		X"3B",X"4F",X"4F",X"3F",X"33",X"5C",X"47",X"22",X"FE",X"FE",X"FC",X"FE",X"FE",X"FE",X"8E",X"FE",
		X"01",X"03",X"0E",X"3E",X"7F",X"5F",X"4F",X"63",X"F0",X"FC",X"FE",X"7E",X"FE",X"FE",X"FE",X"FE",
		X"3B",X"0F",X"0F",X"1F",X"13",X"1C",X"07",X"00",X"FE",X"FE",X"FC",X"FE",X"FE",X"FE",X"8E",X"FC",
		X"00",X"00",X"00",X"00",X"00",X"02",X"07",X"07",X"00",X"00",X"00",X"00",X"08",X"0C",X"A6",X"C6",
		X"0F",X"07",X"01",X"00",X"00",X"00",X"00",X"00",X"90",X"A6",X"06",X"0C",X"08",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"0F",X"07",X"0F",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"F8",
		X"0F",X"07",X"0F",X"00",X"00",X"00",X"00",X"00",X"C6",X"80",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"06",X"07",X"1F",X"1D",X"00",X"00",X"00",X"00",X"00",X"C0",X"C0",X"F0",
		X"08",X"1D",X"1F",X"1D",X"00",X"00",X"00",X"00",X"CE",X"C0",X"C0",X"80",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"08",X"08",X"00",X"00",X"00",X"00",X"00",X"08",X"10",X"00",X"00",
		X"00",X"00",X"08",X"08",X"00",X"00",X"00",X"00",X"00",X"10",X"08",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"20",X"30",X"18",X"1C",X"0E",X"0F",X"00",X"00",X"00",X"20",X"60",X"E4",X"CC",X"7C",
		X"07",X"0E",X"0E",X"07",X"03",X"01",X"00",X"00",X"FA",X"70",X"64",X"FC",X"CC",X"B8",X"00",X"00",
		X"00",X"00",X"00",X"03",X"07",X"0F",X"0F",X"1E",X"00",X"00",X"00",X"C0",X"F0",X"F0",X"F0",X"70",
		X"1E",X"0F",X"0F",X"07",X"03",X"00",X"00",X"00",X"70",X"F0",X"F0",X"F0",X"C0",X"00",X"00",X"00",
		X"00",X"80",X"40",X"20",X"10",X"08",X"04",X"02",X"00",X"10",X"08",X"08",X"1C",X"0C",X"00",X"00",
		X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"E0",X"E0",X"70",X"06",X"02",X"00",X"60",X"20",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"02",X"00",X"04",X"08",X"18",X"30",X"20",X"E0",X"40",
		X"00",X"00",X"71",X"12",X"11",X"16",X"04",X"04",X"00",X"00",X"80",X"00",X"00",X"00",X"00",X"70",
		X"31",X"08",X"00",X"00",X"00",X"00",X"01",X"01",X"C0",X"00",X"00",X"00",X"40",X"C0",X"78",X"00",
		X"01",X"06",X"0C",X"08",X"08",X"10",X"20",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"0A",X"0F",X"03",X"38",X"1E",X"00",X"00",X"00",X"00",X"00",X"80",
		X"03",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"B0",X"30",X"30",X"1C",X"0C",X"04",X"02",X"00",
		X"00",X"00",X"00",X"C0",X"C0",X"C0",X"FF",X"FF",X"00",X"00",X"00",X"03",X"03",X"03",X"FF",X"FF",
		X"FF",X"FF",X"C0",X"C0",X"C0",X"00",X"00",X"00",X"FF",X"FF",X"03",X"03",X"03",X"00",X"00",X"00",
		X"C0",X"E0",X"F0",X"F8",X"DC",X"CE",X"C7",X"C3",X"03",X"03",X"03",X"03",X"03",X"03",X"03",X"83",
		X"C1",X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"C3",X"E3",X"73",X"3B",X"1F",X"0F",X"07",X"03",
		X"38",X"78",X"E0",X"C0",X"C0",X"C0",X"C0",X"C0",X"30",X"30",X"3F",X"3F",X"3F",X"33",X"33",X"03",
		X"C0",X"C0",X"C0",X"E0",X"70",X"38",X"1F",X"0F",X"03",X"03",X"03",X"07",X"0E",X"1C",X"F8",X"F0",
		X"00",X"03",X"07",X"0E",X"1C",X"38",X"70",X"E0",X"00",X"FF",X"FF",X"60",X"60",X"60",X"60",X"60",
		X"E0",X"70",X"38",X"1C",X"0E",X"07",X"03",X"00",X"60",X"60",X"60",X"60",X"60",X"FF",X"FF",X"00",
		X"FF",X"FF",X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"FF",X"FF",X"03",X"03",X"03",X"03",X"03",X"03",
		X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"FF",X"FF",X"03",X"03",X"03",X"03",X"03",X"03",X"FF",X"FF",
		X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"C0",X"03",X"03",X"03",X"03",X"03",X"03",X"03",X"03",
		X"FF",X"FF",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"FF",X"FF",
		X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"03",X"02",X"00",X"00",X"00",X"00",X"00",X"00",X"30",X"30",X"60",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"06",X"00",X"00",X"00",X"00",X"03",X"07",X"00",X"00",X"00",
		X"06",X"04",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"60",X"30",X"30",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"01",X"03",X"00",X"00",X"01",X"02",X"02",X"80",X"C0",X"E0",X"80",X"80",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"01",X"03",X"00",X"00",X"00",X"00",X"00",X"80",X"C0",X"E0",X"80",X"80",X"40",X"20",X"20",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"01",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"80",X"40",X"40",X"20",X"20",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"01",X"01",X"02",X"02",X"40",X"40",X"80",X"80",X"00",X"00",X"00",X"00",
		X"01",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"80",X"40",X"40",X"20",X"20",
		X"00",X"00",X"00",X"00",X"01",X"01",X"02",X"02",X"40",X"40",X"80",X"80",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"01",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"80",X"40",X"40",X"20",X"20",
		X"00",X"00",X"00",X"00",X"01",X"01",X"02",X"02",X"40",X"40",X"80",X"80",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"23",X"64",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"F8",X"60",X"20",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"20",X"60",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"F8",X"64",X"23",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"30",X"0C",X"03",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"0C",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",
		X"30",X"C0",X"00",X"00",X"00",X"00",X"00",X"00",X"30",X"0C",X"03",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"0C",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"30",X"C0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"0C",
		X"30",X"0C",X"03",X"00",X"00",X"00",X"00",X"00",X"30",X"C0",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"19",X"10",X"3B",X"31",X"39",X"3D",X"00",X"00",X"80",X"80",X"C0",X"E0",X"F8",X"C0",
		X"03",X"18",X"1E",X"00",X"06",X"00",X"00",X"00",X"F0",X"F0",X"F0",X"DC",X"DC",X"18",X"10",X"10",
		X"00",X"00",X"04",X"76",X"6F",X"71",X"39",X"3F",X"00",X"00",X"00",X"00",X"BC",X"FE",X"FE",X"C6",
		X"01",X"1C",X"16",X"1A",X"0E",X"00",X"00",X"00",X"F2",X"FA",X"FE",X"DE",X"DC",X"08",X"08",X"18",
		X"00",X"00",X"01",X"01",X"63",X"33",X"9F",X"FF",X"00",X"F6",X"FE",X"FE",X"FE",X"FC",X"FC",X"FE",
		X"FF",X"3F",X"03",X"31",X"00",X"04",X"00",X"00",X"FE",X"DE",X"DF",X"DF",X"DE",X"0C",X"1C",X"7C",
		X"31",X"14",X"02",X"03",X"3B",X"1F",X"4F",X"7F",X"00",X"40",X"17",X"B7",X"FF",X"FF",X"FE",X"FE",
		X"01",X"01",X"30",X"30",X"0C",X"0C",X"00",X"00",X"FE",X"FF",X"CF",X"CF",X"8F",X"8E",X"8C",X"3C",
		X"00",X"01",X"01",X"05",X"05",X"0E",X"36",X"34",X"00",X"80",X"E0",X"F0",X"FC",X"7C",X"38",X"38",
		X"36",X"3B",X"18",X"1F",X"0F",X"07",X"00",X"00",X"B8",X"BC",X"3C",X"10",X"90",X"D0",X"70",X"00",
		X"06",X"03",X"01",X"1D",X"15",X"4C",X"5F",X"6E",X"00",X"E8",X"FC",X"FC",X"FC",X"3C",X"9C",X"DE",
		X"E4",X"F2",X"F9",X"FC",X"3F",X"1F",X"07",X"00",X"5E",X"DE",X"1C",X"08",X"C4",X"E2",X"C6",X"00",
		X"07",X"3F",X"1F",X"07",X"31",X"6C",X"07",X"AE",X"E0",X"FB",X"FF",X"FF",X"FC",X"7E",X"3F",X"9C",
		X"9E",X"C8",X"66",X"72",X"39",X"3C",X"1F",X"07",X"DC",X"08",X"CF",X"9C",X"1C",X"0E",X"C6",X"C6",
		X"12",X"4D",X"19",X"0F",X"07",X"31",X"50",X"0F",X"28",X"48",X"6D",X"3F",X"BF",X"FF",X"7F",X"1F",
		X"5C",X"38",X"98",X"CC",X"4C",X"67",X"30",X"38",X"CF",X"CF",X"27",X"27",X"C7",X"8E",X"1C",X"7C",
		X"00",X"00",X"10",X"18",X"30",X"38",X"38",X"3C",X"00",X"00",X"C0",X"40",X"E8",X"64",X"E0",X"F0",
		X"3E",X"3F",X"1F",X"19",X"09",X"07",X"00",X"00",X"F8",X"98",X"8C",X"84",X"04",X"04",X"04",X"00",
		X"00",X"00",X"00",X"0B",X"1D",X"1B",X"3D",X"3B",X"00",X"00",X"00",X"00",X"80",X"90",X"D8",X"FC",
		X"3D",X"3F",X"3F",X"1F",X"13",X"19",X"07",X"00",X"C4",X"E0",X"F0",X"18",X"0C",X"04",X"0C",X"10",
		X"00",X"00",X"07",X"29",X"2E",X"2F",X"29",X"2F",X"00",X"40",X"20",X"30",X"60",X"70",X"30",X"30",
		X"2F",X"26",X"30",X"19",X"09",X"00",X"00",X"00",X"30",X"60",X"F0",X"E0",X"A0",X"E0",X"00",X"00",
		X"00",X"01",X"1C",X"A4",X"B9",X"BD",X"A4",X"BC",X"00",X"00",X"80",X"80",X"C0",X"C0",X"C0",X"80",
		X"BC",X"99",X"C3",X"67",X"26",X"00",X"00",X"00",X"80",X"C0",X"C0",X"80",X"80",X"E0",X"00",X"00",
		X"00",X"00",X"30",X"1C",X"1F",X"0F",X"07",X"00",X"00",X"00",X"F8",X"FC",X"7C",X"3C",X"3C",X"78",
		X"00",X"07",X"0F",X"1F",X"1C",X"30",X"00",X"00",X"78",X"3C",X"3C",X"7C",X"FC",X"F8",X"00",X"00",
		X"00",X"00",X"00",X"0F",X"0F",X"3F",X"3C",X"00",X"00",X"00",X"3C",X"3C",X"3C",X"7C",X"78",X"F8",
		X"00",X"3C",X"3F",X"0F",X"0F",X"00",X"00",X"00",X"F8",X"78",X"7C",X"3C",X"3C",X"3C",X"00",X"00",
		X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"08",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",X"20",
		X"07",X"00",X"06",X"09",X"08",X"08",X"04",X"00",X"C0",X"00",X"20",X"20",X"A0",X"60",X"20",X"00",
		X"00",X"00",X"00",X"02",X"05",X"00",X"03",X"0C",X"00",X"00",X"00",X"10",X"50",X"68",X"88",X"C8",
		X"03",X"0A",X"03",X"01",X"04",X"03",X"00",X"00",X"F4",X"A0",X"C0",X"70",X"40",X"20",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"20",X"2B",X"01",X"13",X"00",X"4C",X"10",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"20",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"12",X"17",X"08",X"00",X"09",X"00",X"02",X"00",X"03",X"02",X"84",X"89",X"10",X"88",X"84",X"01",
		X"0F",X"06",X"04",X"00",X"00",X"01",X"01",X"02",X"C2",X"67",X"21",X"21",X"C2",X"82",X"91",X"08",
		X"00",X"08",X"04",X"14",X"01",X"63",X"50",X"08",X"0A",X"16",X"02",X"21",X"07",X"84",X"2C",X"18",
		X"06",X"00",X"46",X"21",X"00",X"11",X"26",X"20",X"01",X"41",X"0F",X"10",X"0E",X"02",X"02",X"0E",
		X"07",X"08",X"08",X"08",X"07",X"00",X"09",X"0A",X"C0",X"20",X"20",X"20",X"C0",X"00",X"C0",X"20",
		X"0A",X"0A",X"0E",X"00",X"00",X"0F",X"04",X"00",X"20",X"20",X"40",X"00",X"20",X"E0",X"20",X"00",
		X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"08",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",X"20",
		X"07",X"00",X"06",X"09",X"08",X"08",X"04",X"00",X"C0",X"00",X"20",X"20",X"A0",X"60",X"20",X"00",
		X"01",X"03",X"0F",X"17",X"31",X"00",X"00",X"00",X"F8",X"FC",X"7E",X"3E",X"FE",X"FE",X"36",X"06",
		X"00",X"00",X"00",X"07",X"09",X"0E",X"07",X"00",X"0E",X"1E",X"9C",X"FE",X"FE",X"7E",X"8E",X"FC",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"06",X"02",X"02",X"0A",X"06",X"1E",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"0A",X"0C",X"0E",X"02",X"0C",X"06",X"00",X"00",
		X"00",X"00",X"00",X"00",X"07",X"08",X"08",X"07",X"00",X"00",X"00",X"00",X"C0",X"20",X"20",X"C0",
		X"00",X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"00",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",
		X"08",X"07",X"00",X"00",X"0F",X"04",X"00",X"00",X"20",X"C0",X"00",X"20",X"E0",X"20",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"06",X"09",X"08",X"08",X"04",X"20",X"C0",X"00",X"20",X"20",X"A0",X"60",X"20",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"00",X"0F",X"04",X"02",X"01",X"20",X"C0",X"00",X"40",X"E0",X"40",X"40",X"40",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"06",X"09",X"09",X"09",X"06",X"20",X"C0",X"00",X"C0",X"20",X"20",X"20",X"C0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"00",X"09",X"09",X"09",X"07",X"20",X"C0",X"00",X"C0",X"20",X"20",X"20",X"C0",
		X"00",X"00",X"0F",X"04",X"00",X"00",X"00",X"00",X"00",X"20",X"E0",X"20",X"00",X"00",X"00",X"00",
		X"08",X"07",X"00",X"06",X"09",X"08",X"08",X"04",X"20",X"C0",X"00",X"20",X"20",X"A0",X"60",X"20",
		X"00",X"0C",X"0B",X"09",X"08",X"08",X"00",X"00",X"00",X"C0",X"20",X"20",X"20",X"40",X"00",X"00",
		X"23",X"43",X"4E",X"3E",X"7F",X"5F",X"4F",X"63",X"F2",X"FC",X"FE",X"7E",X"FE",X"FE",X"FE",X"FE",
		X"3B",X"4F",X"4F",X"3F",X"33",X"5C",X"47",X"22",X"FE",X"FE",X"FC",X"FE",X"FE",X"FE",X"8E",X"FE",
		X"01",X"03",X"0E",X"3E",X"7F",X"5F",X"4F",X"63",X"F0",X"FC",X"FE",X"7E",X"FE",X"FE",X"FE",X"FE",
		X"3B",X"0F",X"0F",X"1F",X"13",X"1C",X"07",X"00",X"FE",X"FE",X"FC",X"FE",X"FE",X"FE",X"8E",X"FC",
		X"00",X"00",X"00",X"00",X"00",X"02",X"07",X"07",X"00",X"00",X"00",X"00",X"08",X"0C",X"A6",X"C6",
		X"0F",X"07",X"01",X"00",X"00",X"00",X"00",X"00",X"90",X"A6",X"06",X"0C",X"08",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"0F",X"07",X"0F",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"F8",
		X"0F",X"07",X"0F",X"00",X"00",X"00",X"00",X"00",X"C6",X"80",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"06",X"07",X"1F",X"1D",X"00",X"00",X"00",X"00",X"00",X"C0",X"C0",X"F0",
		X"08",X"1D",X"1F",X"1D",X"00",X"00",X"00",X"00",X"CE",X"C0",X"C0",X"80",X"00",X"00",X"00",X"00",
		X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"08",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",X"20",
		X"07",X"00",X"08",X"0D",X"0B",X"09",X"08",X"00",X"C0",X"00",X"C0",X"20",X"20",X"20",X"40",X"00",
		X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"08",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",X"20",
		X"07",X"00",X"00",X"0F",X"04",X"02",X"01",X"00",X"C0",X"00",X"40",X"E0",X"40",X"40",X"40",X"C0",
		X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"08",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",X"20",
		X"07",X"00",X"09",X"0A",X"0A",X"0A",X"0E",X"00",X"C0",X"00",X"C0",X"20",X"20",X"20",X"40",X"00",
		X"07",X"08",X"08",X"07",X"00",X"07",X"08",X"08",X"C0",X"20",X"20",X"C0",X"00",X"C0",X"20",X"20",
		X"07",X"00",X"07",X"08",X"08",X"07",X"00",X"0F",X"C0",X"00",X"C0",X"20",X"20",X"C0",X"00",X"E0",
		X"00",X"00",X"00",X"00",X"00",X"15",X"15",X"2F",X"00",X"00",X"00",X"00",X"00",X"E0",X"E0",X"C0",
		X"60",X"C0",X"FF",X"C0",X"60",X"20",X"00",X"00",X"30",X"60",X"F8",X"00",X"00",X"00",X"00",X"00",
		X"00",X"01",X"03",X"00",X"00",X"0A",X"0A",X"07",X"70",X"FC",X"26",X"20",X"20",X"F0",X"F0",X"E0",
		X"00",X"04",X"04",X"00",X"00",X"00",X"00",X"00",X"30",X"3C",X"20",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"01",X"06",X"01",X"07",X"01",X"07",X"70",X"F8",X"AC",X"20",X"20",X"20",X"20",X"20",
		X"07",X"07",X"06",X"00",X"00",X"00",X"00",X"00",X"20",X"60",X"E0",X"A0",X"20",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"06",X"01",X"27",X"61",X"00",X"00",X"00",X"00",X"00",X"60",X"00",X"00",
		X"47",X"C7",X"FF",X"C6",X"40",X"60",X"20",X"00",X"00",X"00",X"E0",X"C0",X"40",X"40",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"15",X"15",X"0F",X"00",X"00",X"00",X"00",X"00",X"E0",X"E0",X"C0",
		X"10",X"30",X"7F",X"30",X"10",X"00",X"00",X"00",X"30",X"60",X"F0",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"0A",X"0A",X"07",X"00",X"00",X"00",X"00",X"00",X"F0",X"F0",X"E0",
		X"04",X"0C",X"1F",X"0C",X"04",X"00",X"00",X"00",X"08",X"18",X"FC",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"06",X"01",X"07",X"01",X"07",X"00",X"20",X"70",X"F8",X"20",X"20",X"20",X"20",
		X"07",X"07",X"06",X"00",X"00",X"00",X"00",X"00",X"20",X"60",X"E0",X"A0",X"20",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"06",X"01",X"07",X"01",X"00",X"00",X"00",X"20",X"70",X"F8",X"20",X"20",
		X"07",X"07",X"07",X"06",X"00",X"00",X"00",X"00",X"20",X"20",X"20",X"60",X"E0",X"20",X"00",X"00",
		X"00",X"00",X"00",X"00",X"03",X"03",X"01",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"0C",X"02",X"0E",X"02",X"0E",X"0C",X"00",X"00",X"00",X"00",X"00",X"00",X"18",X"78",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"01",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"80",X"E0",X"20",
		X"01",X"00",X"01",X"00",X"01",X"01",X"00",X"00",X"80",X"40",X"C0",X"46",X"DE",X"80",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"0E",X"00",X"00",X"00",X"00",X"0C",X"0C",X"04",X"04",
		X"0C",X"01",X"02",X"02",X"00",X"00",X"00",X"00",X"00",X"E0",X"B0",X"B0",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;