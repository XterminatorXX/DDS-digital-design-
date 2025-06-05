# Direct Digital Synthesis (DDS) Generator  
**Sine/Cosine Wave Generation using LUT & CORDIC**  


## 📌 Overview
Two Verilog implementations of DDS (Direct Digital Synthesis):
1. **LUT-Based** (Look-Up Table) - Fast, memory-intensive  
2. **CORDIC-Based** - Iterative, memory-efficient  

## 🏗️ Repository Structure
DDS-Generator/ <br>
├── LUT-Based-DDS/ # LUT implementation <br>
│ ├── full_sine.sv # Main module<br>
│ ├── blk_mem_gen_0.xci # Xilinx RO IP<br>
│ ├── tb_full_sine.sv # Testbench<br>
│ └── USER-GUIDE.md # Setup instructions<br>
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
