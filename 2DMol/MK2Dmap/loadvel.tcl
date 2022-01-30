#draw color by velocity vx vy vz
display depthcue off
axes location off
display projection orthographic
#color Display Background white
#display resize 368 368

set filename Edis.vel
set sel [atomselect top all]
set numframes [molinfo top get numframes]
set numatoms  [molinfo top get numatoms]
set rdvel [open $filename r]
set nc1 $numatoms

for {set i 0} {$i<$numframes} {incr i} {
   $sel frame $i
   puts "setting user values for frame [$sel frame]"
   set tmppe {}
   set tmppb {}
   set tmppd {}   
   set tmppp {}   

   for {set j 0} {$j<2} {incr j} {
      gets $rdvel line
   }

   for {set j 0} {$j<$nc1} {incr j} {
      
      gets $rdvel line
      scan [string range $line 0 100] "%d%f%f%f%f%f" id hl et eb ed evdw
      set ar1($id) $et
      set ar2($id) $eb
      set ar3($id) $ed
      #set ar4($id) $ed
      set ar4($id) $evdw
      #set ar4($id) [expr $pe-$pb-$pd]
   }

   for {set j 0} {$j<$nc1} {incr j} {
      set id [expr $j+1]
      lappend tmppe $ar1($id)
      lappend tmppb $ar2($id)
      lappend tmppd $ar3($id)
      lappend tmppp $ar4($id)
   }
   
   for {set j $nc1} {$j<$numatoms} {incr j} {
      set dum 0

      lappend tmppe $dum
   }

   #componets of user
   $sel set user  $tmppe
   $sel set user2 $tmppb
   $sel set user3 $tmppd
   $sel set user4 $tmppp
}

close $rdvel

color scale method BWR


