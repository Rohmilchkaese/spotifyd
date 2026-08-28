FROM alpine:3.24.1 AS build
ARG SPOTIFYD_VERSION=0.4.2
RUN apk -U --no-cache add \
	git \
	build-base \
	alsa-lib-dev \
	avahi-dev \
	dbus-dev \
	openssl-dev \
	pulseaudio-dev \
	curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUSTFLAGS="-C target-feature=-crt-static"

RUN git clone https://github.com/Spotifyd/spotifyd /build \
&& cd /build \
&& git checkout tags/v${SPOTIFYD_VERSION} \
&& cargo build --release

FROM alpine:3.24.1
RUN apk -U --no-cache add \
	alsa-lib \
	avahi \
	dbus \
	libgcc \
	libpulse
COPY --from=build /build/target/release/spotifyd /usr/bin/spotifyd
COPY --chmod=+x bootstrap.sh /start
ENTRYPOINT [ "/start" ]