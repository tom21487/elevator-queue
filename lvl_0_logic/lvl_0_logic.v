module lvl_0_logic(
    input [1:0] next_queue_add_0,
    input [1:0] next_queue_add_1,
    input [2:0] next_tail_add,
    input [1:0] pos_lvl,
    output [1:0] next_queue_sub_0,
    output shift_0
);
    assign shift_0 = (next_tail_add > 0) & (pos_lvl == next_queue_add_0);
    assign next_queue_sub_0 = shift_0 ? next_queue_add_1 : next_queue_add_0;
endmodule
