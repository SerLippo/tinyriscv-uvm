class tinyriscv_ram_monitor extends uvm_component;

    tinyriscv_config cfg;
    virtual rib_if ram_vif;
    virtual soc_probe_if probe_vif;

    process thread_monitor_done;
    process thread_print_info;
    process thread_monitor_rst;

    bit drop_signal;

    `uvm_component_utils(tinyriscv_ram_monitor)
    `uvm_component_new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(tinyriscv_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal(`gfn, "cannot get cfg from config db")
        end
        if(!uvm_config_db#(virtual rib_if)::get(this, "", "ram_vif", ram_vif)) begin
            `uvm_fatal(`gfn, "cannot get ram_vif form config db")
        end
        if(!uvm_config_db#(virtual soc_probe_if)::get(this, "", "probe_vif", probe_vif)) begin
            `uvm_fatal(`gfn, "cannot get probe_vif form config db")
        end
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        forever begin
            wait(probe_vif.rst == `RstDisable);
            fork
                begin: thread_monitor_done_begin
                    thread_monitor_done = process::self();
                    if(cfg.kernel_type == ORIGIN) begin
                        origin_waiting_done_signal();
                    end else if(cfg.kernel_type == NEW) begin
                        monitor_shake_done_signal();
                    end
                end
                begin: thread_print_info_begin
                    thread_print_info = process::self();
                    monitor_print_info();
                end
                begin: thread_monitor_rst_begin
                    thread_monitor_rst = process::self();
                    wait(probe_vif.rst == `RstEnable);
                    if(thread_monitor_done) thread_monitor_done.kill();
                    if(thread_print_info) thread_print_info.kill();
                end
            join_any
            if(drop_signal) break;
        end
        phase.drop_objection(this);
    endtask: run_phase

    virtual task monitor_print_info();
        forever begin
            wait(ram_vif.addr == cfg.shake_hand_addr);
            @(negedge ram_vif.clk);
            `uvm_info(`gfn, $sformatf("Listening %0x", ram_vif.wdata), UVM_NONE)
        end
    endtask: monitor_print_info

    virtual task monitor_shake_done_signal();
        forever begin
            wait(ram_vif.addr == cfg.shake_hand_addr);
            @(negedge ram_vif.clk);
            case(ram_vif.wdata)
                cfg.shake_done_pass_data: begin
                    drop_signal = 1;
                    `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~ #####   ######       #       #~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "Capture program done in signature addr.", UVM_NONE)
                    break;
                end
                cfg.shake_done_fail_data: begin
                    `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~", UVM_NONE);
                    `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
                    `uvm_fatal(`gfn, "Capture program fatal in signature addr.")
                end
            endcase
        end
    endtask: monitor_shake_done_signal

    virtual task origin_waiting_done_signal();
        wait(probe_vif.x26 == 32'b1)
        #100;
        if (probe_vif.x27 == 32'b1) begin
            `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~ #####   ######       #       #~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
        end else begin
            `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~", UVM_NONE);
            `uvm_info(`gfn, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", UVM_NONE);
            `uvm_error(`gfn, $sformatf("fail testnum = %2d", probe_vif.x3));
        end
        drop_signal = 1;
    endtask: origin_waiting_done_signal

endclass: tinyriscv_ram_monitor