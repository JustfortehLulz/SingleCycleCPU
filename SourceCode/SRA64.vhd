Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
use ieee.math_real.all;		--needed to use ceil() function

Entity SRA64 is
Generic ( N : natural := 64 );
-- X is the input of the SRA
	Port ( X : in std_logic_vector( N-1 downto 0 );
-- Y is the output of the SRA
		Y : out std_logic_vector( N-1 downto 0 );
-- ShiftCount determines how much shifting is done
	ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Entity SRA64;

architecture structure of SRA64 is
	signal shift1: std_logic_vector(N-1 downto 0);
begin

-- Shift when ShiftCount is non-zero else it will not shift
	shift1 <= X when ShiftCount = "000000" else
		std_logic_vector(SHIFT_RIGHT(signed(X),to_integer(ShiftCount)));

	Y <= shift1;
end architecture structure;