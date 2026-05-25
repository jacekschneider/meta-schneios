FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://platform-top.h file://bsp.cfg"

do_configure:append() {
    install -d ${S}/include/configs
    install -m 0644 ${WORKDIR}/platform-top.h ${S}/include/configs/platform-top.h
}
CONFIG_DTFILE = "system.dtb"

# It shouldn't belong here, fix for speciality of xilinx-bootbin
PROVIDES += " boot-scr"
