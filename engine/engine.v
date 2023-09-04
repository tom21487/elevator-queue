module engine (
    input [11:0] queue,
    input [3:0] ipmod30,
    input [1:0] pos_lvl,
    input [2:0] tail,
    output stop_at_pos_lvl,
    output [11:0] next_queue_sub,
    output [2:0] next_tail_sub
);
    // 导线
    wire pressed_en;
    wire [1:0] pressed_lvl;
    wire pressed_lvl_in_queue;
    // 组合逻辑
    priority_encoder pe(
        .in(ipmod30),                         // 输入
        .valid(pressed_en), .out(pressed_lvl) // 输出
    );
    pressed_lvl_in_queue_logic pl(
        .pressed_en(pressed_en), .pressed_lvl(pressed_lvl), .queue(queue), // 输入
        .pressed_lvl_in_queue(pressed_lvl_in_queue)                        // 输出
    );
    queue_logic q(
        .pressed_en(pressed_en), .pressed_lvl(pressed_lvl), .pressed_lvl_in_queue(pressed_lvl_in_queue), .pos_lvl(pos_lvl), .queue(queue), .tail(tail), // 输入
        .stop_at_pos_lvl(stop_at_pos_lvl), .next_queue_sub(next_queue_sub), .next_tail_sub(next_tail_sub)                                               // 输出
    );
    assign stop_at_pos_lvl = 0;
    assign next_queue_sub = 0;
    assign next_tail_sub = 0;
endmodule
