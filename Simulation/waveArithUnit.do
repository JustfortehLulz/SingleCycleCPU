onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbarithunit/Sstable
add wave -noupdate /tbarithunit/Squiet
add wave -noupdate /tbarithunit/Clock
add wave -noupdate /tbarithunit/Resetn
add wave -noupdate /tbarithunit/STIM/PropTimeDelay
add wave -noupdate /tbarithunit/MeasurementIndex
add wave -noupdate /tbarithunit/STIM/ResultV
add wave -noupdate -divider {DUT Signals}
add wave -noupdate -height 40 -radix hexadecimal /tbarithunit/A
add wave -noupdate -height 40 -radix hexadecimal /tbarithunit/B
add wave -noupdate -height 40 -radix hexadecimal /tbarithunit/Y
add wave -noupdate -height 40 -radix hexadecimal /tbarithunit/TbY
add wave -noupdate -divider {Control Signals}
add wave -noupdate -height 25 /tbarithunit/AddnSub
add wave -noupdate -height 25 /tbarithunit/ExtWord
add wave -noupdate -divider -height 25 {Status Signals}
add wave -noupdate -height 50 /tbarithunit/Cout
add wave -noupdate -height 50 /tbarithunit/Ovfl
add wave -noupdate -height 50 /tbarithunit/Zero
add wave -noupdate -height 50 /tbarithunit/AltB
add wave -noupdate -height 50 /tbarithunit/AltBu
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {16000 ps} 0} {{Cursor 4} {41600 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {43800 ps}
