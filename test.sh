#!/usr/bin/bash
CONTAINER_NAME="test-cont"

docker run --detach --privileged --volume /sys/fs/cgroup/:/sys/fs/cgroup:ro --name $CONTAINER_NAME local/$CONTAINER_NAME

sleep 1
if [[ ! $(docker exec $CONTAINER_NAME /usr/bin/ps -aux) == *"dbus"* ]]; then
	echo "ERROR: DBUS NOT INSTALLED"
	exit 1
fi

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
