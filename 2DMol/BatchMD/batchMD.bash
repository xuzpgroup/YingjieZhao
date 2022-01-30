#!/bin/bash
#SBATCH -J sup-sp
#SBATCH -p cnall
#SBATCH -N 1
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH --no-requeue
#SBATCH --ntasks-per-node=28
module load compiles/intel/2019/u4/config
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
             cd ./$ff4
             mpiexec.hydra -n 28 lmp_sj<in.sphere>out
             cd ../     
         done
         cd ../
      done
      cd ../
   done
   cd ../
done
