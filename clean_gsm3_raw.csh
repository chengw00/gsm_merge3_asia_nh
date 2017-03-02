#!/bin/csh

set PATH = /home/DATA/GSM/gsm3_rt

set DIR = ( download_sec1 download_sec2 download_sec3 )

set AGE_LIMIT = 64800   # 18-h in sec, files will be processed
                         # when its age exceeds this time
set TIME_NOW  = ` date +%s `

foreach dd ( $DIR )
 if ( -d $PATH/$dd/from_WIS-JMA ) then
  set filelist = ` /bin/ls -1 $PATH/$dd/from_WIS-JMA `
  foreach ff ( $filelist )
   set TIME_FILE = ` stat -c %Y ${PATH}/$dd/from_WIS-JMA/$ff `
   @  age = $TIME_NOW - $TIME_FILE
   echo $ff $age
   if ( $age > $AGE_LIMIT ) then
    echo "removing $ff : age $age "
    rm -f ${PATH}/$dd/from_WIS-JMA/$ff
   endif
  end
 endif
end

# =====
set DIR = ( jma_bin1 jma_bin2 jma_bin3 )

set AGE_LIMIT = 86400   # 24-h in sec, files will be processed
                         # when its age exceeds this time
set TIME_NOW  = ` date +%s `


foreach dd ( $DIR )
 if ( -d $PATH/$dd ) then
  set filelist = ` /bin/ls -1 $PATH/$dd `
  foreach ff ( $filelist )
   set TIME_FILE = ` stat -c %Y ${PATH}/$dd/$ff `
   @  age = $TIME_NOW - $TIME_FILE
   echo $ff $age
   if ( $age > $AGE_LIMIT ) then
    echo "removing $ff : age $age "
    rm -f ${PATH}/$dd/$ff
   endif
  end
 endif
end

# =====
set DIR = ( jma_hold )

set AGE_LIMIT = 604800   # 7-days in sec, files will be processed
                         # when its age exceeds this time
set TIME_NOW  = ` date +%s `


foreach dd ( $DIR )
 if ( -d $PATH/$dd ) then
  set filelist = ` /bin/ls -1 $PATH/$dd `
  foreach ff ( $filelist )
   set TIME_FILE = ` stat -c %Y ${PATH}/$dd/$ff `
   @  age = $TIME_NOW - $TIME_FILE
   echo $ff $age
   if ( $age > $AGE_LIMIT ) then
    echo "removing $ff : age $age "
    rm -f ${PATH}/$dd/$ff
   endif
  end
 endif
end

