class tinyriscv_env extends uvm_env;

    tinyriscv_config cfg;
    virtual rib_if ram_vif;
    virtual soc_probe_if probe_vif;
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
        if(!uvm_config_db#(virtual rib_if)::get(this, "", "ram_vif", ram_vif)) begin
            `uvm_fatal(`gfn, "cannot get ram_vif form config db")
        end
        uvm_config_db#(virtual rib_if)::set(this, "*", "ram_vif", ram_vif);
        if(!uvm_config_db#(virtual soc_probe_if)::get(this, "", "probe_vif", probe_vif)) begin
            `uvm_fatal(`gfn, "cannot get probe_vif form config db")
        end
        uvm_config_db#(virtual soc_probe_if)::set(this, "*", "probe_vif", probe_vif);
        vsqr = tinyriscv_virtual_sequencer::type_id::create("vsqr", this);
        ram_mon = tinyriscv_ram_monitor::type_id::create("ram_mon", this);
    endfunction: build_phase

endclass: tinyriscv_env