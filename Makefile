NEXT_QUEUE_ADD_LOGIC_DEPS := next_queue_add_logic/next_queue_add_logic.v
next_queue_add_logic/testbench: next_queue_add_logic/testbench.v $(NEXT_QUEUE_ADD_LOGIC_DEPS)
	iverilog -o $@ next_queue_add_logic/testbench.v $(NEXT_QUEUE_ADD_LOGIC_DEPS)

LVL_0_LOGIC_DEPS := lvl_0_logic/lvl_0_logic.v
lvl_0_logic/testbench: lvl_0_logic/testbench.v $(LVL_0_LOGIC_DEPS)
	iverilog -o $@ lvl_0_logic/testbench.v $(LVL_0_LOGIC_DEPS)

LVL_I_LOGIC_DEPS := lvl_i_logic/lvl_i_logic.v
lvl_i_logic/testbench: lvl_i_logic/testbench.v $(LVL_I_LOGIC_DEPS)
	iverilog -o $@ lvl_i_logic/testbench.v $(LVL_I_LOGIC_DEPS)

LVL_3_LOGIC_DEPS := lvl_3_logic/lvl_3_logic.v
lvl_3_logic/testbench: lvl_3_logic/testbench.v $(LVL_3_LOGIC_DEPS)
	iverilog -o $@ lvl_3_logic/testbench.v $(LVL_3_LOGIC_DEPS)

NEXT_QUEUE_SUB_LOGIC_DEPS := next_queue_sub_logic/next_queue_sub_logic.v $(LVL_0_LOGIC_DEPS) $(LVL_I_LOGIC_DEPS) $(LVL_3_LOGIC_DEPS)
next_queue_sub_logic/testbench: next_queue_sub_logic/testbench.v $(NEXT_QUEUE_SUB_LOGIC_DEPS)
	iverilog -o $@ next_queue_sub_logic/testbench.v $(NEXT_QUEUE_SUB_LOGIC_DEPS)

PRESSED_LVL_IN_QUEUE_LOGIC_DEPS := pressed_lvl_in_queue_logic/pressed_lvl_in_queue_logic.v
pressed_lvl_in_queue_logic/testbench: pressed_lvl_in_queue_logic/testbench.v $(PRESSED_LVL_IN_QUEUE_LOGIC_DEPS)
	iverilog -o $@ pressed_lvl_in_queue_logic/testbench.v $(PRESSED_LVL_IN_QUEUE_LOGIC_DEPS)

ADD_NEW_LVL_LOGIC_DEPS := add_new_lvl_logic/add_new_lvl_logic.v $(PRESSED_LVL_IN_QUEUE_LOGIC_DEPS)
add_new_lvl_logic/testbench: add_new_lvl_logic/testbench.v $(ADD_NEW_LVL_LOGIC_DEPS)
	iverilog -o $@ $^

QUEUE_LOGIC_DEPS := queue_logic/queue_logic.v next_tail_add_logic/next_tail_add_logic.v next_tail_sub_logic/next_tail_sub_logic.v $(ADD_NEW_LVL_LOGIC_DEPS) $(NEXT_QUEUE_ADD_LOGIC_DEPS) $(NEXT_QUEUE_SUB_LOGIC_DEPS)
queue_logic/testbench: queue_logic/testbench.v $(QUEUE_LOGIC_DEPS)
	iverilog -o $@ $^

PRIORITY_ENCODER_DEPS := priority_encoder/priority_encoder.v
priority_encoder/testbench: priority_encoder/testbench.v $(PRIORITY_ENCODER_DEPS)
	iverilog -o $@ $^

ENGINE_DEPS := engine/engine.v $(PRIORITY_ENCODER_DEPS) $(QUEUE_LOGIC_DEPS)
engine/testbench: engine/testbench.v $(ENGINE_DEPS)
	iverilog -o $@ engine/testbench.v $(ENGINE_DEPS)

ELEVATOR_DEPS := elevator.v $(ENGINE_DEPS) pos_lvl_logic/pos_lvl_logic.v clk_divider/clk_divider.v decoder/decoder.v
testbench: testbench.v $(ELEVATOR_DEPS)
	iverilog -o $@ testbench.v $(ELEVATOR_DEPS)

elevator.blif: elevator_tb
	yosys -p "synth_ice40 -blif $@" $(ELEVATOR_DEPS)

elevator.asc: elevator.blif
	arachne-pnr -d 1k -P tq144 -p elevator.pcf elevator.blif -o $@

elevator.bin: elevator.asc
	icepack elevator.asc $@

.PHONY: iceprog
iceprog: elevator.bin
	iceprog elevator.bin
