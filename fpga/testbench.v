// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps
// Define our testbench
module testbench();
    // 寄存器（输入）
    reg clk;
    reg [4:0] pmod;
    // 导线（输出）
    wire [4:0] led;
    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;
    localparam HALF_PERIOD = 41.67;
    // Instantiate the unit under test (UUT)
    elevator uut (
        .clk(clk),
        .pmod(pmod),
        .led(led)
    );
    // Generate FPGA clock signal: 1 / ((2 * 41.67) * 1 ns) = 11,999,040.08 Hz = 12 MHz
    always begin
        // Delay for 41.67 time units
        // 10 ps precision means that 41.667 is rounded to 41.67
        #HALF_PERIOD;        
        // Toggle clock line
        clk = ~clk;
    end
    // Pulse reset line high at the beginning
    initial begin
        pmod[4] = 1'b1;
        #HALF_PERIOD;
        #HALF_PERIOD;
        pmod[4] = 1'b0;
    end
    // Toggle inputs
    initial begin
        clk = 0;
        pmod[3:0] = 0;
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
