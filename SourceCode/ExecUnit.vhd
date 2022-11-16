Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity ExecUnit is
Generic ( N : natural := 64 );
Port ( A, B : in std_logic_vector( N-1 downto 0 );
	NotA : in std_logic := '0';
	FuncClass, LogicFN, ShiftFN : in std_logic_vector( 1 downto 0 );
	AddnSub, ExtWord : in std_logic := '0';
	Y : out std_logic_vector( N-1 downto 0 );
	Zero, AltB, AltBu : out std_logic );
End Entity ExecUnit;

Architecture rtl of ExecUnit is
	signal AdderOutput, arithY, ShiftOutput, LogicOutput: std_logic_vector( N-1 downto 0 );
	signal AltBu64, AltB64: std_logic_vector( N-1 downto 0 );
	signal interY: std_logic_vector( N-1 downto 0);
	signal Cout, Ovfl, interAltB, interAltBu: std_logic;

Begin

Arith: entity work.ArithUnit port map(A, B, AdderOutput, arithY, NotA, AddnSub, ExtWord, Cout, Ovfl, Zero, interAltB, interAltBu);

Shift: entity work.ShiftUnit port map(A, B, AdderOutput, ShiftOutput, ShiftFN, ExtWord);

Logic: entity work.LogicUnit port map(A, B, LogicFN, LogicOutput);

	AltBu64 <= X"000000000000000" & "000" & interAltBu;
	AltB64 <= X"000000000000000" & "000" & interAltB;

	interY <= AltBu64 when FuncClass = "00" else
			AltB64 when FuncClass = "01" else
			ShiftOutput when FuncClass = "10" else
			LogicOutput;

	AltBu <= interAltBu;
	AltB <= interAltB;
	Y <= interY;
End Architecture rtl;
