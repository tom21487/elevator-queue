# Elevator Queue
Random-access buffer in Verilog, supporting random-access deletion and queue-like insertion.
## Inspiration
When waiting for an elevator, a user can press a button to add themselves to the queue. When the elevator reaches the user, they are removed from the queue. While actual elevators use more efficient algorithms, the mechanics of elevators inspired me to write this project to practice buffer design and verification.
## Examples
```
Test 0: add added_entry
Input:
- Current entry: A
- Queued entries: [ B, C ]
- State to add: D
Output:
- Current entry in queue: no
- Queued entries: [ B, C, D ]     
```

```
 Test 1: subtract current_entry
 Input:
 - Current entry: C
 - Queued entries: [ A, C, B ]
 - State to add: none
 Output:
 - Current entry in queue: yes
 - Queued entries: [ A, B ]
 ```

```
 Test 2: don't add because added_entry_in_queue
 Input:
 - Current entry: C
 - Queued entries: [ A ]
 - State to add: A
 Output:
 - Current entry in queue: no
 - Queued entries: [ A ]
 ```

```
 Test 3: don't subtract because tail is out of bounds
 Input:
 - Current entry: D
 - Queued entries: [ A ]
 - State to add: none
 Output:
 - Current entry in queue: no
 - Queued entries: [ A ]
```

```
 Test 4: add and subtract at the same time (different levels)
 Input:
 - Current entry: B
 - Queued entries: [ B ]
 - States to add: A
 Output:
 - Current entry in queue: yes
 - Queued entries: [ A ]
```

```
 Test 5: add and subtract at the same time (same level, full)
 Input: 
 - Current entry: C
 - Queued entries: [ D, C, A, B ]
 - State to add: C
 Output:
 - Current entry in queue: yes
 - Queued entries: [ D, A, B ]
```

```
 Test 6: add and subtract at the same time (same level, not full)
 Input:
 - Current entry: C
 - Queued entries: [ D, C, A ]
 - State to add: C
 Output:
 - Current entry in queue: yes
 - Queued entry: [ D, A ]
```
## Files
- **Makefile**: Build information.
- **queue_logic/testbench.v**: System-level testbench.
  - Every module has its own unit-level testbench.
- **diagrams.pdf**: Block diagrams and digital circuits.
- **fpga/**: Additional modules when using the design on an FPGA (ex. Lattice iCE40). This is only partially complete.
