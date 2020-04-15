STOR2RRD_PATH=/stor2rrd
STOR2RRD_DATA_PATH=$STOR2RRD_PATH/data
SW_NAME=$1
cat $STOR2RRD_DATA_PATH/$SW_NAME/pool.cfg | cut -d':' -f1,2 --output-delimiter=' ' > /tmp/pools.out

cat /tmp/pools.out  | while read line;do
        $STOR2RRD_PATH/ELK/rrdfetch.sh $line $SW_NAME
done

