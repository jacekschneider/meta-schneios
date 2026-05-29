DESCRIPTION = "Message of the day recipe"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://motd"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${S}/motd ${D}${sysconfdir}/motd
}

FILES_${PN} = "${sysconfdir}/motd"