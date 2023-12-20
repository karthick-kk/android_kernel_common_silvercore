export PATH=/home/kk/dev/android/proprietary_vendor_qcom_sdclang/compiler/bin/:${PATH}
cp Makefile Makefile.orig
cp Makefile.sd Makefile
#ccache clang -print-supported-cpus
make ARCH=arm64 LLVM=1 LLVM_IAS=1 O=out mrproper
make SHELL="sh -e" ARCH=arm64 LLVM=1 LLVM_IAS=1 HOSTCC="ccache clang -target x86_64-unknown-linux-gnu"  O=out  -j 12 gki_defconfig
make SHELL="sh -e" ARCH=arm64 LLVM=1 LLVM_IAS=1 HOSTCC="ccache clang -target x86_64-unknown-linux-gnu"  O=out -j 12 2>&1 | tee build.log
mv Makefile.orig Makefile