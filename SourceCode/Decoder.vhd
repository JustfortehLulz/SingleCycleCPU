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
        rd : out std_logic_vector(4 downto 0);
        imm : out std_logic_vector(11 downto 0)
    );
end decoder;

architecture rtl of decoder is
begin
    -- read the last 7 bits to determine the opcode
        Process(instruction) is
            constant R_TYPE : std_logic_vector(6 downto 0) := "0110011";
            constant I_TYPE : std_logic_vector(6 downto 0) := "0010011";
            constant I_TYPE_LOAD : std_logic_vector(6 downto 0) := "0000011";
            variable interop : std_logic_vector(6 downto 0) := "0000000";
            variable inter3 : std_logic_vector(2 downto 0) := "000";
            variable interRD : std_logic_vector(4 downto 0) := "00000";
            variable interR1 : std_logic_vector(4 downto 0) := "00000";
            variable imm7 : std_logic_vector(6 downto 0) := "0000000";
        Begin
            interop := instruction(6 downto 0);
            if interop = R_TYPE then
                rd <= instruction(11 downto 7);
                funct3 <= instruction(14 downto 12);
                rs1 <= instruction(19 downto 15);
                rs2 <= instruction(24 downto 20);
                funct7 <= instruction(31 downto 25);
                imm <= (others => 'X');
            elsif interop = I_TYPE then
                rd <= instruction(11 downto 7);
                inter3 := instruction(14 downto 12); -- added since switching for SLLI instructions cause issues
                rs1 <= instruction(19 downto 15);
                imm7 := instruction(31 downto 25);
                imm <= instruction(31 downto 20);
                rs2 <= (others => 'X');
                if(inter3 = "001") then
                    funct7 <= (others => '0');
                elsif(inter3 = "101" and imm7 = "0000000") then
                    funct7 <= (others => '0');
                elsif(inter3 = "101" and imm7 = "0010100") then
                    funct7 <= "0010100";
                else
                    funct7 <= (others => 'X');
                end if;
                funct3 <= inter3;
            elsif interop = I_TYPE_LOAD then
                interRD := instruction(11 downto 7);
                funct3 <= instruction(14 downto 12);
                interR1 := instruction(19 downto 15);
                imm <= instruction(31 downto 20);
                rd <= interRD;
                rs1 <= interR1;
            else 
                rd <= (others => '0');
                funct3 <= (others => '0');
                rs1 <= (others => '0');
                rs2 <= (others => '0');
                funct7 <= (others => '0');
                imm <= (others => '0');
            end if;
            opcode <= interop;
        end process;

end architecture;