module next_tail_sub_logic(
    // 输入
    input [2:0] next_tail_add,
    input stop_at_pos_lvl,
    // 输出
    output [2:0] next_tail_sub
);
    // 组合逻辑
    assign next_tail_sub = stop_at_pos_lvl ? next_tail_add - 1 : next_tail_add;
endmodule
