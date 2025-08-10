module mux_ff(
    in,out,reg_select,clk,rst,clk_en
);
    parameter INPUT_WIDTH = 18;
    parameter OUTPUT_WIDTH = 18;    
    parameter RSTTYPE = "SYNC";

    input [INPUT_WIDTH-1 : 0]in;
    input clk,rst,reg_select,clk_en; 
    output [OUTPUT_WIDTH-1 : 0] out;

    reg [INPUT_WIDTH-1 : 0 ]in_reg;

    generate
        if (RSTTYPE == "SYNC") begin
            always @(posedge clk) begin  // DFF
                if (rst) begin
                    in_reg <= 0;
                end
                else if (clk_en) begin                
                    in_reg <= in;
                end
            end

            assign out = (reg_select)? in_reg : in; // mux
        end
        else begin
            always @(posedge clk, posedge rst) begin  // DFF
                if (rst) begin
                    in_reg <= 0;
                end
                else if (clk_en) begin
                    in_reg <= in;
                end
            end

            assign out = (reg_select)? in_reg : in;
        end
    endgenerate
endmodule
