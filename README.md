Overview
--------
This project implements a DSP48A1-based arithmetic unit in Verilog, inspired by the Xilinx DSP48A1 primitive.
It supports high-speed arithmetic and logic operations with pipeline stages, pre/post adders, carry logic, and cascading support for scalable designs.

Features
--------
Pipeline Registers for high-speed operation

OPMODE Decoding for flexible function selection

Pre-Adder & Post-Adder support

Carry Logic integration

Cascading Support for multi-DSP designs

Fully parameterized for easy modification

Compatible with FPGA synthesis and simulation

Module Structure
-----------------
dsp48a1.v – Main DSP48A1-based arithmetic and logic unit

dsp48a1_tb.v – Testbench for functional verification

opmode_decoder.v – Decodes OPMODE signals to operations

Operation Modes
---------------
The DSP48A1 supports:

Addition / Subtraction

Multiplication

Multiply-Accumulate (MAC)

Bitwise Logic (AND, OR, XOR)

Shift and Pass-Through operations

OPMODE determines the active function, and pipelining ensures maximum throughput.
