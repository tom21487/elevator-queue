module lvl_i_logic #(parameter i = 1) (
    input [1:0] next_queue_add_i,
    input [1:0] next_queue_add_ip1,
    input [2:0] next_tail_add,
    input [1:0] pos_lvl,
    input shift_im1,
    output [1:0] next_queue_sub_i,
    output shift_i
);
    assign shift_i = shift_im1 | ((next_tail_add > i) & (pos_lvl == next_queue_add_i));
    assign next_queue_sub_i = shift_i ? next_queue_add_ip1 : next_queue_add_i;
endmodule
