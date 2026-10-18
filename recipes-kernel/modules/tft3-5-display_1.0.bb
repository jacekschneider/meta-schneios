DESCRIPTION = "tft35 display module"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/jacekschneider/display-spi-tft3-5.git;protocol=https;branch=main"
SRCREV = "aaf6dfef4f882052775e5aaa1487a9321928dd9c"

inherit module 

KERNEL_MODULE_PROBECONF = "tft35_spi"

# inherit externalsrc
# EXTERNALSRC = "${THISDIR}/display-spi-tft3-5"
# EXTERNALSRC_BUILD = "${WORKDIR}/build"
# S = "${EXTERNALSRC}"
# B = "${EXTERNALSRC_BUILD}"

S = "${UNPACKDIR}/${PN}-${PV}"



do_configure() {
    oe_runmake -C ${STAGING_KERNEL_DIR} M=${S} clean || true
}

do_compile() {
    oe_runmake -C ${STAGING_KERNEL_DIR} M=${S} modules
}

do_install() {
    install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra
    install -m 0644 ${S}/tft35_spi.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra
}
