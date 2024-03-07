class tinyriscv_base_test extends uvm_test;

    tinyriscv_config cfg;
    tinyriscv_env env;

    `uvm_component_utils(tinyriscv_base_test)
    `uvm_component_new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = tinyriscv_config::type_id::create("cfg");
        uvm_config_db#(tinyriscv_config)::set(this, "env", "cfg", cfg);
        env = tinyriscv_env::type_id::create("env", this);
    endfunction: build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_root::get().set_report_max_quit_count(10);
        uvm_root::get().set_timeout(1ms);
    endfunction: end_of_elaboration_phase

    function void start_of_simulation_phase(uvm_phase phase);
        string cmd;
        if(cfg.kernel_type == ORIGIN) begin
            cmd = $sformatf("python3 $REPO_BASE/tools/BinToMem_CLI.py $REPO_BASE/tests/isa/generated/%0s.bin inst.data", cfg.origin_kernel_name);
            if($system(cmd))
                `uvm_fatal(`gfn, "Generate inst.data failed")
            else
                `uvm_info(`gfn, "Generate inst.data successed", UVM_LOW)
        end else begin
            cmd = $sformatf("python3 $REPO_BASE/verif/soc/asm/asm_gen.py");
            if($system(cmd))
                `uvm_fatal(`gfn, "Generate asm failed")
            else
                `uvm_info(`gfn, "Generate asm successed", UVM_LOW)
            cmd = $sformatf("python3 $REPO_BASE/tools/BinToMem_CLI.py asm.bin inst.data");
            if($system(cmd))
                `uvm_fatal(`gfn, "Generate inst.data failed")
            else
                `uvm_info(`gfn, "Generate inst.data successed", UVM_LOW)
        end
    endfunction: start_of_simulation_phase

    task run_phase(uvm_phase phase);
        tinyriscv_base_virtual_sequence vseq = tinyriscv_base_virtual_sequence::type_id::create("vseq");
        vseq.start(env.vsqr);
    endtask: run_phase

endclass: tinyriscv_base_test