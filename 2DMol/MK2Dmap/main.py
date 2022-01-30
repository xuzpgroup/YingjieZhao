# main.py
# Purpose: Calculate the orientation of PE chani 
# Syntax:  main.py nl nw 
# Process: Read relax.dump and sort the center-of-mass of neighboring bonds
import sys,random,math,commands
from ctypes import * 

NR = CDLL("./libread.so")
p = sys.argv
arg = (c_float*20)()
name = "relax.dump"

#if len(p) < 2 :
#   print "parameter less than 2"
#   sys.exit()

arg[0] = c_float(1.0)      #ns, start frames
arg[1] = c_float(1.0)      #np, stop  frames
arg[2] = c_float(1.0)      #in, increasing frames
arg[3] = c_float(0.0)      #at, number of atoms
arg[4] = c_float(2.38)     #Emin, 2.38
arg[5] = c_float(5.33)     #Emax, 5.33
arg[6] = c_float(1.0)     #nbin, 44
arg[7] = c_float(float(p[1]))    #nx
arg[8] = c_float(float(p[2]))    #ny
arg[9] = c_float(10.0)     #bl
arg[10] = c_float(1.0)     #highlight flag, 1:on  0:off
arg[11] = c_float(0.0)     #
arg[12] = c_float(0.0)     #
arg[13] = c_float(0.0)     #
arg[14] = c_float(0.0)     #

#NR.sortdata(pointer(arg),name)
#commands.getstatusoutput('mv relax01.dump relax.dump')
NR.readdata(pointer(arg),name)

