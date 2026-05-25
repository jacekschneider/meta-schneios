SUMMARY = "A console-only image with more full-featured Linux system \
functionality installed."

IMAGE_FEATURES += "splash ssh-server-openssh package-management"

IMAGE_INSTALL = "\
    packagegroup-core-boot \
    packagegroup-core-full-cmdline \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    "

inherit core-image

# application
IMAGE_INSTALL:append = " nano"

# debugging
IMAGE_INSTALL:append = " i2c-tools"
IMAGE_INSTALL:append = " spidev-test"
IMAGE_INSTALL:append = " gdbserver"
IMAGE_INSTALL:append = " dtc"

# networking
IMAGE_INSTALL:append = " tcpdump iputils"

# kernel
IMAGE_INSTALL:append = " kernel-devsrc"
## Store the kernel in the rootfs partition
IMAGE_INSTALL:append = " kernel-image kernel-modules kernel-devicetree"
IMAGE_INSTALL:append = " mcpioexpander"
IMAGE_INSTALL:append = " kernel-module-gpio-interrupt"

# lib
IMAGE_INSTALL:append = " libgpiod libgpiod-tools libiio libcamera"

# system config
IMAGE_INSTALL:append = " motd"
IMAGE_INSTALL:append = " modules-conf"
IMAGE_INSTALL:append = " os-release"
IMAGE_INSTALL:append = " lcd-show"

# rauc
IMAGE_INSTALL:append = " rauc"
