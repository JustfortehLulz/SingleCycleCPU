Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity ShiftUnit is
Generic ( N : natural := 64 );
Port ( A, B, C : in std_logic_vector( N-1 downto 0 );
	Y : out std_logic_vector( N-1 downto 0 );
	ShiftFN : in std_logic_vector( 1 downto 0 );
	ExtWord : in std_logic );
End Entity ShiftUnit;

architecture rtl of ShiftUnit is
	signal extractShift: std_logic_vector(5 downto 0);
	signal swapWord: std_logic;
	signal interA, interC, shiftA: std_logic_vector(N-1 downto 0);
	signal SLLoutput, SRLoutput, SRAoutput: std_logic_vector(N-1 downto 0);
	signal signal2A, signal2B: std_logic_vector(N-1 downto 0);
	signal signal1A, signal1B: std_logic_vector(N-1 downto 0);
	signal resize2A, resize1A: std_logic_vector((N/2)-1 downto 0);
	signal signalC:	std_logic_vector(N-1 downto 0);
begin
-- extracted the lower 6 bits that make the ShiftCount
	extractShift <= B(5 downto 0) when ExtWord = '0' else '0' & B(4 downto 0);
	
	swapWord <= ShiftFN(1) and ExtWord;

	interA <= A;
	interC <= C;

	shiftA <= interA when swapWord = '0' else
		interA(31 downto 0) & interA(63 downto 32);

SLL64: entity work.SLL64 port map (shiftA, SLLoutput, unsigned(extractShift));
SRL64: entity work.SRL64 port map (shiftA, SRLoutput, unsigned(extractShift));
SRA64: entity work.SRA64 port map (shiftA, SRAoutput, unsigned(extractShift));

-- selects between shift right logical and shift right arithmetic
	signal2A <= SRLoutput when ShiftFN(0) = '0' else
			SRAoutput when ShiftFN(0) = '1';

-- grabbing the first 32 bits of the output signal of SRL or SRA
	resize2A <= signal2A(31 downto 0) when ShiftFN(1) = '0' else 
			signal2A(63 downto 32);

-- sign extend upper 32 bits of signal2A
	signal2B <= signal2A when ExtWord = '0' else
			std_logic_vector(RESIZE(signed(resize2A),N)) when ExtWord = '1';

-- selects between C and shift left logical output
	signal1A <= interC when ShiftFN(0) = '0' else
			SLLoutput when ShiftFN(0) = '1';

	resize1A <= signal1A(31 downto 0);

-- sign extend lower of signal 1A
	signal1B <= signal1A when ExtWord = '0' else
			std_logic_vector(RESIZE(signed(resize1A),N)) when ExtWord = '1';

-- selects which shift was performed 
-- signal1B SLL
-- signal2B SRA or SRL
	signalC <= signal1B when ShiftFN(1) = '0' else
			signal2B when ShiftFN(1) = '1';

	Y <= signalC;


end architecture rtl;