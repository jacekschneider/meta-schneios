FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://i2c.cfg \
file://inkernel_config.cfg \
file://lcd.cfg \
file://rauc.cfg \
file://debug.cfg \
"

SRC_URI += "file://custom-mcp23017-overlay.dts;subdir=git/arch/arm/boot/dts/overlays \
        "
SRC_URI += "file://custom-trigger-overlay.dts;subdir=git/arch/arm/boot/dts/overlays \
        "
RPI_KERNEL_DEVICETREE_OVERLAYS:append = " overlays/custom-mcp23017.dtbo"
RPI_KERNEL_DEVICETREE_OVERLAYS:append = " overlays/custom-trigger.dtbo"

# rauc integration includes rootfsA rootfsB
CMDLINE:remove = "root=/dev/mmcblk0p2"
