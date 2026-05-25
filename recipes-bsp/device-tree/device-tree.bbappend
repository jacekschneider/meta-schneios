FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://system-user.dtsi \
    file://system.dtb \
    "

require ${@'device-tree-sdt.inc' if d.getVar('SYSTEM_DTFILE') != '' else ''}
CONFIG_DTFILE = "system.dtb"
DT_INCLUDE:append = " ${WORKDIR}"

