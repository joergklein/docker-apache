# Docker base image for the Apache webserver

The Apache webserver in a Docker container.

## The Dockerfile

```sh
FROM centos:8

LABEL maintainer="Joerg Klein <kwp.klein@gmail.com>" \
      description="Docker base for the Apache webserver"

RUN dnf update -y  \
    && dnf install -y httpd \
    && dnf clean all; systemctl enable httpd.service

EXPOSE 80
```

### Build the image

```sh
docker build -t my-centos:8 .
```

### Start the service inside the Docker container

`Systemd cannot run without SYS_ADMIN`. That's why I set the following vars. The
simplest way is to use the `run script`.

```sh
#!/bin/sh

docker run -it -p 80:80 \
           -e "container=docker" --privileged=true \
           -d --security-opt seccomp:unconfined --cap-add=SYS_ADMIN \
           -v /sys/fs/cgroup:/sys/fs/cgroup:ro apache bash -c "/usr/sbin/init"
```

### Verify the container is running

```sh
$ docker ps

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
dbb57b79eb14        apache              "bash -c /usr/sbin/i…"   10 seconds ago      Up 8 seconds        0.0.0.0:80->80/tcp   adoring_davinci
```

### Verifiy if the httpd is started

```sh
$ docker exec -it adoring_davinci /bin/bash -c "systemctl status httpd"

● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2020-11-09 10:53:32 UTC; 1min 19s ago
     Docs: man:httpd.service(8)
 Main PID: 57 (httpd)
   Status: "Total requests: 6; Idle/Busy workers 100/0;Requests/sec: 0.0759; Bytes served/sec: 4.0KB/sec"
    Tasks: 213 (limit: 22089)
   Memory: 33.7M
   CGroup: /docker/3a78574a5230bb4da956351988348d443ad9ce4ebf6cf821d176c785f7348b55/system.slice/httpd.service
           ├─57 /usr/sbin/httpd -DFOREGROUND
           ├─75 /usr/sbin/httpd -DFOREGROUND
           ├─78 /usr/sbin/httpd -DFOREGROUND
           ├─79 /usr/sbin/httpd -DFOREGROUND
           └─83 /usr/sbin/httpd -DFOREGROUND

Nov 09 10:53:32 3a78574a5230 systemd[1]: Starting The Apache HTTP Server...
Nov 09 10:53:32 3a78574a5230 systemd[1]: Started The Apache HTTP Server.
Nov 09 10:53:32 3a78574a5230 httpd[57]: Server configured, listening on: port 80
```

### Start the Apache Web server

Start the browser and visit: `localhost:80`

