# 🧭 USER GUIDE – LUT-Based Direct Digital Synthesizer (DDS)

This directory provides a LUT-based DDS design using Verilog and Xilinx IP. It outputs sine and cosine values based on a tunable frequency control word.

---

## 📁 File Descriptions

- `full_sine.v`  
  ➤ Contains the **main DDS module** and **testbench**, with comments for clarity and ease of understanding.

- `blk_mem_gen_0.xci`  
  ➤ Xilinx **Block Memory Generator IP** declaration for accessing LUT data.

- `full_sin_LUT.coe`  
  ➤ COE file containing **14-bit signed sine values** over a full cycle (0 to 2π), used to initialize the block ROM.

- `coe_full_sine.m`  
  ➤ MATLAB script to generate or modify `.coe` files for LUTs with custom resolution and bit width.

- `USER-GUIDE.md`  
  ➤ This guide – explains usage, setup, and file relationships.

---

## ✅ How to Use

1. **Generate the Block ROM IP:**
   - Open **Vivado**, go to *IP Catalog*, and instantiate the **Block Memory Generator**.
   - Set the following parameters:
     - Memory depth: `4096`
     - Data width: `14`
     - Initialization file: `full_sin_LUT.coe`
   - Name the module `blk_mem_gen_0` to match the Verilog reference.

2. **Add the IP to Your Project:**
   - Include the generated `blk_mem_gen_0.xci` and its dependencies.
   - Ensure the `.coe` file is accessible during synthesis/simulation.

3. **Simulate or Modify Behavior:**
   - Use the provided testbench in `full_sine.v`.
   - Adjust the input `M` to set output frequency.
   - Observe `sin_out` and `cos_out` for sine/cosine waveforms derived from the LUT.

4. **Customize the LUT (Optional):**
   - Run `coe_full_sine.m` in MATLAB to generate a new `.coe` file with custom bit width or resolution.
   - Replace `full_sin_LUT.coe` with the new file and regenerate the ROM IP in Vivado.

---

## 📌 Notes

- The cosine output is derived by phase-shifting the sine index by 1024 (i.e., 90° offset for 12-bit phase resolution).
- You can easily change phase width and data width in the Verilog to adapt the design for other applications.

---


