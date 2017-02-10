# dit4c/dit4c-container-x11

[![](https://images.microbadger.com/badges/version/dit4c/dit4c-container-x11.svg)](https://microbadger.com/images/dit4c/dit4c-container-x11)

DIT4C container which provides X11 support via HTML5 VNC.

## seccomp compatibility

Unfortunately, Xorg in Debian is currently incompatible with the seccomp profiles used by Docker & rkt. This is because the Xorg server is compiled to uses libudev for device discovery. Annoyingly, libudev calls [uses `name_to_handle_at`](https://github.com/systemd/systemd/blob/master/src/libudev/libudev-monitor.c#L121) during normal operation, which is blacklisted for [security reasons](https://bugs.launchpad.net/ubuntu/+source/ubuntu-core-security/+bug/1448873/comments/1).

The long-term fix for this is a patched libudev or Xorg server compiled without libudev support. In the meantime, the syscall `name_to_handle_at` must be allowed.

### Docker

Disable seccomp, as the only other option is writing your own profile.

```
docker run --security-opt seccomp=unconfined -p 8080:8080 dit4c/dit4c-container-x11
```

### rkt

Generate & patch the ACI to allow the single call required, or disable seccomp entirely.

#### Patch the ACI

```
docker2aci docker://dit4c/dit4c-container-x11
sudo acbuild begin dit4c-dit4c-container-x11-latest.aci
echo '{ "set": ["@rkt/default-whitelist", "name_to_handle_at"] }' | \
  sudo /usr/local/bin/acbuild isolator add "os/linux/seccomp-retain-set" -
sudo acbuild write dit4c-dit4c-container-x11-latest-with-seccomp.aci
sudo acbuild end
```

Then run the image normally:

```
sudo rkt run --insecure-options image --port 8080-tcp:8080 ./dit4c-dit4c-container-x11-latest-with-seccomp.aci
```

#### Disable entirely

```
sudo rkt run --insecure-options image,seccomp --port 8080-tcp:8080 docker://dit4c/dit4c-container-x11
```
