FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
file://i2c.cfg \
file://inkernel_config.cfg \
file://lcd.cfg \
file://rauc.cfg \
file://debug.cfg \
"

# rauc integration includes rootfsA rootfsB
CMDLINE:remove = "root=/dev/mmcblk0p2"
