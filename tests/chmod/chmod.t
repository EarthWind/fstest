#!/bin/sh

desc="start running ${0}.........."

dir=`dirname $0`
. ${dir}/../misc.sh

n0=`namegen`
n1=`namegen`
n2=`namegen`
expect 0 mkdir ${n2} 0755
cdir=`pwd`
cd ${n2}

# common test
# file
expect 0 create ${n0} 0644
expect 0644 stat ${n0} mode
expect 0 chmod ${n0} 0111
expect 0111 stat ${n0} mode
expect 0 unlink ${n0}
# directory
expect 0 mkdir ${n0} 0755
expect 0755 stat ${n0} mode
expect 0 chmod ${n0} 0753
expect 0753 stat ${n0} mode
expect 0 rmdir ${n0}
# fifo
expect 0 mkfifo ${n0} 0644
expect 0644 stat ${n0} mode
expect 0 chmod ${n0} 0310
expect 0310 stat ${n0} mode
expect 0 unlink ${n0}
# symlink
expect 0 create ${n0} 0644
expect 0 symlink ${n0} ${n1}
expect 0644 stat ${n1} mode
expect 0 chmod ${n1} 0321
expect 0321 stat ${n1} mode
expect 0321 lstat ${n0} mode
expect 0 unlink ${n0}
expect 0 unlink ${n1}

# successful chmod(2) updates ctime.
# file
expect 0 create ${n0} 0644
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect 0 chmod ${n0} 0111
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -lt $ctime2
expect 0 unlink ${n0}

# directory
expect 0 mkdir ${n0} 0755
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect 0 chmod ${n0} 0753
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -lt $ctime2
expect 0 rmdir ${n0}

# filfo
expect 0 mkfifo ${n0} 0644
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect 0 chmod ${n0} 0310
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -lt $ctime2
expect 0 unlink ${n0}

# symlink
expect 0 create ${n0} 0644
expect 0 symlink ${n0} ${n1}
ctime1=`{fstest} stat ${n1} ctime`
sleep 1
expect 0 chmod ${n1} 0321
ctime2=`{fstest} stat ${n1} ctime`
test_check $ctime1 -lt $ctime2
expect 0 unlink ${n1}
expect 0 unlink ${n0}

# unsuccessful chmod(2) does not update ctime.
expect 0 create ${n0} 0644
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect EPERM -u 65534 chmod ${n0} 0111
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -eq $ctime2
expect 0 unlink ${n0}

expect 0 mkdir ${n0} 0755
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect EPERM -u 65534 chmod ${n0} 0753
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -eq $ctime2
expect 0 rmdir ${n0}

expect 0 mkfifo ${n0} 0644
ctime1=`${fstest} stat ${n0} ctime`
sleep 1
expect EPERM -u 65534 chmod ${n0} 0310
ctime2=`${fstest} stat ${n0} ctime`
test_check $ctime1 -eq $ctime2
expect 0 unlink ${n0}

# POSIX: If the calling process does not have appropriate privileges, and if
# the group ID of the file does not match the effective group ID or one of the
# supplementary group IDs and if the file is a regular file, bit S_ISGID
# (set-group-ID on execution) in the file's mode shall be cleared upon
# successful return from chmod().
expect 0 create ${n0} 0755
expect 0 chown ${n0} 65535 65535
expect 0 -u 65535 -g 65535 chmod ${n0} 02755
expect 02755 stat ${n0} mode
expect 0 -u 65535 -g 65535 chmod ${n0} 0755
expect 0755 stat ${n0} mode

cd ${cdir}
expect 0 rmdir ${n2}
