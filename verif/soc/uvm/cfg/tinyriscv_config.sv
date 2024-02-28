class tinyriscv_config extends uvm_object;

    soc_kernel_t kernel_type;
    string origin_kernel_name;

    bit[31:0] shake_hand_addr = 'h1FFF_FFFC;
    bit[31:0] shake_done_pass_data = 'hEDED_AAAA;
    bit[31:0] shake_done_fail_data = 'hEDED_FFFF;

    `uvm_object_utils(tinyriscv_config)

    function new(string name="tinyriscv_config");
        super.new(name);
        inst = uvm_cmdline_processor::get_inst();
        cmdline_enum_processor#(soc_kernel_t)::get_enum_value("+kernel_type=", kernel_type);
        inst.get_arg_value("+origin_kernel_name=", origin_kernel_name);
    endfunction: new

endclass: tinyriscv_config