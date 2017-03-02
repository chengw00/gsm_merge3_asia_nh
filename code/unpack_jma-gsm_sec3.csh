#!/bin/csh
# 
# extract individual Grib files from JMA-GSM 
# fields go from north to south for re-formatting to Grib 1 format
 
set DATA_RAW = $1
#/qnap-10/chengw/ral/cepri/jma/download/from_WIS-JMA

set DATA_HOLD = $2

set DATA_BIN = $3

set CYCLE = $4
#set CYCLE = 2012072512

# ====== set up forecast hours to process =========
set FHR = ( 000 006 012 018 024 030 036 042 048 060 072 084 )

# ================================================

if ( $1 == "" || $2 == "" || $3 == ""  || $4 == "" ) then
 echo "MISSING INPUT: EXIT"
 exit
endif

#if ( ! -e $DATA_HOLD ) mkdir -p $DATA_HOLD

set TIME1 = ` echo $CYCLE | cut -c7-10 `

set filelist = ` /bin/ls -1 ${DATA_RAW}/*RJTD${TIME1}00_*.grib `

if ( $#filelist == 0 ) then
 echo "$CYCLE has not downloaded yet: EXIT"
 exit
endif

set nchar = `echo $DATA_RAW | awk '{print length($0)}'`
@ v1 = $nchar + 1 + 4
set v2 = $v1

@ l1 = $nchar + 1 + 7
@ l2 = $nchar + 1 + 8

@ f1 = $nchar + 1 + 6
set f2 = $f1


foreach ff ( $filelist )
 #set variable = ` echo $ff | cut -c4-4 `
 #set level    = ` echo $ff | cut -c7-8 `
 #set fcsthour = ` echo $ff | cut -c6-6 `

 set variable = ` echo $ff | cut -c${v1}-${v2} `
 set level    = ` echo $ff | cut -c${l1}-${l2} `
 set fcsthour = ` echo $ff | cut -c${f1}-${f2} `

 echo $ff $variable $level $fcsthour
 # ========= height =====================
 set VAR  = "NONE"
 set LEV  = "NONE"
 set FCST = "NONE"
 set GNAME = "NONE" 

 if ( $level == 01 ) then
  set LEV = "10"
 else if ( $level == 02 ) then
  set LEV = "20"
 else if ( $level == 03 ) then
  set LEV = "30"
 else if ( $level == 05 ) then
  set LEV = "50"
 else if ( $level == 07 ) then
  set LEV = "70"
 else if ( $level == 10 ) then
  set LEV = "100"
 else if ( $level == 15 ) then
  set LEV = "150"
 else if ( $level == 20 ) then
  set LEV = "200"
 else if ( $level == 25 ) then
  set LEV = "250"
 else if ( $level == 30 ) then
  set LEV = "300"
 else if ( $level == 40 ) then
  set LEV = "400"
 else if ( $level == 50 ) then
  set LEV = "500"
 else if ( $level == 60 ) then
  set LEV = "600"
 else if ( $level == 70 ) then
  set LEV = "700"
 else if ( $level == 85 ) then
  set LEV = "850"
 else if ( $level == 92 ) then
  set LEV = "925"
 else if ( $level == 98 || $level == 89 ) then  # 89 = MSL
  set LEV = "sfc"
 else if ( $level == 99 ) then
  set LEV = "1000"
 else
  set LEV  = "NONE"
 endif

 if ( $fcsthour == "A" ) then
  set FCST = "000"
 else if ( $fcsthour == "B" ) then
  set FCST = "006"
 else if ( $fcsthour == "C" ) then
  set FCST = "012"
 else if ( $fcsthour == "D" ) then
  set FCST = "018"
 else if ( $fcsthour == "E" ) then
  set FCST = "024"
 else if ( $fcsthour == "F" ) then
  set FCST = "030"
 else if ( $fcsthour == "G" ) then
  set FCST = "036"
 else if ( $fcsthour == "H" ) then
  set FCST = "042"
 else if ( $fcsthour == "I" ) then
  set FCST = "048"
 else if ( $fcsthour == "J" ) then
  set FCST = "060"
 else if ( $fcsthour == "K" ) then
  set FCST = "072"
 else if ( $fcsthour == "L" ) then
  set FCST = "084"
 else
  set FCST = "NONE"
 endif

 if ( $variable == "H" ) then
  set VAR = height
  set GNAME = "HGT_39_ISBL"
 else if ( $variable == "R" ) then
  set VAR = rh
  if ( $LEV == "sfc" ) then
   set GNAME = "R_H_39_SFC"
  else
   set GNAME = "R_H_39_ISBL"
  endif
 else if ( $variable == "T" ) then
  set VAR = tmp
  if ( $LEV == "sfc" ) then
   set GNAME = "TMP_39_SFC"
  else
   set GNAME = "TMP_39_ISBL"
  endif
 else if ( $variable == "U" ) then
  set VAR = u
  if ( $LEV == "sfc" ) then
   set GNAME = "U_GRD_39_SFC"
  else
   set GNAME = "U_GRD_39_ISBL"
  endif
 else if ( $variable == "V" ) then
  set VAR = v
  if ( $LEV == "sfc" ) then 
   set GNAME = "V_GRD_39_SFC"
  else
   set GNAME = "V_GRD_39_ISBL"
  endif

 else if ( $variable == "P" ) then
  set VAR = slp
  set GNAME = "PRMSL_39_MSL"
 
 else
  set VAR  = "NONE"
  set GNAME = "NONE"
 endif

 echo $VAR $LEV $FCST $GNAME
 # ======== use NCL to extract and flip j-index ===========
 set FILE_BIN_OUT = ${VAR}_${LEV}_f0${FCST}_${CYCLE}.bin.dat
 if ( ( ! -e $DATA_BIN/$FILE_BIN_OUT ) && ( $VAR != "NONE" ) && ( $LEV != "NONE" ) && ( $FCST != "NONE" ) && ( $CYCLE != "NONE" ) ) then
  echo $VAR $LEV $FCST $GNAME
  ./extract_flip_ncl_sec3.csh $ff $FILE_BIN_OUT $GNAME
  mv $FILE_BIN_OUT $DATA_BIN
 else
#  echo "SKIP" $ff $FILE_BIN_OUT $GNAME
 endif
 

end

