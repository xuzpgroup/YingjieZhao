#!/bin/bash
for ff1 in T300.0 T500.0
do
   cd ./$ff1
   for ff2 in V*
   do
      cd ./$ff2
      for ff3 in K*
      do
         cd ./$ff3
         for ff4 in R*
         do
            echo $ff4
               cp ./$ff4/relax.dump /home/xuzp/WORK/ZYJ/ridge/relax.dump
               cd /home/xuzp/WORK/ZYJ/ridge/ 
               python main.py 100 116;
               cp /home/xuzp/WORK/ZYJ/ridge/Edis.xyz     /home/xuzp/WORK/ZYJ/Make2Dimages/sphere_out/$ff1/$ff2/$ff3/$ff4/Edis.xyz
               cp /home/xuzp/WORK/ZYJ/ridge/Edis.vel     /home/xuzp/WORK/ZYJ/Make2Dimages/sphere_out/$ff1/$ff2/$ff3/$ff4/Edis.vel
               cp /home/xuzp/WORK/ZYJ/ridge/loadvel.tcl                /home/xuzp/WORK/ZYJ/Make2Dimages/sphere_out/$ff1/$ff2/$ff3/$ff4/loadvel.tcl
               cd $OLDPWD
         done
         cd ../
      done
      cd ../
   done
   cd ../
done
