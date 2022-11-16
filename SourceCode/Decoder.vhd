library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    generic (N : natural := 64);
    port (
        instruction : in std_logic_vector(31 downto 0);
        opcode : out std_logic_vector(6 downto 0);
        funct7 : out std_logic_vector(6 downto 0);
        funct3 : out std_logic_vector(2 downto 0);
        rs1 : out std_logic_vector(4 downto 0);
        rs2 : out std_logic_vector(4 downto 0);
        rd : out std_logic_vector(4 downto 0)
    );
end decoder;

architecture rtl of decoder is

begin

end architecture;