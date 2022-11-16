quit -sim
transcript file TimeLogicUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=time,-cmd,msg ModelSim/LogicUnit.vho

vcom -work work -2008 -explicit -stats=time,-cmd,msg TBLogicUnit.vhd

vcom -work work -2008 -explicit -stats=time,-cmd,msg ConfigExU.vhd
#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -t 100ps -gui work.TimeLUSim -sdftyp ../DUT=ModelSim/LogicUnit.sdo
transcript off
do waveLogicUnit.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 15600 ns
transcript off
transcript file ""

