onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 /tbshiftunit/Sstable
add wave -noupdate -height 30 /tbshiftunit/Squiet
add wave -noupdate -height 30 /tbshiftunit/Clock
add wave -noupdate -height 30 /tbshiftunit/Resetn
add wave -noupdate -height 30 /tbshiftunit/STIM/PropTimeDelay
add wave -noupdate -height 30 /tbshiftunit/MeasurementIndex
add wave -noupdate -height 30 /tbshiftunit/STIM/ResultV
add wave -noupdate -divider -height 40 {DUT Signals}
add wave -noupdate -height 40 -radix hexadecimal /tbshiftunit/A
add wave -noupdate -height 40 -radix hexadecimal /tbshiftunit/B
add wave -noupdate -height 40 -radix hexadecimal /tbshiftunit/C
add wave -noupdate -height 40 -radix hexadecimal /tbshiftunit/Y
add wave -noupdate -height 40 -radix hexadecimal /tbshiftunit/TbY
add wave -noupdate -divider -height 40 {Control Signals}
add wave -noupdate -height 40 /tbshiftunit/ShiftFN
add wave -noupdate -height 40 /tbshiftunit/ExtWord
add wave -noupdate -divider -height 40 {Additional Signals}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 191
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
WaveRestoreZoom {5059900 ps} {5144300 ps}
