// 假设队列为：[2, 1]，电梯现在在0层。该模块会让电梯在去2层的过程中先在1层停。
module next_queue_sub_logic (
    // 输入
    input [1:0] pos_lvl,
    input [7:0] next_queue_add,
    input [2:0] next_tail_add,
    // 输出
    output [7:0] next_queue_sub,
    output stop_at_pos_lvl
);
    // 生成变量
    genvar i;
    // 导线
    wire [3:0] shift;
    // 组合逻辑
    lvl_0_logic l0(
        // 输入
        .next_queue_add_0(next_queue_add[1:0]),
        .next_queue_add_1(next_queue_add[3:2]),
        .next_tail_add(next_tail_add),
        .pos_lvl(pos_lvl),
        // 输出
        .next_queue_sub_0(next_queue_sub[1:0]),
        .shift_0(shift[0])
    );
    generate
        for (i = 1; i < 3; i = i + 1) begin
            lvl_i_logic #(.i(i)) l1 (
                // 输入
                .next_queue_add_i(next_queue_add[i*2+1:i*2]),
                .next_queue_add_ip1(next_queue_add[(i+1)*2+1:(i+1)*2]),
                .next_tail_add(next_tail_add),
                .pos_lvl(pos_lvl),
                .shift_im1(shift[i-1]),
                // 输出
                .next_queue_sub_i(next_queue_sub[i*2+1:i*2]),
                .shift_i(shift[i])
            );
        end
    endgenerate
    lvl_3_logic l3(
        // 输入
        .next_queue_add_3(next_queue_add[7:6]),
        .next_tail_add(next_tail_add),
        .pos_lvl(pos_lvl),
        .shift_2(shift[2]),
        // 输出
        .next_queue_sub_3(next_queue_sub[7:6]),
        .shift_3(shift[3])
    );
    assign stop_at_pos_lvl = shift[3];
endmodule
