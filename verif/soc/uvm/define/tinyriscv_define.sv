uvm_cmdline_processor inst;

typedef enum int {
    ORIGIN,
    NEW
} soc_mode_t;

function automatic void get_int_arg_value(string cmdline_str, ref int val);
    string s;
    if(inst.get_arg_value(cmdline_str, s)) begin
        val = s.atoi();
    end
endfunction: get_int_arg_value

function automatic void get_bool_arg_value(string cmdline_str, ref bit val);
    string s;
    if(inst.get_arg_value(cmdline_str, s)) begin
        val = s.atobin();
    end
endfunction: get_bool_arg_value

function automatic void get_hex_arg_value(string cmdline_str, ref bit [31:0] val);
    string s;
    if(inst.get_arg_value(cmdline_str, s)) begin
        val = s.atohex();
    end
endfunction: get_hex_arg_value

class cmdline_enum_processor #(parameter type T = soc_mode_t);
    static function void get_array_values(string cmdline_str, ref T vals[]);
        string s;
        void'(inst.get_arg_value(cmdline_str, s));
        if(s != "") begin
            string cmdline_list[$];
            T value;
            uvm_split_string(s, ",", cmdline_list);
            vals = new[cmdline_list.size];
            foreach (cmdline_list[i]) begin
                if (uvm_enum_wrapper#(T)::from_name(cmdline_list[i].toupper(), value)) begin
                    vals[i] = value;
                end else begin
                    `uvm_fatal("ENUM", $sformatf("Invalid value (%0s) specified in command line: %0s", cmdline_list[i], cmdline_str))
                end
            end
        end
    endfunction

    static function void get_array_value(string cmdline_str, ref T val);
        string s;
        void'(inst.get_arg_value(cmdline_str, s));
        if(s != "") begin
            T value;
            if (uvm_enum_wrapper#(T)::from_name(s.toupper(), value)) begin
                val = value;
            end else begin
                `uvm_fatal("ENUM", $sformatf("Invalid value (%0s) specified in command line: %0s", s, cmdline_str))
            end
        end
    endfunction: get_array_value
endclass