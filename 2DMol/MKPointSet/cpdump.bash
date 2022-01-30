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
              # cp ./$ff4/relax.dump /home/xuzp/WORK/qjs/compress/DUMP/cylinder/$io.dump
               cp ./$ff4/relax.dump /home/xuzp/WORK/ZYJ/DUMP/sphere/$io.dump
		#cp ./$ff4/test.xyz /home/xuzp/WORK/qjs/compress/XYZ/cylinder/$io.xyz
               
         done
         cd ../
      done
      cd ../
   done
   cd ../
done
