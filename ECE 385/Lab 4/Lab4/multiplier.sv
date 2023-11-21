module mult(
    input logic [7:0] A, SW,
    input logic Shift_En, Add_En, Sub_En, clk,
    output logic [7:0] newA,
    output logic X_in,
    input logic Reset, Ld_X
);
logic X_out;
logic [7:0] C, c1, c2;
logic cin;
always_comb
begin
   c1 = SW;
   c2 = ~SW;
end
always_ff @ (posedge clk)
begin
    if (Reset) begin
        X_in <= 1'b0;
    end
    if (Ld_X)
        X_in <= X_out;
end



adder Add1(.A({A[7], A[7:0]}), .B({C[7], C[7:0]}), .cin(cin), .S(newA), .X_out(X_out));
mux2_4 mux1(.S(Add_En), .A({c1, 1'b0}), .B({c2, 1'b1}), .Q_out({C, cin}));
endmodule

module adder(
    input  logic [8:0] A, B,
	input  logic        cin,
	output logic [7:0] S,
	output logic      X_out, cout
);
    logic c1, c2, c3, c4, c5, c6, c7, c8;
    full_adder FA0 (.x (A[0]), .y (B[0]), .z (cin), .s (S[0]), .c (c1));
    full_adder FA1 (.x (A[1]), .y (B[1]), .z (c1), .s (S[1]), .c (c2));
    full_adder FA2 (.x (A[2]), .y (B[2]), .z (c2), .s (S[2]), .c (c3));
    full_adder FA3 (.x (A[3]), .y (B[3]), .z (c3), .s (S[3]), .c (c4));
    full_adder FA4 (.x (A[4]), .y (B[4]), .z (c4), .s (S[4]), .c (c5));
    full_adder FA5 (.x (A[5]), .y (B[5]), .z (c5), .s (S[5]), .c (c6));
    full_adder FA6 (.x (A[6]), .y (B[6]), .z (c6), .s (S[6]), .c (c7));
    full_adder FA7 (.x (A[7]), .y (B[7]), .z (c7), .s (S[7]), .c (c8));
    full_adder FA8 (.x (A[8]), .y (B[8]), .z (c8), .s (X_out), .c (cout));
endmodule




module full_adder (input x, y, z,
 output logic s, c);
assign s = x^y^z;
assign c = (x&y)|(y&z)|(x&z);
endmodule

module mux2_4 (
	input S,
	input [7:0] A, B,
	output logic [8:0] Q_out
);
	always_comb
		begin
				unique case(S)
						1'b0	:	Q_out <= A;
						1'b1	:	Q_out <= B;
				endcase
		end


	
endmodule
