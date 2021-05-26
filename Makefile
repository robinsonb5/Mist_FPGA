
all: DeMiSTify/Makefile DeMiSTify/site.mk
	make -C "Console_MiST/GCE - Vectrex_MiST"

DeMiSTify/Makefile:
	git submodule init
	git submodule update --init --recursive

DeMiSTify/site.mk:
	$(info ************************************************)
	$(info Copy the example DeMiSTify/site.template file)
	$(info to DeMISTify/site.mk and edit the paths for the)
	$(info version(s) of Quartus you have installed.)
	$(info ************************************************)
	$(error site.mk not found.)

