This is a hardware data structure in Verilog inspired by elevator queueing. The idea is a user can press a button to add themselves to the queue. When the elevator reaches the user, they are removed from the queue. I wrote this to practice testbenching and verification.
- If queue is empty, add added_entry to end of queue
- If subtracted_entry is in queue, remove it
- See queue_logic/testbench.v for behaviour details
- See diagrams.pdf for block diagrams and digital circuits
- See fpga/ additional modules when using the design on a Lattice iCE40 FPGA (archived)