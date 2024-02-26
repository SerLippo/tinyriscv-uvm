`timescale 1ns/1ps

module tinyriscv_top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "defines.v"
    import tinyriscv_pkg::*;

    logic clk;
    logic rst;

    always #10 clk = ~clk; // 50MHz

    rib_if ram_if(.*);

    wire[`RegBus] x3 = tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[3];
    wire[`RegBus] x26 = tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[26];
    wire[`RegBus] x27 = tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[27];

    initial begin
        clk = 0;
        rst = `RstEnable;
        repeat(5) @(posedge clk);
        $readmemh("inst.data", tinyriscv_soc_top_0.u_rom._rom);
        repeat(5) @(posedge clk);
        rst = `RstDisable;
    end

    initial begin
        uvm_config_db#(virtual rib_if)::set(uvm_root::get(), "uvm_test_top.env", "ram_if", ram_if);
        run_test();
    end

    tinyriscv_soc_top tinyriscv_soc_top_0(
        .clk(clk),
        .rst(rst),
        .uart_debug_pin(1'b0)
    );

    assign ram_if.addr  = tinyriscv_soc_top_0.u_ram.addr_i;
    assign ram_if.wdata = tinyriscv_soc_top_0.u_ram.data_i;
    assign ram_if.rdata = tinyriscv_soc_top_0.u_ram.data_o;
    assign ram_if.we    = tinyriscv_soc_top_0.u_ram.we_i;

endmodule: tinyriscv_top