onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 20 -radix hexadecimal /tblogicunit/Sstable
add wave -noupdate -height 20 -radix hexadecimal /tblogicunit/Squiet
add wave -noupdate -height 20 -radix hexadecimal /tblogicunit/Resetn
add wave -noupdate -height 40 -radix hexadecimal /tblogicunit/Clock
add wave -noupdate -divider Measurment
add wave -noupdate -height 30 -radix decimal /tblogicunit/MeasurementIndex
add wave -noupdate -height 30 /tblogicunit/STIM/ResultV
add wave -noupdate -height 30 -radix time /tblogicunit/STIM/PropTimeDelay
add wave -noupdate -divider {Testbench Signals}
add wave -noupdate -height 40 -radix hexadecimal /tblogicunit/LogicFN
add wave -noupdate -height 40 -radix hexadecimal /tblogicunit/A
add wave -noupdate -height 40 -radix hexadecimal /tblogicunit/B
add wave -noupdate -height 40 -radix hexadecimal /tblogicunit/Y
add wave -noupdate -height 40 -radix hexadecimal /tblogicunit/TbY
add wave -noupdate -divider {DUT Signals}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15987765 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {16408 ps}
