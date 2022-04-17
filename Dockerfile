FROM alpine:3.14 AS build 
RUN apk -U --no-cache add \
	git \
	build-base \
    avahi-dev \
	autoconf \
	automake \
	libtool \
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
&& cargo build --release --no-default-features --features 'with-dns-sd'
FROM alpine:3.14
RUN apk -U --no-cache add \
        libtool \
        libconfig-dev \
		dbus
COPY --from=build /root/target/release/spotifyd /usr/bin/spotifyd
COPY bootstrap.sh /start
RUN chmod +x /start
ENTRYPOINT [ "/start" ]