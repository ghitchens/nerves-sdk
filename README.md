# Nerves SDK
[![Build Status](https://travis-ci.org/nerves-project/nerves-sdk.png?branch=master)](https://travis-ci.org/nerves-project/nerves-sdk)

Build the cross-compiler, various tools, and the base root filesystem
for creating embedded firmware images from Erlang/OTP releases. This
project uses [Buildroot](http://buildroot.net/) to do all of the hard
work. It just provides a configuration and a few helper scripts and
patches to customize Buildroot for Erlang/OTP embedded projects.

Currently, most development is being done on the BeagleBone Black, but
work is proceeding on embedded x86 platforms and the Raspberry Pi. Porting
to other platforms is easy especially if they're already support by Buildroot.
See the `configs` directory in the SDK for examples.

## First time build

Before building the SDK, it is important to have a few build tools
already installed. Buildroot provides a lot, but it does depend on
a few host programs. If using Ubuntu, run the following:

    sudo apt-get install git g++ libssl-dev libncurses5-dev bc

    # If your system is 64-bit, also run this
    sudo apt-get install libc6:i386 libstdc++6:i386 zlib1g:i386 gcc-multilib

Nerves downloads a large number of files to build the toolchain, Linux kernel,
Erlang, and other tools. It is recommended that you create a top level directory
to cache these files so that future builds can skip the download step. This step
is optional, so you may skip it:

    mkdir ~/.nerves-cache  # optional

Next, you will need to choose an initial platform and configuration for the SDK. Change
to the nerves-sdk directory and run `make help` for an up-to-date list of options.
Then run the following:

    make <platform>_defconfig

For example, if you're interested in a basic Raspberry Pi configuration, start
out with the `nerves_rpi_defconfig`.

To build, type:

    make

The first time build takes a long time since it has to download and
build lot of code. For the most part, you will not need to rebuild
the SDK unless you switch platforms or need to add libraries and applications
that cannot be pulled in by `rebar` or `erlang.mk`.

## Using the SDK

In order to use the cross-compiler and the version of Erlang built by
Buildroot, you'll need to source a shell script to update various
environment settings.

    source ./nerves-env.sh

This step has to be done each time you launch a shell. The key environment settings
updated by the script are the `PATH` variable and a set of variables that direct
`rebar` and other `Makefiles` to invoke the cross-compiler.

## Updating the SDK

If it turns out that you need another library or application on
your target that can't be pulled in with `rebar`, you'll need
to update the Buildroot configuration. Luckily, Buildroot comes
with recipes for cross-compiling tons of packages. To change the
configuration, first run the Buildroot configuration utility from
the nerves-sdk directory:

    make menuconfig

You'll probably be interested in the "Package Selection for the target"
menu option. After you're done, run `make` to rebuild the SDK. If you
want to save your set of options permanently, you'll need to copy
`buildroot/defconfig` to the `configs` directory.

Be aware that Buildroot caches the root filesystem between builds
and that when you unselect a configuration option, it will not
disappear from the Nerves SDK root file system image until a clean
build.

The [Buildroot documentation](http://buildroot.net/docs.html) is very helpful if
you're having trouble.

## Built-in SDK Configurations

Nerves comes with several configurations out of the box. These can be
used directly or just as an examples for your own custom configuration.

### nerves_bbb_defconfig

This is the default configuration for building images for the Beaglebone
Black. It is a minimal image intended for applications that do not require
a lot of hardware or C library support.

### nerves_rpi_defconfig

This is an initial configuration for building images for the Raspberry Pi.
It is a minimal image similar to the one built for the Beaglebone Black.

The Erlang or Elixir shell can run on either the HDMI port or over the UART
pins on the GPIO header. It's configured to run over the HDMI port, but if you'd
like it to run over the UART pins, edit
`board/raspberrypi/rootfs_additions/etc/erlinit.config` to force the controlling
terminal to be `ttyAMA0`.

If you use this one, please post to the mailing list as some work is needed
to bring the firmware update side of the project up to the robustness that
I can get on the Beaglebone. It appears to be limited by the Raspberry Pi's
bootloader, but someone with more knowledge of the board may be able to get
around this limitation.

### ag150_defconfig and alix_defconfig

These are 32-bit x86 platforms. The ag150 is Intel Atom-based and the Alix uses
an AMD Geode CPU. Both are minimal system configurations that use Syslinux
as the bootloader.

### nerves_camera_defconfig

This is the configuration that I'm using for my camera project. Normally
it wouldn't be a part of the Nerves SDK, but it may be useful to others as
an example. It requires a custom cape for the BeagleBone Black and uses the
AM3359's PRU for the hard real-time parts of the project. Erlang is used
for the rest.

### nerves_bbb_wifi_defconfig

This configuration is a work-in-progress to support wifi within the Nerves
environment. It is currently setup to support a Rosewill RNX-N150UBE (Realtek
rtl8712 driver). To test, try run the following programs (using `os:cmd/1`):

```
modprobe musb_dsps
ip link set wlan0 up
iwlist wlan0 scan
[use wpa_passphrase to generate a configuration for the wpa_supplicant]
wpa_supplicant -i wlan0 -c /tmp/wifi.conf
ip addr add 192.168.1.40/24 dev wlan0
```
### bbb_linux_defconfig

This configuration produces a Linux image. It is not useful for Erlang
development, but it can be helpful when getting unfamiliar hardware to work.
I use it to debug Linux kernel issues since most documentation and
developers expect a traditional shell-based environment.

