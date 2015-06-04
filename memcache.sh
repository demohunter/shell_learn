#!/bin/bash
# ---------------------------------------------------------------------------
# 
# Filename:memcache.sh
# Revision:0.1
# Description:获取Memcached 里所有 KEY的列表
# Author:biaoge
# Todo:验证IP地址 验证端口是否可用
#
# ---------------------------------------------------------------------------

>/tmp/$$ 

if [ $# -lt 2 ];then
	echo "Usage: memcache.sh localhost 10001 10002"
	exit 0
fi

#ip地址
IP=$1

#丢弃第一个参数
shift 1

#所有端口号
PORTS=$*

for port in $PORTS;
do
	echo stats items \
	|nc $IP $port|grep 'STAT items'|awk -F':' '{print $1" "$2}'\
	|sort -r|uniq -c -i\
	|awk '{print "echo stats cachedump " $4 " 0" "|nc '`echo $IP`' '`echo $port`' "}' >>/tmp/$$
done

while read line
do
	eval $line |grep "ITEM"|awk '{print $2}'
done< <(cat /tmp/$$)

rm /tmp/$$
exit 0