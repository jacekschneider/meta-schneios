SUMMARY = "Small proxy to be used with kgdb"
DESCRIPTION = "This is a simple, small proxy which was intended for use with kgdb, or \
gdbserver type connections where you want to share a text console and \
a debug session. \
"

SRC_URI = "git://git.kernel.org/pub/scm/utils/kernel/kgdb/agent-proxy.git;protocol=https;nobranch=1"
SRCREV = "agent-proxy-1.97"
LICENSE = "GPL-2.0-only"

S = "${WORKDIR}/git"
LIC_FILES_CHKSUM = "file://COPYING;md5=eb723b61539feef013de476e68b5c50a"

do_patch() {
    sed -i -e 's/^CC := gcc/CC ?= gcc/' -e 's/^CFLAGS := -Wall -Wunreachable-code/CFLAGS ?= -Wall -Wunreachable-code/' -e '/^CFLAGS += -D_XOPEN_SOURCE/a LDFLAGS ?=' -e 's|^[[:space:]]*\$(CC) -o \$@ kdmx.o|	$(CC) $(CFLAGS) -o $@ kdmx.o $(LDFLAGS)|' ${S}/kdmx/Makefile
}

do_compile() {
    cd kdmx 
    oe_runmake \
        CC="${CC}" \
        CFLAGS="${CFLAGS} -Wall -Wunreachable-code" \
        LDFLAGS="${LDFLAGS}"
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 kdmx/kdmx ${D}${bindir}
}
