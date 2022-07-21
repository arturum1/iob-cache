# (c) 2022-Present IObundle, Lda, all rights reserved
#
# This makefile segment lists all hardware header and source files 
#
# It is always included in submodules/LIB/Makefile for populating the
# build directory
#


#import lib hardware
include hardware/regfile/iob_regfile_sp/hardware.mk
include hardware/fifo/iob_fifo_sync/hardware.mk
include hardware/ram/iob_ram_2p/hardware.mk
include hardware/ram/iob_ram_sp/hardware.mk


#HEADERS

#core header
VHDR+=$(BUILD_VSRC_DIR)/iob_cache.vh
$(BUILD_VSRC_DIR)/iob_cache.vh: $(CACHE_DIR)/hardware/src/iob_cache.vh
	cp $< $(BUILD_VSRC_DIR)

#clk/rst interface
VHDR+=$(BUILD_VSRC_DIR)/iob_gen_if.vh
$(BUILD_VSRC_DIR)/iob_gen_if.vh: hardware/include/iob_gen_if.vh
	cp $< $(BUILD_VSRC_DIR)

#back-end AXI4 interface verilog header file 
AXI_GEN:=software/python/axi_gen.py
VHDR+=$(BUILD_VSRC_DIR)/iob_cache_axi_m_port.vh
$(BUILD_VSRC_DIR)/iob_cache_axi_m_port.vh:
	$(AXI_GEN) axi_m_port iob_cache_ && mv iob_cache_axi_m_port.vh $(BUILD_VSRC_DIR)

#back-end AXI4 portmap verilog header file 
VHDR+=$(BUILD_VSRC_DIR)/iob_cache_axi_portmap.vh
$(BUILD_VSRC_DIR)/iob_cache_axi_portmap.vh:
	$(AXI_GEN) axi_portmap iob_cache_ && mv iob_cache_axi_portmap.vh $(BUILD_VSRC_DIR)

#cache software accessible register defines
VHDR+=$(BUILD_VSRC_DIR)/iob_cache_swreg_def.vh
$(BUILD_VSRC_DIR)/iob_cache_swreg_def.vh: iob_cache_swreg_def.vh
	cp $< $@

iob_cache_swreg_def.vh: $(CACHE_DIR)/mkregs.conf
	$(MKREGS) iob_cache $(CACHE_DIR) HW

#SOURCES
VSRC1=$(wildcard $(CACHE_DIR)/hardware/src/*.v)
VSRC2=$(patsubst $(CACHE_DIR)/hardware/src/%, $(BUILD_VSRC_DIR)/%, $(VSRC1))
VSRC+=$(VSRC2)

$(BUILD_VSRC_DIR)/%.v: $(CACHE_DIR)/hardware/src/%.v
	cp $< $@


#
# SIMULATION FILES
#

# copy simulation wrapper
VSRC+=$(BUILD_VSRC_DIR)/iob_cache_wrapper.v
$(BUILD_VSRC_DIR)/iob_cache_wrapper.v: $(CORE_SIM_DIR)/iob_cache_wrapper.v
	cp $< $(BUILD_VSRC_DIR)

# copy external memory for iob interface
include hardware/ram/iob_ram_sp_be/hardware.mk

# copy external memory for axi interface
include hardware/axiram/hardware.mk

# generate and copy AXI4 wires to connect cache to axi memory
VHDR+=$(BUILD_VSRC_DIR)/iob_cache_axi_wire.vh
$(BUILD_VSRC_DIR)/iob_cache_axi_wire.vh:
	./software/python/axi_gen.py axi_wire iob_cache_
	mv $(subst $(BUILD_VSRC_DIR)/, , $@) $(BUILD_VSRC_DIR)
