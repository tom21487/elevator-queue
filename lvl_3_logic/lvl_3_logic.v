module lvl_3_logic (
    input [1:0] next_queue_add_3,
    input [2:0] next_tail_add,
    input [1:0] pos_lvl,
    input shift_2,
    output [1:0] next_queue_sub_3,
    output shift_3
);
    assign shift_3 = shift_2 | ((next_tail_add > 3) & (pos_lvl == next_queue_add_3));
    assign next_queue_sub_3 = next_queue_add_3;
endmodule
