onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbexecunit/Sstable
add wave -noupdate /tbexecunit/Squiet
add wave -noupdate /tbexecunit/Clock
add wave -noupdate /tbexecunit/Resetn
add wave -noupdate /tbexecunit/STIM/PropTimeDelay
add wave -noupdate /tbexecunit/MeasurementIndex
add wave -noupdate /tbexecunit/STIM/ResultV
add wave -noupdate -divider {DUT Signals}
add wave -noupdate -height 40 -radix hexadecimal /tbexecunit/A
add wave -noupdate -height 40 -radix hexadecimal /tbexecunit/B
add wave -noupdate -height 40 -radix hexadecimal /tbexecunit/Y
add wave -noupdate -height 40 -radix hexadecimal /tbexecunit/TbY
add wave -noupdate -divider {Control Signals}
add wave -noupdate -height 40 -radix hexadecimal /tbexecunit/FuncClass
add wave -noupdate -height 40 -radix hexadecimal /tbexecunit/LogicFN
add wave -noupdate -height 40 -radix hexadecimal /tbexecunit/ShiftFN
add wave -noupdate -height 25 /tbexecunit/AddnSub
add wave -noupdate -height 25 /tbexecunit/ExtWord
add wave -noupdate -divider -height 25 {Status Signals}
add wave -noupdate -height 50 /tbexecunit/Zero
add wave -noupdate -height 50 /tbexecunit/AltB
add wave -noupdate -height 50 /tbexecunit/AltBu
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
WaveRestoreZoom {0 ps} {94200 ps}
