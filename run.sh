#!/bin/bash
make build

XAUTH=/tmp/.docker.xauth
touch ${XAUTH} 
xauth nlist ${DISPLAY} | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -

docker run -it --rm \
   --privileged \
   --env="DISPLAY=$DISPLAY" \
   --env="QT_X11_NO_MITSHM=1" \
   --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
   --env="XAUTHORITY=$XAUTH" \
   --volume="$XAUTH:$XAUTH" \
   --runtime=nvidia \
   -e HOME=${HOME} \
   -v "${HOME}:${HOME}/" \
   -v /etc/group:/etc/group:ro \
   -v /etc/localtime:/etc/localtime \
   -v /etc/passwd:/etc/passwd:ro \
   --security-opt seccomp=unconfined \
   -u $(id -u ${USER} ):$(id -g ${USER}) \
   --net=host \
   --privileged \
   rtabmap3d
