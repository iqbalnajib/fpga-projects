PRJ_HOME ?= $(PWD)
PRJ_NAME ?= $(shell basename $(PWD))
SIM_PATH ?= $(PRJ_HOME)
WORK_PATH ?= $(PRJ_HOME)/work

# LIB_NAME := [VMM/UVM]
LIB_NAME :=
# TEST_NAME := test0 test1
# TEST_NAME := test_normal test_crc test_cov

VCS_VDB = design.vdb
SIM_VDB = sim.vdb

# CM_FLAG += -cm line+cond+fsm+tgl+branch+assert

VERDI_FLAG := -sverilog +v2k -f $(SIM_PATH)/filelist.f
VERDI_FLAG += -ntb_opts uvm-1.2 +define+UVM_NO_DEPRECATED

VCS_FLAG := $(VERDI_FLAG) \
	-debug_access+all+dmptf -kdb -lca \
	-debug_region+cell+encrypt \
	-LDFLAGS -Wl,--no-as-needed -CC -std=c11 \
	-assert svaext
VCS_FLAG += -timescale=1ns/1ps
VCS_FLAG += $(CM_FLAG) -cm_dir $(VCS_VDB) 
# VCS_FLAG += -CC -lpython3.6m -CC -I/usr/include/python3.6m
# VCS_FLAG += -LDFLAGS -lpython3.6m

SIM_FLAG := +ntb_random_seed=0
# SIM_FLAG := +ntb_random_seed_automatic
SIM_FLAG += $(CM_FLAG) -cm_dir $(SIM_VDB) 
# SIM_FLAG += +fsdb+delta
# SIM_FLAG += -verdi
# SIM_FLAG += +UVM_VERBOSITY=UVM_HIGH
# SIM_FLAG += +UVM_CONFIG_DB_TRACE
# SIM_FLAG += +UVM_OBJECTION_TRACE
# SIM_FLAG += +UVM_PHASE_TRACE 

.PHONY: all vcs sim cov wave clr

all: vcs sim

vcs: $(WORK_PATH)
	@cd $(WORK_PATH) && vcs $(VCS_FLAG) -l compile.log

sim: $(WORK_PATH)
ifdef LIB_NAME
	@$(foreach item, $(TEST_NAME), cd $(WORK_PATH) && ./simv $(SIM_FLAG) +$(LIB_NAME)_TESTNAME=$(item) -l $(item).log;)
else
	@cd $(WORK_PATH) && ./simv $(SIM_FLAG) -l sim.log
endif

wave: $(WORK_PATH)
	@cd $(WORK_PATH) && verdi $(VERDI_FLAG) &

cov: $(WORK_PATH)
	@cd $(WORK_PATH) && urg -dir $(VCS_VDB) $(SIM_VDB) -dbname merge.vdb -format both
	@cd $(WORK_PATH) && verdi -cov -covdir merge.vdb &

$(WORK_PATH):
	@mkdir -p $(WORK_PATH)

clr:
	@rm -rf $(WORK_PATH) *.pyc

