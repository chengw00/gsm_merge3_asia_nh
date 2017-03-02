#!/bin/csh

set HOME = /home/DATA/GSM/gsm3_rt

set DATA_RAW1  = $HOME/download_sec1/from_WIS-JMA  # raw grib file directory

set DATA_HOLD1 = $HOME/jma_hold # holding directory for grib files

set DATA_BIN1  = $HOME/jma_bin1

set DATA_RAW2  = $HOME/download_sec2/from_WIS-JMA  # raw grib file directory

set DATA_HOLD2 = $HOME/jma_hold # holding directory for grib files

set DATA_BIN2  = $HOME/jma_bin2

set DATA_RAW3  = $HOME/download_sec3/from_WIS-JMA  # raw grib file directory

set DATA_HOLD3 = $HOME/jma_hold # holding directory for grib files

set DATA_BIN3  = $HOME/jma_bin3

set DATA_RUN = $HOME/../gsm

set WORKING = $HOME/working

# ======
rm -r -f $WORKING

mkdir $WORKING 

# =============================
# find out cycle
if ( $1 == "" ) then
 set yrwb = ` date -u +%Y `
 set mnwb = ` date -u +%m `
 set dywb = ` date -u +%d `
 set hrwb = ` date -u +%H `

 if ( $hrwb >= 21 ) then
   set hrwb = 18
 else if ( $hrwb >= 15 ) then
   set hrwb = 12
 else if ( $hrwb >= 9 ) then
   set hrwb = 06
 else
   set hrwb = 00
 endif

 set CYCLE = $yrwb$mnwb$dywb$hrwb

else
 set CYCLE = $1
endif

# =========
mkdir $DATA_HOLD1
mkdir $DATA_BIN1

#mkdir $DATA_HOLD2
mkdir $DATA_BIN2

#mkdir $DATA_HOLD3
mkdir $DATA_BIN3

# ======
mkdir $WORKING/download_sec1
cd $WORKING/download_sec1
cp -p $HOME/code/*.ncl .
cp -p $HOME/code/*.csh .
cp -p $HOME/code/*.exe .

mkdir $WORKING/download_sec2
cd $WORKING/download_sec2
cp -p $HOME/code/*.ncl .
cp -p $HOME/code/*.csh .
cp -p $HOME/code/*.exe .

mkdir $WORKING/download_sec3
cd $WORKING/download_sec3
cp -p $HOME/code/*.ncl .
cp -p $HOME/code/*.csh .
cp -p $HOME/code/*.exe .

cd $WORKING/download_sec1
./unpack_jma-gsm_sec1.csh $DATA_RAW1 $DATA_HOLD1 $DATA_BIN1 $CYCLE  &

cd $WORKING/download_sec2
./unpack_jma-gsm_sec2.csh $DATA_RAW2 $DATA_HOLD2 $DATA_BIN2 $CYCLE  &

cd $WORKING/download_sec3
./unpack_jma-gsm_sec3.csh $DATA_RAW3 $DATA_HOLD3 $DATA_BIN3 $CYCLE  &

