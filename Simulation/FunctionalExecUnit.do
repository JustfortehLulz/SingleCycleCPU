quit -sim
transcript file FuncExecUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=none ../SourceCode/LogicUnit.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/Adder.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/ArithUnit.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/SLL64.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/SRL64.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/SRA64.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/ShiftUnit.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/ExecUnit.vhd

vcom -work work -2008 -explicit -stats=none TBExecUnit.vhd

vcom -work work -2008 -explicit -stats=time,-cmd,msg ConfigExU.vhd
#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -gui work.FuncXUSim -t 100ps
transcript off
do waveExecUnit.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 4120 ns
transcript off
transcript file ""
