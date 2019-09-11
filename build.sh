#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    echo "Usage: $0 [x86_64|armv7l|aarch64|amazonlinux] <greengrass-core-version>"
fi

arch=${1}
version=${2}
image="alpine/greengrass:${version}-${arch}"

# install latest docker-compose
which docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
/usr/bin/docker-compose --version

case ${arch} in
  amazonlinux )
    COMPOSE="docker-compose.yml"
    image="amazonlinux/greengrass:${version}"
    ;;
  x86_64 )
    COMPOSE="docker-compose.alpine-x86_64.yml"
    ;;
  armv7l )
    COMPOSE="docker-compose.alpine-armv7l.yml"
    ;;
  aarch64 )
    COMPOSE="docker-compose.alpine-aarch64.yml"
    ;;
  * )
    echo "Wrong arch, exit .."
    exit 1
    ;;
esac

# build image
/usr/bin/docker-compose -f ${COMPOSE} build --build-arg VERSION=${version}

# test image
docker run ${image} uname -m 

# push image
if [ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
  docker push ${image}
fi
