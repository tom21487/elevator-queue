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
    reg [3:0] in;
    // 导线（输出）
    wire valid;
    wire [1:0] out;
    // 预期输出
    reg valid_expected;
    reg [1:0] out_expected;

    // Instantiate the unit under test (UUT)
    priority_encoder uut(
        // 输入
        .in(in),
        // 输出
	.valid(valid),
        .out(out)
    );

    // 验证输出值
    task check_ans();
	begin
            if (valid != valid_expected) begin
		$display("ERROR: valid mismatch!");
		$display("expected: %b", valid_expected);
		$display("got:      %b", valid);
		$finish;
            end
            if (out != out_expected) begin
		$display("ERROR: out mismatch!");
		$display("expected: %b", out_expected);
		$display("got:      %b", out);
		$finish;
            end
	end
    endtask

    // Toggle inputs and check output
    initial begin
        in = 4'b0000;
        valid_expected = 0;
	out_expected = 2'b00;
        #10;
        check_ans();

        in = 4'b0001;
	valid_expected = 1;
        out_expected = 2'b00;
        #10;
        check_ans();

	in = 4'b001x;
	valid_expected = 1;
	out_expected = 2'b01;
	#10;
	check_ans();

	in = 4'b01xx;
	valid_expected = 1;
	out_expected = 2'b10;
	#10;
	check_ans();

	in = 4'b1xxx;
	valid_expected = 1;
	out_expected = 2'b11;
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
