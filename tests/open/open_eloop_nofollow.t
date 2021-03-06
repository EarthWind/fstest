#!/bin/sh

desc="start running ${0}.........."

dir=`dirname $0`
. ${dir}/../misc.sh

n0=`namegen`
n1=`namegen`

expect 0 symlink ${n0} ${n1}
expect ELOOP open ${n1} O_RDONLY,O_CREAT,O_NOFOLLOW 0644
expect ELOOP open ${n1} O_RDONLY,O_NOFOLLOW
expect ELOOP open ${n1} O_WRONLY,O_NOFOLLOW
expect ELOOP open ${n1} O_RDWR,O_NOFOLLOW

expect 0 unlink ${n1}
