class tinyriscv_base_virtual_sequence extends uvm_sequence;

    tinyriscv_config cfg;
    virtual rib_if ram_vif;

    `uvm_declare_p_sequencer(tinyriscv_virtual_sequencer)
    `uvm_object_utils(tinyriscv_base_virtual_sequence)
    `uvm_object_new

    virtual task body();
        cfg = p_sequencer.cfg;
        ram_vif = p_sequencer.ram_vif;
        waiting_end_signal();
    endtask: body

    virtual task waiting_end_signal();
        bit[`RegBus] x3, x26, x27;
        while(1) begin
            uvm_hdl_read("tinyriscv_top.x26", x26);
            #10;
            if(x26 == 1)
                break;
        end
        #100;
        uvm_hdl_read("tinyriscv_top.x3", x3);
        uvm_hdl_read("tinyriscv_top.x26", x26);
        uvm_hdl_read("tinyriscv_top.x27", x27);
        if (x27 == 32'b1) begin
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
            `uvm_error(`gfn, $sformatf("fail testnum = %2d", x3));
        end
    endtask: waiting_end_signal

endclass: tinyriscv_base_virtual_sequence