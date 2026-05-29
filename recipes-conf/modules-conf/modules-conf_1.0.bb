DESCRIPTION = "module configuration"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://extra-modules.conf \
    file://debug.conf \
"

FILES:${PN} += " \
    ${sysconfdir}/* \
"

do_install:append() {
    install -d ${D}${sysconfdir}/modules-load.d
    install -m 0644 ${WORKDIR}/extra-modules.conf ${D}${sysconfdir}/modules-load.d

    install -d ${D}${sysconfdir}/modprobe.d
    install -m 0644 ${WORKDIR}/debug.conf ${D}${sysconfdir}/modprobe.d
}
