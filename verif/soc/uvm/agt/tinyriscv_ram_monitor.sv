class tinyriscv_ram_monitor extends uvm_component;

    tinyriscv_config cfg;
    virtual rib_if ram_vif;

    `uvm_component_utils(tinyriscv_ram_monitor)
    `uvm_component_new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(tinyriscv_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal(`gfn, "cannot get cfg from config db")
        end
        if(!uvm_config_db#(virtual rib_if)::get(this, "", "ram_if", ram_vif)) begin
            `uvm_fatal(`gfn, "cannot get ram_if form config db")
        end
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
    endtask: run_phase

endclass: tinyriscv_ram_monitor