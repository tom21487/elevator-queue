module pressed_lvl_in_queue_logic (
    input [1:0] pressed_lvl,
    input [7:0] queue,
    input [2:0] tail,
    // 输出（触发形）
    output reg pressed_lvl_in_queue
);
    // 变量
    genvar g_idx; // generate
    integer a_idx; // always
    // 导线
    wire [3:0] pressed_lvl_in_qentry;
    // 组合逻辑
    generate
	for (g_idx = 0; g_idx < 4; g_idx = g_idx+1) begin
	    assign pressed_lvl_in_qentry[g_idx] = (queue[g_idx*2+1:g_idx*2] == pressed_lvl) & (tail > g_idx);
	end
    endgenerate
    always @(pressed_lvl_in_qentry) begin
	pressed_lvl_in_queue = 0;
	for (a_idx = 0; a_idx < 4; a_idx = a_idx+1) begin
	    pressed_lvl_in_queue = pressed_lvl_in_queue | pressed_lvl_in_qentry[a_idx];
	end
    end
endmodule
