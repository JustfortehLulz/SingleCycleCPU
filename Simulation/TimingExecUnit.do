quit -sim
transcript file TimeExecUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=time,-cmd,msg ModelSim/ExecUnit.vho

vcom -work work -2008 -explicit -stats=time,-cmd,msg TBExecUnit.vhd

vcom -work work -2008 -explicit -stats=time,-cmd,msg ConfigExU.vhd
#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -t 100ps -gui work.TimeXUSim -sdftyp ../DUT=ModelSim/ExecUnit.sdo
transcript off
do waveExecUnit.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 7570 ns
transcript off
transcript file ""

