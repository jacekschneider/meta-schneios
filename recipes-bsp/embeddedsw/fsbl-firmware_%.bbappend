FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SKIP_MSG:zynq = ""

#mki: this override only works if meta-user layer has higher priority than meta-xilinx-tools
SRC_URI += " file://lib/sw_apps/zynqmp_fsbl/src;subdir=${S} \
             file://lib/sw_apps/zynq_fsbl/src;subdir=${S}"

do_compile:prepend() {
    BSP="${S}/lib/sw_apps/zynq_fsbl/misc/ps7_cortexa9_0"
    SA="${S}/lib/bsp/standalone/src"
    FSBL_MISC="${S}/lib/sw_apps/zynq_fsbl/misc"

    install -d "${BSP}/libsrc/standalone/src"

    # Generic standalone implementation
    cp -f "${SA}/common/"*.c \
          "${BSP}/libsrc/standalone/src/"
    cp -f "${SA}/common/"*.h \
          "${BSP}/libsrc/standalone/src/"

    # ARM common implementation
    cp -f "${SA}/arm/common/"*.c \
          "${BSP}/libsrc/standalone/src/"
    cp -f "${SA}/arm/common/"*.h \
          "${BSP}/libsrc/standalone/src/"

    # Cortex-A9 implementation
    cp -f "${SA}/arm/cortexa9/"*.c \
          "${BSP}/libsrc/standalone/src/"
    cp -f "${SA}/arm/cortexa9/"*.h \
          "${BSP}/libsrc/standalone/src/"

    # GCC-specific ARM files
    cp -f "${SA}/arm/common/gcc/"* \
          "${BSP}/libsrc/standalone/src/"

    cp -f "${SA}/arm/cortexa9/gcc/"* \
          "${BSP}/libsrc/standalone/src/"

    # Profiling part used by standalone Makefile
    cp -rf "${SA}/profile" \
           "${BSP}/libsrc/standalone/src/"

    # Configuration required by standalone Makefile
    cp -f "${FSBL_MISC}/config.make" \
          "${BSP}/libsrc/standalone/src/"

    # Board-specific console implementation
    cp -f "${FSBL_MISC}/zc702/inbyte.c" \
          "${FSBL_MISC}/zc702/outbyte.c" \
          "${BSP}/libsrc/standalone/src/"
}