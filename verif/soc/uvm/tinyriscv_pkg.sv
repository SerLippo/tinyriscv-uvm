package tinyriscv_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "uvm/cfg/tinyriscv_config.sv"

    `include "uvm/agt/tinyriscv_ram_monitor.sv"
    `include "uvm/sqr/tinyriscv_virtual_sequencer.sv"
    `include "uvm/env/tinyriscv_env.sv"

    `include "uvm/seq/tinyriscv_base_virtual_sequence.sv"

    `include "uvm/test/tinyriscv_base_test.sv"

endpackage: tinyriscv_pkg