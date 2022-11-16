Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity LogicUnit is
Generic ( N : natural := 64 );
-- A and B are input signals
Port 	( 	A 	: in std_logic_vector( N-1 downto 0 );
		B 	: in std_logic_vector( N-1 downto 0 );
-- LogicFN is the control signal
		LogicFN : in std_logic_vector( 1 downto 0);
-- Y is the output signal
		Y 	: out std_logic_vector(N-1 downto 0 ) );
End Entity LogicUnit;

Architecture rtl of LogicUnit is
	signal X2: std_logic_vector( N-1 downto 0);
	signal O2: std_logic_vector( N-1 downto 0);
	signal A2: std_logic_vector( N-1 downto 0);

Begin
-- goes through all the bits and performs XOR,OR, AND operations on each bit
AIO: for d in 0 to N-1 generate
	X2(d) <= A(d) xor B(d);
 	O2(d) <= A(d) or B(d);
 	A2(d) <= A(d) and B(d);
end generate AIO;

-- multiplexer where LogicFN selects which signal will be the output
Y <= 	B when LogicFN = "00" else
	X2 when LogicFN = "01" else
	O2 when LogicFN = "10" else
	A2;

End Architecture rtl;