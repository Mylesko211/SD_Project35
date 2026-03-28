# control_interface interface packages source
# pragma uvmf custom additional begin
# pragma uvmf custom additional end

control_interface_PKG         ?= \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/control_interface_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/control_interface_pkg/control_interface_filelist_hvl.f 

control_interface_PKG_HDL         ?= \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/control_interface_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/control_interface_pkg/control_interface_filelist_hdl.f 

control_interface_PKG_XRTL         ?= \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/control_interface_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/control_interface_pkg/control_interface_filelist_xrtl.f 

COMP_control_interface_PKG_TGT_0 = q_comp_control_interface_pkg
COMP_control_interface_PKG_TGT_1 = v_comp_control_interface_pkg
COMP_control_interface_PKG_TGT = $(COMP_control_interface_PKG_TGT_$(USE_VELOCE))

comp_control_interface_pkg: $(COMP_control_interface_PKG_TGT) 

q_comp_control_interface_pkg:
	$(HDL_COMP_CMD) $(control_interface_PKG_HDL)
	$(HVL_COMP_CMD) $(control_interface_PKG)
	$(HDL_COMP_CMD) $(control_interface_PKG_XRTL) 

v_comp_control_interface_pkg:
	$(HVL_COMP_CMD) $(control_interface_PKG_HDL)
	$(HVL_COMP_CMD) $(control_interface_PKG)
	$(VELANALYZE_CMD) $(control_interface_PKG_HDL) 
	$(VELANALYZE_HVL_CMD) $(control_interface_PKG) 
	$(HDL_COMP_CMD) $(control_interface_PKG_XRTL)

ifeq ($(MTI_VCO_MODE),64)
  GCC_COMP_ARCH = -m64
else
  GCC_COMP_ARCH = -m32
endif

export control_interface_IF_DPI_SRC ?= $(UVMF_VIP_LIBRARY_HOME)/interface_packages/control_interface_pkg/dpi

C_FILE_COMPILE_LIST_control_interface_pkg	?= \

O_FILE_COMPILE_LIST_control_interface_pkg ?= $(notdir $(C_FILE_COMPILE_LIST_control_interface_pkg:.c=.o))

GCC_COMP_ARGS_control_interface_pkg	+= -I$(control_interface_IF_DPI_SRC) \
	-fPIC 

GCC_COMP_ARGS_control_interface_pkg	+= $(control_interface_IF_GCC_COMP_ARGUMENTS)

GCC_LINK_ARGS_control_interface_pkg	+= \
	 \
 	-o .so

comp_control_interface_pkg_c_files:
	@echo "--------------------------------"
	@echo "Compiling Interface C source"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_COMP_ARGS_control_interface_pkg) $(C_FILE_COMPILE_LIST_control_interface_pkg)
	@echo "--------------------------------"
	@echo "Linking Interface C objects into a shared object"
	@echo "--------------------------------"
	gcc $(GCC_COMP_ARCH) $(GCC_LINK_ARGS_control_interface_pkg) $(O_FILE_COMPILE_LIST_control_interface_pkg)
	@echo "--------------------------------"

