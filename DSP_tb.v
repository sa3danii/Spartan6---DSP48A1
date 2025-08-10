module tb();
    parameter ABD_WIDTH = 18;
    parameter CP_WIDTH = 48;
    parameter OPMODE_WIDTH = 8;
    parameter MUL_OUT_WIDTH = 36;
    reg CLK;
    reg RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;
    reg CEA,CEB,CEM,CEC,CED,CECARRYIN,CEOPMODE,CEP;
    reg [ABD_WIDTH-1 : 0] A,B,D,BCIN;
    reg [CP_WIDTH-1 : 0] C,PCIN;
    reg CARRYIN;
    reg [OPMODE_WIDTH-1 : 0]OPMODE;
    wire [CP_WIDTH-1 : 0]P_dut,PCOUT_dut;
    wire [ABD_WIDTH-1 : 0]BCOUT_dut;
    wire [MUL_OUT_WIDTH-1 : 0] M_dut;
    wire CARRYOUT_dut,CARRYOUTF_dut;
    reg [CP_WIDTH-1 : 0]P_ex,PCOUT_ex;
    reg [ABD_WIDTH-1 : 0]BCOUT_ex;
    reg [MUL_OUT_WIDTH-1 : 0] M_ex;
    reg CARRYOUT_ex,CARRYOUTF_ex;
    dsp DUT(A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
    CEA,CEB,CEM,CEC,CED,CECARRYIN,CEOPMODE,CEP,PCIN,BCOUT_dut,PCOUT_dut,P_dut,M_dut,CARRYOUT_dut,CARRYOUTF_dut);
    initial begin
        CLK = 0;
        forever begin
            #1 CLK = ~CLK;
        end
    end    
    initial begin
        RSTA=1; RSTB=1; RSTM=1; RSTP=1;RSTC=1; RSTD=1; RSTCARRYIN=1; RSTOPMODE=1;
        CEA=$random; CEB=$random; CEM=$random; CEC=$random; CED=$random; CECARRYIN=$random; CEOPMODE=$random; CEP=$random; 
        A=$random; B=$random; D=$random; BCIN=$random; OPMODE=$random; 
        C=$random; PCIN=$random; CARRYIN=$random; 
        @(negedge CLK)
        if (P_dut !== 0 || PCOUT_dut !== 0 || BCOUT_dut !== 0 || M_dut !== 0 || CARRYOUT_dut !== 0 || CARRYOUTF_dut !== 0)begin
            $display("Error in reset condition");
            $stop;
        end
        RSTA=0; RSTB=0; RSTM=0; RSTP=0; RSTC=0; RSTD=0; RSTCARRYIN=0; RSTOPMODE=0;
        CEA=1; CEB=1; CEM=1; CEC=1; CED=1; CECARRYIN=1; CEOPMODE=1; CEP=1;
        //verify path 1
        A = 20; B = 10; C = 350; D = 25;
        OPMODE = 8'b11011101;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        BCOUT_ex = 18'hf;
        M_ex = 36'h12c;
        P_ex = 48'h32;  
        PCOUT_ex = 48'h32;
        CARRYOUT_ex = 0;
        CARRYOUTF_ex = 0;
        repeat(4)begin
          @(negedge CLK);
        end
        if (BCOUT_dut != BCOUT_ex || M_ex != M_dut || P_dut != P_ex || PCOUT_dut != PCOUT_ex || CARRYOUT_dut != CARRYOUT_ex || CARRYOUTF_dut!=CARRYOUTF_ex) begin
            $display("Error in Path 1");
            $stop;
        end
        //verify path 2
        A=20; B=10; C=350; D=25;
        OPMODE = 8'b00010000;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        BCOUT_ex = 18'h23;
        M_ex = 36'h2bc;
        P_ex = 48'h0;  
        PCOUT_ex = 48'h0;
        CARRYOUT_ex = 0;
        CARRYOUTF_ex = 0;
        repeat(3)begin
          @(negedge CLK);
        end
        if (BCOUT_dut != BCOUT_ex || M_ex != M_dut || P_dut != P_ex || PCOUT_dut != PCOUT_ex || CARRYOUT_dut != CARRYOUT_ex || CARRYOUTF_dut!=CARRYOUTF_ex) begin
            $display("Error in Path 2");
            $stop;
        end
        //verify path 3
        A=20; B=10; C=350; D=25;
        OPMODE = 8'b00001010;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        BCOUT_ex = 18'ha;
        M_ex = 36'hc8;
        P_ex = 48'h0;  
        PCOUT_ex = 48'h0;
        CARRYOUT_ex = 0;
        CARRYOUTF_ex = 0;
        repeat(3)begin
          @(negedge CLK);
        end
        if (BCOUT_dut != BCOUT_ex || M_ex != M_dut || P_dut != P_ex || PCOUT_dut != PCOUT_ex || CARRYOUT_dut != CARRYOUT_ex || CARRYOUTF_dut!=CARRYOUTF_ex) begin
            $display("Error in Path 3");
            $stop;
        end
        //verify path 4
        A=5; B=6; C=350; D=25;
        OPMODE = 8'b10100111;
        BCIN = $random; PCIN = 3000; CARRYIN = $random;
        BCOUT_ex = 18'h6;
        M_ex = 36'h1e;
        P_ex = 48'hfe6fffec0bb1;  
        PCOUT_ex = 48'hfe6fffec0bb1;
        CARRYOUT_ex = 1;
        CARRYOUTF_ex = 1;
        repeat(3)begin
          @(negedge CLK);
        end
        if (BCOUT_dut != BCOUT_ex || M_ex != M_dut || P_dut != P_ex || PCOUT_dut != PCOUT_ex || CARRYOUT_dut != CARRYOUT_ex || CARRYOUTF_dut!=CARRYOUTF_ex) begin
            $display("Error in Path 4");
            $stop;
        end
        $stop;
    end
endmodule 