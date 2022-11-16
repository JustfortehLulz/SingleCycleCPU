quit -sim
transcript file FuncShiftUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=none ../SourceCode/SLL64.vhd
vcom -work work -2008 -explicit -stats=none ../SourceCode/SRL64.vhd
vcom -work work -2008 -explicit -stats=none ../SourceCode/SRA64.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/ShiftUnit.vhd

vcom -work work -2008 -explicit -stats=none TBShiftUnit.vhd

vcom -work work -2008 -explicit -stats=time,-cmd,msg ConfigExU.vhd
#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -gui work.FuncSUSim -t 100ps
transcript off
do waveShiftUnit.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 5140 ns
transcript off
transcript file ""
