
# Usage

1. First of all determine your pool names and RRD files. In your stor2rrd machine open your_stor2rrd_data_path/your_storage/pool.cfg
file. You will see something like this;
```
  0:pool_name1
  1:pool_name2
  2:pool_name3
  ...
```
2. Now you can create a simple script to use rrd_fetch.sh and collect any pool's data you want.
```
  rrd_fetch.sh 0 pool_name1 your_storage_name
  rrd_fetch.sh 2 pool_name2 your_storage_name
  ...
```

3. And put this script to crontab.

```
  * * * * * my_data_collector.sh
```

4. This will create *allpools.log* inside your ELK folder. Use filebeat or something to forward it to your logstash.
