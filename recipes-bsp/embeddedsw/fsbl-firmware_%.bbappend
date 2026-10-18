FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SKIP_MSG:zynq = ""

SRC_URI += " \
    file://lib/sw_apps/zynq_fsbl/src;subdir=${S} \
    file://lib/sw_apps/zynq_fsbl/misc;subdir=${S} \
    file://lib/sw_apps/zynq_fsbl/data;subdir=${S} \
"

do_patch:append() {
    import os
    import shutil

    misc = os.path.join(
        d.getVar("S"),
        "lib/sw_apps/zynq_fsbl/misc"
    )

    src = os.path.join(misc, "copy_bsp-schneios.sh")
    dst = os.path.join(misc, "copy_bsp.sh")

    if not os.path.isfile(src):
        bb.fatal("Modified copy_bsp1.sh not found")

    shutil.copy2(src, dst)
    os.chmod(dst, 0o755)
}

do_configure:append() {
    FSBL_MAKEFILE="${S}/lib/sw_apps/zynq_fsbl/src/Makefile"

    sed -i '/^%.o:%.S$/,/^%.o:%.s$/ {
        s/$(AS) $(CC_FLAGS) $(CFLAGS) $(ECFLAGS)/$(AS) -mcpu=cortex-a9/
    }' "${FSBL_MAKEFILE}"
}

