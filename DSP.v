module dsp(
    A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,
    RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
    CEA,CEB,CEM,CEC,CED,CECARRYIN,CEOPMODE,CEP,PCIN,
    BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF
);
    parameter A0REG = 0;
    parameter A1REG = 1;
    parameter B0REG = 0;
    parameter B1REG = 1;
    parameter CREG = 1;
    parameter DREG = 1;
    parameter MREG = 1;
    parameter PREG = 1;
    parameter CARRYINREG = 1;
    parameter CARRYOUTREG = 1;
    parameter OPMODEREG = 1;
    parameter CARRYINSEL = "OPMODE5"; 
    parameter B_INPUT = "DIRECT";
    parameter RSTTYPE = "SYNC"; 
    parameter ABD_WIDTH = 18;
    parameter CP_WIDTH = 48;
    parameter OPMODE_WIDTH = 8;
    parameter MUL_OUT_WIDTH = 36;
    input CLK;
    input RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
    input CEA,CEB,CEM,CEC,CED,CECARRYIN,CEOPMODE,CEP;
    input [ABD_WIDTH-1 : 0] A,B,D,BCIN;
    input [CP_WIDTH-1 : 0] C,PCIN;
    input CARRYIN;
    input [OPMODE_WIDTH-1 : 0]OPMODE;
    output [CP_WIDTH-1 : 0]P,PCOUT;
    output [ABD_WIDTH-1 : 0]BCOUT;
    output [MUL_OUT_WIDTH-1 : 0] M;
    output CARRYOUT,CARRYOUTF;
    wire [7:0]OPMODE_mux;
    wire [ABD_WIDTH-1 : 0] A_mux,B_mux,B_mux_in,D_mux,pre_adder_out,pre_mux_out;
    wire [ABD_WIDTH-1 : 0] mul_in1,mul_in2;
    wire [MUL_OUT_WIDTH-1 : 0] mul_out,M_mux;
    wire [CP_WIDTH-1 : 0] C_mux,P_post_adder_out;
    reg [CP_WIDTH-1 : 0] X_out,Z_out;
    wire CIN,carr_cascade,carry_cascade_mux,cout;
    //Opmodesssssssss
    mux_ff #(.INPUT_WIDTH(8), .OUTPUT_WIDTH(8), .RSTTYPE(RSTTYPE)) op10 (OPMODE[7:0],OPMODE_mux,OPMODEREG,CLK,RSTOPMODE,CEOPMODE); 
    //inistentiation of the mux's + ff
    mux_ff #(.RSTTYPE(RSTTYPE)) ain (A,A_mux,A0REG,CLK,RSTA,CEA); // A
    mux_ff #(.RSTTYPE(RSTTYPE)) bin (B_mux_in,B_mux,B0REG,CLK,RSTB,CEB); // B
    mux_ff #(.RSTTYPE(RSTTYPE)) din (D,D_mux,DREG,CLK,RSTD,CED); // D
    mux_ff #(.INPUT_WIDTH(CP_WIDTH), .OUTPUT_WIDTH(CP_WIDTH), .RSTTYPE(RSTTYPE)) cin (C,C_mux,CREG,CLK,RSTC,CEC); // C
    mux_ff #(.RSTTYPE(RSTTYPE)) mul1 (pre_mux_out,mul_in1,B1REG,CLK,RSTB,CEB);   // mul in1 
    mux_ff #(.RSTTYPE(RSTTYPE)) mul2 (A_mux,mul_in2,A1REG,CLK,RSTA,CEA);        // mul in2
    mux_ff #(.INPUT_WIDTH(MUL_OUT_WIDTH),.OUTPUT_WIDTH(MUL_OUT_WIDTH), .RSTTYPE(RSTTYPE)) mul_muxff(
        mul_out,M_mux,MREG,CLK,RSTM,CEM
    );
    mux_ff #(.INPUT_WIDTH(1), .OUTPUT_WIDTH(1), .RSTTYPE(RSTTYPE)) carryin (carr_cascade,CIN,CARRYINREG,CLK,RSTCARRYIN,CECARRYIN); // carry in
    mux_ff #(.INPUT_WIDTH(1), .OUTPUT_WIDTH(1), .RSTTYPE(RSTTYPE)) CarryOut (cout,CARRYOUT,CARRYOUTREG,CLK,RSTCARRYIN,CECARRYIN); // carry out
    mux_ff #(.INPUT_WIDTH(CP_WIDTH),.OUTPUT_WIDTH(CP_WIDTH), .RSTTYPE(RSTTYPE)) p_mux(
        P_post_adder_out,P,PREG,CLK,RSTP,CEP
    );
    assign B_mux_in = (B_INPUT == "DIRECT")?B :(B_INPUT == "CASCADE")? BCIN: 0; 
    assign pre_mux_out = (OPMODE_mux[4])? pre_adder_out:B_mux;
    assign BCOUT = mul_in1;
    assign mul_out = mul_in1 * mul_in2; 
    assign M = M_mux;
    assign carr_cascade = (CARRYINSEL == "OPMODE5")? OPMODE_mux[5]: CARRYIN;
    assign pre_adder_out = (OPMODE_mux[6])? (D_mux - B_mux): (D_mux + B_mux);
    assign {cout,P_post_adder_out} = (OPMODE_mux[7])? (Z_out-(X_out+CIN)): (Z_out + X_out + CIN);
    assign CARRYOUTF = CARRYOUT;
    assign PCOUT = P;
    //X MUX
    always @(*) begin
        case (OPMODE_mux[1:0])
            0: X_out = 48'd0;
            1: X_out = {12'd0,M_mux};
            2: X_out = PCOUT;
            3: X_out = {D_mux[11:0],mul_in2,mul_in1};
        endcase
    end
    //Z MUX
    always @(*) begin
        case (OPMODE_mux[3:2])
            0: Z_out =  48'd0;
            1: Z_out = PCIN;
            2: Z_out = P;
            3: Z_out = {12'd0,C_mux};
        endcase
    end
endmodule
