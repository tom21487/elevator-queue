module next_tail_add_logic (
    // 输入
    input add_new_lvl,
    input [2:0] tail,
    // 输出
    output [2:0] next_tail_add
);
    // 组合逻辑
    assign next_tail_add = add_new_lvl ? tail + 1 : tail;
endmodule
