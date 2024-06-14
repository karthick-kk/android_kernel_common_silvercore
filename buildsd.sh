#!/bin/bash

# Set Compiler path
export PATH=/zfsdata/build/kernel/17.0.2.0/bin/:${PATH}

# Patch version
cp Makefile Makefile.orig
CURRENTSUBLEVEL=`grep SUBLEVEL Makefile.sd|head -1`
NEWSUBLEVEL="SUBLEVEL = `grep SUBLEVEL Makefile|head -1|awk '{print $NF}'`"
sed -i -e "s/${CURRENTSUBLEVEL}/${NEWSUBLEVEL}/g" Makefile.sd
cp Makefile.sd Makefile

# Start build
#ccache clang -print-supported-cpus
make ARCH=arm64 LLVM=1 LLVM_IAS=1 O=out mrproper
make SHELL="sh -e" ARCH=arm64 LLVM=1 LLVM_IAS=1 HOSTCC="ccache clang -target x86_64-unknown-linux-gnu"  O=out  -j 32 gki_defconfig
make SHELL="sh -e" ARCH=arm64 LLVM=1 LLVM_IAS=1 HOSTCC="ccache clang -target x86_64-unknown-linux-gnu"  O=out -j 32 2>&1 | tee build.log
mv Makefile.orig Makefile