# 🧭 USER GUIDE – CORDIC-Based Direct Digital Synthesizer (DDS)

This project implements a **CORDIC-based DDS** system in Verilog targeting an **RFSoC device**. It outputs high-resolution sine and cosine signals using a **pipelined, quadrant-aware architecture** without any block memory or IP cores.

---

## 📁 File Descriptions

- `cordic_algo_14bit.v`  
  ➤ Implements the **CORDIC rotation algorithm** with 14-bit input/output using a 13-stage pipelined datapath. Computes sine and cosine from signed angle input.

- `main_phase_14bit.v`  
  ➤ Top-level DDS module. Contains:
    - A **phase accumulator with FSM-based quadrant control**
    - A pipeline to manage CORDIC latency and correct output sign
    - Integration with `cordic_algo_14bit.v`

- `cordic_algo_14bit_tb.v`  
  ➤ Basic testbench for **standalone CORDIC** to verify correct sine/cosine output from fixed angle input.

- `main_phase_14bit_tb.v`  
  ➤ Testbench for the **complete DDS system**. Simulates real-time sine/cosine wave generation with configurable frequency.

---


## ✅ How to Use

1. **Understand Input/Output Range:**
   - The CORDIC module uses a **14-bit signed angle input**, spanning:
     ```
     -8192 to +8191 → represents -π/2 to +π/2
     ```
   - The output sine and cosine values are also **14-bit signed integers**, ranging approximately:
     ```
     sin_out, cos_out ∈ [-6741, +6741]
     ```
   - CORDIC introduces a **gain** (`K`) due to vector rotations:
     - For **13 iterations**, the gain is approximately:
       ```
       K ≈ 0.60725
       ```
     - To retrieve the actual sine/cosine values:
       ```
       sin_actual = (sin_out / 4096) * K
       cos_actual = (cos_out / 4096) * K
       ```
     - ✳️ Example:
       ```
       If sin_out = 6741
       sin_actual = (6741 / 4096) * 0.60725 ≈ 0.99938 ≈ 1.0
       ```

2. **Phase Accumulator + FSM Logic:**
   - The **FSM** divides the full `0 – 2π` range into 4 quadrants.
   - Internally maps each quadrant’s phase into the CORDIC's accepted `-π/2 to +π/2` input range.
   - The correct sign of sine and cosine is restored after a **14-cycle pipeline delay**, accounting for the CORDIC latency and FSM decisions.

3. **Set Frequency using `M`:**
   - `M` is a 14-bit signed **frequency control word**.
   - The output frequency `f_out` is computed as:
     ```
     f_out = (M / 2^N) * f_clk
     where:
       M     = frequency control word
       N     = phase accumulator width (here, N = 14)
       f_clk = system clock frequency (e.g., 200 MHz)
     ```
   - ✳️ Example:
     ```
     M = 200
     f_out = (200 / 16384) * 200e6 = 2.441 MHz
     ```
     When observed in simulation, the output is ≈ 2.440 MHz, confirming the formula’s accuracy.

4. **Simulate:**
   - Use `main_phase_14bit_tb.v` to simulate the full DDS pipeline.
   - Open the waveform viewer (e.g., Vivado or ModelSim):
     - Set `sin_out` and `cos_out` **radix to "Signed Decimal"** for correct waveform visualization.
     - Use analog plotting to view sine and cosine waveforms smoothly.
   - Observe:
     - `sin_out`, `cos_out` waveform shapes
     - `phase_acc` cycling across 0 to 2π
     - Quadrant transitions via the `state` signal

---


## 📌 Notes

- 💡 No external IP or memory used. RTL-only design.
- 🧱 Fully pipelined with 13 clock cycles latency (CORDIC iterations).
- 🎯 Optimized for high-speed real-time operation (200 MHz tested).
- 🎚️ Ready for DAC integration or SDR/communications front-ends.

---

## 🛠️ Customization

- **To modify precision:**
  - Change internal signal widths from `14` to desired bit width.
  - Update `atan_table[]` with precomputed values scaled to your format.

- **To change CORDIC iterations:**
  - Update:
    - Array sizes for `x`, `y`, `z`, `state_pipeline`
    - Loop bounds for iteration logic
    - Arctangent table values

---


