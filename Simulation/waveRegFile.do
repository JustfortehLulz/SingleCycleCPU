onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /registerfile_tb/Clock
add wave -noupdate /registerfile_tb/Resetn
add wave -noupdate /registerfile_tb/regA
add wave -noupdate /registerfile_tb/tb_regA
add wave -noupdate /registerfile_tb/regB
add wave -noupdate /registerfile_tb/tb_regB
add wave -noupdate /registerfile_tb/regD
add wave -noupdate /registerfile_tb/tb_regD
add wave -noupdate /registerfile_tb/regWrite
add wave -noupdate /registerfile_tb/tb_regWrite
add wave -noupdate /registerfile_tb/writeVal
add wave -noupdate /registerfile_tb/tb_writeVal
add wave -noupdate /registerfile_tb/outA
add wave -noupdate /registerfile_tb/tb_outA
add wave -noupdate /registerfile_tb/outB
add wave -noupdate /registerfile_tb/tb_outB
add wave -noupdate /registerfile_tb/MeasurementIndex
add wave -noupdate /registerfile_tb/DUT/reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 250
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits sec
update
WaveRestoreZoom {999100 ps} {1 us}
