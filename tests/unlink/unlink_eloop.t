#!/bin/sh

desc="unlink returns ELOOP if too many symbolic links were encountered in translating the pathname"

dir=`dirname $0`
. ${dir}/../misc.sh

n0=`namegen`
n1=`namegen`

expect 0 symlink ${n0} ${n1}
expect 0 symlink ${n1} ${n0}
expect ELOOP unlink ${n0}/test
expect ELOOP unlink ${n1}/test
expect 0 unlink ${n0}
expect 0 unlink ${n1}
