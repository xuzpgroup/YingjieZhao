echo both
#Temperature
variable Tmin equal     1.0
variable Tmax equal   300.0
variable Tdam equal 10000.0

#Lenard Jones
variable s1lj equal 14.80  #
variable e1lj equal  1.00  #

#Spheres
variable mass1    equal 413.0 

#Bond parameters
variable rb equal  10.0
variable al equal   1.0   #
variable b1 equal  16.0   #
variable b2 equal  12.5   #
variable D1 equal 120.0   #ks = 120, D*al*al=ks
variable D2 equal 120.0   #
variable D3 equal 120.0   #
variable k1 equal   1.0   #
variable k2 equal   6.0   #
variable k2 equal   6.0   #

#largest timestep
variable timestep equal 1
variable respa    equal 1

#output frequencies
variable dump_frequency equal $(round(50000/v_timestep))
variable xyz_frequency  equal $(round(50000/v_timestep))
variable aver_frequency equal $(round(1000/v_timestep))

#running times 
variable equilibrate_time equal 200000
variable equilibrate_step equal ${equilibrate_time}/${timestep}
##########################################
#processors     3 4 1
units          real
boundary       s s p
timestep       ${timestep}  

atom_style     molecular
pair_style     lj/cut $(v_s1lj*2.5) 
bond_style     morse
dihedral_style harmonic
read_data      l100.data

mass     *       ${mass1}

bond_coeff     * ${D1} ${al} ${rb}
dihedral_coeff * ${k1} 1 1
pair_coeff * * $(v_e1lj) $(v_s1lj) 
#pair_coeff 1 1 $(v_e1lj) $(v_s1lj) $(v_s1lj*1.122) 
pair_modify shift yes

neighbor        2.0 bin
neigh_modify    delay 0 every 1 check yes #exclude molecule/intra all
special_bonds lj/coul 0.0 1.0 1.0
##########################
group   net     type 1

variable dis   equal 30.0
variable xmin1 equal bound(net,xmin)-${dis}/2.0
variable xmin2 equal ${xmin1}+${dis}
variable xmax1 equal bound(net,xmax)+${dis}/2.0
variable xmax2 equal ${xmax1}-${dis}
variable ymin1 equal bound(net,ymin)-${dis}/2.0
variable ymin2 equal ${ymin1}+${dis}
variable ymax1 equal bound(net,ymax)+${dis}/2.0
variable ymax2 equal ${ymax1}-${dis}
variable zmin1 equal bound(net,zmin)-${dis}/2.0
variable zmin2 equal ${zmin1}+${dis}
variable zmax1 equal bound(net,zmax)+${dis}/2.0
variable zmax2 equal ${zmax1}-${dis}
#variable xlo   equal 0.0
#variable xhi   equal 0.0
variable xrc   equal (${xmin1}+${xmax1})/2.0
variable yrc   equal (${ymin1}+${ymax1})/2.0
variable zrc   equal (${zmin1}+${zmax1})/2.0
variable lx2   equal (${xmax1}-${xmin1})*(${xmax1}-${xmin1})
variable ly2   equal (${ymax1}-${ymin1})*(${ymax1}-${ymin1})
#variable rad   equal sqrt(${lx2}+${ly2})/2.0
variable rad   equal sqrt(${ly2})/2.0
variable r0    equal ${rad}
variable r2    equal 512.96

#region xlo plane ${xmin1} 0 0  1 0 0 side in units box move v_xlo NULL NULL
#region xhi plane ${xmax1} 0 0 -1 0 0 side in units box move v_xhi NULL NULL
region xlo block  ${xmin1} ${xmin2} ${ymin1} ${ymax1} ${zmin1} ${zmax1}
region xhi block  ${xmax2} ${xmax1} ${ymin1} ${ymax1} ${zmin1} ${zmax1}
region ylo block  ${xmin1} ${xmax1} ${ymin1} ${ymin2} ${zmin1} ${zmax1}
region yhi block  ${xmin1} ${xmax1} ${ymax2} ${ymax1} ${zmin1} ${zmax1}
#region sph sphere ${xrc} ${yrc} ${zrc} v_rad side in units box
region cyl cylinder x ${yrc} ${zrc} v_rad INF INF side in units box

