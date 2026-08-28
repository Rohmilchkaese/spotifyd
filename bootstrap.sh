#!/bin/sh
# spotifyd (>=0.4) uses librespot's built-in pure-Rust mDNS (libmdns) for Spotify
# Connect discovery, so it needs neither Avahi nor a system D-Bus. Starting those
# here was dead weight and reproduced a crash-loop (avahi racing an unready bus,
# plus a stale /run/dbus/dbus.pid blocking a restart). exec so signals reach
# spotifyd directly for a clean `docker stop`.
exec /usr/bin/spotifyd --config-path /etc/spotifyd.conf --no-daemon
