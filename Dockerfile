FROM alpine:3.21.6 AS build
ARG CARGO_NET_GIT_FETCH_WITH_CLI=true
RUN apk -U --no-cache add \
	git \
	build-base \
    avahi-dev \
	autoconf \
	automake \
	libtool \
	alsa-lib-dev \
	openssl-dev \
	libconfig-dev \
	libstdc++ \
	gcc \
	rust \
	cargo 

RUN cd /root \ 
&& git clone https://github.com/Spotifyd/spotifyd . \
&& git checkout tags/v0.4.2 \
&& cargo build --release
FROM alpine:3.21.6
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