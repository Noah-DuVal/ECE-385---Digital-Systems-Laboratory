module sprite_rom( 
        input [5:0] char_idx_a,
        input [5:0] char_idx_b,
        input clock,
        input [7:0] address_a, 
        input [7:0] address_b,
        output [3:0] q_a,
        output [3:0] q_b 
         );




// logic [2:0] mario_mem [0:255] /* synthesis ram_init_file = "mario.mif" */;
// logic [2:0] block_mem [0:255] /* synthesis ram_init_file = "block.mif" */;
// logic [2:0] floor_mem [0:255] /* synthesis ram_init_file = "floor.mif" */;
// logic [2:0] shell_mem [0:255] /* synthesis ram_init_file = "koopa_shell.mif" */;
// logic [2:0] goomba_mem [0:255] /* synthesis ram_init_file = "goomba.mif" */;

logic [3:0] mario_pix_a, qblock_pix_a, floor_pix_b, shell_pix_a, goomba_pix_a, brick_pix_a; 
//logic [2:0] mario_pix_b, block_pix_b, floor_pix_b, shell_pix_b, goomba_pix_b; 

mario_rom rom0(.*, .q_a(mario_pix_a));
qblock_rom rom1(.*,.q_a(qblock_pix_a));
floor_rom rom2(.*,.q_a(floor_pix_b));
shell_rom rom3(.*,.q_a(shell_pix_a));
goomba_rom rom4(.*,.q_a(goomba_pix_a));
brick_rom rom5 (.*, .q_a(brick_pix_a));


// always_comb begin
// 	mario_pix_a = mario_mem[address_a];
//     block_pix_a = block_mem[address_a];
//     floor_pix_a = floor_mem[address_a];
//     shell_pix_a = shell_mem[address_a];
//     goomba_pix_a = goomba_mem[address_a];

// end

// always_comb begin
// 	mario_pix_b = mario_mem[address_b];
//     block_pix_b = block_mem[address_b];
//     floor_pix_b = floor_mem[address_b];
//     shell_pix_b = shell_mem[address_b];
//     goomba_pix_b = goomba_mem[address_b];

// end

always_comb begin
    unique case(char_idx_a)
        6'b000000: q_a = qblock_pix_a;
        6'b000001: q_a = brick_pix_a; 
       // 4'b0001: q_a = floor_pix_a; Changing so that the floor is accessed differently 
        6'b000010: q_a = mario_pix_a; 
        6'b000011: q_a = goomba_pix_a; 
        6'b000100: q_a = shell_pix_a; 
        default: q_a = 4'b0000;  
    endcase
end

assign q_b = floor_pix_b; //b address only used for accessing floor sprites because there are so many of them




endmodule

module mario_rom (
        input clock,
        input [7:0] address_a, 
        output [3:0] q_a
);
logic [3:0] mario_mem [0:255] /* synthesis ram_init_file = "mario.mif" */;

always_ff @(posedge clock) begin
    q_a <= mario_mem[address_a];
end

endmodule

module qblock_rom (
        input clock,
        input [7:0] address_a, 
        output [3:0] q_a
);
logic [3:0] qblock_mem [0:255] /* synthesis ram_init_file = "qblock.mif" */;

always_ff @(posedge clock) begin
    q_a <= qblock_mem[address_a];
end

endmodule

module floor_rom ( //This module is different because floor sprites are accessed separate from other sprites. 
        input clock,
        input [7:0] address_b, 
        output [3:0] q_a
);
logic [3:0] floor_mem [0:255] /* synthesis ram_init_file = "floor.mif" */;
// initial begin
// $readmemh("floor.mif", floor_mem);
// end
always_ff @(posedge clock) begin
    q_a <= floor_mem[address_b];
end

endmodule

module goomba_rom (
        input clock,
        input [7:0] address_a, 
        output [3:0] q_a
);
logic [3:0] goomba_mem [0:255]/* synthesis ram_init_file = "goomba.mif" */;
// initial begin
// $readmemh("goomba.mif", goomba_mem);
// end
always_ff @(posedge clock) begin
    q_a <= goomba_mem[address_a];
end

endmodule


// module goomba_rom (
//         input clock,
//         input [7:0] address_a, 
//         output [3:0] q_a
// );
// logic [3:0] goomba_mem [0:255]/* synthesis ram_init_file = "level.mif" */;
// // initial begin
// // $readmemh("goomba.mif", goomba_mem);
// // end
// always_ff @(posedge clock) begin
//     q_a <= goomba_mem[address_a];
// end

// endmodule

module level_rom (
        input clock,
        input [7:0] address_a, 
        output [3:0] q_a
);
logic [3:0] level_mem [0:255]/* synthesis ram_init_file = "level.mif" */;

always_ff @(posedge clock) begin
    q_a <= level_mem[address_a];
end

endmodule

module shell_rom (
        input clock,
        input [7:0] address_a, 
        output [3:0] q_a
);
logic [3:0] shell_mem [0:255] /* synthesis ram_init_file = "koopa_shell.mif" */;

always_ff @(posedge clock) begin
    q_a <= shell_mem[address_a];
end

endmodule

module brick_rom (
        input clock,
        input [7:0] address_a, 
        output [3:0] q_a
);
logic [3:0] brick_mem [0:255] /* synthesis ram_init_file = "brick.mif" */;

always_ff @(posedge clock) begin
    q_a <= brick_mem[address_a];
end

endmodule