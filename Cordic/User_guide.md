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
   - CORDIC input angle: 14-bit signed integer  
     `-8192` to `+8191` ↔ `-π/2` to `+π/2`
   - Output:  
     `sin_out`, `cos_out` are 14-bit signed, ranging from `-8191` to `+8191`.

2. **Phase Accumulator + FSM Logic:**
   - The FSM divides the full `0–2π` range into **4 quadrants**.
   - Internally maps each quadrant's phase to the CORDIC input range.
   - Output signs are corrected based on the quadrant via a **14-cycle pipeline**.

3. **Set Frequency using `M`:**
   - `M` is a 14-bit signed **frequency control word**.
   - Larger values of `M` yield higher output frequency.
   - Example: `M = 14'd200` produces a low-frequency waveform.

4. **Simulate:**
   - Use `main_phase_14bit_tb.v` to simulate the full system.
   - Run the waveform viewer to observe:
     - `sin_out`, `cos_out`
     - `phase_acc` values cycling
     - Correct quadrant control (`state`)

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

- **To adapt for unsigned angles:**
  - Add logic to convert unsigned angles to signed range (`-π` to `+π`).

---


