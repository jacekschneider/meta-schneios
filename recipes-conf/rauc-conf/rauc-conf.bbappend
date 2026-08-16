FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RAUC_KEYRING_FILE ??= "keyring.pem"
RAUC_KEYRING_URI ??= "file://${RAUC_KEYRING_FILE}"
SRC_URI:append := " ${RAUC_KEYRING_URI} "

do_install:prepend() {
	sed -i "s/@@MACHINE@@/${MACHINE}/g" ${S}/system.conf
}

do_install:append() {
	install -d ${D}${sysconfdir}/rauc
	install -m 0644 ${UNPACKDIR}/${RAUC_KEYRING_FILE} ${D}${sysconfdir}/rauc/
}