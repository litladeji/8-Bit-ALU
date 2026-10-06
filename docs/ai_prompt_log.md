## Entry 1: Day 1 Planning

**What I asked:** 
I requested a structured actionable guide and breakdown for completing Day 1 of the 8-Bit ALU starter project, including explanations of core RTL concepts and key specification decisions.

**What the AI gave me:** 
The AI provided an overview of core concepts (combinational vs. sequential logic, simulation vs. synthesis, latches), a breakdown of hand calculations (overflow, Two's Complement, shifting), and four flag design decisions required to clarify edge cases in the spec.

**What I kept or changed, and why:** 
* **Kept:** The step-by-step hand calculation method and the flag edge case decisions (borrow convention for SUB, capturing shifted-out bits for SHL/SHR, and output-driven Zero flag logic).
* **Changed:** Formatted the explanation directly into custom Markdown sections inside `design_notes.md` to keep documentation clear and aligned with the project repository requirements.