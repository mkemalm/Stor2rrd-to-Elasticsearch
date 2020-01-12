#!/usr/bin/env python

# this python script creates a readable data for elasticsearch, from differential files which are created by rrd_fetch.sh
from datetime import datetime
import sys
 
storage_name = sys.argv[1]
pool_name = sys.argv[2]
pool_dest_folder="/stor2rrd/ELK/" + storage_name + "/Pools/" + pool_name
dest_file=pool_dest_folder + "/diff.log"
 
with open(dest_file) as dfile:
        content = dfile.readlines()
content = [x.strip() for x in content]
for line in content:
        words = line.split()
        ts = int(words[0].split(':')[0])
        perf_time = datetime.utcfromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
        perf_read = int(float(words[1].replace(',','.')))
        perf_write = int(float(words[2].replace(',','.')))
        perf_readio = int(float(words[3].replace(',','.')))
        perf_writeio = int(float(words[4].replace(',','.')))
        perf_respread = int(float(words[5].replace(',','.')))
        perf_respwrite = int(float(words[6].replace(',','.')))
        print "Storage:" + storage_name+ ",Pool:" + pool_name + ",Read:" + str(perf_read) + ",Write:" + str(perf_write) + ",ReadIO:" + str(perf_readio) + ",WriteIO:" + str(perf_writeio) + ",ReadResp:" + str(perf_respread) + ",WriteResp:" + str(perf_respwrite) + ",Time:" + str(perf_time)
