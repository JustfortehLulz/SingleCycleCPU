quit -sim
transcript file DecoderUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=none ../SourceCode/Decoder.vhd

vcom -work work -2008 -explicit -stats=none TBDecoder.vhd

#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -gui work.decoder_tb -t 100ps
transcript off
do waveDecoder.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 4120 ns
transcript off
transcript file ""
