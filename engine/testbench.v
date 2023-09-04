// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps
// Define our testbench
module testbench();
    // 寄存器（输入）
    reg [11:0] queue;
    reg [3:0] ipmod30;
    reg [1:0] pos_lvl;
    reg [2:0] tail;
    // 导线（输出）
    wire stop_at_pos_lvl;
    wire [11:0] next_queue_sub;
    wire [2:0] next_tail_sub;
    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;
    // Instantiate the unit under test (UUT)
    engine uut(
        // 输入
        .queue(queue),
        .ipmod30(ipmod30),
        .pos_lvl(pos_lvl),
        .tail(tail),
        // 输出
        .stop_at_pos_lvl(stop_at_pos_lvl),
        .next_queue_sub(next_queue_sub),
        .next_tail_sub(next_tail_sub)
    );
    // Toggle inputs
    initial begin
        queue = 0;
        ipmod30 = 0;
        pos_lvl = 0;
        tail = 0;
    end
    // Run simulation (output to .vcd file)
    initial begin
        // Create simulation output file
        $dumpfile("testbench.vcd");
        // 0 means look for variables in all levels
        $dumpvars(0, testbench);
        // Wait for given amount of time for simulation to complete
        #(DURATION);
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
endmodule
