# i2c interface packages source
# pragma uvmf custom additional begin
# pragma uvmf custom additional end

i2c_PKG         ?= \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/i2c_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/i2c_pkg/i2c_filelist_hvl.f 

i2c_PKG_HDL         ?= \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/i2c_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/i2c_pkg/i2c_filelist_hdl.f 

i2c_PKG_XRTL         ?= \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/i2c_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/i2c_pkg/i2c_filelist_xrtl.f 

COMP_i2c_PKG_TGT_0 = q_comp_i2c_pkg
COMP_i2c_PKG_TGT_1 = v_comp_i2c_pkg
COMP_i2c_PKG_TGT = $(COMP_i2c_PKG_TGT_$(USE_VELOCE))

comp_i2c_pkg: $(COMP_i2c_PKG_TGT) 

q_comp_i2c_pkg:
	$(HDL_COMP_CMD) $(i2c_PKG_HDL)
	$(HVL_COMP_CMD) $(i2c_PKG)
	$(HDL_COMP_CMD) $(i2c_PKG_XRTL) 

v_comp_i2c_pkg:
	$(HVL_COMP_CMD) $(i2c_PKG_HDL)
	$(HVL_COMP_CMD) $(i2c_PKG)
	$(VELANALYZE_CMD) $(i2c_PKG_HDL) 
	$(VELANALYZE_HVL_CMD) $(i2c_PKG) 
	$(HDL_COMP_CMD) $(i2c_PKG_XRTL)

ifeq ($(MTI_VCO_MODE),64)
  GCC_COMP_ARCH = -m64
else
  GCC_COMP_ARCH = -m32
endif

export i2c_IF_DPI_SRC ?= $(UVMF_VIP_LIBRARY_HOME)/interface_packages/i2c_pkg/dpi

C_FILE_COMPILE_LIST_i2c_pkg	?= \

O_FILE_COMPILE_LIST_i2c_pkg ?= $(notdir $(C_FILE_COMPILE_LIST_i2c_pkg:.c=.o))

GCC_COMP_ARGS_i2c_pkg	+= -I$(i2c_IF_DPI_SRC) \
	-fPIC 

GCC_COMP_ARGS_i2c_pkg	+= $(i2c_IF_GCC_COMP_ARGUMENTS)

GCC_LINK_ARGS_i2c_pkg	+= \
	 \
 	-o .so

comp_i2c_pkg_c_files:
	@echo "--------------------------------"
	@echo "Compiling Interface C source"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_COMP_ARGS_i2c_pkg) $(C_FILE_COMPILE_LIST_i2c_pkg)
	@echo "--------------------------------"
	@echo "Linking Interface C objects into a shared object"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_LINK_ARGS_i2c_pkg) $(O_FILE_COMPILE_LIST_i2c_pkg)
	@echo "--------------------------------"

