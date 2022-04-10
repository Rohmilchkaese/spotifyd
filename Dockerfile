FROM alpine:3.15.4 AS build 
RUN apk -U --no-cache add \
	git \
	build-base \
	autoconf \
	automake \
	libtool \
	alsa-lib-dev \
	libdaemon-dev \
	libressl-dev \
	libconfig-dev \
	libstdc++ \
	gcc \
	rust \
	cargo 

RUN cd /root \ 
&& git clone https://github.com/Spotifyd/spotifyd .\
&& git checkout tags/v0.3.3 \
&& cargo build --release
FROM alpine:edge
RUN apk -U --no-cache add \
        libtool \
        alsa-lib-dev \
        libconfig-dev 
COPY --from=build /root/target/release/spotifyd /usr/bin/spotifyd
COPY bootstrap.sh /start
RUN chmod +x /start
ENTRYPOINT [ "/start" ]	
