library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Use std.TEXTIO.all;

use std.textio.all;
use std.env.finish;

entity decoder_tb is
    generic (N : natural := 64);
end decoder_tb;

architecture sim of decoder_tb is

	constant TestVectorFile : string := "DecoderUnit00.txt";
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

    Signal MeasurementIndex : Integer := 0;
	File   VectorFile : text; 

begin

    Clock <= not Clock after ClockPeriod/2;
	Resetn <= '1', '0' after ResetPeriod;
	Sstable <= opcode'stable(PostStimTime);
	Squiet <= opcode'quiet(PostStimTime);

    DUT : entity work.decoder(rtl) generic map (N => N)
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
        
        wait until Resetn = '0';
        wait for 10 ns;
        file_open( VectorFile, TestVectorFile, read_mode );
        report "Using TestVectors from file " & TestVectorFile;

        while not endfile( VectorFile ) loop

        end loop;
    end process;

end architecture;