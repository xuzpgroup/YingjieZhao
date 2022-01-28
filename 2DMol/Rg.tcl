set fid [open "C:/Users/Dell/Desktop/rgyr.txt" w+]
set num 1081

cd C:/Users/Dell/Desktop/XYZ/cylinder/
for {set i 1} {$i < $num} {incr i} {
	mol addfile $i.xyz;
	set a [measure rgyr [atomselect top all]]
	puts $fid $a
	flush $fid
	mol delete top
}

cd C:/Users/Dell/Desktop/XYZ/sphere/
for {set i 1} {$i < $num} {incr i} {
	mol addfile $i.xyz;
	set a [measure rgyr [atomselect top all]]
	puts $fid $a
	flush $fid
	mol delete top
}

set num 325

cd C:/Users/Dell/Desktop/XYZ-combine/
for {set i 1} {$i < $num} {incr i} {
	mol addfile $i.xyz;
	set a [measure rgyr [atomselect top all]]
	puts $fid $a
	flush $fid
	mol delete top
}

close $fid