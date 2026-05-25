FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://i2c.cfg \
file://inkernel_config.cfg \
file://lcd.cfg \
file://rauc.cfg \
"

SRC_URI += "file://custom-mcp23017-overlay.dts;subdir=git/arch/arm/boot/dts/overlays \
        "
RPI_KERNEL_DEVICETREE_OVERLAYS:append = " overlays/custom-mcp23017.dtbo"

# rauc integration includes rootfsA rootfsB
CMDLINE:remove = "root=/dev/mmcblk0p2"
