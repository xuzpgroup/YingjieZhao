#!/bin/bash
io=0;
a=1;
for ff1 in T*
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
            #echo $ff4
			#declare -i io=$io+$a
			io=$[$io+1]
			echo $io
		
              cp ./$ff4/test.xyz /home/xuzp/WORK/ZYJ/XYZ_pre/$io.xyz
               
         done
         cd ../
      done
      cd ../
   done
   cd ../
done
