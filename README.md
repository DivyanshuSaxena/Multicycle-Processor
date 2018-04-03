# Multi Cycle ARM Processor 
This repository is for the Computer Architecture Assignment to develop a multi-cycle ARM Processor in VHDL.  
The Processor implements the following instructions:  
1. Arithmetic: <add|sub|rsb|adc|sbc|rsc> {cond} {s}  
2. Logical: <and | orr | eor | bic> {cond} {s}  
3. Test:  <cmp | cmn | teq | tst> {cond}  
4. Move:  <mov | mvn> {cond} {s}  
5. Branch: <b | bl> {cond}  
6. Multiply: <mul | mla> {cond} {s}  
7. Load/store: <ldr | str> {cond} {b | h | sb | sh }  
cond:  <EQ|NE|CS|CC|MI|PL|VS|VC|HI|LS|GE|LT|GT|LE|AL>  
