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
        imm : out std_logic_vector(11 downto 0);
        longImm : out std_logic_vector(19 downto 0)
    );
end decoder;

architecture rtl of decoder is
begin
    -- read the last 7 bits to determine the opcode
        Process(instruction) is
            constant R_TYPE : std_logic_vector(6 downto 0) := "0110011";
            constant I_TYPE : std_logic_vector(6 downto 0) := "0010011";
            constant I_TYPE_LOAD : std_logic_vector(6 downto 0) := "0000011";
            constant I_TYPE_JALR : std_logic_vector(6 downto 0) := "1100111";
            constant S_TYPE : std_logic_vector(6 downto 0) := "0100011";
            constant B_TYPE : std_logic_vector(6 downto 0) := "1100011";
            constant J_TYPE : std_logic_vector(6 downto 0) := "1101111";
            constant LUI_TYPE : std_logic_vector(6 downto 0) := "0110111";
            constant AUIPC_TYPE : std_logic_vector(6 downto 0) := "0010111";
            variable interop : std_logic_vector(6 downto 0) := "0000000";
            variable inter3 : std_logic_vector(2 downto 0) := "000";
            variable interRD : std_logic_vector(4 downto 0) := "00000";
            variable interR1 : std_logic_vector(4 downto 0) := "00000";
            variable imm7 : std_logic_vector(6 downto 0) := "0000000";
            variable interImm : std_logic_vector(11 downto 0) := "000000000000";
            variable interLongImm : std_logic_vector(19 downto 0) := "00000000000000000000";
        Begin
            interop := instruction(6 downto 0);
            if interop = R_TYPE then
                rd <= instruction(11 downto 7);
                funct3 <= instruction(14 downto 12);
                rs1 <= instruction(19 downto 15);
                rs2 <= instruction(24 downto 20);
                funct7 <= instruction(31 downto 25);
                imm <= (others => 'X');
                longImm <= (others => 'X');
            elsif interop = I_TYPE then
                rd <= instruction(11 downto 7);
                inter3 := instruction(14 downto 12); -- added since switching for SLLI instructions cause issues
                rs1 <= instruction(19 downto 15);
                imm7 := instruction(31 downto 25);
                imm <= instruction(31 downto 20);
                rs2 <= (others => 'X');
                interLongImm := (others => 'X');
                if(inter3 = "001") then
                    funct7 <= (others => '0');
                elsif(inter3 = "101" and imm7 = "0000000") then
                    funct7 <= (others => '0');
                elsif(inter3 = "101" and imm7 = "0010100") then
                    funct7 <= "0010100";
                else
                    funct7 <= (others => 'X');
                end if;
                longImm <= interLongImm;
                funct3 <= inter3;
            elsif interop = I_TYPE_LOAD then
                interRD := instruction(11 downto 7);
                funct3 <= instruction(14 downto 12);
                interR1 := instruction(19 downto 15);
                imm <= instruction(31 downto 20);
                longImm <= (others => 'X');

                rd <= interRD;
                rs1 <= interR1;
            elsif interop = I_TYPE_JALR then
                interRD := instruction(11 downto 7);
                inter3 := instruction(14 downto 12);
                interR1 := instruction(19 downto 15);
                interImm := instruction(31 downto 20);

                rd <= interRD;
                funct3 <= inter3;
                rs1 <= interR1;
                imm <= interImm;
            elsif interop = S_TYPE then
                interImm(4 downto 0) := instruction(11 downto 7);
                inter3 := instruction(14 downto 12);
                rs1 <= instruction(19 downto 15);
                rs2 <= instruction(24 downto 20);
                interImm(11 downto 5) := instruction(31 downto 25);

                rd <= (others => 'X');
                funct7 <= (others => 'X');
                longImm <= (others => 'X');
                funct3 <= inter3;
                imm <= interImm;
            elsif interop = B_TYPE then
                inter3 := instruction(14 downto 12);
                rs1 <= instruction(19 downto 15);
                rs2 <= instruction(24 downto 20);
                interImm := instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8);

                rd <= (others => 'X');
                funct7 <= (others => 'X');
                longImm <= (others => 'X');
                funct3 <= inter3;
                imm <= interImm;
            elsif interop = J_TYPE then
                funct7 <= (others => 'X');
                rs2 <= (others => 'X');
                rs1 <= (others => 'X');
                funct3 <= (others => 'X');
                imm <= (others => 'X');

                rd <= instruction(11 downto 7);
                interLongImm := instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21);
                longImm <= interLongImm;
            elsif interop = LUI_TYPE then
                funct7 <= (others => 'X');
                rs2 <= (others => 'X');
                rs1 <= (others => 'X');
                funct3 <= (others => 'X');
                imm <= (others => 'X');

                interRD := instruction(11 downto 7);
                interLongImm := instruction(31 downto 12);
                rd <= interRD;
                longImm <= interLongImm;
            elsif interop = AUIPC_TYPE then
                funct7 <= (others => 'X');
                rs2 <= (others => 'X');
                rs1 <= (others => 'X');
                funct3 <= (others => 'X');
                imm <= (others => 'X');

                interRD := instruction(11 downto 7);
                interLongImm := instruction(31 downto 12);
                rd <= interRD;
                longImm <= interLongImm;
            else 
                rd <= (others => '0');
                funct3 <= (others => '0');
                rs1 <= (others => '0');
                rs2 <= (others => '0');
                funct7 <= (others => '0');
                imm <= (others => '0');
                longImm <= (others => '0');
            end if;
            opcode <= interop;
        end process;

end architecture;