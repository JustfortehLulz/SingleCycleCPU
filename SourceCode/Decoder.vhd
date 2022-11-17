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
    signal interop : std_logic_vector(6 downto 0);
begin
    -- read the last 7 bits to determine the opcode
    process(instruction) is
        begin
            interop <= instruction(6 downto 0);
            opcode <= interop;
            if interop = "0110011" then
                rd <= instruction(11 downto 7);
                funct3 <= instruction(14 downto 12);
                rs1 <= instruction(19 downto 15);
                rs2 <= instruction(24 downto 20);
                funct7 <= instruction(31 downto 25);
            else
                rd <= (others => 'X');
                funct3 <= (others => 'X');
                rs1 <= (others => 'X');
                rs2 <= (others => 'X');
                funct7 <= (others => 'X');
            end if;
    end process;

end architecture;