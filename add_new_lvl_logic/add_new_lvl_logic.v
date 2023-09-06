module add_new_lvl_logic (
    input pressed_en,
    input [1:0] pressed_lvl,
    input [7:0] queue,
    input [2:0] tail,
    output add_new_lvl
);
    // 导线
    wire pressed_lvl_in_queue;
    // 组合逻辑
    pressed_lvl_in_queue_logic pliq(
        // 输入
	.pressed_lvl(pressed_lvl),
	.queue(queue),
	.tail(tail),
	// 输出
	.pressed_lvl_in_queue(pressed_lvl_in_queue)
    );
    assign add_new_lvl = pressed_en & ~pressed_lvl_in_queue;
endmodule
