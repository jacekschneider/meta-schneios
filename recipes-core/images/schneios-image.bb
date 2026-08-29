SUMMARY = "SchneiOS Image"
LICENSE = "MIT"

IMAGE_FEATURES += " splash ssh-server-openssh package-management"
IMAGE_FEATURES += " allow-empty-password empty-root-password allow-root-login"

# system config
IMAGE_INSTALL:append = " motd"
IMAGE_INSTALL:append = " modules-conf"
IMAGE_INSTALL:append = " os-release"

# application
IMAGE_INSTALL:append = " nano"

# debugging
IMAGE_INSTALL:append = " i2c-tools"
IMAGE_INSTALL:append = " gdbserver"
IMAGE_INSTALL:append = " dtc"

# networking
IMAGE_INSTALL:append = " tcpdump iputils static-ipv4"

##kgdb
IMAGE_INSTALL:append = " kdmx"
