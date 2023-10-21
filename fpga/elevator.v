module elevator (
    input clk,
    input [4:0] pmod,
    output [4:0] led
);
    integer i;
    // 寄存器。
    reg [11:0] queue; // 4层，每层位宽为3。
    reg [2:0] tail;
    reg [1:0] pos_lvl;
    // 导线。
    wire clk_divided;
    wire rst;
    wire [11:0] next_queue;
    wire [2:0] next_tail;
    wire [1:0] next_pos_lvl;
    wire [3:0] pmod30;
    // 组合逻辑。
    assign rst = ~pmod[4];
    assign ipmod30 = ~pmod[3:0];
    clk_divider c(
        .clk(clk), .rst(rst),     // 输入
        .clk_divided(clk_divided) // 输出
    );
    engine e(.queue(queue), .ipmod30(ipmod30), .pos_lvl(pos_lvl), .tail(tail),            // 输入
             .stop_at_pos_lvl(led[4]), .next_queue_sub(next_queue), .next_tail_sub(next_tail)   // 输出
    );
    pos_lvl_logic l(.pos_lvl(pos_lvl), .tail(tail), .queue(queue), // 输入
                    .next_pos_lvl(next_pos_lvl)                    // 输出
    );
    decoder d(.in2(pos_lvl),  // 输入
              .out4(led[3:0]) // 输出
    );
    // 时序逻辑。
    always @ (posedge clk_divided) begin
        if (rst) begin
            queue   <= 0;
            tail    <= 0; // 这个表明队列是空的
            pos_lvl <= 0; // 从第零层开始
        end else begin
            queue   <= next_queue;
            tail    <= next_tail;
            pos_lvl <= next_pos_lvl;
        end
    end
endmodule
