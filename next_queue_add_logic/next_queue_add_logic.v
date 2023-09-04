module next_queue_add_logic (
    // 输入
    input add_new_lvl,
    input [1:0] pressed_lvl,
    input [7:0] queue,
    input [2:0] tail,
    // 输出
    output [7:0] next_queue_add
);
    genvar i;
    generate
        for (i = 0; i < 4; i = i+1) begin
            assign next_queue_add[i*2+1:i*2] = (add_new_lvl & i == tail) ? pressed_lvl : queue[i*2+1:i*2];
        end
    endgenerate
 endmodule
