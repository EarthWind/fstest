#!/bin/sh

desc="start running ${0}.........."
echo $desc

dir=`dirname $0`
. ${dir}/../misc.sh

n0=`namegen`
n1=`namegen`
n2=`namegen`
n3=`namegen`
n4=`namegen`

expect 0 mkdir ${n0} 0755
cdir=`pwd`
cd ${n0}

expect 0 mkdir ${n1} 0755
expect 0 chown ${n1} 65534 65534
expect 0 mkdir ${n2} 0755
expect 0 chown ${n2} 65534 65534
expect 0 -u 65534 -g 65534 create ${n1}/${n3} 0644

expect 0 -u 65534 -g 65534 link ${n1}/${n3} ${n2}/${n4}
expect 0 -u 65534 -g 65534 unlink ${n2}/${n4}

expect 0 chmod ${n1} 0644
expect EACCES -u 65534 -g 65534 link ${n1}/${n3} ${n1}/${n4}
expect EACCES -u 65534 -g 65534 link ${n1}/${n3} ${n2}/${n4}

expect 0 chmod ${n1} 0755
expect 0 chmod ${n2} 0644
expect EACCES -u 65534 -g 65534 link ${n1}/${n3} ${n2}/${n4}

expect 0 unlink ${n1}/${n3}
expect 0 rmdir ${n1}
expect 0 rmdir ${n2}

cd ${cdir}
expect 0 rmdir ${n0}
