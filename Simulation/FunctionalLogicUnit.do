quit -sim
transcript file FuncLogicUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=none ../SourceCode/LogicUnit.vhd

vcom -work work -2008 -explicit -stats=none TBLogicUnit.vhd

vcom -work work -2008 -explicit -stats=time,-cmd,msg ConfigExU.vhd
#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -gui work.FuncLUSim -t 100ps
transcript off
do waveLogicUnit.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 6500 ns
transcript off
transcript file ""
