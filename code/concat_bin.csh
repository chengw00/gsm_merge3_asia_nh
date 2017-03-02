#!/bin/csh

#set echo

#set CYCLE = 2012072512

#set FCST = ( 000 006 012 018 024 )
#set FCST = ( 006 )

set CYCLE = $1

set FCST = $2

set PATH_SEC1 = $3

set PATH_SEC2 = $4

set PATH_SEC3 = $5

set PATH_HOLD = $6

if ( $1 == "" || $2 == "" || $3 == "" || $4 == "" || $5 == "" || $6 == "" ) then
 echo "input missing for concat_bin.csh: EXIT"
 exit
endif

set VAR = ( height tmp u v )

set LEV = ( 10 20 30 50 70 100 150 200 250 300 400 500 600 700 850 925 1000 )

set VARRH = ( rh )
set LEVRH = ( 300 400 500 600 700 850 925 1000 )

set FILE_BIG_SEC1 = wrf.plev.fort.bin_sec1.dat
set FILE_BIG_SEC2 = wrf.plev.fort.bin_sec2.dat
set FILE_BIG_SEC3 = wrf.plev.fort.bin_sec3.dat

foreach ff ( $FCST )
 rm -f $FILE_BIG_SEC1
 set FLAG = 0

 set FILE = $PATH_SEC1/tmp_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC1
 else
  set FLAG = 1
  goto SKIP1
 endif

 set FILE = $PATH_SEC1/rh_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC1
 else
  set FLAG = 1
  goto SKIP1
 endif

 set FILE = $PATH_SEC1/u_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC1
 else
  set FLAG = 1
  goto SKIP1
 endif

 set FILE = $PATH_SEC1/v_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC1
 else
  set FLAG = 1
  goto SKIP1
 endif

 set FILE = $PATH_SEC1/slp_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC1
 else
  set FLAG = 1
  goto SKIP1
 endif
 # =====================================
 foreach vv ( $VARRH )
  foreach ll ( $LEVRH )
   set FILE = $PATH_SEC1/${vv}_${ll}_f0${ff}_${CYCLE}.bin.dat
   if ( -e $FILE ) then
    cat $FILE >> $FILE_BIG_SEC1
   else
    set FLAG = 1
    goto SKIP1
   endif
  end
 end
 # ====================================

 foreach vv ( $VAR )
  foreach ll ( $LEV )
   set FILE = $PATH_SEC1/${vv}_${ll}_f0${ff}_${CYCLE}.bin.dat
   if ( -e $FILE ) then
    cat $FILE >> $FILE_BIG_SEC1
   else
    set FLAG = 1
    goto SKIP1
   endif
  end
 end


SKIP1:

echo "FLAG" $FLAG $CYCLE $ff
if ( $FLAG == 1 ) then
 rm -f $FILE_BIG_SEC1 file.in
endif


   # ======= section 2 =======
 rm -f $FILE_BIG_SEC2
 set FLAG = 0

 set FILE = $PATH_SEC2/tmp_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC2
 else
  set FLAG = 1
  goto SKIP2
 endif

 set FILE = $PATH_SEC2/rh_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC2
 else
  set FLAG = 1
  goto SKIP2
 endif

 set FILE = $PATH_SEC2/u_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC2
 else
  set FLAG = 1
  goto SKIP2
 endif

 set FILE = $PATH_SEC2/v_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC2
 else
  set FLAG = 1
  goto SKIP2
 endif

 set FILE = $PATH_SEC2/slp_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC2
 else
  set FLAG = 1
  goto SKIP2
 endif
 # =====================================
 foreach vv ( $VARRH )
  foreach ll ( $LEVRH )
   set FILE = $PATH_SEC2/${vv}_${ll}_f0${ff}_${CYCLE}.bin.dat
   if ( -e $FILE ) then
    cat $FILE >> $FILE_BIG_SEC2
   else
    set FLAG = 1
    goto SKIP2
   endif
  end
 end
 # ====================================

 foreach vv ( $VAR )
  foreach ll ( $LEV )
   set FILE = $PATH_SEC2/${vv}_${ll}_f0${ff}_${CYCLE}.bin.dat
   if ( -e $FILE ) then
    cat $FILE >> $FILE_BIG_SEC2
   else
    set FLAG = 1
    goto SKIP2
   endif
  end
 end


SKIP2:

echo "FLAG" $FLAG $CYCLE $ff
if ( $FLAG == 1 ) then
 rm -f $FILE_BIG_SEC2 file.in
endif

   # ======= 3rd section ========
 rm -f $FILE_BIG_SEC3
 set FLAG = 0

 set FILE = $PATH_SEC3/tmp_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC3
 else
  set FLAG = 1
  goto SKIP3
 endif

 set FILE = $PATH_SEC3/rh_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC3
 else
  set FLAG = 1
  goto SKIP3
 endif

 set FILE = $PATH_SEC3/u_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC3
 else
  set FLAG = 1
  goto SKIP3
 endif

 set FILE = $PATH_SEC3/v_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC3
 else
  set FLAG = 1
  goto SKIP3
 endif

 set FILE = $PATH_SEC3/slp_sfc_f0${ff}_${CYCLE}.bin.dat
 if ( -e $FILE ) then
  cat $FILE >> $FILE_BIG_SEC3
 else
  set FLAG = 1
  goto SKIP3
 endif
 # =====================================
 foreach vv ( $VARRH )
  foreach ll ( $LEVRH )
   set FILE = $PATH_SEC3/${vv}_${ll}_f0${ff}_${CYCLE}.bin.dat
   if ( -e $FILE ) then
    cat $FILE >> $FILE_BIG_SEC3
   else
    set FLAG = 1
    goto SKIP3
   endif
  end
 end
 # ====================================

 foreach vv ( $VAR )
  foreach ll ( $LEV )
   set FILE = $PATH_SEC3/${vv}_${ll}_f0${ff}_${CYCLE}.bin.dat
   if ( -e $FILE ) then
    cat $FILE >> $FILE_BIG_SEC3
   else
    set FLAG = 1
    goto SKIP3
   endif
  end
 end


SKIP3:

echo "FLAG" $FLAG $CYCLE $ff
if ( $FLAG == 1 ) then
 rm -f $FILE_BIG_SEC3 file.in
endif


 if ( -e $FILE_BIG_SEC1 && -e $FILE_BIG_SEC2 && -e $FILE_BIG_SEC3 ) then
  rm -f ./file.in ./wrf.plev.dum.grib ./combined.plev.fort.bin.dat
  set yr = ` echo $CYCLE | cut -c1-4 `
  set mn = ` echo $CYCLE | cut -c5-6 `
  set dy = ` echo $CYCLE | cut -c7-8 `
  set hr = ` echo $CYCLE | cut -c9-10 `
cat <<EOF>file.in
$yr
$mn
$dy
$hr
$ff
EOF
  ./bin2grib.plev_jma_gsm_merge.exe < ./file.in
  ./wgrib -PDS10 -GDS10 ./wrf.plev.dum.grib | ./gribw ./combined.plev.fort.bin.dat -o ${PATH_HOLD}/${CYCLE}_fh.0${ff}.GSM.grib2
 endif

end  # ff loop
