#!/bin/sh

desc="start running ${0}.........."
echo $desc

dir=`dirname $0`
. ${dir}/../misc.sh
n0=`namegen`
n1=`namegen`

expect 0 mkdir ${n0} 0755
expect ENOENT chown ${n0}/${n1}/test 65534 65534
expect ENOENT chown ${n0}/${n1} 65534 65534
expect 0 rmdir ${n0}
