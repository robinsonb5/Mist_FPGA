
all: DeMiSTify/Makefile
	make -C "Console_MiST/GCE - Vectrex_MiST"

DeMiSTify/Makefile:
	git submodule init
	git submodule update --init --recursive

