DESCRIPTION = "Custom overlays"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit devicetree
PROVIDES = "custom-overlays"

SRC_URI += "file://custom-mcp23017-overlay.dts"
SRC_URI += "file://custom-trigger-overlay.dts"
SRC_URI += "file://custom-tft3-5-display-overlay.dts"

DT_FILES = " \
    custom-mcp23017-overlay.dts \
    custom-trigger-overlay.dts \
    custom-tft3-5-display-overlay.dts \
"

COMPATIBLE_MACHINE = "rpi4-schneios"