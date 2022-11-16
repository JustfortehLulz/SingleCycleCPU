quit -sim
transcript file TimeArithUnitTranscript.txt
transcript on
#----------------------------------------------------------------------------------------------------------
# compile
#----------------------------------------------------------------------------------------------------------
vcom -work work -2008 -explicit -stats=time,-cmd,msg ModelSim/ArithUnit.vho

vcom -work work -2008 -explicit -stats=time,-cmd,msg TBArithUnit.vhd

vcom -work work -2008 -explicit -stats=time,-cmd,msg ConfigExU.vhd
#----------------------------------------------------------------------------------------------------------
# Start the simulation
#----------------------------------------------------------------------------------------------------------
vsim -t 100ps -gui work.TimeAUSim -sdftyp ../DUT=ModelSim/ArithUnit.sdo
transcript off
do waveArithUnit.do
transcript on
#----------------------------------------------------------------------------------------------------------
# Simulation Run
#----------------------------------------------------------------------------------------------------------
restart -f
run 5900 ns
transcript off
transcript file ""

