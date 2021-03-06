#!/usr/bin/env sh
/usr/sbin/crond
cd /etc/npme/node_modules/@npm/relational-registry-follower/node_modules/@npm/registry-relational-models/

node bootstrap.js
ret=$?
if [ $ret -ne 0 ]; then
  exit 1
fi

curl --fail -XGET http://$DOCKER_ADDR:5984/registry
ret=$?
if [ $ret -ne 0 ]; then
  exit 1
fi

npm run create-dev
cd /etc/npme/node_modules/@npm/relational-registry-follower/
ENVIRONMENT=development node ./bin/follow.js --sequence=/etc/npme/data/rr-sequence --db=http://$DOCKER_ADDR:5984/registry
