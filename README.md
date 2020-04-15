
# Usage

1. Replace /stor2rrd path in scripts with your stor2rrd installation folder.

3. And put this script to crontab.

```
  * * * * * collect_data.sh
```

4. This will create *allpools.log* inside your stor2rrd_install_path/ELK folder. Use filebeat or something to forward it to your logstash.
