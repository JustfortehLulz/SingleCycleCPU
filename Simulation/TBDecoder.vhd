library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Use std.TEXTIO.all;

use std.textio.all;
use std.env.finish;

entity decoder_tb is
    generic (N : natural := 64);
end decoder_tb;

architecture behavioural of decoder_tb is

    -- TODO: Next steps, wait until allout is finished and compare the values
	constant TestVectorFile : string := "DecoderUnit00.tvs";
	constant ClockPeriod : time := 2 ns;
	constant ResetPeriod : time := 5 ns;
	constant PreStimTime : time := 1 ns;
	constant PostStimTime : time := 30 ns;

    signal Sstable, Squiet : boolean := false;

    signal Clock : std_logic := '0';
    signal Resetn : std_logic := '1';
    signal instruction : std_logic_vector(31 downto 0);
    signal opcode : std_logic_vector(6 downto 0); 
    signal funct7 : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal rs1 : std_logic_vector(4 downto 0);
    signal rs2 : std_logic_vector(4 downto 0);
    signal rd : std_logic_vector(4 downto 0);

    signal allout : std_logic_vector(31 downto 0);

    -- testbench signals
    signal tb_opcode : std_logic_vector(6 downto 0); 
    signal tb_funct7 : std_logic_vector(6 downto 0);
    signal tb_funct3 : std_logic_vector(2 downto 0);
    signal tb_rs1 : std_logic_vector(4 downto 0);
    signal tb_rs2 : std_logic_vector(4 downto 0);
    signal tb_rd : std_logic_vector(4 downto 0);

    component decoder is
       port (
        instruction : in std_logic_vector(31 downto 0);
        opcode : out std_logic_vector(6 downto 0);
        funct7 : out std_logic_vector(6 downto 0);
        funct3 : out std_logic_vector(2 downto 0);
        rs1 : out std_logic_vector(4 downto 0);
        rs2 : out std_logic_vector(4 downto 0);
        rd : out std_logic_vector(4 downto 0)
    );
    end component decoder;


    Signal MeasurementIndex : Integer := 0;
	File   VectorFile : text; 

begin

    Clock <= not Clock after ClockPeriod/2;
	Resetn <= '1', '0' after ResetPeriod;
	Sstable <= opcode'stable(PostStimTime);
	Squiet <= opcode'quiet(PostStimTime);

    allout <= opcode & funct7 & funct3 & rs1 & rs2 & rd;

    DUT : component decoder generic map (N => N)
    port map (
            instruction => instruction,
            opcode => opcode,
            funct7 => funct7,
            funct3 => funct3,
            rs1 => rs1,
            rs2 => rs2,
            rd => rd
    );

    SEQUENCER_PROC : process
        variable StartTime, EndTime, PropTimeDelay : time := 0 ns;
        variable ResultV : std_logic := 'X';
    -- Variables used for File I/O.
        variable LineBuffer : line;
        variable instVar : std_logic_vector(31 downto 0);
        variable opVar : std_logic_vector(6 downto 0);
        variable sevenVar : std_logic_vector(6 downto 0);
        variable threeVar : std_logic_vector(2 downto 0);
        variable rs1Var : std_logic_vector(4 downto 0);
        variable rs2Var : std_logic_vector(4 downto 0);
        variable rdVar : std_logic_vector(4 downto 0);

    begin
        -- open the file after reset is 0
        wait until Resetn = '0';
        wait for 10 ns;
        file_open( VectorFile, TestVectorFile, read_mode );
        report "Using TestVectors from file " & TestVectorFile;

        -- continuously read the file until you reach the end
        while not endfile( VectorFile ) loop
            -- set values to 'X'
            MeasurementIndex <= MeasurementIndex + 1;

            ResultV := 'X';
            PropTimeDelay := 0 ns;
            wait for PreStimTime;
            -- setup input values
            
            StartTime := NOW;
            ResultV := '1';
            readline(VectorFile, LineBuffer);
            read(LineBuffer, instVar);
            read(LineBuffer, sevenVar);
            read(LineBuffer, rs2Var);
            read(LineBuffer, rs1Var);
            read(LineBuffer, threeVar);
            read(LineBuffer, rdVar);
            read(LineBuffer, opVar);

            instruction <= instVar;

            tb_opcode <= opVar;
            tb_funct7 <= sevenVar;
            tb_funct3 <= threeVar;
            tb_rs1 <= rs1Var;
            tb_rs2 <= rs2Var;
            tb_rd <= rdVar;

            -- wait until allout'active = true;
            wait until allout'quiet(PostStimTime) = true;

            EndTime := Now;
            PropTimeDelay := EndTime - StartTime - allout'Last_Active;

            if opcode /= tb_opcode then
                ResultV := '0';
                assert opcode = tb_opcode
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  opcode = " & to_hstring(opcode) & CR &
                "tb_opcode = " & to_hstring(tb_opcode)
                Severity error;
            end if;

            if funct7 /= tb_funct7 then
                ResultV := '0';
                assert funct7 = tb_funct7
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  funct7 = " & to_hstring(funct7) & CR &
                "tb_funct7 = " & to_hstring(tb_funct7)
                Severity error;
            end if;

            if funct3 /= tb_funct3 then
                ResultV := '0';
                assert funct3 = tb_funct3
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  funct3 = " & to_hstring(funct3) & CR &
                "tb_funct3 = " & to_hstring(tb_funct3)
                Severity error;
            end if;

            if rs1 /= tb_rs1 then
                ResultV := '0';
                assert rs1 = tb_rs1
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  rs1 = " & to_hstring(rs1) & CR &
                "tb_rs1 = " & to_hstring(tb_rs1)
                Severity error;
            end if;

            if rs2 /= tb_rs2 then
                ResultV := '0';
                assert rs1 = tb_rs1
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  rs2 = " & to_hstring(rs2) & CR &
                "tb_rs2 = " & to_hstring(tb_rs2)
                Severity error;
            end if;

            if rd /= tb_rd then
                ResultV := '0';
                assert rs1 = tb_rs1
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  rd = " & to_hstring(rd) & CR &
                "tb_rd = " & to_hstring(tb_rd)
                Severity error;
            end if;

            wait until Clock = '1';
        end loop;
    Report "Simulation Completed";
    file_close( VectorFile );
    wait;
    
    end process SEQUENCER_PROC;

end architecture behavioural;