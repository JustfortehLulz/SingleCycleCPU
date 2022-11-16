quit -sim
transcript file TimeShiftUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=time,-cmd,msg ModelSim/ShiftUnit.vho

vcom -work work -2008 -explicit -stats=time,-cmd,msg TBShiftUnit.vhd

vcom -work work -2008 -explicit -stats=time,-cmd,msg ConfigExU.vhd
#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -t 100ps -gui work.TimeSUSim -sdftyp ../DUT=ModelSim/ShiftUnit.sdo
transcript off
do waveShiftUnit.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 16500 ns
transcript off
transcript file ""

