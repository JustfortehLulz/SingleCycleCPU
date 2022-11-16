quit -sim
transcript file FuncArithUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=none ../SourceCode/Adder.vhd

vcom -work work -2008 -explicit -stats=none ../SourceCode/ArithUnit.vhd

vcom -work work -2008 -explicit -stats=none TBArithUnit.vhd

vcom -work work -2008 -explicit -stats=time,-cmd,msg ConfigExU.vhd
#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -gui work.FuncAUSim -t 100ps
transcript off
do waveArithUnit.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 1220 ns
transcript off
transcript file ""
