module testbench_mult();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
    logic   Clk,     // Internal
    Reset_Load_Clear,   // Push button 0
    Run,   // Push button 1
    LoadB;   // Push button 2
    logic [7:0]  SW;     // input data

    logic [7:0]  Aval, Bval;    // DEBUG        
    logic X_in, M; 
    //input and output logic changed to 8 bits
    logic [6:0]  HEX0,
    HEX1,
    HEX2,
    HEX3;

// logic Clr_Ld, Shift_En, Add_En, Sub_En;
// 	 logic Ld_A, Ld_B, newB, opA, opB, bitA, bitB;
// 	 logic [7:0] A, B, SWval, newA;
//    logic Reset_SH, Run_SH;

// To store expected results
logic [7:0] ans_1a, ans_2b;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
Processor processor0(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset_Load_Clear = 0;		// Toggle Rest
Run = 0;
SW = 8'hC5;	// Specify Din, F, and R


#5 Reset_Load_Clear = 1;
#5 Reset_Load_Clear = 0;
#8 SW = 8'h07;

#5 Run = 1'b1;

#30 Run = 1'b0;
    ans_1a = 16'h0054;
    if ({Aval, Bval} != ans_1a)
     ErrorCnt++;

#6 SW = 8'h10;
#2 Reset_Load_Clear = 1;
#2 Reset_Load_Clear = 0;

#2 SW = 8'hFD;
#2 Run = 1;
#30 Run = 0;
    ans_1a = 16'hFFD0;
   if ({Aval, Bval} != ans_1a)
     ErrorCnt++;

#2 SW = 8'hF4;
#2 Reset_Load_Clear = 1;
#2 Reset_Load_Clear = 0;

#2 SW = 8'h05;
#2 Run = 1;
#30 Run = 0;
    ans_1a = 16'hFFC4;
   if ({Aval, Bval} != ans_1a)
     ErrorCnt++;

#2 SW = 8'hF3;
#2 Reset_Load_Clear = 1;
#2 Reset_Load_Clear = 0;

#2 SW = 8'hFA;
#2 Run = 1;
#30 Run = 0;
    ans_1a = 16'h004E;
   if ({Aval, Bval} != ans_1a)
     ErrorCnt++;

if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule
