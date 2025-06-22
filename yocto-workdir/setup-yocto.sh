#!/bin/bash
set -e

YOCTO_BRANCH="kirkstone"
BUILD_DIR="build"
CORE_COUNT=$(nproc)

echo "🔍 Detected $CORE_COUNT CPU cores."

# Clone layers only if missing
clone_if_needed() {
  local dir=$1
  local repo=$2
  local branch=$3
  if [ -d "$dir/.git" ]; then
    echo "✅ $dir already exists. Skipping clone."
  else
    echo "📦 Cloning $dir..."
    git clone -b "$branch" "$repo" "$dir"
  fi
}

clone_if_needed poky git://git.yoctoproject.org/poky.git $YOCTO_BRANCH
cd poky

clone_if_needed meta-openembedded git://git.openembedded.org/meta-openembedded $YOCTO_BRANCH
clone_if_needed meta-ti https://git.ti.com/git/arago-project/meta-ti.git $YOCTO_BRANCH
clone_if_needed meta-arm git://git.yoctoproject.org/meta-arm.git $YOCTO_BRANCH

# Only initialize build dir if missing
if [ ! -f "$BUILD_DIR/conf/local.conf" ]; then
  echo "🛠️ Initializing build environment..."
  source oe-init-build-env $BUILD_DIR

  echo "⚙️ Writing local.conf..."
  cp ../meta-poky/conf/local.conf.sample conf/local.conf
  echo "MACHINE = \"beaglebone\"" >> conf/local.conf
  echo "BB_NUMBER_THREADS = \"$CORE_COUNT\"" >> conf/local.conf
  echo "PARALLEL_MAKE = \"-j$CORE_COUNT\"" >> conf/local.conf

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
  echo "✅ Yocto build environment configured for BeagleBone Black."
  echo ""
  echo "Next steps:"
  echo "  cd poky"
  echo "  source oe-init-build-env $BUILD_DIR"
  echo "  bitbake core-image-minimal"
  echo ""
else
  echo "🟡 Build directory already exists. Skipping reinitialization."
fi

