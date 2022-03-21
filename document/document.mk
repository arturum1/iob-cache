include $(CACHE_DIR)/config.mk

#block diagram verilog source
BD_VSRC=iob_cache.v

SWREGS=0

INT_FAMILY ?=CYCLONEV-GT
XIL_FAMILY ?=XCKU

NOCLEAN+=-o -name "test.expected" -o -name "Makefile"

#include tex submodule makefile segment
#root directory
CORE_DIR:=$(CACHE_DIR)

#headers for creating tables
VHDR+=$(LIB_DIR)/hardware/include/iob_s_if.vh
VHDR+=$(LIB_DIR)/hardware/include/gen_if.vh

#export definitions
export DEFINE

include $(LIB_DIR)/document/document.mk

test: clean $(DOC).pdf
	diff -q $(DOC).aux test.expected

.PHONY: test