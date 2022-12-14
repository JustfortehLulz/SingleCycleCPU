library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFile is
    generic (N : natural := 64);
    port 
    (
        regA : in std_logic_vector (4 downto 0);
        regB : in std_logic_vector (4 downto 0);
        regD : in std_logic_vector (4 downto 0);
        regWrite : in std_logic;
        writeVal : in std_logic_vector(N-1 downto 0);
        outA : out std_logic_vector(N-1 downto 0);
        outB : out std_logic_vector(N-1 downto 0)
    );
end registerFile;

architecture rtl of registerFile is
    type file_reg is array (0 to 31) of std_logic_vector(N-1 downto 0);
    signal reg : file_reg;
begin
    process(regA, regB, regD, regWrite, writeVal) is
        variable interA : std_logic_vector(N-1 downto 0);
        variable interB : std_logic_vector(N-1 downto 0);
        variable interRegD : std_logic_vector(4 downto 0);
        variable interWriteVal : std_logic_vector(N-1 downto 0);
        begin
            reg(0) <= (others => '0');
            -- writing values into the registerFile
            if(regWrite = '1') then
                interRegD := regD;
                interWriteVal := writeVal;

                reg(to_integer(unsigned(interRegD))) <= interWriteVal;
                outA <= (others => 'X');
                outB <= (others => 'X');
            -- reading values from registerFile
            elsif (regWrite = '0') then
                outA <= reg(to_integer(unsigned(regA)));
                outB <= reg(to_integer(unsigned(regB)));
            else
                outA <= (others => 'X');
                outB <= (others => 'X');
            end if;

        end process;

end architecture;