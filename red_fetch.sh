#!/bin/bash

# RRD this is an index of pools inside stor2rrd database, can be retrieved from /stor2rrd/data/${STORAGE}/pool.cfg
# POOL is pool name in storage, should be same name within stor2rrd
# STORAGE is storage name, should be same name within stor2rrd

RRD=$1
POOL=$2
STORAGE=$3
 
pool_source_rrd="/stor2rrd/data/${STORAGE}/POOL/${RRD}.rrd"
pool_dest_folder="/stor2rrd/ELK/${STORAGE}/Pools/${POOL}"
 
# Folders for generated data, should be created if doesn't exist.
if [ ! -d /stor2rrd/ELK/${STORAGE}/Pools ];then
        mkdir -p /stor2rrd/ELK/${STORAGE}/Pools
fi

# Read RRD data last 30m as average at first execution
if [[ ! -f ${pool_dest_folder}/0.log ]];then
        /bin/rrdtool fetch ${pool_source_rrd} AVERAGE -s -30m | grep -v nan | grep ":"  > "${pool_dest_folder}/0.log"
        /bin/rrdtool fetch ${pool_source_rrd} AVERAGE -s -30m | grep -v nan | grep ":"  > "${pool_dest_folder}/diff.log"
        exit
fi
 
# Read RRD last 30m as average at every execution
/bin/rrdtool fetch ${pool_source_rrd} AVERAGE -s -30m | grep -v nan | grep ":"  > "${pool_dest_folder}/1.log"
cd $pool_dest_folder
# Find diffirences and push them to difference file. Data comes cumulative from RRD files, it should be differentiated to have 
# real time data.
awk 'BEGIN { while ( getline < "0.log" ) { arr[$0]++ } } { if (!( $0 in arr ) ) { print } }' 1.log >  "${pool_dest_folder}/diff.log"

# Create text as field_name:value for elasticsearch, allpools.log should be ingested to the elasticsearch.
/stor2rrd/ELK/read_storage_perf.py $STORAGE $POOL >> "/stor2rrd/ELK/${STORAGE}/allpools.log"
 
# if difference file is not empty last created file is moved as initial file.
if [[ ! -z "${pool_dest_folder}/diff.log" ]];then
        cp "${pool_dest_folder}/1.log" "${pool_dest_folder}/1_old.log"
        cp "${pool_dest_folder}/0.log" "${pool_dest_folder}/0_old.log"
        mv "${pool_dest_folder}/1.log" "${pool_dest_folder}/0.log" -f
fi
