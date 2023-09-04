// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

// Define our testbench
module testbench();

    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;

    // 寄存器（输入）
    reg add_new_lvl;
    reg [1:0] pressed_lvl;
    reg [7:0] queue;
    reg [2:0] tail;
    // 导线（输出）
    wire [7:0] next_queue_add;

    // Instantiate the unit under test (UUT)
    next_queue_add_logic uut(
        // 输入
        .add_new_lvl(add_new_lvl),
        .pressed_lvl(pressed_lvl),
        .queue(queue),
        .tail(tail),
        // 输出
        .next_queue_add(next_queue_add)
    );

    // 验证队列任务
    task check_queue(
        input [7:0] queue_expected
    );
        if (next_queue_add != queue_expected) begin
            $display("ERROR: queue mismatch!");
            $display("expected: %b", queue_expected);
            $display("got:      %b", queue);
            $finish;
        end
    endtask

    // Toggle inputs and check output
    initial begin
        add_new_lvl = 0;
        pressed_lvl = 0;
        queue = 0;
        tail = 0;
        // Queue:
        // 0: [00] <= tail
        // 1: [00]
        // 2: [00]
        // 3: [00]
        #10;
        check_queue(8'b00000000);

        add_new_lvl = 1;
        pressed_lvl = 2;
        // Queue:
        // 0: [10] <= tail
        // 1: [00]
        // 2: [00]
        // 3: [00]
        #10;
        check_queue(8'b00000010);
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
