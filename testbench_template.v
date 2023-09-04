// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

// Define our testbench
module testbench();

    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;

    // 寄存器（输入）
    reg my_input;
    // 导线（输出）
    wire my_output;
    // 预期输出
    wire expected;

    // Instantiate the unit under test (UUT)
    my_module uut(
        // 输入
        .my_input(my_input),
        // 输出
        .my_output(my_output)
    );

    // 验证输出值
    task check_ans();
	begin
            if (my_output != expected) begin
		$display("ERROR: output mismatch!");
		$display("expected: %b", expected);
		$display("got:      %b", my_output);
		$finish;
            end
	end
    endtask

    // Toggle inputs and check output
    initial begin
        my_input = 0;
        expected = 0;
        #10;
        check_ans();

        my_input = 0;
        expected = 0;
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
