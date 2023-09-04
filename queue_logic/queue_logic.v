module queue_logic (
    input pressed_en,
    input [1:0] pressed_lvl,
    input [1:0] pos_lvl,
    input [7:0] queue,
    input [2:0] tail,
    output stop_at_pos_lvl,
    output [7:0] next_queue_sub,
    output [2:0] next_tail_sub
);
    // 导线
    wire add_new_lvl;
    wire [7:0] next_queue_add;
    wire [2:0] next_tail_add;
    // 组合逻辑
    add_new_level_logic anl(
        // 输入
	.pressed_en(pressed_en),
        .pressed_lvl(pressed_lvl),
        .queue(queue),
        .tail(tail),
	// 输出
	.add_new_lvl(add_new_lvl)
    );
    next_queue_add_logic nqa(
        // 输入
        .add_new_lvl(add_new_lvl),
        .pressed_lvl(pressed_lvl),
        .queue(queue),
        .tail(tail),
        // 输出
        .next_queue_add(next_queue_add)
    );
    next_tail_add_logic nta(
        // 输入
        .add_new_lvl(add_new_lvl),
        .tail(tail),
        // 输出
        .next_tail_add(next_tail_add)
    );
    next_queue_sub_logic nqs(
        // 输入
        .pos_lvl(pos_lvl),
        .next_queue_add(next_queue_add),
        .next_tail_add(next_tail_add),
        // 输出
        .next_queue_sub(next_queue_sub),
        .stop_at_pos_lvl(stop_at_pos_lvl)
    );
    next_tail_sub_logic nts(
        // 输入
        .next_tail_add(next_tail_add),
        .stop_at_pos_lvl(stop_at_pos_lvl),
        // 输出
        .next_tail_sub(next_tail_sub)
    );
endmodule
