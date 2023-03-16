FROM alpine:3.17.2 AS build
ARG CARGO_NET_GIT_FETCH_WITH_CLI=true
RUN apk -U --no-cache add \
	git \
	build-base \
    avahi-dev \
	autoconf \
	automake \
	libtool \
	libdaemon-dev \
	alsa-lib-dev \
	libressl-dev \
	libconfig-dev \
	libstdc++ \
	gcc \
	rust \
	cargo 

RUN cd /root \ 
&& git clone https://github.com/Spotifyd/spotifyd . \
&& git checkout tags/v0.3.4 \
&& cargo build --release
FROM alpine:3.17.2
RUN apk -U --no-cache add \
        libtool \
        libconfig-dev \
		alsa-lib \
		avahi \
		dbus
COPY --from=build /root/target/release/spotifyd /usr/bin/spotifyd
COPY bootstrap.sh /start
RUN chmod +x /start
ENTRYPOINT [ "/start" ]