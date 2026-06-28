DESCRIPTION = "schneios update bundle"

inherit bundle

RAUC_BUNDLE_COMPATIBLE = "${MACHINE}"
RAUC_BUNDLE_VERSION = "v1"
RAUC_BUNDLE_DESCRIPTION = "RAUC ELTS Update Bundle"

RAUC_BUNDLE_FORMAT = "verity"

RAUC_BUNDLE_SLOTS = "rootfs"
RAUC_SLOT_rootfs = "schneios-image"
RAUC_SLOT_rootfs[fstype] = "ext4"

RAUC_KEY_FILE ?= "${THISDIR}/files/dev.key.pem"
RAUC_CERT_FILE ?= "${THISDIR}/files/dev.cert.pem"