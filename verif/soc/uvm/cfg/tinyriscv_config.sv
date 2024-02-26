class tinyriscv_config extends uvm_object;

    soc_mode_t soc_mode;

    `uvm_object_utils(tinyriscv_config)

    function new(string name="tinyriscv_config");
        super.new(name);
        inst = uvm_cmdline_processor::get_inst();
        cmdline_enum_processor#(soc_mode_t)::get_array_value("+soc_mode=", soc_mode);
    endfunction: new

endclass: tinyriscv_config