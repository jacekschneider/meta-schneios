FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Additional hardware description files used by system.dts
EXTRA_DT_FILES = " \
    zynq-7000.dtsi \
    pl.dtsi \
    pcw.dtsi \
"

# Automatically append this include to system.dts
EXTRA_DT_INCLUDE_FILES = "system-user.dtsi"

# Build output name
BASE_DTS = "system"
DTB_FILE_NAME = "system.dtb"