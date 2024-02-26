interface rib_if#(
        WIDTH = 32
    )(
        input clk, rst
    );

    logic [WIDTH-1:0] addr;
    logic [WIDTH-1:0] wdata;
    logic [WIDTH-1:0] rdata;
    logic             req;
    logic             we;

endinterface: rib_if