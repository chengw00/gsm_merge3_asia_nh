#!/bin/csh

setenv NCARG_ROOT /home/soft/WRF_tools/NCL
setenv NCARG_LIB  /home/soft/WRF_tools/NCL/lib

set FILE_IN = $1

set FILE_OUT = $2

set GNAME = $3
 
cat <<EOF>test.ncl

;********************************************************
; WRF: latitude-z cross section.
;********************************************************
load "\$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "\$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "\$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "\$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
begin
  ; ==================
  setfileoption("bin","WriteByteOrder","LittleEndian")
  file_in =    "$FILE_IN"
  file_out =   "$FILE_OUT"

  fall      = addfile (file_in, "r")  
  
  names = getfilevarnames(fall)

  atts = getfilevaratts(fall,names(0))
  dims = getfilevardims(fall,names(2))

  lat2d   = fall->lat_38
  lon2d   = fall->lon_38
  dimlc   = dimsizes(lat2d)
  nlat    = dimlc(0)
  dimlc   = dimsizes(lon2d)
  mlon    = dimlc(0)

  variable = fall->$GNAME

  varflip = variable

  do j=0,nlat-1
   do i=0,mlon-1
    ii = i
    jj = (nlat-1)-j
    varflip(jj,ii)=variable(j,i)
   end do
  end do
  
  printVarSummary(variable)

  ; ======direct access binary ========
  ;fbindirwrite(file_out,HGT_38_ISBL)

  ; ====== sequential binary =====
  fbinwrite(file_out,varflip)

  ;========================

  end
EOF

$NCARG_ROOT/bin/ncl test.ncl
