library ieee;
Use ieee.std_logic_1164.all;
Use std.TEXTIO.all;
Use ieee.numeric_std.all;


Entity TbShiftUnit is
Generic ( N : natural := 64 );
End Entity TbShiftUnit;

Architecture behavioural of TbShiftUnit is
	Constant TestVectorFile : string := "SLL32Unit00.tvs";
	Constant ClockPeriod : time := 2 ns;
	Constant ResetPeriod : time := 5 ns;
	Constant PreStimTime : time := 1 ns;
	Constant PostStimTime : time := 8 ns;
	
	Signal Sstable, Squiet : boolean := false;

	Signal Clock, Resetn : std_logic := '0';
	Signal A, B, C, Y, TbY : std_logic_vector( N-1 downto 0 );
	Signal	ShiftFN : std_logic_vector( 1 downto 0 );
	Signal	ExtWord : std_logic;
-- use a component for the DUT. Use the same Entity name and Port Spec
-- use default binding rules.
	Component ShiftUnit is
		Port ( A, B, C : in std_logic_vector( N-1 downto 0 );
				Y	: out std_logic_vector( N-1 downto 0 );
				ShiftFN : in std_logic_vector( 1 downto 0 );
				ExtWord : in std_logic );
	End Component ShiftUnit;
	Signal MeasurementIndex : Integer := 0;
	File   VectorFile : text; 

	
Begin
-- Some useful signals for monitoring and timing.
	Clock <= not clock after ClockPeriod/2;
	Resetn <= '0', '1' after ResetPeriod;
	Sstable <= Y'stable(PostStimTime);
	Squiet <= Y'quiet(PostStimTime);
-- Instantiate the component	
DUT:	Component ShiftUnit generic map( N => N )
		port map ( A=>A, B=>B, C=>C, Y=>Y,
				ShiftFN=>ShiftFN, ExtWord=>ExtWord );
-- *****************************************************************************
-- Now the main process for generating stimulii and response.	
-- *****************************************************************************
STIM:	Process is
			Variable StartTime, EndTime, PropTimeDelay : time := 0 ns;
			Variable ResultV : std_logic := 'X';
-- Variables used for File I/O.
			Variable LineBuffer : line;
			Variable Avar, Bvar, Cvar, Yvar : std_logic_vector( N-1 downto 0 );
			Variable ShiftFNvar : std_logic_vector( 1 downto 0 );
			Variable ExtWordvar : std_logic;
			
		Begin
			Wait until Resetn = '1';
			Wait for 10 ns;
			file_open( VectorFile, TestVectorFile, read_mode );
			report "Using TestVectors from file " & TestVectorFile;
			while not endfile( VectorFile ) loop
-- Preceed the measurement with "Forced Unknown", 'X'
				MeasurementIndex <= MeasurementIndex + 1;
				A <= (others => 'X');
				B <= (others => 'X');
				C <= (others => 'X');
				ShiftFN <= "XX";
				ExtWord <= 'X';
-- End of Control Signals
				ResultV := 'X';
				PropTimeDelay := 0 ns;
				Wait for PreStimTime;
-- Now setup the Stimulii. - don't change the order of the file reads.
				StartTime := NOW;
				ResultV := '1';
				readline( VectorFile, LineBuffer );
				hread( LineBuffer, Avar );
				hread( LineBuffer, Bvar );
				hread( LineBuffer, Cvar );
				read( LineBuffer, ShiftFNvar(1) );
				read( LineBuffer, ShiftFNvar(0) );
				read( LineBuffer, ExtWordvar );
				hread( LineBuffer, Yvar );

-- Assign input stimulii variables to the signals.
				A <= Avar;
				B <= Bvar;
				C <= Cvar;
				TbY <= Yvar;

				ShiftFN <= ShiftFNvar;
				ExtWord <= ExtWordvar;
-- Assign the known status flags to Testbench signals (not really necessary) 
				
				Wait until Y'Active = true;
				Wait until Y'Quiet(PostStimTime) = true;
-- now check to see if the output values are correct.				
				EndTime := NOW;
				PropTimeDelay := EndTIme - StartTime - Y'Last_Active;

				If Y /= TbY then
					ResultV := '0';			
					assert Y = TbY
						Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
						"  Y = " & to_hstring(Y) & CR &
						"TbY = " & to_hstring(TbY)
						Severity error;
				End If;

--				Report "   ---   Propagation Delay = " & to_string(PropTimeDelay);
				Wait until Clock = '1';
			End Loop;
			Report "Simulation Completed";
			File_close( VectorFile );
			Wait;
		End Process STIM;
		
End Architecture behavioural;
