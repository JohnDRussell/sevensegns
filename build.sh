#!/bin/bash
ghdl -a debounce.vhdl
ghdl -e debounce
ghdl -a sevensegns.vhdl
ghdl -e main_7_seg
ghdl -a sevensegns_tb.vhdl
ghdl -e sevensegns_tb
ghdl -r sevensegns_tb --vcd=sevens.vcd


