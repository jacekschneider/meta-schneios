#!/bin/sh
# Copyright (c) 2021 Xilinx, Inc.
# SPDX-License-Identifier: MIT
# SchneiOS: portable Zynq-7000 BSP copy helper (run from zynq_fsbl/src).

set -eu

BOARD=${1:?Usage: copy_bsp.sh BOARD COMPILER}
COMPILER=${2:?Usage: copy_bsp.sh BOARD COMPILER}
# The caller may pass the CC command with flags as separate arguments.
COMPILER=${COMPILER##*/}

WORKING_DIR=../misc
BSP_DIR=$WORKING_DIR/ps7_cortexa9_0
BOARD_DIR=$WORKING_DIR/$BOARD
EMBEDDED_SW_DIR=$WORKING_DIR/../../../..
DRIVERS_LIST=$BOARD_DIR/drivers.txt
DRIVERS_DIR=$EMBEDDED_SW_DIR/XilinxProcessorIPLib/drivers
STANDALONE_DIR=$EMBEDDED_SW_DIR/lib/bsp/standalone/src
SERVICES_DIR=$EMBEDDED_SW_DIR/lib/sw_services
STANDALONE_DEST=$BSP_DIR/libsrc/standalone/src

# On disk these must be generated for the selected hardware, not invented here.
[ -f "$DRIVERS_LIST" ] || { echo "Missing $DRIVERS_LIST" >&2; exit 1; }
[ -f "$BOARD_DIR/xparameters.h" ] || { echo "Missing $BOARD_DIR/xparameters.h" >&2; exit 1; }

mkdir -p "$BSP_DIR/code" "$BSP_DIR/include" "$BSP_DIR/lib" "$STANDALONE_DEST"

echo "Copying BSP for board=$BOARD compiler=$COMPILER"

cp -R "$STANDALONE_DIR/profile" "$STANDALONE_DEST/"
for pattern in \
    "$STANDALONE_DIR"/common/*.h \
    "$STANDALONE_DIR"/common/*.c \
    "$STANDALONE_DIR"/arm/cortexa9/*.h \
    "$STANDALONE_DIR"/arm/cortexa9/*.c \
    "$STANDALONE_DIR"/arm/common/*.h \
    "$STANDALONE_DIR"/arm/common/*.c \
    "$STANDALONE_DIR"/arm/common/gcc/*; do
    [ -f "$pattern" ] && cp "$pattern" "$STANDALONE_DEST/"
done

case "$COMPILER" in
    *gcc*)
        echo 'Using Cortex-A9 GCC runtime'
        for f in "$STANDALONE_DIR"/arm/cortexa9/gcc/*; do
            [ -f "$f" ] && cp "$f" "$STANDALONE_DEST/"
        done
        ;;
    armcc)
        for f in "$STANDALONE_DIR"/arm/cortexa9/armcc/*; do
            [ -f "$f" ] && cp "$f" "$STANDALONE_DEST/"
        done
        ;;
    *) echo "Unsupported compiler: $COMPILER" >&2; exit 1 ;;
esac

# A regular file, rather than a pipe, ensures this loop runs in the parent shell.
# Append demo video drivers even when they are absent from zc702/drivers.txt.
DRIVER_INPUT=$BSP_DIR/.schneios-drivers.txt
cat "$DRIVERS_LIST" > "$DRIVER_INPUT"
printf '\naxivdma\nvtc\n' >> "$DRIVER_INPUT"

SEEN=' '
while IFS= read -r driver || [ -n "$driver" ]; do
    driver=$(printf '%s' "$driver" | tr -d '\r')
    case "$driver" in ''|'#'*) continue ;; esac
    case "$SEEN" in *" $driver "*) continue ;; esac
    SEEN="$SEEN$driver "
    src=$DRIVERS_DIR/$driver/src
    dest=$BSP_DIR/libsrc/$driver
    [ -d "$src" ] || { echo "Missing driver: $src" >&2; exit 1; }
    echo "Copying driver: $driver"
    mkdir -p "$dest"
    cp -R "$src" "$dest/"
    for h in "$src"/*.h; do
        [ -f "$h" ] && cp "$h" "$BSP_DIR/include/"
    done
done < "$DRIVER_INPUT"
rm -f "$DRIVER_INPUT"

# Software services expected by the original misc/makefile.
cp -R "$SERVICES_DIR/xilffs" "$BSP_DIR/libsrc/"
cp -R "$SERVICES_DIR/xilrsa" "$BSP_DIR/libsrc/"
for dir in "$SERVICES_DIR/xilffs/src/include" "$SERVICES_DIR/xilrsa/src/include"; do
    for f in "$dir"/*; do
        [ -f "$f" ] && cp "$f" "$BSP_DIR/include/"
    done
done

cp "$BOARD_DIR/xparameters.h" "$BOARD_DIR/bspconfig.h" "$BSP_DIR/include/"
cp "$WORKING_DIR/config.make" "$STANDALONE_DEST/"
for f in "$STANDALONE_DIR"/common/*; do
    [ -f "$f" ] && cp "$f" "$BSP_DIR/include/"
done
cp "$BOARD_DIR/inbyte.c" "$BOARD_DIR/outbyte.c" "$STANDALONE_DEST/"
# Ensure generated include contains all Cortex-A9 standalone headers,
# including xparameters_ps.h and xpseudo_asm_gcc.h.
for h in "$STANDALONE_DEST"/*.h; do
    [ -f "$h" ] && cp "$h" "$BSP_DIR/include/"
done

for required in xparameters.h xparameters_ps.h xpseudo_asm_gcc.h xaxivdma.h xvtc.h; do
    [ -f "$BSP_DIR/include/$required" ] || {
        echo "Missing generated BSP header: $required" >&2
        exit 1
    }
done

echo 'SchneiOS BSP source copy complete'
