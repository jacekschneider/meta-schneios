DESCRIPTION = "mcp gpio i2c expander module"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/jacekschneider/mcp23017.git;protocol=https;branch=main"
SRCREV = "${AUTOREV}"

inherit module

KERNEL_MODULE_PROBECONF = "pinctrl-mcp23017_i2c"

S = "${UNPACKDIR}/${PN}-${PV}"


do_configure() {
    oe_runmake -C ${STAGING_KERNEL_DIR} M=${S} clean || true
}

do_compile() {
    oe_runmake -C ${STAGING_KERNEL_DIR} M=${S} modules
}

do_install() {
    install -d ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra
    install -m 0644 ${S}/pinctrl-mcp23017_i2c.ko ${D}${base_libdir}/modules/${KERNEL_VERSION}/extra
}
