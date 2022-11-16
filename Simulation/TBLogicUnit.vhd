library ieee;
Use ieee.std_logic_1164.all;
Use std.TEXTIO.all;
Use ieee.numeric_std.all;


Entity TbLogicUnit is
Generic ( N : natural := 64 );
End Entity TbLogicUnit;

Architecture behavioural of TbLogicUnit is
	Constant TestVectorFile : string := "LogicUnit00.tvs";
	Constant ClockPeriod : time := 2 ns;
	Constant ResetPeriod : time := 5 ns;
	Constant PreStimTime : time := 1 ns;
	Constant PostStimTime : time := 5 ns;
--	Constant HoldOffTime  : time := 7500 ps;
	
	Signal Sstable, Squiet : boolean := false;
--	Signal Result : std_logic := 'X';

	Signal Clock, Resetn : std_logic := '0';
	Signal A, B, Y, TbY : std_logic_vector( N-1 downto 0 );
	Signal LogicFN : std_logic_vector( 1 downto 0 );
-- use a component for the DUT. Use the same Entityname and Port Spec
-- use default binding rules.
	Component LogicUnit is
		Port ( A, B: in std_logic_vector( N-1 downto 0 );
				Y	: out std_logic_vector( N-1 downto 0 );
				LogicFN : in std_logic_vector( 1 downto 0 ) );
	End Component LogicUnit;
-- create an array of Records for setup and testing without File I/O.
--	Type TestVectorLU is Record
--		A, B, Y : unsigned( N-1 downto 0 );
--		LFN : unsigned( 1 downto 0 );
--	End Record TestVectorLU;
--	Type VectorTableLU is array (natural range <>) of TestVectorLU;
--	Constant	TestVector : VectorTableLU := 	(
--	(A=>X"FFFFFFFFFFFFFFFF", B=>X"FFFFFFFFFFFFFFFF", Y=>X"FFF0FFFFFFFFFFFF", LFN=>"00" ),
--	(A=>X"AAAAAAAAAAAAAAAA", B=>X"FFFFFFFFFFFFFFFF", Y=>X"AAAAAAAAAAAAAAAA", LFN=>"00" ),
--	(A=>X"0000000000000000", B=>X"FFFFFFFFFFFFFFFF", Y=>X"FFFFFFFFFFFFFFFF", LFN=>"00" )
--	);
	Signal MeasurementIndex : Integer := 0;
	File   VectorFile : text; 

	
Begin
-- Some useful signals for monitoring and timing.
	Clock <= not clock after ClockPeriod/2;
	Resetn <= '0', '1' after ResetPeriod;
	Sstable <= Y'stable(PostStimTime);
	Squiet <= Y'quiet(PostStimTime);
-- Instantiate the component	
DUT:	Component LogicUnit generic map( N => N )
		port map ( A=>A, B=>B, Y=>Y, LogicFN=>LogicFN );
-- *****************************************************************************
-- Now the main process for generating stimulii and response.	
-- *****************************************************************************
STIM:	Process is
			Variable StartTime, EndTime, PropTimeDelay : time := 0 ns;
			Variable ResultV : std_logic := 'X';
-- Variables used for File I/O.
			Variable LineBuffer : line;
			Variable Avar, Bvar, Yvar : std_logic_vector( N-1 downto 0 );
			Variable LFNvar : std_logic_vector( 1 downto 0 );
		Begin
			Wait until Resetn = '1';
			file_open( VectorFile, TestVectorFile, read_mode );
			report "Using TestVectors from file " & TestVectorFile;		
--			for i in TestVector'range loop
			while not endfile( VectorFile ) loop
-- Preceed the measurement with "Forced Unknown", 'X'
				MeasurementIndex <= MeasurementIndex + 1;
				A <= (others => 'X');
				B <= (others => 'X');
				LogicFN <= (others => 'X');
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
				read( LineBuffer, LFNvar );
				hread( LineBuffer, Yvar );
-- Assign input stimulii variables to the signals.
				A <= Avar;
				B <= Bvar;
				TbY <= Yvar;
				LogicFN <= LFNvar;
-- The folowing statements are used when testing with the constant array.
--				A <= TestVector(i).A;
--				B <= TestVector(i).B;
--				LogicFN <= TestVector(i).LFN;
--				TbY <= TestVector(i).Y;
				Wait until Y'Active = true;
--				if Y'Quiet(PostStimTime) = false then
					Wait until Y'Quiet(PostStimTime) = true;
--				End If;
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
				Else
					ResultV := '1';
				End If;
--				Report "   ---   Propagation Delay = " & to_string(PropTimeDelay);
				Wait until Clock = '1';
			End Loop;
			Report "Simulation Completed";
			File_close( VectorFile );
			Wait;
		End Process STIM;
		
End Architecture behavioural;
