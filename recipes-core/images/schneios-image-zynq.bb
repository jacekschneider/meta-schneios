require petalinux-image-minimal.bb
require schneios-image.bb

IMAGE_INSTALL:append = " devmem2"