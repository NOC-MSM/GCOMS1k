# Setup on Archer2
```
export CONFIG=GCOMS1k
export WORK=/work/n01/n01/$USER
export WDIR=$WORK/$CONFIG
export INPUTS=$WDIR/INPUTS
export START_FILES=$WDIR/START_FILES
export CDIR=$WDIR/trunk_NEMOGCM_v4.0.4/cfgs
export TDIR=$WDIR/trunk_NEMOGCM_v4.0.4/tools
export GIT=$WORK/Git/
export TMPLD=$CDIR/$CONFIG/GCOMS1k_templates
export $REPO_DIR=$GIT/GCOMS1k
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
ssh-add ~/.ssh/id_rsa

cd  $GIT
git clone https://github.com/NOC-MSM/GCOMS1k
```
# Install XIOS
Following SE-NEMO
```
svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/branchs/xios-2.5@1964 xios
cd xios
cp $REPO_DIR/arch/xios/2.5/* ./arch
./make_xios --full --prod --arch ${HPC_TARG}-${COMPILER}-${MPI_TARG} --netcdf_lib netcdf4_par --job 10
export XIOS_DIR=$WDIR/xios

```
# Install NEMO
```
export NEMO_VER=4.0.4
svn co http://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/r4.0/r$NEMO_VER --depth empty nemo
svn co http://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/r4.0/r$NEMO_VER/src --depth infinity nemo/src
svn co http://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/r4.0/r$NEMO_VER/cfgs/SHARED nemo/cfgs/SHARED
svn export http://forge.ipsl.jussieu.fr/nemo/svn/NEMO/releases/r4.0/r$NEMO_VER/cfgs/ref_cfgs.txt nemo/cfgs/ref_cfgs.txt

 for ext_name in mk FCM IOIPSL
   do
   ext=`svn propget svn:externals | grep $ext_name | cut -c2-`
   svn co http://forge.ipsl.jussieu.fr/nemo/svn/$ext
 done
 ext=`svn propget svn:externals | grep makenemo | cut -c2-`
 svn export http://forge.ipsl.jussieu.fr/nemo/svn/$ext
 ;;

cd nemo
./makenemo -m ${HPC_TARG}-${COMPILER}-${MPI_TARG} -r se-eORCA025 -j 16
```

```
conda create -n gcoms1k -c conda-forge --file requirements.txt
```
 ipython kernel install --user --name=gcoms1k
