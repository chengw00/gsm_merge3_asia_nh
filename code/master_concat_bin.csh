#!/bin/csh

set HOME = /home/DATA/GSM/gsm3_rt

set WORKING = $HOME/working

set DATA_HOLD = $HOME/jma_hold

set DATA_RUN = $HOME/gsm

# =======
set FCST = ( 000 006 012 018 024 030 036 042 048 060 072 084  )

set PATH_SEC1 = $HOME/jma_bin1

set PATH_SEC2 = $HOME/jma_bin2

set PATH_SEC3 = $HOME/jma_bin3

# ===========
if ( ! -d $WORKING ) then
 echo "$WORKING does not exist: EXIT" 
endif

mkdir -p $DATA_HOLD

mkdir -p $DATA_RUN

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

# ========
cd $WORKING
cp -p $HOME/code/*.ncl .
cp -p $HOME/code/*.csh .
cp -p $HOME/code/*.exe .
cp -p $HOME/code/gribw .
cp -p $HOME/code/wgrib .

foreach fc ( $FCST )
 if ( ! -e ${DATA_HOLD}/${CYCLE}_fh.0${fc}.GSM.grib2 ) then
  ./concat_bin.csh $CYCLE $fc $PATH_SEC1 $PATH_SEC2 $PATH_SEC3 ${DATA_HOLD}
 endif
end

# ===== get files from other cycles to fill gap ======
set yr = ` echo $CYCLE | cut -c1-4 `
set mn = ` echo $CYCLE | cut -c5-6 `
set dy = ` echo $CYCLE | cut -c7-8 `
set hr = ` echo $CYCLE | cut -c9-10 `
set FUTCYC = ` ./time_reversal_hour.exe $yr $mn $dy $hr 6 `

foreach fh ( 54 66 78 )
 @ fh_fut = $fh + 6
 set FILE1 = ${DATA_HOLD}/${CYCLE}_fh.00${fh}.GSM.grib2
 set FILE2 = ${DATA_HOLD}/$FUTCYC[$#FUTCYC]_fh.00${fh_fut}.GSM.grib2
 #if ( ! -e ${DATA_HOLD}/${CYCLE}_fh.00${fh}.GSM.grib2 && -e ${DATA_HOLD}/$FUTCYC[$#FUTCYC]_fh.00${fh_fut}.GSM.grib2 ) then
 if ( ! -e $FILE1 && -e $FILE2 ) then
  #cp -p ${DATA_HOLD}/$FUTCYC[$#FUTCYC]_fh.00${fh_fut}.GSM.grib2 ${DATA_HOLD}/${CYCLE}_fh.00${fh}.GSM.grib2 
  cp -p $FILE2 $FILE1
 endif
end

# ===== check if all files have been processed, if so, kill all jobs and exit =====
set ncount = 0

foreach fh ( $FCST )
 set FILE = ${DATA_HOLD}/${CYCLE}_fh.0${fh}.GSM.grib2
 if ( -e $FILE ) @ ncount = $ncount + 1
end

if ( $ncount >= $#FCST ) then
 cp -p ${DATA_HOLD}/${CYCLE}* $DATA_RUN
endif

echo $DATA_RUN $ncount

