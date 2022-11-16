Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
use ieee.math_real.all;		--needed to use ceil() function

Entity SLL64 is
Generic ( N : natural := 64 );
-- X is the input of the SLL
	Port ( X : in std_logic_vector( N-1 downto 0 );
-- Y is the output of the SLL
		Y : out std_logic_vector( N-1 downto 0 );
-- ShiftCount determines how much shifting is done
	ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Entity SLL64;

architecture structure of SLL64 is
	signal shift1: std_logic_vector(N-1 downto 0);
	signal shift2: std_logic_vector(N-1 downto 0);
	signal shift3: std_logic_vector(N-1 downto 0);

begin
	--first MUX shift by either 1 bit, 2 bits, or 3 bits depending on bit 0 and bit 1 of ShiftCount
	shift1 <= X when ShiftCount(1 downto 0) = "00" else
		std_logic_vector(SHIFT_LEFT(unsigned(X),1)) when ShiftCount(1 downto 0) = "01" else
		std_logic_vector(SHIFT_LEFT(unsigned(X),2)) when ShiftCount(1 downto 0) = "10" else
		std_logic_vector(SHIFT_LEFT(unsigned(X),3)) when ShiftCount(1 downto 0) = "11";
		

	--second MUX will shift by either 4 bits, 8 bits, or 12 bits depending on bit 2 and bit 3 of ShiftCount
	shift2 <= shift1 when ShiftCount(3 downto 2) = "00" else
		std_logic_vector(SHIFT_LEFT(unsigned(shift1),4)) when ShiftCount(3 downto 2) = "01" else
		std_logic_vector(SHIFT_LEFT(unsigned(shift1),8)) when ShiftCount(3 downto 2) = "10" else
		std_logic_vector(SHIFT_LEFT(unsigned(shift1),12)) when ShiftCount(3 downto 2) = "11";
	

	--third MUX will shift by either 16 bits, 32 bits, or 48 bits depending on bit 4 and bit 5 of ShiftCount
	shift3 <= shift2 when ShiftCount(5 downto 4) = "00" else
		std_logic_vector(SHIFT_LEFT(unsigned(shift2),16)) when ShiftCount(5 downto 4) = "01" else
		std_logic_vector(SHIFT_LEFT(unsigned(shift2),32)) when ShiftCount(5 downto 4) = "10" else
		std_logic_vector(SHIFT_LEFT(unsigned(shift2),48)) when ShiftCount(5 downto 4) = "11";
	
	Y <= shift3;
end architecture;