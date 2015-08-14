#!/bin/sh
echo "Starting run.sh"

set +x

sysctl -w kernel.shmall=4194304
sysctl -w kernel.shmmax=17179869184

echo "127.0.0.1 $(hostname)" >> /etc/hosts

/opt/opscode/embedded/bin/runsvdir-start &
/opt/opscode-manage/embedded/bin/runsvdir-start &

chef-server-ctl reconfigure
opscode-manage-ctl reconfigure

ADMIN=${ADMIN:-admin}
PASSWORD=${PASSWORD:-admin}
ORG=${ORG:-default}

if ! (chef-server-ctl user-list | grep -q $ADMIN) ; then
  chef-server-ctl user-create $ADMIN chef admin chef.admin@mynet.net $PASSWORD > /etc/chef/$ADMIN.pem
fi

if ! (chef-server-ctl org-list | grep -q $ORG) ; then
  chef-server-ctl  org-create $ORG $ORG -a $ADMIN > /etc/chef/$ORG-validator.pem
fi

echo "Starting chef_server_broker PEM and CRT file copy"
PEMFILE=/etc/chef/$ORG-validator.pem
CAPEMFILE=/etc/chef/$ADMIN.pem
CRTFILE=/var/opt/opscode/nginx/ca/${HOSTNAME}.crt
	
cp ${PEMFILE} /chef-setup/$ORG-validator.pem
cp ${CAPEMFILE} /chef-setup/$ADMIN.pem
cp ${CRTFILE} /chef-setup/${HOSTNAME}.crt

echo "run.sh complete"

tail $(find /var/log/opscode -type f -iname '*.log' | sed -e 's/^/\-f /g') $(find /var/log/opscode-manage -type f -iname '*.log' | sed -e 's/^/\-f /g') | awk '/^==> / {a=substr($0, 5, length-8); next} {print a":"$0}'             
