SUMMARY = "Install configuration files for TFT35 display"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/goodtft/LCD-show.git;protocol=https;branch=master"

SRCREV = "${AUTOREV}"

inherit deploy

do_install() {

    install -d ${D}/boot/overlays
    install -m 0644 ${S}/usr/tft35a-overlay.dtb ${D}/boot/overlays/tft35a.dtbo
    install -m 0644 ${S}/usr/cmdline.txt ${D}/boot/cmdline.txt
}

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0664 ${S}/usr/tft35a-overlay.dtb ${DEPLOYDIR}/tft35a.dtbo
}

addtask deploy after do_install

FILES:${PN} = " \
    /boot/overlays/tft35a.dtbo \
    /boot/cmdline.txt \
    /etc/X11/xorg.conf.d \
    /usr/share/X11 \
    /usr/share/X11/xorg.conf.d \
"

INSANE_SKIP_${PN} += "installed-vs-shipped"

