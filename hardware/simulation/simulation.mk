#
# This file is included in BUILD_DIR/sim/Makefile
#

#verilator top module
VTOP:=iob_cache_wrapper

test: iob-cache-clean-testlog test1
	diff -q test.log test.expected

test1: clean
	make run TEST_LOG=">> test.log"

ifeq ($(BE_IF),axi)
VFLAGS+=-DAXI
endif

# choose top module file

TOP_ROOT=../vsrc/top/$(TOP_MODULE)
TOP_CURR=../vsrc/top/$(TOP_MODULE).v
VSRC+=$(TOP_CURR)

$(TOP_CURR): top

top:
ifeq ($(BE_IF),axi)
	if [ ! -f $(TOP_CURR) ]; then cp $(TOP_ROOT)_axi.v $(TOP_CURR); elif [ "`diff -q $(TOP_ROOT)_axi.v $(TOP_CURR)`" ]; then cp $(TOP_ROOT)_axi.v $(TOP_CURR); fi
else
	if [ ! -f $(TOP_CURR) ]; then cp $(TOP_ROOT)_iob.v $(TOP_CURR); elif [ "`diff -q $(TOP_ROOT)_iob.v $(TOP_CURR)`" ]; then cp $(TOP_ROOT)_iob.v $(TOP_CURR); fi
endif

.PHONY: test test1 top
