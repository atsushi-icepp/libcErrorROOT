
# Container image that reproduces the error
### Dockerfile and Built image on DockerHub
The reported problem can be reproduced in the container image uploaded to [docker.io/atsushiicepp/askrootforum:2024Dec20_libc](https://hub.docker.com/layers/atsushiicepp/askrootforum/2024Dec20_libc/images/sha256-09ae15a6c9e74fc2cc79c28d8d03c19d4e517c2c794c09880351d10dbefe5011).
This image was built from [Dockerfile](Dockerfile).

### Build log
Below commands were executed on a directory where this repository was cloned.
```sh
$ podman build --format docker  -t libcerror . 2>&1 | tee build.log
$ podman push libcerror docker.io/atsushiicepp/askrootforum:2024Dec20_libc
```

### Environment for building: Container software and host machine 
- Container software
```sh
$ podman version
Client:       Podman Engine
Version:      5.3.1
API Version:  5.3.1
Go Version:   go1.23.3
Git Commit:   4cbdfde5d862dcdbe450c0f1d76ad75360f67a3c
Built:        Fri Nov 22 00:43:07 2024
OS/Arch:      linux/amd64

Server:       Podman Engine
Version:      5.3.1
API Version:  5.3.1
Go Version:   go1.22.7
Built:        Thu Nov 21 09:00:00 2024
OS/Arch:      linux/amd64
```

- Linux version of host OS
```sh
$ cat /proc/version
Linux version 5.14.0-427.35.1.el9_4.x86_64 (mockbuild@x64-builder01.almalinux.org) (gcc (GCC) 11.4.1 20231218 (Red Hat 11.4.1-3), GNU ld version 2.35.2-43.el9) #1 SMP PREEMPT_DYNAMIC Thu Sep 12 11:21:43 EDT 2024
```

- Distribution of host OS
```sh
$ cat /etc/*release
AlmaLinux release 9.4 (Seafoam Ocelot)
NAME="AlmaLinux"
VERSION="9.4 (Seafoam Ocelot)"
ID="almalinux"
ID_LIKE="rhel centos fedora"
VERSION_ID="9.4"
PLATFORM_ID="platform:el9"
PRETTY_NAME="AlmaLinux 9.4 (Seafoam Ocelot)"
ANSI_COLOR="0;34"
LOGO="fedora-logo-icon"
CPE_NAME="cpe:/o:almalinux:almalinux:9::baseos"
HOME_URL="https://almalinux.org/"
DOCUMENTATION_URL="https://wiki.almalinux.org/"
BUG_REPORT_URL="https://bugs.almalinux.org/"

ALMALINUX_MANTISBT_PROJECT="AlmaLinux-9"
ALMALINUX_MANTISBT_PROJECT_VERSION="9.4"
REDHAT_SUPPORT_PRODUCT="AlmaLinux"
REDHAT_SUPPORT_PRODUCT_VERSION="9.4"
SUPPORT_END=2032-06-01
AlmaLinux release 9.4 (Seafoam Ocelot)
AlmaLinux release 9.4 (Seafoam Ocelot)
```


