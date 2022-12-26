quit -sim
transcript file DecoderUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=none ../SourceCode/RegisterFile.vhd

vcom -work work -2008 -explicit -stats=none TBRegisterFile.vhd

#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -gui work.registerFile_tb -t 100ps
transcript off
do waveRegFile.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 1000 ns
transcript off
transcript file ""
