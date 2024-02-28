class tinyriscv_base_virtual_sequence extends uvm_sequence;

    tinyriscv_config cfg;
    virtual rib_if ram_vif;

    `uvm_declare_p_sequencer(tinyriscv_virtual_sequencer)
    `uvm_object_utils(tinyriscv_base_virtual_sequence)
    `uvm_object_new

    virtual task body();
        cfg = p_sequencer.cfg;
        ram_vif = p_sequencer.ram_vif;
    endtask: body

endclass: tinyriscv_base_virtual_sequence