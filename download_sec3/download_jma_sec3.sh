#!/bin/sh
### Configuration ###
atomURL="http://www.wis-jma.go.jp/data/syn?ContentType=Text&Resolution=1.25 1.25&Grid=Latitude/Longitude&Discipline=Global Spectral Model&Type=GRIB&Access=Open&Indicator=RJTD&Area=0.0 90.0 150.0 240.0"
userName=""
userPassword=""
limitSpeed="512k"
sleepTime="1800"
export PATH=$PATH:"/usr/bin"
workParentDirectory=`pwd`
storeDirectory=$workParentDirectory"/from_WIS-JMA"
scriptName=${0##*/}
workDirectory="_"$scriptName
formerETagFile="formerETag"
pidFile=$workDirectory"/pid"
######
loopSubscribe(){
    while [ 1 ]
    do
        nowTime=`date -u +'%H%M%S'`
        tmpFilePrefix="_"$nowTime"_"
        tmpFiles="_"
        rm -f $tmpFiles*
        ### download list of published data ###
        updatedListFile=$tmpFilePrefix"UpdatedList.txt"
        updatedListLogFile=$tmpFilePrefix"UpdatedListLog.txt"
        if test -s $formerETagFile
        then
            formerETag=`cat $formerETagFile`
            header="If-None-Match: "$formerETag
            stdout=`wget --header="$header" --save-headers -T 60 -t 1 -nc --limit-rate="$limitSpeed" -o "$updatedListLogFile" -O "$updatedListFile" "$atomURL" 2>&1`
        else
            stdout=`wget --save-headers -T 60 -t 1 -nc --limit-rate="$limitSpeed" -o "$updatedListLogFile" -O "$updatedListFile" "$atomURL" 2>&1`
        fi
        ### download published data ###
        if test -s $updatedListFile
        then
            filesLogFile=$tmpFilePrefix"FilesLog.txt"
            stdout=`wget --no-check-certificate -T 60 -t 10 -nc --limit-rate="$limitSpeed" -o "$filesLogFile" -i "$updatedListFile" -P "$storeDirectory" 2>&1`

            eTagValue=`grep "ETag:" $updatedListFile | tail -1 | cut -d" " -f2`
            if test -n "$eTagValue"
            then
                echo $eTagValue > $formerETagFile
            fi
        fi

        sleep $sleepTime

    done
}

startSubscribe(){
    if test ! -d "$workDirectory"
    then
        mkdir -p "$workDirectory"
    fi
    if test ! -d "$storeDirectory"
    then
        mkdir -p "$storeDirectory"
    fi
    if test -s $pidFile
    then
        pidFileValue=`cat $pidFile`
        if kill -s 0 $pidFileValue 2>_pErr
        then
            echo "script["$scriptName"] is already running. Please stop or restart script["$scriptName"]."
            exit 0
        else
            rm -f $pidFile
            echo $$ > $pidFile
            cd "$workDirectory"
            loopSubscribe
        fi
    else
        echo $$ > $pidFile
        cd "$workDirectory"
        loopSubscribe
    fi
}

stopSubscribe(){
    if test -s $pidFile
    then
        pid=`cat $pidFile`
        kill -9 $pid
        rm -f $pidFile
    fi
}

case "$1" in
    start)
        startSubscribe
        ;;
    stop)
        stopSubscribe
        ;;
    restart)
        stopSubscribe
        startSubscribe
        ;;
    *)
        echo "Usage: sh ./"$0" {start|stop|restart}"
esac
