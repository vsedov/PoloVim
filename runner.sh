#!/usr/bin/env bash
filetype=$1
filepath=$2
shift
shift
params=$@
echo "Start $filetype $filepath"
echo "====================="
case $filetype in
 javascript | js)
    node $filepath $params
   ;;

 bash | sh)
    bash $filepath $params
   ;;

 go )
    go run $filepath $params
   ;;
 python | ipython3) 
    ipython3 $filepath $params
   ;;

 *)
   echo -n "unknown"
   ;;
esac
echo "====================="
