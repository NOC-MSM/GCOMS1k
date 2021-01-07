GCOMS2 Running an experiment
exec ssh-agent $SHELL 
ssh-add ~/.ssh/id_rsa

On ARCHER
---------------------------------------------------------------------------------------------------------------:: 
 export CONFIG=GCOMS1k
 export DOMNAM=GTHI35
 export EXPNUM=02
 export WORK=/work/n01/n01/$USER
 export WDIR=$WORK/$CONFIG
 export INPUTS=$WDIR/INPUTS
 export TEMPLATES=$INPUTS/TEMPLATES
 export CDIR=$WDIR/trunk_NEMOGCM_v4.0.2/cfgs
 export TDIR=$WDIR//trunk_NEMOGCM_v4.0.2/tools
 export EXP=$CDIR/$CONFIG/$DOMNAM\_$EXPNUM 
 export EXP=$CDIR/$CONFIG/$DOMNAM\_$EXPNUM
 export TMPLD=$CDIR/$CONFIG/GCOMS1k_templates
 export STARTYEAR=1995
 module swap PrgEnv-cray PrgEnv-intel
 module unload cray-netcdf
 module load cray-netcdf-hdf5parallel cray-hdf5-parallel

 mkdir -p  $EXP
----------------------------------------------------------------------
cd $EXP

ln -s /work/n01/n01/nibrun/NEMO/xios-2.0/bin/xios_server.exe $EXP/xios_server.exe 
ln -s $CDIR/$CONFIG/BLD/bin/nemo.exe opa

ln -s $INPUTS/$DOMNAM/bdydta   bdydta
ln -s $INPUTS/$DOMNAM/metdta   metdta
ln -s  $INPUTS/$DOMNAM/$DOMNAM\_IC_v1_ORCA0083-N06_$STARTYEAR.nc initcd_votemper.nc
ln -s  $INPUTS/$DOMNAM/$DOMNAM\_IC_v1_ORCA0083-N06_$STARTYEAR.nc initcd_vosaline.nc
ln -s $INPUTS/$DOMNAM/bdydta/$DOMNAM\_coordinates.bdy.nc coordinates.bdy.nc
ln -s $INPUTS/$DOMNAM/$DOMNAM\_domain_cfg.nc domain_cfg.nc 
ln -s $INPUTS/$DOMNAM/$DOMNAM\_rivertest_v3.nc runoff.nc
mkdir rst
cp $TMPLD/*.xml .
ln -s  $TMPLD/namelist_ref_v4.0.2 namelist_ref
cat $TMPLD/namelist_cfg_domain_v4.0.2 | sed  "s,__STARTDATE__,$STARTYEAR,g"  | sed  "s,__DOMNAM__,$DOMNAM,g"   > namelist_cfg_template
cp $TMPLD/monthlyrun*.pbd .
cat $TMPLD/monthlyrun.pbs_template  | sed  "s,__DOMNAM__,$DOMNAM,g" > monthlyrun.pbs  
cp $TMPLD/run_nemo.sh  .

# check all links work
find . -type l ! -exec test -e {} \; -print
------

------- starting a run----------
# in run_nemo.sh
set y= <start year>
m=<start month> .....Note no 0 in month
tpd = <time steps per day> 

# in monthlyrun.pbs
Set email address, DOMNAM, 
IJ= < number of cores > = (select-1)*24
Change file names for tidy up.

::
run_nemo.sh   monthlyrun.pbs

-------------re staring a run
set y= <start year>
m=<start month> .....Note no 0 in month
nit0 = <time start to start on> = restart step + 1
INIT=1
 ::


run_nemo.sh   monthlyrun.pbs  
----------------------------------------

ARCHIVEDIR=/nerc/n01/n01/$USER/$CONFIG/OUTPUT/$DOMNAM\_$EXPNUM/
for YEAR in 2012 2013 2014
do
mv $EXP/OUTPUT/$YEAR $ARCHIVEDIR
done
------------------------------------------
Harvest data
exec ssh-agent $SHELL 
 ssh-add ~/.ssh/id_rsa

export CONFIG=GCOMS1k
export WORK=/work
export WDIR=$WORK/$USER/NEMO/$CONFIG
export INPUTS=$WDIR/INPUTS
export  OUTPUTS=/projectsa/accord/GCOMS1k/OUTPUTS/
export INPUTS_ARCH=/work/n01/n01/$USER/$CONFIG/INPUTS/
export CDIR_ARCH=/nerc/n01/n01/$USER/$CONFIG/OUTPUT/
export EXP_ARCH=/work/n01/n01/jholt/GCOMS1k/trunk_NEMOGCM_r8395/CONFIG/$CONFIG/
export EXPNUM=01
export DOMNAM=BLZE12_C1

mkdir  -p $OUTPUTS/$DOMNAM\_$EXPNUM 
cd $OUTPUTS/$DOMNAM\_$EXPNUM
rsync -uvtr login.archer.ac.uk:$CDIR_ARCH/$DOMNAM\_$EXPNUM/* . 

rsync -uvtr login.archer.ac.uk:$EXP_ARCH/$DOMNAM\_$EXPNUM/OUTPUT/* . 



# infinite loop to retrieve data:
while : 
do
rsync -uvtr login.archer.ac.uk:$EXP_ARCH/$DOMNAM\_$EXPNUM/OUTPUT/* . 
sleep 3h
done










