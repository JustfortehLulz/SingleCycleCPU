Library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Adder is
Generic ( N : natural := 64 );
Port ( 
	A, B : in std_logic_vector( N-1 downto 0 );
	Y : out std_logic_vector( N-1 downto 0 );
	Cin : in std_logic;
	Cout, Ovfl : out std_logic );
End Entity Adder;

library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.STD_LOGIC_ARITH.ALL;
use     IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Cprop is
Port (
          G, P, Cin     : in     std_logic;
          Cout          : out    std_logic );
end entity Cprop;

architecture Structural of Cprop is
     signal     t     :     std_logic;
begin
     t <= Cin and P;
     Cout <= G or t;
end architecture Structural;

architecture Structural of Adder is
	signal G: std_logic_vector(N-1 downto 0); 	
	signal P: std_logic_vector(N-1 downto 0);
	signal iq: std_logic_vector(N downto 0);
begin

	iq(0) <= Cin;

carry:	for z in 0 to N-1 generate
	G(z) <= A(z) and B(z);
	P(z) <= A(z) xor B(z);
A0: 	entity work.Cprop	port map(G(z), P(z), iq(z), iq(z+1));
	end generate carry;

	Y <= P xor iq(N-1 downto 0);
	Cout <= iq(N);

	Ovfl <= iq(N) xor iq(N-1);

end architecture Structural;