group  xlo   region xlo
group  xhi   region xhi
group  ylo   region ylo
group  yhi   region yhi

thermo_style    custom step fmax fnorm pe evdwl emol ecoul epair ebond eangle edihed elong 
thermo 1000

dump           1   all  xyz  ${xyz_frequency}  test.xyz
dump_modify    1   element C1 C2
min_style cg
min_modify dmax 0.1
minimize 1.0e-6 1.0e-8 50000 50000
reset_timestep 0
#######################
compute p    all pe/atom
compute pnet net reduce sum c_p
compute k    all ke/atom
compute knet net reduce sum c_k
compute bo   net pe/atom bond
compute di   net pe/atom dihedral
compute pa   net pe/atom pair
compute eb   net reduce sum c_bo
compute ed   net reduce sum c_di
compute ep   net reduce sum c_pa
#compute fx1  xlo property/atom fx
#compute fx2  xhi property/atom fx
#compute f1   xlo reduce sum c_fx1
#compute f2   xhi reduce sum c_fx2
#compute Tnet bod temp
#compute 3    net com
###########################
velocity net create ${Tmin} 798
#fix br net bond/break  5 1 ${b1}
#fix cr net bond/create 5 1 1 ${b2} 1 iparam 6 1 jparam 6 1

#fix wxlo all wall/region xlo harmonic 10.0 10.0 10.0
#fix wxhi all wall/region xhi harmonic 10.0 10.0 10.0
#fix wsph all wall/region sph harmonic 10.0 10.0 10.0
fix wcyl all wall/region cyl harmonic 10.0 10.0 10.0

fix  1 all nve 
fix  2 all langevin ${Tmin} ${Tmax} ${Tdam} 789
#fix  ave1 all ave/time 1 10 ${aver_frequency} c_pnet c_knet c_eb c_ed c_ep f_br[2] f_cr[2] file gra.dat
fix  ave1 all ave/time 1 10 ${aver_frequency} c_pnet c_knet c_eb c_ed c_ep file gra.dat
#dump 3 net custom ${dump_frequency} relax.dump id xu yu zu c_k c_p c_bo c_di

thermo_style   custom step ke pe etotal evdwl emol ecoul epair ebond eangle edihed temp lx ly lz press pxx pyy pzz #f_br[2] f_cr[2]
thermo  1000 

run    100000
#######################
#dump            2 all xyz    ${dump_frequency} transition.xyz
#dump_modify     2 element C1 C2
#dump            3 net custom ${dump_frequency} relax.dump id xu yu zu c_k c_p
#fix             6 net ave/atom 1 1000 50000 c_k c_p
#dump            3 net custom 50000 relax.dump id xu yu zu f_6[1] f_6[2]
#dump_modify     3 sort id
#######################
variable e     equal 1.0-(1.0-0.75)*sqrt(${r2}/${r0})
#variable L     equal ${xmax1}-${xmin1}
#variable dl    equal ${L}*${e}
#variable xmin3 equal 0+${dl}/2.0
#variable xmax3 equal 0-${dl}/2.0
#variable xlo   equal ramp(0,${xmin3})
#variable xhi   equal ramp(0,${xmax3})
variable r1    equal ${r2}*0.1
variable rad   equal ramp(${r0},${r1})

fix 2 all langevin ${Tmax} ${Tmax} ${Tdam} 68517

restart 1000000 confine.*.restart
run     2000000
#write_restart  confine.restart
#########################
#variable xlo   equal 0.0
#variable xhi   equal 0.0
variable rad   equal ${r1}

fix 2 all langevin ${Tmax} ${Tmin} ${Tdam} 68551

run     1000000
write_restart  equ.restart
dump 3 net custom ${dump_frequency} relax.dump id xu yu zu c_k c_p c_bo c_di

min_style cg
min_modify dmax 0.1
minimize 1.0e-8 1.0e-9 50000 100000

