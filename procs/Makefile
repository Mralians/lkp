ifeq ($(ARCH),arm64)
  KERNEL_DIR ?= ~/kernel/linux-4.14
else
  KERNEL_DIR ?= /lib/modules/$(shell uname -r)/build
endif


LKM_NAME := procs_showall

PWD            := $(shell pwd)
EXTRA_CFLAGS   += -DDEBUG
obj-m          += ${LKM_NAME}.o
all:
	@echo
	@echo "##################################"
	@echo '[*] building LKM : KERNEL_DIR=${KERNEL_DIR} ARCH=${ARCH} EXTRA_CFLAGS=${EXTRA_CFLAGS}'
	@echo "##################################"
	@echo
	make -C $(KERNEL_DIR) M=$(PWD) modules
install:
	@echo
	@echo "##################################"
	@echo "[*] installing"
	@echo "##################################"
	@echo
	make all
	sudo make -C $(KERNEL_DIR) M=$(PWD) modules_install
	sudo depmod
clean:
	@echo
	@echo "##################################"
	@echo "[*] cleaning"
	@echo "##################################"
	@echo
	make -C $(KERNEL_DIR) M=$(PWD) clean
	rm -f *~ #indent temp file



############################################
### CODE-STYLE
############################################

INDENT := indent

code-style:
	make indent
	make checkpatch

indent:
	@echo "##################################"
	@echo "[*] applying kernel code style indentation with indent"
	@echo "##################################"
	mkdir backup 2> /dev/null
	cp -f *.[chsS] backup/
	${INDENT} -linux --line-length95 *.[chsS]
	  # add source files as required

# Detailed check on the source code styling / etc
checkpatch:
	make clean
	@echo
	@echo "[*] kernel code style check with 'checkpatch.pl'"
	@echo
	$(KERNEL_DIR)/scripts/checkpatch.pl --no-tree -f --max-line-length=95 *.[ch]
	  # add source files as required

############################################
### STATIC-ANALYSIS
############################################

sa:
	reset
	make sa_sparse
	make sa_gcc
	make sa_flawfinder
	make sa_cppcheck

sa_sparse:
	make clean
	@echo
	@echo "----------------------------------"
	@echo "[*] static analysis with sparse"
	@echo "----------------------------------"
	@echo
	make C=2 CHECK="/usr/bin/sparse" -C $(KERNEL_DIR) M=$(PWD) modules

sa_gcc:
	make clean
	@echo
	@echo "############################################"
	@echo "[*] static analysis with gcc"
	@echo "############################################"
	@echo
	make W=1 -C $(KERNEL_DIR) M=$(PWD) modules

sa_flawfinder:
	make clean
	@echo
	@echo "############################################"
	@echo "[*] static analysis with flawfinder"
	@echo "############################################"
	@echo
	flawfinder *.[ch]

sa_cppcheck:
	make clean
	@echo
	@echo "############################################"
	@echo "[*] static analysis with cppcheck"
	@echo "############################################"
	@echo
	cppcheck -v --force --enable=all -i .tmp_versions/ -i *.mod.c -i backup/ --suppress=missingIncludeSystem .

############################################
### PACKAGING
############################################

PKG_NAME := ${LKM_NAME}
tarxz-pkg:
	rm -f ../${PKG_NAME}.tar.xz 2>/dev/null
	make clean
	@echo "############################################"
	@echo "[*] packaging"
	@echo "############################################"
	tar caf ../${PKG_NAME}.tar.xz *
	ls -l ../${PKG_NAME}.tar.xz
	@echo '=== package created: ../$(PKG_NAME).tar.xz ==='
	@echo 'Tip: when extracting, to extract into a dir of the same name as the tar file,'
	@echo ' do: tar -xvf ${PKG_NAME}.tar.xz --one-top-level'

help:
	@echo '=== Makefile Help : additional targets available ==='
	@echo
	@echo 'TIP: type make <tab><tab> to show all valid targets'
	@echo

	@echo '--- 'usual' kernel LKM targets ---'
	@echo 'typing "make" or "all" target : builds the kernel module object (the .ko)'
	@echo 'install     : installs the kernel module(s) to INSTALL_MOD_PATH (default here: /lib/modules/$(shell uname -r)/)'
	@echo 'clean       : cleanup - remove all kernel objects, temp files/dirs, etc'

	@echo
	@echo '--- kernel code style targets ---'
	@echo 'code-style : "wrapper" target over the following kernel code style targets'
	@echo ' indent     : run the $(INDENT) utility on source file(s) to indent them as per the kernel code style'
	@echo ' checkpatch : run the kernel code style checker tool on source file(s)'

	@echo
	@echo '--- kernel static analyzer targets ---'
	@echo 'sa         : "wrapper" target over the following kernel static analyzer targets'
	@echo ' sa_sparse     : run the static analysis sparse tool on the source file(s)'
	@echo ' sa_gcc        : run gcc with option -W1 ("Generally useful warnings") on the source file(s)'
	@echo ' sa_flawfinder : run the static analysis flawfinder tool on the source file(s)'
	@echo ' sa_cppcheck   : run the static analysis cppcheck tool on the source file(s)'
	@echo 'TIP: use coccinelle as well (requires spatch): https://www.kernel.org/doc/html/v4.15/dev-tools/coccinelle.html'


	@echo
	@echo '--- misc targets ---'
	@echo 'tarxz-pkg  : tar and compress the LKM source files as a tar.xz into the dir above; allows one to transfer and build the module on another system'
	@echo ' Tip: when extracting, to extract into a dir of the same name as the tar file,'
	@echo '  do: tar -xvf ${PKG_NAME}.tar.xz --one-top-level'
	@echo 'help       : this help target'
