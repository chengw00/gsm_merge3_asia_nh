#!/bin/csh

# ====== master script to launch JMA download script
set PATH = $1

set FLAG = $2

cd $PATH
./download_jma_sec1.sh $FLAG
