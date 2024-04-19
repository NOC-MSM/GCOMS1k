# Setup on Archer2

```
export CONFIG=GCOMS1k
export WORK=/work/n01/n01/$USER
export WDIR=$WORK/$CONFIG
export INPUTS=$WDIR/INPUTS
export START_FILES=$WDIR/START_FILES
export CDIR=$WDIR/trunk_NEMOGCM_v4.0.4/cfgs
export TDIR=$WDIR/trunk_NEMOGCM_v4.0.4/tools
export CONFIG_DIR=$WDIR/nemo/cfgs/$CONFIG
export GIT=$WORK/Git/
export TMPLD=$CDIR/$CONFIG/GCOMS1k_templates
export REPO_DIR=$GIT/GCOMS1k
export HPC_TARG=archer2
export COMPILER=gnu
export MPI_TARG=mpich
```
Make the directories

```
mkdir $WDIR
mkdir $INPUTS
mkdir $START_FILES
mkdir $GIT
```
Enable Git and cloen the repository
```
exec ssh-agent $SHELL 
ssh-add ~/.ssh/id_ed25519

cd  $GIT
git clone https://github.com/NOC-MSM/GCOMS1k
```
# Install XIOS
Following SE-NEMO
```
cd $WDIR
svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/branchs/xios-2.5@1964 $WDIR/xios
cd $WDIR/xios
cp $REPO_DIR/arch/xios/2.5/* ./arch
  . $REPO_DIR/scripts/env/${HPC_TARG}/${COMPILER}-${MPI_TARG}-ucx
./make_xios --full --prod --arch ${HPC_TARG}-${COMPILER}-${MPI_TARG} --netcdf_lib netcdf4_par --job 10
export XIOS_DIR=$WDIR/xios

```
# Install NEMO
```
cd $WDIR
export NEMO_VER=4.0.4
svn co http://forge.ipsl.jussieu.fr/nemo/svn/NEMO/branches/UKMO/NEMO_4.0.4_mirror nemo
```
Make directores
```
mkdir $CONFIG_DIR
cd $CONFIG_DIR
cp -r $REPO_DIR/EXPREF/ EXPREF
cd $CONFIG_DIR/EXPREF

mkdir meta_out
mkdir RESTARTS
mkdir OUTPUTS
mkdir OUTPUTS_PROCESSED
mkdir OUTPUTS_ZIP

ln -s $XIOS_DIR/bin/xios_server.exe $CONFIG_DIR/EXPREF/xios_server.exe

cp -r $REPO_DIR/MY_SRC_v$NEMO_VER $CONFIG_DIR/MY_SRC
```
Compile

```
cd $WDIR/nemo
./makenemo -m ${HPC_TARG}-${COMPILER}-${MPI_TARG} -r se-eORCA025 -j 16
```

```
conda create -n gcoms1k -c conda-forge --file requirements.txt
```
 ipython kernel install --user --name=gcoms1k
