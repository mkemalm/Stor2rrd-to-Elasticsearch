#!/bin/bash
 
RRD=$1
POOL=$2
STORAGE=$3
 
pool_source_rrd="/stor2rrd/data/${STORAGE}/POOL/${RRD}.rrd"
pool_dest_folder="/stor2rrd/ELK/${STORAGE}/Pools/${POOL}"
 
if [ ! -d /stor2rrd/ELK/${STORAGE}/Pools ];then
        mkdir -p /stor2rrd/ELK/${STORAGE}/Pools
fi
if [[ ! -f ${pool_dest_folder}/0.log ]];then
        /bin/rrdtool fetch ${pool_source_rrd} AVERAGE -s -30m | grep -v nan | grep ":"  > "${pool_dest_folder}/0.log"
        /bin/rrdtool fetch ${pool_source_rrd} AVERAGE -s -30m | grep -v nan | grep ":"  > "${pool_dest_folder}/diff.log"
        exit
fi
 
 
/bin/rrdtool fetch ${pool_source_rrd} AVERAGE -s -30m | grep -v nan | grep ":"  > "${pool_dest_folder}/1.log"
cd $pool_dest_folder
awk 'BEGIN { while ( getline < "0.log" ) { arr[$0]++ } } { if (!( $0 in arr ) ) { print } }' 1.log >  "${pool_dest_folder}/diff.log"
 
/stor2rrd/ELK/read_storage_perf.py $STORAGE $POOL >> "/stor2rrd/ELK/${STORAGE}/allpools.log"
 
if [[ ! -z "${pool_dest_folder}/diff.log" ]];then
        cp "${pool_dest_folder}/1.log" "${pool_dest_folder}/1_old.log"
        cp "${pool_dest_folder}/0.log" "${pool_dest_folder}/0_old.log"
        mv "${pool_dest_folder}/1.log" "${pool_dest_folder}/0.log" -f
fi
