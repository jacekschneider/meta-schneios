DESCRIPTION = "Message of the day recipe"
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://motd"

S = "${UNPACKDIR}"

do_patch() {
    MOTD_FILE="${UNPACKDIR}/motd"

    {
        echo ""
        echo "-----------------------------------------"
        echo " Build Information"
        echo "-----------------------------------------"
        echo "Build Date:       ${DATE}"
        echo "Machine:          ${MACHINE}"
        echo "Distro:           ${DISTRO_NAME} ${DISTRO_VERSION}"
        echo "Kernel Version:   ${KERNEL_VERSION}"
        echo "U-Boot Version:   ${UBOOT_VERSION}"
        echo "-----------------------------------------"
    } >> "${MOTD_FILE}"
}
do_install() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${S}/motd ${D}${sysconfdir}/motd
}

FILES_${PN} = "${sysconfdir}/motd"