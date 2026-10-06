# Concepts
- The Opcode defines the operation of the ALU and as such once it determines what goes out and the other operation(7 other operations in an 8-bitb ALU) are left behind
- A combinational Logic is an operation that uses only its input to determine its output while sequential logic has an extra layer which is the memory to determine the output 
- A latch is an accidental memory and it happens in situations like when a wire is not assigned in the always block 
- Simualation is using a tool such as verilator to create a virtual environment to simulate what the HDL code defines while synthesis is converting this code into the actual gates. So simulation checks if the code behaves correctly while the synthess checks what the code eventually becomes.

# Hand-calculations
- 200 + 100 = $200 = 1100_1000 + 0110_0100 = 10010_1100; 
- 8-bit Result: 0010_1100, Carry Flag: 1;
- 3 -10 = -7 = 1111 1001;
- 1000_0001 shifted to the right  = 0000_0010
- 1000_0001 shifted to the left = 0100_0000;

# Flag Decisions
-Carry on SUBTRACT: should carry be 1 when a borrow happens (A smaller than B), or when it doesn't? Hint: look at your answer to calculation 2.
### 1. Carry Flag on SUBTRACT (`SUB`)
* **The Question:** When executing a subtraction ($A - B$), should the `carry` flag be set to `1` when a **borrow occurs** ($A < B$), or when **no borrow occurs** ($A \ge B$)?
* **Why it matters:** Architecturally, subtraction in digital hardware is performed by adding the Two's Complement of $B$:
  $$\text{Result} = A + \sim B + 1$$
  When $A \ge B$, the 9th bit out of this adder evaluates to `1`. When $A < B$ (a borrow occurs), bit 8 is `0`.
* **Standard CPU Implementations:**
  * **x86 Architecture:** Sets `Carry = 1` to mean *borrow happened* (inverting the raw hardware adder carry-out).
  * **ARM Architecture:** Sets `Carry = 1` to mean *no borrow happened* (directly outputting the hardware adder's carry-out).
* **Your Action:** Choose one convention (e.g., `Carry = 1` when $A < B$ for intuitive borrow indication, or raw carry-out) and document your choice in `design_notes.md`.

---

-Carry on SHIFT LEFT and SHIFT RIGHT: should carry be 0, or should it hold the bit that fell off? Hint: calculations 3 and 4.
### 2. Carry Flag on SHIFT LEFT (`SHL`) & SHIFT RIGHT (`SHR`)
* **The Question:** Should the `carry` flag be forced to `0`, or should it capture the bit that gets shifted out of the register?
* **Why it matters:** 
  * In a left shift (`SHL`), the Most Significant Bit (MSB, bit 7) is pushed off the left edge.
  * In a right shift (`SHR`), the Least Significant Bit (LSB, bit 0) is pushed off the right edge.
* **Best Practice:** Routing the discarded bit into the `carry` flag allows software to detect hardware overflow during multiplication (`SHL`) or retain the remainder during integer division (`SHR`).
* **Your Action:** Decide whether your shifter will dump lost bits into `carry` or set `carry = 0`.

---
-Carry on AND, OR, XOR and COMPARE: what should it be, and why?
### 3. Carry Flag on Logic Operations (`AND`, `OR`, `XOR`, `CMP`)
* **The Question:** What should the `carry` flag output during non-arithmetic operations?
* **Why it matters:** Logic gates operate on individual bits and do not generate arithmetic carries or borrows. Leaving the carry flag undefined or holding garbage values can cause subtle bugs downstream.
* **Standard Practice:** Most RISC architectures clear the carry flag (`carry = 0`) during bitwise logical operations and comparisons.
* **Your Action:** Confirm that `carry = 0` for `AND`, `OR`, `XOR`, and `CMP`, or state if you choose a different behavior.

---
-COMPARE when A equals B: result is 1, so what does the zero flag show? Is that a problem?
### 4. Zero Flag on COMPARE (`CMP`)
* **The Question:** The specification states that for a `CMP` operation ($A == B$), the 8-bit `result` output should equal `8'h01` (or `1`). Given that `result` is non-zero, what should the `zero` flag output?
* **Why it matters:** 
  * Normally, the `zero` flag is driven by checking if the main ALU output equals zero:
    $$\text{zero} = (\text{result} == 8'h00)$$
  * If $A == B$, the operation output is `8'h01`. Evaluating `zero` off the output `result` would make `zero = 0`, even though $A$ and $B$ were equal.
* **Design Choice:**
  * **Option A (Pure Output-Driven):** `zero` flag simply checks `(result == 8'h00)`. For `CMP`, `result = 8'h01`, so `zero = 0`. Software checks equality by inspecting `result` directly.
  * **Option B (Comparison-Driven):** `zero` flag explicitly checks whether $A == B$ directly, making `zero = 1` when inputs match regardless of `result`.
* **Your Action:** Choose Option A or Option B and write one sentence explaining why it makes sense for your control path.

---