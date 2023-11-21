//8-bit logic processor top level module rewritten for Lab 4 multiplier


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module Processor (input logic   Clk,     // Internal
                                Reset_Load_Clear,   // Push button 0
                                Run,   // Push button 1
                  input  logic [7:0]  SW,     // input data

                  output logic [7:0]  Aval,    // DEBUG
                                Bval,    // DEBUG        
						output logic X_in, M, 
						//input and output logic changed to 8 bits
                  output logic [6:0]  HEX0,
                                HEX1,
                                HEX2,
                                HEX3
);

	 //local logic variables go here
	 logic Clr_Ld, Shift_En, Add_En, Sub_En;
	 logic Ld_A, Ld_B, newB, opA, opB, bitA, bitB;
	 logic [7:0] A, B, SWval, newA;
   logic Reset_SH, Run_SH;
	 //We can use the "assign" statement to do simple combinational logic
	 assign Aval = A;
	 assign Bval = B;
   assign SWval = SW;
   assign Ld_B = Reset_SH;
	 //assign LED = {Execute_SH,LoadA_SH,LoadB_SH,Reset_SH}; //Concatenate is a common operation in HDL
	 
	 
	 //Instantiation of modules here
	 register_unit    reg_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH), 
                        .Ld_A,//note these are inferred assignments, because of the existence a logic variable of the same name
                        .Ld_B(Reset_SH),
                        .Shift_En,
                        .sum(newA), 
                        .D(SWval),
                        .A_In(X_in),
                        .B_In(opA),
                        .A_out(opA),
                        .B_out(opB),
                        .A(A),
                        .B(B) );


	 control          control_unit (
                        .Clk(Clk),
                        .Reset_Load_Clear(Reset_SH),
                        .Run(Run_SH),
                        .m(opB), 
                        .Shift_En,
                        .Ld_A,
                        .Add_En,
                        .Sub_En );

    
    mult        multiplier (
                .A(Aval),
                .SW(SWval),
                .clk(Clk),
                .Shift_En,
                .Add_En, 
                .Sub_En,
                .newA(newA),
                .X_in(X_in),
                .Reset(Reset_SH),
                .Ld_X(Ld_A)
                );
					//Redefine hex drivers
	 HexDriver        HexAL (
                        .In0(A[3:0]),
                        .Out0(HEX0) );
	 HexDriver        HexBL (
                        .In0(B[3:0]),
                        .Out0(HEX2) );
								
	 //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
	 HexDriver        HexAU (
                        .In0(A[7:4]), //Values changed from zeros to upper nibble 
                        .Out0(HEX1) );	
	 HexDriver        HexBU (
                       .In0(B[7:4]),
                        .Out0(HEX3) );
								
	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[1:0] (Clk, {Reset_Load_Clear, Run}, {Reset_SH, Run_SH});
	  sync SW_sync[7:0] (Clk, SW, SW_S);

	  
endmodule
