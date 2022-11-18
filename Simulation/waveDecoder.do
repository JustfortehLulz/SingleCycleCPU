onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /decoder_tb/Sstable
add wave -noupdate /decoder_tb/Squiet
add wave -noupdate /decoder_tb/Clock
add wave -noupdate /decoder_tb/Resetn
add wave -noupdate /decoder_tb/instruction
add wave -noupdate /decoder_tb/opcode
add wave -noupdate /decoder_tb/DUT/interop
add wave -noupdate /decoder_tb/funct7
add wave -noupdate /decoder_tb/funct3
add wave -noupdate /decoder_tb/rs1
add wave -noupdate /decoder_tb/rs2
add wave -noupdate /decoder_tb/rd
add wave -noupdate /decoder_tb/allout
add wave -noupdate /decoder_tb/tb_opcode
add wave -noupdate /decoder_tb/tb_funct7
add wave -noupdate /decoder_tb/tb_funct3
add wave -noupdate /decoder_tb/tb_rs1
add wave -noupdate /decoder_tb/tb_rs2
add wave -noupdate /decoder_tb/tb_rd
add wave -noupdate /decoder_tb/MeasurementIndex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34700 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {4326 ns}
