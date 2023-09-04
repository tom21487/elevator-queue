module add_new_lvl_logic (
    input pressed_en,
    input pressed_lvl,
    input [7:0] queue,
    input [2:0] tail,
    output add_new_lvl
);
    // 变量
    genvar i;
    // 导线
    wire [3:0] pressed_lvl_in_qentries;
    // 触发信号
    reg pressed_lvl_in_queue;
    // 1. Set up GitHub
    // 2. Create a pressed_lvl_in_queue_logic
    // 组合逻辑
    for (i = 0; i < 4; i = i+1) begin
	pressed_lvl_in_qentry_logic pliq(
	    // 输入
            .pressed_lvl(pressed_lvl),
            .qentry(queue[i*2+1:i*2]),
            .tail(tail),
	    // 输出
	    .pressed_lvl_in_qentry(pressed_lvl_in_qentries[i])
	);
	pressed_lvl_in_queue = pressed_lvl_in_queue | pressed_lvl_in_qentries[i];
    end
    assign add_new_lvl = pressed_en & ~pressed_lvl_in_queue;
endmodule
