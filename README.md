# spotifyd
spotifyd docker image - based on Alpine Linux

Link to [Docker Hub](https://hub.docker.com/r/rohmilkaese/spotifyd)

[Spotifyd](https://github.com/Spotifyd/spotifyd) streams music just like the official client, but is more lightweight and supports more platforms. Spotifyd also supports the Spotify Connect protocol, which makes it show up as a device that can be controlled from the official clients.

I build this Docker image because there was no Spotifyd Image running on Alpine Linux. As far as I can tell, this is the only one running on Alpine, which also makes it the smallest one. Counting in at ~ 22 mb installed and ~ 8 mb compressed to dowload form Docker Hub.

## Docker Run

Command:

```bash
sudo docker run -d \
-v $PWD:/conf/ \
--net host \
--device /dev/snd \
--name shairport-sync \
rohmilkaese/shairport-sync \
-vu -c /conf/shairport.conf
```
Place a valid shairport.conf file in directory you run the docker run command.

## Docker Compose

docker-compose.yaml
```bash
version: "2.2"
services:
   shairport-sync:
    container_name: shairport-sync
    image: rohmilkaese/shairport-sync:latest
    volumes:
       - ./conf/shairport.conf:/conf/shairport.conf
    devices:
       - /dev/snd
    command: -vu -c conf/shairport.conf
    network_mode: "host"
```
Place a valid shairport.conf file in /conf directory.
