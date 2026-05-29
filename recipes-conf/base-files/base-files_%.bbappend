do_install:append() {
    rm -f ${D}${sysconfdir}/motd
}

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add a mount point for a shared data partition
dirs755 += "/data"
