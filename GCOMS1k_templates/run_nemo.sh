#!/bin/bash 
ITER=27
y=1995
m=1
nit0=1
tpd=1440
#tpd=10
INIT=-1
##tpd=864 
##tpd=720
RUNDIR=`pwd`

#-------------------------------------------------------------------------
if [ $m -lt 10 ] ; then
  month=0$m
else
  month=$m
fi

echo qsub -v m=$m,y=$y,nit0=$nit0,tpd=$tpd,INIT=$INIT -N GCOMS1k$y$month $1 
     qsub -v m=$m,y=$y,nit0=$nit0,tpd=$tpd,INIT=$INIT -N GCOMS1k$y$month $1 

#usage
#  ./run_nemo.sh monthlyrun.pbs
# run perpetuates
# tpd = time steps per day
