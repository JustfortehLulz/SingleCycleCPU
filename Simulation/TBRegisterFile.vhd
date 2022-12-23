library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.TEXTIO.all;

use std.textio.all;
use std.env.finish;

entity registerFile_tb is
    generic (N : natural := 64);
end registerFile_tb;

architecture sim of registerFile_tb is

    constant TestVectorFile : string := "RegisterFile00.tvs";
    constant ClockPeriod : time := 2 ns;
    constant ResetPeriod : time := 5 ns;
    constant PreStimTime : time := 1 ns;
    constant PostStimTime  time := 30 ns;

    signal Sstable, Squiet : boolean := false;

    signal Clock : std_logic := '0';
    signal Resetn : std_logic := '1';
    signal regA : std_logic_vector(4 downto 0);
    signal regB : std_logic_vector(4 downto 0);
    signal regD : std_logic_vector (4 downto 0);
    signal regWrite : std_logic;
    signal writeReg : std_logic_vector(N-1 downto 0);
    signal outA : std_logic_vector(N-1 downto 0);
    signal outB : std_logic_vector(N-1 downto 0);

    signal allout : std_logic_vector(2*N-1 downto 0);

    -- testbench signals
    signal tb_regA : std_logic_vector(4 downto 0);
    signal tb_regB : std_logic_vector(4 downto 0);
    signal tb_regD : std_logic_vector (4 downto 0);
    signal tb_regWrite : std_logic;
    signal tb_writeReg : std_logic_vector(N-1 downto 0);
    signal tb_outA : std_logic_vector(N-1 downto 0);
    signal tb_outB : std_logic_vector(N-1 downto 0);

    component registerFile is 
    port (
        regA : in std_logic_vector (4 downto 0);
        regB : in std_logic_vector (4 downto 0);
        regD : in std_logic_vector (4 downto 0);
        regWrite : in std_logic;
        writeReg : in std_logic_vector(N-1 downto 0);
        outA : out std_logic_vector(N-1 downto 0);
        outB : out std_logic_vector(N-1 downto 0)
    );
    end component registerFile;

    signal MeasurementIndex : integer := 0;
    file vectorFile : text;

    -- create a register file
    type file_reg is array (0 to 31) of std_logic_vector(N-1 downto 0);
    variable reg : file_reg;
begin

    Clock <= not Clock after ClockPeriod/2;
	Resetn <= '1', '0' after ResetPeriod;
	Sstable <= opcode'stable(PostStimTime);
	Squiet <= opcode'quiet(PostStimTime);

    allout <= outA & outB;

    DUT : component registerFile generic map (N => N)
    port map (
        regA => regA,
        regB => regB,
        regD => regD,
        regWrite => regWrite,
        writeReg => writeReg,   
        outA => outA,
        outB => outB
    );
    -- DUT : entity work.registerFile(rtl)
    -- port map (
    --     clk => clk,
    --     rst => rst,
        
    -- );
    
    -- TODO: create your register file values
    

    SEQUENCER_PROC : process
        variable StartTime, EndTime, PropTimeDelay : time := 0 ns;
        variable ResultV : std_logic := 'X';
        -- variables for file IO
        variable linebuffer : line;
        variable aVar : std_logic_vector(4 downto 0);
        variable bVar : std_logic_vector(4 downto 0);
        variable dVar : std_logic_vector(4 downto 0);
        variable regWriteVar : std_logic;
        variable writeRegVar : std_logic_vector(N-1 downto 0);
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

            ResultV := 'X';
            PropTimeDelay := 0 ns;
            wait for PreStimTime;
            -- setup input values
            
            StartTime := NOW;
            ResultV := '1';

            -- TODO: reading all of the TVS file into here

            -- wait until allout'active = true;
            wait until allout'quiet(PostStimTime) = true;

            EndTime := Now;
            PropTimeDelay := EndTime - StartTime - allout'Last_Active;
        end loop;
    report "Simulation Complete";
    file_close(vectorFile);
    wait;
    end process SEQUENCER_PROC;

end architecture;