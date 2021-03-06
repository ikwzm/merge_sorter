PIPEWORK_PATH        = ../../../PipeWork
PIPEWORK_SRC_PATH    = $(PIPEWORK_PATH)/src
PIPEWORK_WORK_PATH   = $(PIPEWORK_PATH)/sim/ghdl-0.35
PIPEWORK_TOOL_PATH   = $(PIPEWORK_PATH)/tools

DUMMY_PLUG_PATH      = ../../../Dummy_Plug
DUMMY_PLUG_SRC_PATH  = $(DUMMY_PLUG_PATH)/src/main/vhdl
DUMMY_PLUG_WORK_PATH = $(DUMMY_PLUG_PATH)/sim/ghdl-0.35/dummy_plug
DUMMY_PLUG_TOOL_PATH = $(DUMMY_PLUG_PATH)/tools

SCENARIO_PATH        = ../../../src/test/scenarios/merge_sorter_tree/

COPY       = cp
REMOVE     = -rm
GHDL       = ghdl
GHDLFLAGS  = --mb-comments -P$(DUMMY_PLUG_WORK_PATH) -P$(PIPEWORK_WORK_PATH)

TEST  =  test_x04_w1_o0_s0 \
         test_x04_w1_o0_s1 \
         test_x02_w1_o1_s0 \
         test_x02_w1_o1_s1 \
         test_x02_w2_o0_s0 \
         test_x04_w2_o0_s0 \
         $(END_LIST)

test   : $(TEST)

clean  :
	$(REMOVE) *.cf *.snr sources.mk

dut    : merge_sorter_tree

define RUN
$(1): $(2) merge_sorter_tree_test_bench dut 
	$(GHDL) -e $(GHDLFLAGS) --work=MERGE_SORTER $(subst test_,Merge_Sorter_Tree_Test_Bench_,$(1))
	$(GHDL) -r $(GHDLFLAGS) --work=MERGE_SORTER $(subst test_,Merge_Sorter_Tree_Test_Bench_,$(1))

$(2): $(addprefix $(SCENARIO_PATH),$(2))
	$(COPY) $(addprefix $(SCENARIO_PATH),$(2)) $(2)
endef

$(foreach ENTITY, $(TEST), $(eval $(call RUN, $(ENTITY), $(addsuffix .snr,$(ENTITY)))))

sources.mk   : sources.yml
	$(PIPEWORK_TOOL_PATH)/vhdl-archiver.rb -v --config sources.yml > sources.mk

include sources.mk
