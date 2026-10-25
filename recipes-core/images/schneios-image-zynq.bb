require petalinux-image-minimal.bb
require schneios-image.bb

# memory access 
IMAGE_INSTALL:append = " devmem2"

# peripheral libs
IMAGE_INSTALL:append = " libgpiod libgpiod-tools libcamera"