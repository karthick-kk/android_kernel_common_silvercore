export CLANG_PATH=$HOME_DIR/tc/clang-r487747c/bin
export PATH=${BINUTILS_PATH}:${CLANG_PATH}:${PATH}
make -j8 CC='ccache clang' ARCH=arm64 LLVM=1 LLVM_IAS=1 O=out gki_defconfig
#!/bin/bash
# Resources
THREAD="-j$(nproc --all)"

export CLANG_PATH=$HOME_DIR/tc/clang-r487747c/bin/
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=$HOME_DIR/tc/clang-r487747c/bin/aarch64-linux-gnu- CC=clang CXX=clang++

DEFCONFIG="gki_defconfig"

# Paths
KERNEL_DIR=`pwd`
ZIMAGE_DIR="$KERNEL_DIR/out/arch/arm64/boot"

# Vars
export ARCH=arm64
export SUBARCH=$ARCH
export KBUILD_BUILD_USER=saikiran

DATE_START=$(date +"%s")

echo  "DEFCONFIG SET TO $DEFCONFIG"
echo "-------------------"
echo "Making Kernel:"
echo "-------------------"
echo

make CC="ccache clang" CXX="ccache clang++" LLVM=1 LLVM_IAS=1 O=out $DEFCONFIG
make CC='ccache clang' CXX="ccache clang++" LLVM=1 LLVM_IAS=1 O=out $THREAD 2>&1 | tee kernel.log

echo
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
ls -a $ZIMAGE_DIR

cd $KERNEL_DIR

TIME="$(date "+%Y%m%d-%H%M%S")"
mkdir -p tmp
cp -fp $ZIMAGE_DIR/Image.gz tmp
