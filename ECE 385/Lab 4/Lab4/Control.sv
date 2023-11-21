//Two-always example for state machine

module control (input  logic Clk, Reset_Load_Clear, Run, m,
                output logic Shift_En, Ld_A, Add_En, Sub_En );

    // Declare signals curr_state, next_state of type enum
    // with enum values of Reset, ADD1, ..., ADD3 as the state values
	 // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    enum logic [4:0] {Reset, ADD1, SHIFT1, ADD2, SHIFT2, ADD3, SHIFT3, ADD4, SHIFT4, ADD5, SHIFT5, ADD6, SHIFT6, ADD7, SHIFT7, SUB, SHIFT8, HOLD}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Reset_Load_Clear)
            curr_state <= Reset;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
        
		  next_state  = curr_state;	//required because SHIFT4 haven't enumerated all possibilities below
        unique case (curr_state) 

            Reset :    if (Run)     //Reset-Default
                        next_state = ADD1;
            ADD1 :    next_state = SHIFT1;  //First Add

            SHIFT1 :    if (m) begin   //First Shift
                next_state = ADD2;     //
            end else begin
                next_state = SHIFT2;
            end
            ADD2 :    next_state = SHIFT2;  //Second Add
            
            SHIFT2 :    if (m) begin
                next_state = ADD3;     
            end else begin
                next_state = SHIFT3;  //
            end
            ADD3 :    next_state = SHIFT3;  //Third Add
            
			SHIFT3 :	   if (m) begin
                next_state = ADD4;
            end else begin
                next_state = SHIFT4;
            end  //Third Shift
			ADD4 :    next_state = SHIFT4;  //Fourth Add

            SHIFT4 :    if (m) begin
                next_state = ADD5;
            end else begin
                next_state = SHIFT5;
            end  //Fourth Shift
			ADD5 :    next_state = SHIFT5;  //Fifth Add

            SHIFT5 :    if (m) begin
                next_state = ADD6;
            end else begin
                next_state = SHIFT6;
            end  //Fifth Shift
            ADD6 :    next_state = SHIFT6;  //Sixth Add

            SHIFT6 :    if (m) begin
                next_state = ADD7;
            end else begin
                next_state = SHIFT7;
            end  //Sixth Shift
            ADD7 :    next_state = SHIFT7;  //Seventh Add

            SHIFT7 :    if (m) begin
                next_state = SUB;
            end else begin
                next_state = SHIFT8;
            end  //Seventh Shift
			SUB :	   next_state = SHIFT8;  //Eighth Add

			SHIFT8 :    next_state = HOLD;  //Eight Shift
			HOLD :   if (~Run)     //Hold State
                  next_state = Reset;
							  
        endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   Reset: 
	         begin

                Shift_En = 1'b0;
                Add_En = 1'b1;
                Sub_En = 1'b0;
                Ld_A = 1'b0;
		      end
            //Add States
           ADD1, ADD2, ADD3, ADD4, ADD5, ADD6, ADD7:
                begin
                    Add_En = 1'b0;
                    Shift_En = 1'b0;
                    Sub_En = 1'b0;

                    Ld_A = 1'b1;
                end
            //Shift States
            SHIFT1, SHIFT2, SHIFT3, SHIFT4, SHIFT5, SHIFT6, SHIFT7:
                begin
                    Add_En = 1'b1;
                    Shift_En = 1'b1;
                    Sub_En = 1'b0;

                    Ld_A = 1'b0;
                end
            //Subtract State
            SUB: 
                begin
                    Sub_En = 1'b1;
                    Add_En = 1'b0;
                    Shift_En = 1'b0;

                    Ld_A = 1'b1;
                end
            //Hold State
	   	   HOLD: 
		      begin
                Sub_En = 1'b0;
                Add_En = 1'b0;

                Shift_En = 1'b0;
                Ld_A = 1'b0;
		      end
	   	   default:  //default case, can also have default assignments for Ld_A and Ld_B before case
		      begin 

                Shift_En = 1'b1;
                Add_En = 1'b0;
                Sub_En = 1'b0;
                Ld_A = 1'b0;
		      end
        endcase
    end

endmodule
