library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.TEXTIO.all;

use std.env.finish;

entity registerFile_tb is
    generic (N : natural := 64);
end registerFile_tb;

architecture sim of registerFile_tb is

    constant TestVectorFile : string := "RegisterFile00.tvs";
    constant ClockPeriod : time := 2 ns;
    constant ResetPeriod : time := 5 ns;
    constant PreStimTime : time := 1 ns;
    constant PostStimTime : time := 30 ns;

    signal Sstable, Squiet : boolean := false;

    signal Clock : std_logic := '0';
    signal Resetn : std_logic := '1';
    signal regA : std_logic_vector(4 downto 0);
    signal regB : std_logic_vector(4 downto 0);
    signal regD : std_logic_vector (4 downto 0);
    signal regWrite : std_logic;
    signal writeVal : std_logic_vector(N-1 downto 0);
    signal outA : std_logic_vector(N-1 downto 0);
    signal outB : std_logic_vector(N-1 downto 0);

    signal allout : std_logic_vector(2*N-1 downto 0);

    -- testbench signals
    signal tb_regA : std_logic_vector(4 downto 0);
    signal tb_regB : std_logic_vector(4 downto 0);
    signal tb_regD : std_logic_vector (4 downto 0);
    signal tb_regWrite : std_logic;
    signal tb_writeVal : std_logic_vector(N-1 downto 0);
    signal tb_outA : std_logic_vector(N-1 downto 0);
    signal tb_outB : std_logic_vector(N-1 downto 0);

    component registerFile is 
    port (
        regA : in std_logic_vector (4 downto 0);
        regB : in std_logic_vector (4 downto 0);
        regD : in std_logic_vector (4 downto 0);
        regWrite : in std_logic;
        writeVal : in std_logic_vector(N-1 downto 0);
        outA : out std_logic_vector(N-1 downto 0);
        outB : out std_logic_vector(N-1 downto 0)
    );
    end component registerFile;

    signal MeasurementIndex : integer := 0;
    file VectorFile : text;

    -- -- create a register file
    -- type file_reg is array (0 to 31) of std_logic_vector(N-1 downto 0);
    -- variable reg : file_reg;
begin

    Clock <= not Clock after ClockPeriod/2;
	Resetn <= '1', '0' after ResetPeriod;
	Sstable <= regD'stable(PostStimTime);
	Squiet <= regD'quiet(PostStimTime);

    allout <= outA & outB;

    DUT : component registerFile generic map (N => N)
    port map (
        regA => regA,
        regB => regB,
        regD => regD,
        regWrite => regWrite,
        writeVal => writeVal,   
        outA => outA,
        outB => outB
    );
    

    SEQUENCER_PROC : process
        variable StartTime, EndTime, PropTimeDelay : time := 0 ns;
        variable ResultV : std_logic := 'X';
        -- variables for file IO
        variable linebuffer : line;
        variable aVar : std_logic_vector(4 downto 0);
        variable bVar : std_logic_vector(4 downto 0);
        variable dVar : std_logic_vector(4 downto 0);
        variable regWriteVar : std_logic;
        variable writeValVar : std_logic_vector(N-1 downto 0);
        variable outAReg : std_logic_vector(N-1 downto 0);
        variable outBReg : std_logic_vector(N-1 downto 0);
    begin
        -- open the file after reset is 0
        wait until Resetn = '0';
        wait for 10 ns;
        file_open( VectorFile, TestVectorFile, read_mode );
        report "Using TestVectors from file " & TestVectorFile;

        -- continuously read the file until you reach the end
        while not endfile( VectorFile ) loop
            MeasurementIndex <= MeasurementIndex + 1;

            -- Report "Meausurement: " & to_string(MeasurementIndex);

            ResultV := 'X';
            PropTimeDelay := 0 ns;
            wait for PreStimTime;
            -- setup input values
            
            StartTime := NOW;
            ResultV := '1';

            -- TODO: reading all of the TVS file into here
            readline(VectorFile,linebuffer);
            read(linebuffer, aVar);
            read(linebuffer, bVar);
            read(linebuffer, dVar);
            read(linebuffer, regWriteVar);
            read(linebuffer, writeValVar);
            read(linebuffer, outAReg);
            read(linebuffer, outBReg);

            regA <= aVar;
            regB <= bVar;
            regD <= dVar;
            regWrite <= regWriteVar;
            writeVal <= writeValVar;

            --Report "RegA : " & to_string(aVar) & CR & "RegB : " & to_string(bVar) & CR & "regD : " & to_string(dVar) 
            --& CR & "regWriteVar : " & to_string(regWriteVar) & CR & "writeVal : " & to_string(writeValVar);
            
            tb_regA <= aVar;
            tb_regB <= bVar;
            tb_regD <= dVar;
            tb_regWrite <= regWriteVar;
            tb_writeVal <= writeValVar;
            tb_outA <= outAReg;
            tb_outB <= outBReg;

            -- wait until allout'active = true;
            -- this line below is the problem
            -- wait until allout'quiet(PostStimTime) = true;

            EndTime := Now;
            PropTimeDelay := EndTime - StartTime - allout'Last_Active;

            -- testing writing into regFile
            -- TODO: add testing for reading out values of outA and outB
            if tb_regD /= regD then
                ResultV := '0';
                assert tb_regD = regD 
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  tb_regD = " & to_hstring(tb_regD) & CR &
                "regD = " & to_hstring(regD)
                Severity error;
            end if;

            if tb_regWrite /= regWrite then
                ResultV := '0';
                assert tb_regWrite = regWrite
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  tb_regWrite = " & to_string(tb_regWrite) & CR &
                "regWrite = " & to_string(regWrite)
                Severity error;
            end if;

            if tb_writeVal /= writeVal then
                ResultV := '0';
                assert tb_writeVal = writeVal
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
            "  tb_writeVal = " & to_hstring(tb_writeVal) & CR &
            "writeVal = " & to_hstring(writeVal)
                Severity error;
            end if;

            if tb_regA /= regA then
                ResultV := '0';
                assert tb_regA = regA
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
            "  tb_regA = " & to_hstring(tb_regA) & CR &
            "regA = " & to_hstring(regA)
                Severity error;
            end if;

            if tb_regB /= regB then
                ResultV := '0';
                assert tb_regB = regB
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
            "  tb_regB = " & to_hstring(tb_regB) & CR &
            "regB = " & to_hstring(regB)
                Severity error;
            end if;

            if tb_outA /= outA then
                ResultV := '0';
                assert tb_outA = outA
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  tb_outA = " & to_hstring(tb_outA) & CR &
                "outA = " & to_hstring(outA)
                Severity error;
            end if;

            if tb_outB /= outB then
                ResultV := '0';
                assert tb_outB = outB
                Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
                "  tb_outB = " & to_hstring(tb_outB) & CR &
                "outB = " & to_hstring(outB)
                Severity error;
            end if;

            wait until Clock = '1';
        end loop;
    report "Simulation Complete";
    file_close(VectorFile);
    wait;
    end process SEQUENCER_PROC;

end architecture sim;