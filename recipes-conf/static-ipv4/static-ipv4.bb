SUMMARY = "Add static ip to systemd configuration"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://10_eth0.network \
"

RDEPENDS:${PN} += "systemd"


FILES:${PN} += " \
    ${sysconfdir}/systemd/network/10_eth0.network \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${UNPACKDIR}/10_eth0.network ${D}${sysconfdir}/systemd/network
}
