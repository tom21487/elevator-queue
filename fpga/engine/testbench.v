// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

// Define our testbench
module testbench();

    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;
    // 楼层枚举值
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    // 寄存器（输入）
    reg [3:0] ipmod30;
    reg [1:0] pos_lvl;
    reg [2:0] tail;
    reg [7:0] queue;
   
    // 导线（输出）
    wire stop_at_pos_lvl;
    wire [7:0] next_queue_sub;
    wire [2:0] next_tail_sub;
    
    // 预期输出
    reg stop_at_pos_lvl_expected;
    reg [7:0] next_queue_sub_expected;
    reg [2:0] next_tail_sub_expected;

    // Instantiate the unit under test (UUT)
    engine uut (
        // 输入
        .ipmod30(ipmod30),
        .pos_lvl(pos_lvl),
        .tail(tail),
        .queue(queue),
        // 输出
        .stop_at_pos_lvl(stop_at_pos_lvl),
        .next_queue_sub(next_queue_sub),
        .next_tail_sub(next_tail_sub)
    );

    // 验证输出值
    task check_ans();
        begin
            if (stop_at_pos_lvl != stop_at_pos_lvl_expected) begin
		$display("ERROR: stop_at_pos_lvl mismatch!");
		$display("expected: %b", stop_at_pos_lvl_expected);
		$display("got:      %b", stop_at_pos_lvl);
		$finish;
            end
            if (next_queue_sub != next_queue_sub_expected) begin
		$display("ERROR: next_queue_sub mismatch!");
		$display("expected: %b", next_queue_sub_expected);
		$display("got:      %b", next_queue_sub);
		$finish;
            end
            if (next_tail_sub != next_tail_sub_expected) begin
		$display("ERROR: next_tail_sub mismatch!");
		$display("expected: %b", next_tail_sub_expected);
		$display("got:      %b", next_tail_sub);
		$finish;
            end
	end
    endtask

    // Toggle inputs and check output
    initial begin
        // Start the queue empty and at level 0
        ipmod30 = 4'b0000; // No button was pressed by the user.
        pos_lvl = 2'b00;
        queue = 8'b00000000;
        tail = 3'b000;
        stop_at_pos_lvl_expected = 0;
        next_queue_sub_expected = 8'b00000000;
        next_tail_sub_expected = 3'b000;
        #10;
        check_ans();

        // Now user presses level 0
        // Level 0 is now queued
        ipmod30 = 4'b0001;
        pos_lvl = 2'b00;
        queue = 8'b00000000;
        tail = 3'b000;
        stop_at_pos_lvl_expected = 1;
        next_queue_sub_expected = 8'b00000000;
        next_tail_sub_expected = 3'b000;
        #10;
        check_ans();
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
