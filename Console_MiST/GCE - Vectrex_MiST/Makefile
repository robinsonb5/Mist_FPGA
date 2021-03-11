DEMISTIFYPATH=../../DeMiSTify
PROJECT=vectrex
BOARD=

all: buildid submodules vbcc firmware init compile

.PHONY: buildid
buildid:
	quartus_sh -t rtl/build_id.tcl

submodules: $(DEMISTIFYPATH)/Makefile

.PHONY: vbcc
vbcc:
	make -C $(DEMISTIFYPATH)/EightThirtyTwo/ vbcc

$(DEMISTIFYPATH)/DeMiSTify/Makefile:
	git submodule update --init --recursive

.PHONY: firmware
firmware: submodules firmware_overrides
	make -f $(DEMISTIFYPATH)/Makefile DEMISTIFYPATH=$(DEMISTIFYPATH) firmware OVERRIDES=../../Console_MiST/GCE\ -\ Vectrex_MiST/firmware_overrides

.PHONY: init
init:
	make -f $(DEMISTIFYPATH)/Makefile DEMISTIFYPATH=$(DEMISTIFYPATH) PROJECTS=$(PROJECT) BOARD=$(BOARD) init 

.PHONY: compile
compile:
	make -f $(DEMISTIFYPATH)/Makefile DEMISTIFYPATH=$(DEMISTIFYPATH) PROJECTS=$(PROJECT) BOARD=$(BOARD) compile

.PHONY: clean
clean:
	make -f $(DEMISTIFYPATH)/Makefile DEMISTIFYPATH=$(DEMISTIFYPATH) PROJECTS=$(PROJECT) BOARD=$(BOARD) clean

