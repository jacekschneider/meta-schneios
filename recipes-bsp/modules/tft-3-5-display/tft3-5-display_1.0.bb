DESCRIPTION = "tft35 display module"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/jacekschneider/display-spi-tft3-5.git;protocol=https;branch=drm-pipe"
SRCREV = "73c66be66cfcab5050b53f5a3d9d3eeb64b71bbb"

inherit module

KERNEL_MODULE_PROBECONF = "tft35_spi"

S = "${WORKDIR}/git"


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
