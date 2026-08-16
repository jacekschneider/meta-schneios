#specify BIF partition attributes required for BOOT.bin
BIF_FSBL_ATTR       = "fsbl"
BIF_BITSTREAM_ATTR  = "bitstream"
BIF_DEVICETREE_ATTR = "device-tree"
BIF_SSBL_ATTR       = "u-boot-xlnx"
BIF_SCR_ATTR        = "boot-scr"

BIF_PARTITION_ATTR  = "${BIF_FSBL_ATTR} ${BIF_BITSTREAM_ATTR} ${BIF_SSBL_ATTR} ${BIF_DEVICETREE_ATTR} ${BIF_SCR_ATTR}"

# FSBL
BIF_PARTITION_ATTR[fsbl] = "bootloader"
BIF_PARTITION_IMAGE[fsbl] = "${RECIPE_SYSROOT}/boot/fsbl.elf"

# BITSTREAM
BIF_PARTITION_IMAGE[bitstream] = "${BITSTREAM_PATH}"

# U-BOOT
BIF_PARTITION_IMAGE[u-boot-xlnx] = "${RECIPE_SYSROOT}/boot/u-boot.elf"

# DTB
BIF_PARTITION_ATTR[device-tree] = "load=0x00100000"
BIF_PARTITION_IMAGE[device-tree] = "${RECIPE_SYSROOT}/boot/devicetree/system.dtb"

# BOOT.SCR (from image deploy)
BIF_PARTITION_ATTR[boot-scr] = "offset=0x00B20000"
BIF_PARTITION_IMAGE[boot-scr] = "${DEPLOY_DIR_IMAGE}/boot.scr"

