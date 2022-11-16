Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity ArithUnit is
Generic ( N : natural := 64 );
Port ( A, B : in std_logic_vector( N-1 downto 0 );
AddY, Y : out std_logic_vector( N-1 downto 0 );
-- Control signals
NotA, AddnSub, ExtWord : in std_logic := '0';
-- Status signals
Cout, Ovfl, Zero, AltB, AltBu : out std_logic );
End Entity ArithUnit;


Architecture rtl of ArithUnit is
	signal interB: std_logic_vector(N-1 downto 0);
	signal interA: std_logic_vector(N-1 downto 0);
	signal interY: std_logic_vector(N-1 downto 0);
	signal interCout, interOvfl: std_logic;
	
Begin
-- Negates signal B
-- InterB is the output
	interB <= B when AddnSub = '0' else
		not B when AddnSub = '1';
-- Negates signal A
-- InterA is the output
	interA <= A when NotA = '0' else
		not A when NotA = '1';

-- Inputs interA, interB, AddnSub
-- Outputs interY, interCout, interOvfl
adder: entity Work.Adder port map (interA, interB, interY, AddnSub, interCout, interOvfl);

-- Adder output before sign extension occurs
	addY <= interY;

-- Extends the 31st bit of interY when ExtWord is 1
-- Y is the output of the multiplexer
	Y <= interY when ExtWord = '0' else
		 "00000000000000000000000000000000" & interY(31 downto 0) when ExtWord = '1' and interY(31) = '0' else
		"11111111111111111111111111111111" & interY(31 downto 0) when ExtWord = '1' and interY(31) = '1';

-- Zero signal when all interY bits are 0	
	Zero <= '1' when interY = "0000000000000000000000000000000000000000000000000000000000000000" else
	'0';

-- AltB is created from odd parity of interY and interOvfl
	AltB <= interY(N-1) xor interOvfl;

	AltBu <= not interCout;

	Cout <= interCout;
	Ovfl <= interOvfl;
End Architecture rtl;