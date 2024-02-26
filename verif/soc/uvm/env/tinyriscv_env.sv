class tinyriscv_env extends uvm_env;

    tinyriscv_config cfg;
    virtual rib_if ram_vif;
    tinyriscv_virtual_sequencer vsqr;

    tinyriscv_ram_monitor ram_mon;

    `uvm_component_utils(tinyriscv_env)
    `uvm_component_new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(tinyriscv_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal(`gfn, "cannot get cfg from config db")
        end
        uvm_config_db#(tinyriscv_config)::set(this, "*", "cfg", cfg);
        if(!uvm_config_db#(virtual rib_if)::get(this, "", "ram_if", ram_vif)) begin
            `uvm_fatal(`gfn, "cannot get ram_if form config db")
        end
        uvm_config_db#(virtual rib_if)::set(this, "*", "ram_if", ram_vif);
        vsqr = tinyriscv_virtual_sequencer::type_id::create("vsqr", this);
        ram_mon = tinyriscv_ram_monitor::type_id::create("ram_mon", this);
    endfunction: build_phase

endclass: tinyriscv_env