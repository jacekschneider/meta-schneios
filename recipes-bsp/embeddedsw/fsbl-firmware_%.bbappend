FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SKIP_MSG:zynq = ""

SRC_URI += " \
    file://lib/sw_apps/zynqmp_fsbl/src;subdir=${S} \
    file://lib/sw_apps/zynq_fsbl/src;subdir=${S} \
"

AS:pn-fsbl-firmware = "${CC}"
LINKER:pn-fsbl-firmware = "${CC}"

do_compile:prepend:zynq() {
    BSP="${S}/lib/sw_apps/zynq_fsbl/misc/ps7_cortexa9_0"
    SA="${S}/lib/bsp/standalone/src"
    FSBL_MISC="${S}/lib/sw_apps/zynq_fsbl/misc"
    DRIVERS="${FSBL_MISC}/zc702/drivers.txt"

    rm -rf "${BSP}"

    install -d \
        "${BSP}/code" \
        "${BSP}/include" \
        "${BSP}/lib" \
        "${BSP}/libsrc" \
        "${BSP}/libsrc/standalone/src"

    #
    # Drivers required by Trenz TE0726 hooks
    #
    grep -qxF "axivdma" "${DRIVERS}" || echo "axivdma" >> "${DRIVERS}"
    grep -qxF "vtc"     "${DRIVERS}" || echo "vtc"     >> "${DRIVERS}"

    #
    # Generic standalone implementation
    #
    cp -f "${SA}/common/"*.c \
        "${BSP}/libsrc/standalone/src/"

    cp -f "${SA}/common/"*.h \
        "${BSP}/libsrc/standalone/src/"

    #
    # ARM common implementation
    #
    cp -f "${SA}/arm/common/"*.c \
        "${BSP}/libsrc/standalone/src/"

    cp -f "${SA}/arm/common/"*.h \
        "${BSP}/libsrc/standalone/src/"

    #
    # Cortex-A9 implementation
    #
    cp -f "${SA}/arm/cortexa9/"*.c \
        "${BSP}/libsrc/standalone/src/"

    cp -f "${SA}/arm/cortexa9/"*.h \
        "${BSP}/libsrc/standalone/src/"

    #
    # GCC-specific ARM files
    #
    cp -f "${SA}/arm/common/gcc/"* \
        "${BSP}/libsrc/standalone/src/"

    cp -f "${SA}/arm/cortexa9/gcc/"* \
        "${BSP}/libsrc/standalone/src/"

    #
    # Profiling
    #
    cp -rf "${SA}/profile" \
        "${BSP}/libsrc/standalone/src/"

    #
    # Configuration required by standalone Makefile
    #
    cp -f "${FSBL_MISC}/config.make" \
        "${BSP}/libsrc/standalone/src/"

    #
    # ZC702 console implementation
    #
    cp -f \
        "${FSBL_MISC}/zc702/inbyte.c" \
        "${FSBL_MISC}/zc702/outbyte.c" \
        "${BSP}/libsrc/standalone/src/"

    #
    # Architecture headers required directly in BSP include/
    #
    cp -f "${SA}/common/"*.h \
        "${BSP}/include/"

    cp -f "${SA}/arm/common/"*.h \
        "${BSP}/include/"

    cp -f "${SA}/arm/common/gcc/"*.h \
        "${BSP}/include/"

    cp -f "${SA}/arm/cortexa9/"*.h \
        "${BSP}/include/"
}