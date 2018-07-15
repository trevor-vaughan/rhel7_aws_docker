#!/bin/sh

EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed 's/[a-z]$//'`"
TMPDIR=tmp

if [ -d $TMPDIR ]; then
  rm -rf $TMPDIR
fi

mkdir $TMPDIR

cp -r --parents /etc/pki/rhui $TMPDIR
cp -r --parents /etc/pki/rpm-gpg $TMPDIR
cp -r --parents /etc/yum $TMPDIR
cp -r --parents /etc/yum.conf $TMPDIR
cp -r --parents /etc/yum.repos.d $TMPDIR
cp -r --parents /usr/lib/yum-plugins $TMPDIR

# You might need to do this if using an old version of the RHEL base image
#cp -r --parents /usr/lib/python* $TMPDIR

chown -R `logname` $TMPDIR

cd $TMPDIR/etc/yum.repos.d

sed -i "s/REGION/${EC2_REGION}/g" *
cd -
