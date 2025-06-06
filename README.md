# Direct Digital Synthesis (DDS) Generator  
**Sine/Cosine Wave Generation using LUT & CORDIC**  
The phase bit width (12-bit) and data bit width (14-bit) were selected to match the requirements of my RF-SoC board and DAC interface. You can easily adapt these widths in the code to suit your hardware constraints." 


## 📌 Overview
Two Verilog-Vivado implementations of DDS (Direct Digital Synthesis):
1. **LUT-Based** (Look-Up Table) - Fast, memory-intensive  
2. **CORDIC-Based** - Iterative, memory-efficient  

## 🏗️ Repository Structure
DDS-Generator/ <br>
├── LUT_full_sine/ # LUT implementation <br>
│ ├── full_sine.v # Main module+ Test bench<br>
│ ├── blk_mem_gen_0.xci # Xilinx RO IP<br>
│ ├── full_sin_LUT.coe # coefficient file for implementing directly in block ROM<br>
│ └── coe_full_sine.m # Matlab code for building the coe<br>
│ └── User_guide.md # Usage instructions<br>
│<br>
└── CORDIC/ # CORDIC implementation<br>
│ ├──main_14bit.v # Main module+ Test bench<br>
│ ├── cordic_algo_14bit.v # cordic algorithm with RTL code+test bench <br>
│ └── User_guide.md # Usage instructions<br>


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
