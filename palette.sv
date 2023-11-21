module palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h9, 4'h8, 4'hE}, //Transparent color, unused
	{4'h7, 4'h6, 4'h1}, //brown
	{4'hD, 4'h9, 4'h2}, //italian
	{4'hA, 4'h3, 4'h2}, //red
    {4'hE, 4'hB, 4'hA}, //white/creame color
	{4'h1, 4'h9, 4'h0}, //green
	{4'h2, 4'h1, 4'h1}, //black
	{4'hC, 4'h7, 4'h0}, //orange
	{4'h0, 4'h0, 4'h0}, 
	{4'h0, 4'h0, 4'h0},
	{4'h0, 4'h0, 4'h0},
	{4'h0, 4'h0, 4'h0},
	{4'h0, 4'h0, 4'h0},
	{4'h0, 4'h0, 4'h0},
	{4'h0, 4'h0, 4'h0},
	{4'h0, 4'h0, 4'h0}
};

assign {red, green, blue} = palette[index];

endmodule