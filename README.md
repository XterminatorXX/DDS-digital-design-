# Direct Digital Synthesis (DDS) Generator  
**Sine/Cosine Wave Generation using LUT & CORDIC**  


## 📌 Overview
Two Verilog implementations of DDS (Direct Digital Synthesis):
1. **LUT-Based** (Look-Up Table) - Fast, memory-intensive  
2. **CORDIC-Based** - Iterative, memory-efficient  

## 🏗️ Repository Structure
DDS-Generator/
├── LUT-Based-DDS/ # LUT implementation
│ ├── full_sine.sv # Main module
│ ├── blk_mem_gen_0.xci # Xilinx ROM IP
│ ├── tb_full_sine.sv # Testbench
│ └── USER-GUIDE.md # Setup instructions
│
└── CORDIC-Based-DDS/ # CORDIC implementation
├── cordic_dds.sv # CORDIC pipeline
├── tb_cordic_dds.sv # Testbench
└── USER-GUIDE.md # Configuration guide


## 🔧 LUT-Based DDS
### Features
- ✅ 12-bit phase, 14-bit amplitude
- ✅ 1-cycle latency
- ✅ Xilinx Block Memory optimized

### Usage
See [USER-GUIDE](LUT-Based-DDS/USER-GUIDE.md) for:
- Vivado IP setup
- Simulation steps
- Customization

## ⚙️ CORDIC-Based DDS
### Features
- ✅ No precomputed tables
- ✅ Adjustable precision
- ✅ Fully pipelined

### Usage
See [USER-GUIDE](CORDIC-Based-DDS/USER-GUIDE.md) for:
- Iteration tuning
- Resource estimates

## 📊 Comparison
| Metric       | LUT-Based         | CORDIC-Based      |
|-------------|------------------|-------------------|
| **Latency** | 1 cycle          | (#iterations) cycles |
| **Memory**  | High (ROM)       | None              |
| **Precision**| Fixed           | Adjustable        |
