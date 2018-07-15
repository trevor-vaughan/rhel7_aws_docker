#!/bin/sh

if [ ! `curl -m 2 -s http://169.254.169.254/latest/meta-data/placement/availability-zone` ]; then
  echo 'You must be on AWS to use this software'
  exit 1
fi

cd assets
sudo ./env_prep.sh
cd -

DOCKER_REGISTRY='registry.access.redhat.com'

docker build . -t 'rhel7:dev'

docker run -it 'rhel7:dev' su - build_user -c /bin/bash
