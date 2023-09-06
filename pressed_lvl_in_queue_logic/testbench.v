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
    reg [1:0] pressed_lvl;
    reg [7:0] queue;
    reg [2:0] tail;
    // 导线（输出）
    wire pressed_lvl_in_queue;
    // 预期输出
    reg pressed_lvl_in_queue_expected;

    // Instantiate the unit under test (UUT)
    pressed_lvl_in_queue_logic uut(
        // 输入
	.pressed_lvl(pressed_lvl),
	.queue(queue),
	.tail(tail),
        // 输出
        .pressed_lvl_in_queue(pressed_lvl_in_queue)
    );

    // 验证输出值
    task check_ans();
	begin
            if (pressed_lvl_in_queue != pressed_lvl_in_queue_expected) begin
		$display("ERROR: output mismatch!");
		$display("expected: %b", pressed_lvl_in_queue_expected);
		$display("got:      %b", pressed_lvl_in_queue);
		$finish;
            end
	end
    endtask

    // Toggle inputs and check output
    initial begin
	// Test 0: Pressed lvl in queue.
        pressed_lvl = B;
	queue[1:0] = A;
	queue[3:2] = B;
	queue[5:4] = C;
	queue[7:6] = D;
        tail = 4;
	pressed_lvl_in_queue_expected = 1;
        #10;
        check_ans();

	// Test 1: Pressed lvl not in queue.
        pressed_lvl = D;
	queue[1:0] = A;
	queue[3:2] = B;
	queue[5:4] = C;
	queue[7:6] = C; // This situation could happen from a shift up.
        tail = 3;
	pressed_lvl_in_queue_expected = 0;
        #10;
        check_ans();

	// Test 2: Pressed lvl in queue but tail is invalid.
        pressed_lvl = D;
	queue[1:0] = A;
	queue[3:2] = B;
	queue[5:4] = C;
	queue[7:6] = D;
        tail = 3;
	pressed_lvl_in_queue_expected = 0;
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
