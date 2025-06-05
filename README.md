# Direct Digital Synthesis (DDS) Generator  
**Sine/Cosine Wave Generation using LUT & CORDIC**  


## 📌 Overview
Two Verilog-Vivado implementations of DDS (Direct Digital Synthesis):
1. **LUT-Based** (Look-Up Table) - Fast, memory-intensive  
2. **CORDIC-Based** - Iterative, memory-efficient  

## 🏗️ Repository Structure
DDS-Generator/ <br>
├── LUT-Based-DDS/ # LUT implementation <br>
│ ├── full_sine.v # Main module+ Test bench<br>
│ ├── blk_mem_gen_0.xci # Xilinx RO IP<br>
│ ├── full_sin_LUT.coe # coefficient file for implementing directly in block ROM<br>
│ └── coe_full_sine.m # Matlab code for building the coe<br>
| └── User_guide.md # Usage instructions<br>
│<br>
└── CORDIC-Based-DDS/ # CORDIC implementation<br>
├── cordic_dds.sv # CORDIC pipeline<br>
├── tb_cordic_dds.sv # Testbench<br>
└── USER-GUIDE.md # Configuration guide<br>


## 🔧 LUT-Based DDS
### Features
- ✅ 12-bit phase
- ✅ 14-bit amplitude(one signed bit)
- ✅ Xilinx Block Memory optimized

### Usage
Check User guide in the LUT_full_sine directory

## ⚙️ CORDIC-Based DDS
### Features
- ✅ No precomputed tables
- ✅ Memory efficient
- ✅ Fully pipelined

### Usage
Check User guide in the Cordic directory

## 📊 Comparison
| Metric       | LUT-Based         | CORDIC-Based      |
|-------------|------------------|-------------------|
| **Latency** | 1 cycle          | (#iterations) cycles |
| **Memory**  | High (ROM)       | None              |
| **Precision**| Fixed           | Adjustable        |
