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
    -- read the last 7 bits to determine the opcode
        Process(instruction) is
            constant R_TYPE : std_logic_vector(6 downto 0) := "0110011";
            variable interop : std_logic_vector(6 downto 0) := "0000000";
        Begin
            interop := instruction(6 downto 0);
            if interop = R_TYPE then
                rd <= instruction(11 downto 7);
                funct3 <= instruction(14 downto 12);
                rs1 <= instruction(19 downto 15);
                rs2 <= instruction(24 downto 20);
                funct7 <= instruction(31 downto 25);
            else 
                rd <= (others => '0');
                funct3 <= (others => '0');
                rs1 <= (others => '0');
                rs2 <= (others => '0');
                funct7 <= (others => '0');
            end if;
            opcode <= interop;
        end process;

end architecture;