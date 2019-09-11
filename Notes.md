### reference: 

https://docs.aws.amazon.com/greengrass/latest/developerguide/what-is-gg.html#gg-docker-download

### base images: 

https://hub.docker.com/u/balenalib

https://www.balena.io/docs/reference/base-images/base-images/

### device types: 

https://www.balena.io/docs/reference/base-images/devicetypes/

### Usage

- `alpine-x86_64`:  [alpine/greengrass:tagname](https://cloud.docker.com/u/alpine/repository/docker/alpine/greengrass)

you can run directly 

```
$ docker run -ti --rm alpine/greengrass:1.9.2-x86_64 sh
/ # uname -m 
x86_64
/ # 
```

- `alpine-armv7hf`:  [alpine/greengrass:tagname](https://cloud.docker.com/u/alpine/repository/docker/alpine/greengrass)

you need register QEMU first (https://blog.hypriot.com/post/setup-simple-ci-pipeline-for-arm-images/)

```
$ docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

then you are free to run it

```
$ docker run -ti --rm alpine/greengrass:1.9.2-armv7hf bash
bash-4.4# uname -m 
armv7l
bash-4.4# 
```

- `alpine-aarch64`:  [alpine/greengrass:tagname](https://cloud.docker.com/u/alpine/repository/docker/alpine/greengrass)

you need register QEMU first (https://blog.hypriot.com/post/setup-simple-ci-pipeline-for-arm-images/)

```
$ docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

then you are free to run it

```
$ docker run -ti --rm alpine/greengrass:1.9.2-aarch64 bash
bash-4.4# uname -m
aarch64
bash-4.4# 
```

- `amazonlinux`:  [amazonlinux/greengrass:tagname](https://cloud.docker.com/u/amazonlinux/repository/docker/amazonlinux/greengrass)

you can run directly

```
$ docker run -ti --rm amazonlinux/greengrass:1.9.2 bash 
bash-4.2# uname -m
x86_64
```
