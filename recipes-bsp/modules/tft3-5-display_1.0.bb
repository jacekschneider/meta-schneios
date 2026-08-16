DESCRIPTION = "tft35 display module"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/jacekschneider/display-spi-tft3-5.git;protocol=https;branch=main"
SRCREV = "afe1a16fe9d4e973e66124c5b46130042308d560"

inherit module

KERNEL_MODULE_PROBECONF = "tft35_spi"

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
