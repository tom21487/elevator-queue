module engine (
    input [3:0] ipmod30,
    input [1:0] pos_lvl,
    input [2:0] tail,
    input [7:0] queue,
    output stop_at_pos_lvl,
    output [7:0] next_queue_sub,
    output [2:0] next_tail_sub
);
    // 导线
    wire pressed_en;
    wire [1:0] pressed_lvl;

    // 组合逻辑
    priority_encoder pe(
        .in(ipmod30),                         // 输入
        .valid(pressed_en), .out(pressed_lvl) // 输出
    );
    queue_logic q(
        .pressed_en(pressed_en), .pressed_lvl(pressed_lvl), .pos_lvl(pos_lvl), .queue(queue), .tail(tail), // 输入
        .stop_at_pos_lvl(stop_at_pos_lvl), .next_queue_sub(next_queue_sub), .next_tail_sub(next_tail_sub)  // 输出
    );
endmodule
