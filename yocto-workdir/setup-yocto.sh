#!/bin/bash
set -e

YOCTO_BRANCH="kirkstone"
BUILD_DIR="build"

echo "🔎 Checking for Poky directory..."
if [ ! -d "poky/.git" ]; then
    echo "📦 Cloning Poky..."
    git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/poky.git
fi
cd poky

echo "🔎 Checking for meta-openembedded..."
[ -d meta-openembedded/.git ] || git clone -b $YOCTO_BRANCH git://git.openembedded.org/meta-openembedded

echo "🔎 Checking for meta-ti..."
[ -d meta-ti/.git ] || git clone -b $YOCTO_BRANCH https://git.ti.com/git/arago-project/meta-ti.git

echo "🔎 Checking for meta-arm..."
[ -d meta-arm/.git ] || git clone -b $YOCTO_BRANCH git://git.yoctoproject.org/meta-arm.git

echo "🛠️ Setting up build environment..."
rm -rf $BUILD_DIR
source oe-init-build-env $BUILD_DIR

echo "⚙️ Writing local.conf..."
cp -f ../meta-poky/conf/local.conf.sample conf/local.conf
cat <<EOF >> conf/local.conf
MACHINE = "beaglebone"
BB_NUMBER_THREADS = "4"
PARALLEL_MAKE = "-j4"
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
  \${TOPDIR}/../meta-arm/meta-arm-toolchain \\
"
EOF

echo ""
echo "✅ Yocto environment configured for BeagleBone Black."
echo ""
echo "To build, run:"
echo "  cd poky"
echo "  source oe-init-build-env $BUILD_DIR"
echo "  bitbake core-image-minimal"
echo ""

