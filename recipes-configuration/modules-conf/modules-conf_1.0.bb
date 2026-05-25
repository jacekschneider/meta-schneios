DESCRIPTION = "module configuration"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://extra-modules.conf \
"

FILES:${PN} += " \
    ${sysconfdir}/modules-load.d/extra-modules.conf \
"

do_install:append() {
    install -d ${D}${sysconfdir}/modules-load.d
    install -m 0644 ${WORKDIR}/extra-modules.conf ${D}${sysconfdir}/modules-load.d
}
