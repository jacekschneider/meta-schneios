inherit core-image
require schneios-image.bb

IMAGE_INSTALL = "\
    packagegroup-core-boot \
    packagegroup-core-full-cmdline \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    "

## Device Tree
IMAGE_INSTALL:append = " custom-overlays"

# rauc
IMAGE_INSTALL:append = " rauc"

# graphics stack test
IMAGE_INSTALL:append = " libdrm-tests"
IMAGE_INSTALL:append = " kmscube"

CORE_IMAGE_EXTRA_INSTALL += "wayland weston"

# kernel
## Store the kernel/modules/devicetree/source in the rootfs partition
IMAGE_INSTALL:append = " kernel-devsrc kernel-image kernel-modules kernel-devicetree"
# out of tree kernel modules
IMAGE_INSTALL:append = " lcd-show"
#IMAGE_INSTALL:append = " mcpioexpander"
#IMAGE_INSTALL:append = " kernel-module-gpio-interrupt"
IMAGE_INSTALL:append = " tft3-5-display"

# peripheral libs
IMAGE_INSTALL:append = " libgpiod libgpiod-tools libcamera"