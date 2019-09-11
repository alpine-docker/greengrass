#!/usr/bin/env sh

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    echo "Usage: $0 [x86_64|armv7l|aarch64|amazonlinux] <greengrass-core-version>"
fi

arch=${1}
version=${2}
image="alpine/greengrass:${version}-${arch}"

case ${arch} in
  amazonlinux )
    COMPOSE="docker-compose.yml"
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
docker-compose -f ${COMPOSE} build --build-arg VERSION=${version}

# test image
docker run ${image} uname -m 

# push image
if [ "$TRAVIS_BRANCH" == "master" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  docker login -u="$DOCKER_USER" -p="$DOCKER_PASS"
  echo docker push ${image}
fi
