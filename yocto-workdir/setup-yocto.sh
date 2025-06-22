#!/bin/bash
set -e

YOCTO_BRANCH="kirkstone"
BUILD_DIR="build"

echo "📦 Cloning Poky..."
git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/poky.git
cd poky

echo "📦 Cloning meta-openembedded..."
git clone -b $YOCTO_BRANCH git://git.openembedded.org/meta-openembedded

echo "📦 Cloning meta-ti..."
git clone -b $YOCTO_BRANCH https://git.ti.com/git/arago-project/meta-ti.git

echo "📦 Cloning meta-arm..."
git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-arm.git

echo "🛠️ Initializing build environment..."
source oe-init-build-env $BUILD_DIR

echo "⚙️ Writing local.conf..."
cat > conf/local.conf <<EOF
MACHINE = "beaglebone"
BB_NUMBER_THREADS = "4"
PARALLEL_MAKE = "-j4"
CONF_VERSION = "1"
EOF

echo "⚙️ Writing bblayers.conf..."
cat > conf/bblayers.conf <<EOF
LCONF_VERSION = "7"

BBPATH = "\${TOPDIR}"
BBFILES ?= ""

BBLAYERS ?= " \\
  \${TOPDIR}/../meta \\
  \${TOPDIR}/../meta-poky \\
  \${TOPDIR}/../meta-openembedded/meta-oe \\
  \${TOPDIR}/../meta-ti/meta-ti-bsp \\
  \${TOPDIR}/../meta-arm/meta-arm \\
"
EOF

echo "✅ Yocto environment ready. Run 'bitbake core-image-minimal' to build."

