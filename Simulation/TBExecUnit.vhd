library ieee;
Use ieee.std_logic_1164.all;
Use std.TEXTIO.all;
Use ieee.numeric_std.all;


Entity TbExecUnit is
Generic ( N : natural := 64 );
End Entity TbExecUnit;

Architecture behavioural of TbExecUnit is
	Constant TestVectorFile : string := "ExecUnit00.tvs";
	Constant ClockPeriod : time := 2 ns;
	Constant ResetPeriod : time := 5 ns;
	Constant PreStimTime : time := 1 ns;
	Constant PostStimTime : time := 30 ns;
	
	Signal Sstable, Squiet : boolean := false;

	Signal Clock, Resetn : std_logic := '0';
	Signal A, B : std_logic_vector( N-1 downto 0 );
	Signal NotA : std_logic;
	Signal FuncClass : std_logic_vector( 1 downto 0 );
	Signal LogicFN : std_logic_vector( 1 downto 0 );
	Signal ShiftFN : std_logic_vector( 1 downto 0 );
	Signal AddnSub, ExtWord : std_logic;
	Signal Y, TbY : std_logic_vector( N-1 downto 0 );
	Signal Zero, AltB, AltBu : std_logic;
	Signal AllOut : std_logic_vector( N-1+3 downto 0 ); --used to concat ExUStatus with Y
-- use a component for the DUT. Use the same Entityname and Port Spec
-- use default binding rules.
	Component ExecUnit is
		Port ( A, B : in std_logic_vector( N-1 downto 0 );
			NotA : in std_logic := '0';
			FuncClass : in std_logic_vector( 1 downto 0 );
			LogicFN : in std_logic_vector( 1 downto 0 );
			ShiftFN : in std_logic_vector( 1 downto 0 );
			AddnSub, ExtWord : in std_logic := '0';
			Y : out std_logic_vector( N-1 downto 0 );
			Zero, AltB, AltBu  : out std_logic
		);
	End Component ExecUnit;
	Signal MeasurementIndex : Integer := 0;
	File   VectorFile : text; 

	
Begin
-- Some useful signals for monitoring and timing.
	Clock <= not clock after ClockPeriod/2;
	Resetn <= '0', '1' after ResetPeriod;
	Sstable <= Y'stable(PostStimTime);
	Squiet <= Y'quiet(PostStimTime);
	AllOut <= Y & Zero & AltB & AltBu;
-- Instantiate the component	
DUT:	Component ExecUnit generic map( N => N )
		port map ( A=>A, B=>B, Y=>Y,
				FuncClass=>FuncClass, LogicFN=>LogicFN, ShiftFN=>ShiftFN,
				NotA=>NotA, AddnSub=>AddnSub, ExtWord=>ExtWord,
				Zero=>Zero, AltB=>AltB, AltBu=>AltBu );
-- *****************************************************************************
-- Now the main process for generating stimulii and response.	
-- *****************************************************************************
STIM:	Process is
			Variable StartTime, EndTime, PropTimeDelay : time := 0 ns;
			Variable ResultV : std_logic := 'X';
-- Variables used for File I/O.
			Variable LineBuffer : line;
			Variable Avar, Bvar, Yvar : std_logic_vector( N-1 downto 0 );
			Variable NotAvar, AddnSubvar, ExtWordvar : std_logic;
			Variable FuncClassvar : std_logic_vector( 1 downto 0 );
			Variable LogicFNvar : std_logic_vector( 1 downto 0 );
			Variable ShiftFNvar : std_logic_vector( 1 downto 0 );
			Variable Zerovar, AltBvar, AltBuvar : std_logic;
			
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
				NotA <= 'X';
				FuncClass <= "XX";
				LogicFN <= "XX";
				ShiftFN <= "XX";
				AddnSub <= 'X';
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
				read( LineBuffer, NotAvar );
				read( LineBuffer, FuncClassvar(1) );
				read( LineBuffer, FuncClassvar(0) );
				read( LineBuffer, LogicFNvar(1) );
				read( LineBuffer, LogicFNvar(0) );
				read( LineBuffer, ShiftFNvar(1) );
				read( LineBuffer, ShiftFNvar(0) );
				read( LineBuffer, AddnSubvar );
				read( LineBuffer, ExtWordvar );
				hread( LineBuffer, Yvar );
				read( LineBuffer, Zerovar );
				read( LineBuffer, AltBvar );
				read( LineBuffer, AltBuvar );

-- Assign input stimulii variables to the signals.
				A <= Avar;
				B <= Bvar;
				TbY <= Yvar;

				NotA <= NotAvar;
				FuncClass <= FuncClassvar;
				LogicFN <= LogicFNvar;
				ShiftFN <= ShiftFNvar;
				AddnSub <= AddnSubvar;
				ExtWord <= ExtWordvar;
-- Assign the known status flags to Testbench signals (not really necessary) 
				
--				Wait until Y'Active = true;
--				Wait until Y'Quiet(PostStimTime) = true;
				Wait until Y'Active = true;
				Wait until AllOut'Quiet(PostStimTime) = true;
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
				If FuncClass(1) = '0' or ( FuncClass = "10" and ShiftFN = "00" ) then
					If Zero /= Zerovar then
						ResultV := '0';			
						Assert Zero = Zerovar
							Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
							"  Zero = " & to_string(Zero) & CR &
							"ZeroVar = " & to_string(Zerovar)
							Severity error;
					End If;
					If AddnSubvar = '1' and ExtWordvar = '0' then
						If AltB /= AltBvar then
							ResultV := '0';			
							Assert AltB = AltBvar
								Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
								"  AltB = " & to_string(AltB) & CR &
								"AltBVar = " & to_string(AltBvar)
								Severity error;
						End If;

						If AltBu /= AltBuvar then
							ResultV := '0';			
							Assert AltBu = AltBuvar
								Report "Measurement Index := " & to_string(MeasurementIndex) & CR &
								"  AltBu = " & to_string(AltBu) & CR &
								"AltBuVar = " & to_string(AltBuvar)
								Severity error;
						End If;
					End If;
				End If;
--				Report "   ---   Propagation Delay = " & to_string(PropTimeDelay);
				Wait until Clock = '1';
			End Loop;
			Report "Simulation Completed";
			File_close( VectorFile );
			Wait;
		End Process STIM;
		
End Architecture behavioural;
