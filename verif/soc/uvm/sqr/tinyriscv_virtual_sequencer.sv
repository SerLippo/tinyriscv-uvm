class tinyriscv_virtual_sequencer extends uvm_sequencer;

    tinyriscv_config cfg;
    virtual rib_if ram_vif;

    `uvm_component_utils(tinyriscv_virtual_sequencer)
    `uvm_component_new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(tinyriscv_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal(`gfn, "cannot get cfg from config db")
        end
        if(!uvm_config_db#(virtual rib_if)::get(this, "", "ram_vif", ram_vif)) begin
            `uvm_fatal(`gfn, "cannot get ram_vif form config db")
        end
    endfunction: build_phase

endclass: tinyriscv_virtual_sequencer