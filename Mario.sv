
//Everything here is copied from lab7.sv .      Will definitely need to be updated. 

  ///////////////////////////////////////////////////////////\
 //////////////////////Start of 7.2 Code////////////////////\\\
///////////////////////////////////////////////////////////\\\\\

module Mario (

	  ///////// Clocks //////
      input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	input logic [7:0] keycode, 
	input logic [7:0] keycode1,
	
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs		

);
 


//logic [11:0] Palette_REG       [8]; 	// Registers
logic pixel_clk, blank, sync; 			//vga_controller vals
logic [9:0] DrawX, DrawY;				//vga_controller vals

logic [10:0] addr; 						//font_rom address.... Choses Glyf
logic [7:0] data;						//font_rom output..... Glyf

//// Declare submodules..e.g. VGA controller, ROMS, etc \\\\

vga_controller vga_controller (.*, .Clk(CLK), .Reset(RESET), .pixel_clk(pixel_clk), .blank(blank), .sync(sync), .DrawX(DrawX), .DrawY(DrawY));

logic [8:0] sprite_row;				//Row of 30
logic [8:0] sprite_col;				//Column of 80

logic pixel;						//Either 1 or 0 determines pixel
logic invert; 
logic [3:0] clr_idx;
logic [3:0] r,g,b;

assign sprite_row = DrawY >> 1;		//DrawY / 2 using bitshfit
assign sprite_col = DrawX >> 1;		//DrawX / 2

always_ff @(posedge CLK) begin
    if (blank) begin
            re_address_a <= (( sprite_row * 252 ) + sprite_col);	//VRAM address
            clr_idx <= q_a;											//gives color index from vram to palette reg
      end
end



always_ff @(posedge pixel_clk) begin
	if (~blank) begin
		red <= 4'b0000;
		blue <= 4'b0000;
		green <= 4'b0000;
	end 								
	else if (DrawX < (504)) begin 			//decides which color
		red <= r;
		green <= g;
		blue <= b;
	end
	else begin
		red <= 4'b0000;
		blue <= 4'b0000; 
		green <= 4'b0000; 
	end	
end

//////////////////////////////////////////////////////\\\
//////////////////////End of 7.2 Code//////////////////\\\
////////////////////////////////////////////////////////\\\

//Buffer inputs and outputs 

logic [15:0]  address_a;
logic [15:0]  re_address_a;
logic [15:0]  wr_address_a;
logic [15:0]  address_b;
logic [3:0]  data_a;
logic [3:0]  data_b;
logic wren_a;
logic wren_b;
logic [3:0]  q_a;
logic [3:0]  q_b;

BufferRAM Buffer(.address_a(address_a), .clock(CLK), .wren_a(wren_a), .data_a(data_a), .q_a(q_a), 
.address_b(address_b), .data_b(data_b), .wren_b(wren_b), .q_b(q_b)); 		//VRAM


//FrameBuffer inputs and outputs 
logic       LD_bgd_all,
		LD_bgd_sprite,
		LD_fgd_sprite;

parameter [14:0] pixels = 15'b111011000100000; 		//(252 * 240 /2) 
parameter [8:0] sprite_pix = 9'b100000000; 
logic [14:0] pix; 
logic [8:0] sp_pix; 
logic [3:0]  sp_y;
logic [4:0] sp_x; 
logic count_start; 
logic sp_count; 
logic sp_done; 
logic done; 
logic [7:0] object; 

framebuffer framebuff (.*); 			//Frame buffer ggbtate machine

always_comb begin
      unique case(blank)
            1'b0: address_a = wr_address_a;
            1'b1: address_a = re_address_a;

      endcase
end

//sprite_ROM inputs and outputs 

logic [5:0] char_idx_a;
logic [5:0] char_idx_b;
logic [7:0] rom_address_a;
logic [7:0] rom_address_b; 
logic [3:0] rom_q_a;
logic [3:0] rom_q_b; 

sprite_rom ROM (.*, .char_idx_a(char_idx_a), .address_a(rom_address_a), .q_a(rom_q_a), .clock(CLK), .address_b(rom_address_b), .q_b(rom_q_b));


//////////////////////////////////////////
////////// Writing to VRAM //////////////
////////////////////////////////////////

//This is simplified for demo and testing purposes



palette pal (.index(clr_idx), .red(r), .green(g), .blue(b) );


//These are hardcoded OAR values for testing and demonstration purposes

///////////////////////////////////////////////////////////////\
/////////// Start of OAR /////////////////////////////////////\\\
/////////////////////////////////////////////////////////////\\\\\

logic [39:0] obj_REG [101];       //Set values later
//logic [9:0] obj_X, obj_Y;
//logic [4:0] Brick, Mario, Goomba, Shell, Cloud, Bush, Q_Block;
// logic [8:0] floor;

///////////////////////////////////
///// Sets the Char indicies /////
/////////////////////////////////



parameter [5:0] Q_Block = 6'b000000;
parameter [5:0] Brick = 6'b000001;
parameter [5:0] Mario = 6'b000010;
parameter [5:0] Goomba = 6'b000011;
parameter [5:0] Shell = 6'b000100;

/***************
assign Cloud = ;
assign Bush = ;
***************/

parameter [8:0] floor = 240 - 32;

logic obj_reset; //This is for setting initial values
logic [3:0] counter ;

// always_ff @(posedge pixel_clk)begin
// 	if (counter == 4'b1111)
// 		obj_reset <= 1'b1; 
// 	else begin
// 		obj_reset <= 1'b0; 
// 		counter <= counter + 1; 
// 		end
// end

logic [39:0] mario_initial, mario_new; //These 
logic [15:0] cam_initial, cam_new; 

// always_ff @ (posedge CLK)begin
// 	unique case(obj_reset)
// 		1'b0: begin
// 			obj_REG[8] <= mario_initial;
// 			cam_REG <= cam_initial;
// 		end
// 		1'b1:begin
// 			obj_REG[8] <= mario_new;
// 			cam_REG <= cam_new;
// 		end

// 	endcase

// end

always_ff @(posedge CLK) begin //Character Register 
	//if(~obj_reset)begin
		begin
		// obj_REG[8][39:34] <= Mario;      
		// obj_REG[8][33:18] <= 16;     
		// obj_REG[8][17:2] <= floor-16; 
		// obj_REG[8][0] <= 1'b1;

		// cam_REG[15:0] <= 16'h0000; 
		// obj_REG[8][39:34] <= Mario; 
		
 
	

		obj_REG[0][39:34] <= Brick;      
		obj_REG[0][33:23] <= 64;     
		obj_REG[0][17:7] <= 240-80; 
		obj_REG[0][0] <= 1'b1;

		obj_REG[1][39:34] <= Q_Block;      //Char index
		obj_REG[1][33:23] <= 96;     //X-position of top left corner
		obj_REG[1][17:7] <= 240-80;       //Y-position of top left corner
		obj_REG[1][0] <= 1'b1;

		obj_REG[2][39:34] <= Brick;    //Puts question block in middle     
		obj_REG[2][33:23] <= 80;     
		obj_REG[2][17:7] <= 240-80;       
		obj_REG[2][0] <= 1'b1;

		obj_REG[3][39:34] <= Q_Block;      
		obj_REG[3][33:23] <= 32;     
		obj_REG[3][17:7] <= 240-80; 
		obj_REG[3][0] <= 1'b1;

		obj_REG[4][39:34] <= Brick;      
		obj_REG[4][33:23] <= 48;     
		obj_REG[4][17:7] <= 240-80; 
		obj_REG[4][0] <= 1'b1;

		////////////////////////////////////////////////////////////
		////// Set of 3 bricks in middle right of the screen //////
		//////////////////////////////////////////////////////////

		obj_REG[5][39:34] <= Brick;      //Char index
		obj_REG[5][33:23] <= 252-96;     //X-position of top left corner
		obj_REG[5][17:7] <= 240-80;       //Y-position of top left corner
		obj_REG[5][0] <= 1'b1;

		obj_REG[6][39:34] <= Brick;    //Puts question block in middle     
		obj_REG[6][33:23] <= 252-32;     
		obj_REG[6][17:7] <= floor - 16; 
		obj_REG[6][0] <= 1'b1;      

		obj_REG[7][39:34] <= Brick;      
		obj_REG[7][33:23] <= 252-16;     
		obj_REG[7][17:7] <= floor - 16; 
		obj_REG[7][0] <= 1'b1;

		////////////////////////////////////////////////////////////
		/////////////// Draws Mario in bottom right ///////////////
		//////////////////////////////////////////////////////////

		//obj_REG[8][39:34] <= Shell;      
		// obj_REG[8][33:23] <= 16;     
		// obj_REG[8][17:7] <= floor-16; 
		// obj_REG[8][0] <= 1'b1;

		////////////////////////////////////////////////////////////
		//////////////// Draws Shell in the middle ////////////////
		//////////////////////////////////////////////////////////

		obj_REG[9][39:34] <= Brick;      
		obj_REG[9][33:23] <= 252-16;     
		obj_REG[9][17:7] <= floor-32; 
		obj_REG[9][0] <= 1'b1;

		////////////////////////////////////////////////////////////
		//////////////// Draws Goomba on the right ////////////////
		//////////////////////////////////////////////////////////

		// obj_REG[10][39:34] <= Goomba;      
		// obj_REG[10][33:23] <= 252-64;     
		// obj_REG[10][17:7] <= floor-16; 
		// obj_REG[10][0] <= 1'b1;

		////////////////////////////////////////////////////////////
		////////////// Draws the first layer of floor /////////////
		//////////////////////////////////////////////////////////

		obj_REG[11][39:34] <= Brick;      //1
		obj_REG[11][33:23] <= 0;     
		obj_REG[11][17:7] <= floor-96; 

		obj_REG[12][39:34] <= Brick;      //2
		obj_REG[12][33:23] <= 16;     
		obj_REG[12][17:7] <= floor-96; 

		obj_REG[13][39:34] <= Q_Block;      //3
		obj_REG[13][33:23] <= 32;     
		obj_REG[13][17:7] <= floor-96; 

		obj_REG[14][39:34] <= Brick;      //4
		obj_REG[14][33:23] <= 48;     
		obj_REG[14][17:7] <= floor-96; 

		obj_REG[15][39:34] <= Q_Block;      //5
		obj_REG[15][33:23] <= 64;     
		obj_REG[15][17:7] <= floor-96; 

		obj_REG[16][39:34] <= Brick;      //6
		obj_REG[16][33:23] <= 80;     
		obj_REG[16][17:7] <= floor-96; 

		obj_REG[17][39:34] <= Brick;      //7
		obj_REG[17][33:23] <= 96;     
		obj_REG[17][17:7] <= floor-96; 

		obj_REG[18][39:34] <= Shell;      //8
		obj_REG[18][33:23] <= 80;     
		obj_REG[18][17:7] <= floor-112; 

		obj_REG[19][39:34] <= Brick;      //9
		obj_REG[19][33:23] <= 252-96;     
		obj_REG[19][17:7] <= floor-48; 

		obj_REG[20][39:34] <= Brick;      //10
		obj_REG[20][33:23] <= 252-144;     
		obj_REG[20][17:7] <= floor-48; 

		obj_REG[20][39:34] <= Brick;      //11
		obj_REG[20][33:23] <= 252 - 84;     
		obj_REG[20][17:7] <= floor-48; 

		obj_REG[21][39:34] <= Brick;      //12
		obj_REG[21][33:23] <= 252-112;     
		obj_REG[21][17:7] <= floor-48; 

		// obj_REG[22][39:34] <= Brick;      //13
		// obj_REG[22][33:23] <= 192;     
		// obj_REG[22][17:7] <= floor; 

		// obj_REG[23][39:34] <= Brick;      //14
		// obj_REG[23][33:23] <= 208;     
		// obj_REG[23][17:7] <= floor; 

		// obj_REG[24][39:34] <= Brick;      //15
		// obj_REG[24][33:23] <= 224;     
		// obj_REG[24][17:7] <= floor; 

		// obj_REG[25][39:34] <= Brick;      //16
		// obj_REG[25][33:23] <= 236;     
		// obj_REG[25][17:7] <= floor; 

		////////////////////////////////////////////////////////////
		//////////////// Draws second layer of floor //////////////
		//////////////////////////////////////////////////////////

		// obj_REG[26][39:34] <= Brick;      //1
		// obj_REG[26][33:23] <= 0;     
		// obj_REG[26][17:7] <= floor+16; 

		// obj_REG[27][39:34] <= Brick;      //2
		// obj_REG[27][33:23] <= 16;     
		// obj_REG[27][17:7] <= floor+16; 

		// obj_REG[28][39:34] <= Brick;      //3
		// obj_REG[28][33:23] <= 32;     
		// obj_REG[28][17:7] <= floor+16; 

		// obj_REG[29][39:34] <= Brick;      //4
		// obj_REG[29][33:23] <= 48;     
		// obj_REG[29][17:7] <= floor+16; 

		// obj_REG[30][39:34] <= Brick;      //5
		// obj_REG[30][33:23] <= 64;     
		// obj_REG[30][17:7] <= floor+16; 

		// obj_REG[31][39:34] <= Brick;      //6
		// obj_REG[31][33:23] <= 80;     
		// obj_REG[31][17:7] <= floor+16; 

		// obj_REG[32][39:34] <= Brick;      //7
		// obj_REG[32][33:23] <= 96;     
		// obj_REG[32][17:7] <= floor+16; 

		// obj_REG[33][39:34] <= Brick;      //8
		// obj_REG[33][33:23] <= 112;     
		// obj_REG[33][17:7] <= floor+16; 

		// obj_REG[34][39:34] <= Brick;      //9
		// obj_REG[34][33:23] <= 128;     
		// obj_REG[34][17:7] <= floor+16; 

		// obj_REG[35][39:34] <= Brick;      //10
		// obj_REG[35][33:23] <= 144;     
		// obj_REG[35][17:7] <= floor+16; 

		// obj_REG[36][39:34] <= Brick;      //11
		// obj_REG[36][33:23] <= 160;     
		// obj_REG[36][17:7] <= floor+16; 

		// obj_REG[37][39:34] <= Brick;      //12
		// obj_REG[37][33:23] <= 176;     
		// obj_REG[37][17:7] <= floor+16; 

		// obj_REG[38][39:34] <= Brick;      //13
		// obj_REG[38][33:23] <= 192;     
		// obj_REG[38][17:7] <= floor+16; 

		// obj_REG[39][39:34] <= Brick;      //14
		// obj_REG[39][33:23] <= 208;     
		// obj_REG[39][17:7] <= floor+16; 

		// obj_REG[40][39:34] <= Brick;      //15
		// obj_REG[40][33:23] <= 224;     
		// obj_REG[40][17:7] <= floor+16; 

		// obj_REG[41][39:34] <= Brick;      //16
		// obj_REG[41][33:23] <= 236;     
		// obj_REG[41][17:7] <= floor+16; 
	end
end


/////////////////////////////////////////
//////////// End of OAR ////////////////
///////////////////////////////////////


/////////////////////////////////////
//////// Start of Movement /////////
///////////////////////////////////


logic signed [15:0] mov_REG; //movement registers. 
//bits 9:5 are x movement, 4:0 are Y movement. 

logic move_left, move_right, jump, move_left1, move_right1, jump1;
logic collision_down, collision_up, collision_left, collision_right;

always_ff @(posedge vs) begin

unique case(keycode1) //Having two signals allow for two button presses at once
				8'h04 : begin						//A
							move_left1 <= 1; 
							end    
				8'h07 : begin
							move_right1 <= 1;		//D
							end
				8'h1A : begin
							jump1 <= 1;				//W
							end
							
				default: begin
					move_left1 <= 0; 
					move_right1 <= 0; 
					jump1 <= 0; 
				end
			endcase

	unique case(keycode)
				8'h04 : begin						//A
							move_left <= 1; 
							
							end    
				8'h07 : begin
							move_right <= 1;		//D
							end
				8'h1A : begin
							jump <= 1;				//W
							// if (~collision_up)
							// 	obj_REG[8][17:7] <= obj_REG[8][17:7] - 1;
							end

							
				default: begin
					move_left <= 0; 
					move_right <= 0; 
					jump <= 0; 
				end
			endcase
end

//Movement Logic 
logic [6:0] grav_REG;

	always_ff @(posedge vs) begin				//Mario movement
		if(keycode == 8'h2C )begin //initial character object parameters trigger on spacebar
			obj_REG[8][39:34] <= Mario;      
			obj_REG[8][33:23] <= 16;     
			obj_REG[8][17:7] <= floor-16; 
			obj_REG[8][0] <= 1'b1;
			obj_REG[10][0] <= 1'b1; 
			cam_REG[15:0] <= 16'b0;
			obj_REG[10][39:34] <= Goomba;      
			obj_REG[10][33:23] <= 252-64;     
			obj_REG[10][17:7] <= floor-16; 
		end
		else
		begin
			//Camera Scrolling, disabled for now
			// if (((cam_REG[15:5]+100) <= obj_REG[8][33:23] <= (cam_REG[15:5] + 120)) && (move_left==1'b0))	//Moves Camera once Mario hits halfway
			// 	cam_REG[15:0] <= (cam_REG[15:0] + mov_REG[14:8]);	
			if ((jump || jump1)) begin 
				obj_REG[8][17:2] <= obj_REG[8][17:2] - 7'b1000000;
				
			end 
			else if (collision_down5)
				obj_REG[8][17:7] <= floor-16;
			else if (collision_down4)
				obj_REG[8][17:7] <= floor-64;
			else if (collision_down3)
				obj_REG[8][17:7] <= floor-32;
			else if (collision_down2)
				obj_REG[8][17:7] <= floor-64;
			else if (collision_down1)
				obj_REG[8][17:7] <= floor-112;
			else if (collision_down6)
				obj_REG[8][17:7] <= 252-64;
			else if (collision_down7)
				obj_REG[8][17:7] <= floor-48;
			else if (collision_down8)
				obj_REG[8][17:7] <= floor-112;  
			else 
				obj_REG[8][17:2] <= obj_REG[8][17:2] + 7'b1000000;
	
			//horizontal movement 

			if ((move_left || move_left1) && (collision_left == 1'b0))
				mov_REG[15:8] <= 8'b1100000; 
			else if ((move_right || move_right1) && (collision_right == 1'b0))
				mov_REG[15:8] <= 8'b01000000; 
			else 
				mov_REG[15:8] <= 8'b00000000; 

			if ((move_right||move_right1) && (~(move_left||move_left1)) && (collision_right == 1'b0)) begin
				obj_REG[8][33:18] <= obj_REG[8][33:18] + 7'b1000000; //moving Right
			end
			else if ((move_left||move_left1) && (~(move_right||move_right1)) && (collision_left == 1'b0))begin
				obj_REG[8][33:18] <= obj_REG[8][33:18] - 7'b1000000; //moving Left
			end
		
		end

		//goomba movement
		
		// if(goomba_left)
		// 	obj_REG[10][33:18] <= obj_REG[10][33:23] - 7'b1000000; 
		// else 
		// 	obj_REG[10][33:18] <= obj_REG[10][33:23] + 7'b1000000; 
		// if (obj_REG[10][33:18] == 11'h000)
		// 	goomba_left <= 1'b1;
		// else if (obj_REG[10][33:23] == 210)
		// 	goomba_left <= 1'b0; 




		//Collision Checker for screen 1
		if ((obj_REG[8][17:7] >= (floor-17) ) )
			collision_down5 <= 1'b1;
		else 
			collision_down5 <= 1'b0;

		if((obj_REG[8][33:23] >= 0) && (obj_REG[8][33:23] <= 96)&& (obj_REG[8][17:7] <= floor -111) && (obj_REG[8][17:7] >= floor-113))
			collision_down1 <= 1'b1; 
		else 
			collision_down1 <= 1'b0;
		
		
		if ((obj_REG[8][33:23] >= 128)&&(obj_REG[8][33:23] <= 176)&& (obj_REG[8][17:7] <= floor -63) && (obj_REG[8][17:7] >= floor-65))
			collision_down2 <= 1'b1;
		else 
			collision_down2 <= 1'b0;
	
		
		if ((obj_REG[8][33:23] >= 204)&&(obj_REG[8][33:23] <= 220)&& (obj_REG[8][17:7] <= floor -31) && (obj_REG[8][17:7] >= floor-33))
			collision_down3 <= 1'b1;
		else 
			collision_down3 <= 1'b0; 
	
		
		if ((obj_REG[8][33:23] >= 18) && (obj_REG[8][33:23] <=111) && (obj_REG[8][17:7] <= floor - 63) && (obj_REG[8][17:7] >= floor - 65))
			collision_down4 <= 1'b1;
		else
			collision_down4 <= 1'b0;
		
	
		if ((obj_REG[8][33:23] >= 192-14) && (obj_REG[8][33:23] <= 192+14) && (obj_REG[8][17:7] <= 252 - 63) && (obj_REG[8][17:7] >= 252 - 65)&&(obj_REG[10][0]))begin
			collision_down6 <= 1'b1;
			obj_REG[10][0] <= 1'b0;  end
		else
			collision_down6 <= 1'b0;

		if ((obj_REG[8][33:23] >= 238) && (obj_REG[8][33:23] <=251) && (obj_REG[8][17:7] <= floor - 31) && (obj_REG[8][17:7] >= floor - 33))
			collision_down7 <= 1'b1;
		else
			collision_down7 <= 1'b0;

		if ((obj_REG[8][33:23] >= 80) && (obj_REG[8][33:23] <=96) && (obj_REG[8][17:7] <= floor - 127) && (obj_REG[8][17:7] >= floor - 129))
			collision_down8 <= 1'b1;
		else
			collision_down8 <= 1'b0;
	
	end
logic collision_down1, collision_down2, collision_down3, collision_down4, collision_down5, collision_down6 , collision_down7, collision_down8, goomba_left;
//level height ROM - This module is defined in sprite_rom.sv
logic [7:0] level_addr;
logic [3:0] level_q; 

level_rom romLVL(.clock(CLK), .address_a(level_addr), .q_a(level_q));
//level_rom contains the ground height for the level. address is which 16 pixel block, q returns block height (16 pixels each)


//Collision Detection

// always_ff @(posedge vs) begin: Collision		//check clock if problems

// 	if (obj_REG[8][17:7] == floor-16)		//stops Mario from going through floor 
// 		collision_down <= 1'b1;				//Account for holes in floor when added
// 	else
// 		collision_down <= 1'b0;

// 	if (obj_REG[8][33:23] == cam_REG[15:5])				//Stops Mario on left side of screen
// 		collision_left <= 1'b1;
// 	else
// 		collision_left <= 1'b0;

// end



///////// Camera Reg /////////////////

logic [15:0] cam_REG;		// [15:5] -> X position [4:0] -> empty just used for counting

// always_ff @( vs ) begin
	
// 		if (obj_REG[8][33:23] == cam_REG[15:5] + 110)	//Moves Camera once Mario hits halfway
// 			cam_REG[15:0] <= (cam_REG[15:0] + mov_REG[11:6]);
// 	end




/////////////////////////////////////
///////// End of Movement //////////
///////////////////////////////////



//Writing to VRAM loops and counters
//pixel counter
logic [7:0] sc_x, sc_y; 

always_ff @ (posedge CLK) 
	begin
		  if ( ~count_start ) 
			begin 
				sc_x <= 8'b00000000;
				sc_y <= 8'b00000000;
				done <= 1'b0; 
			end
		  else begin
			if ( sc_x == 8'b11111011 )  				//If hc has reached the end of pixel count
			begin 
				sc_x <= 8'b00000000; 
				if ( sc_y == 8'b01110111 ) begin  		//if vc has reached end of line count

					sc_y <= 8'b00000000;
					done <= 1'b1; 

				end
				else 
				sc_y <= (sc_y + 1);
			end
			else begin
				sc_x <= (sc_x + 1);  //no statement about vc, implied vc <= vc;
			 	done <= 1'b0;
			end
		  end
	 end 


always_ff @ (posedge CLK) 
	begin
		  if (~sp_count) 
			begin 
				sp_x <= 5'b0000;
				sp_y <= 4'b0000;
				sp_done <= 1'b0; 
			end
		  else begin
			if ( sp_x == 4'b1111 )  				//If hc has reached the end of pixel count
			begin 
				sp_x <= 1'b0000; 
				if ( sp_y == 4'b1111 ) begin  		//if vc has reached end of line count

					sp_y <= 4'b0000;
					sp_done <= 1'b1; 

				end
				else 
				sp_y <= (sp_y + 1);
			end
			else begin
				sp_x <= (sp_x + 1);  //no statement about vc, implied vc <= vc;
			 	sp_done <= 1'b0;
			end
		  end
	 end 

//Write Logic based on state machine variables and OARs
logic floor_done; 

always_ff @(posedge CLK) begin
		if (LD_bgd_all && ~blank && (DrawY > 480))begin //Replaces buffer with background color
			wr_address_a <= sc_x+252*sc_y;
			address_b <= 252*120 + (sc_x+252*sc_y) ;
			data_a <= 4'b0000;
			data_b <= 4'b0000; 
			wren_b <= 1'b1; 
			// collision_down <= 1'b0; 
			// collision_left <= 1'b0; 
			// collision_right <= 1'b0; 
			// collision_up <= 1'b0; 
		end
		else if (~blank && DrawY>480)begin //Draws floor after background from ROM
			wren_b <=1'b1;
			if ((sc_x+252*sc_y) < (252*32))begin //floor not done
				floor_done <= 1'b0; 
				address_b <= sc_x + 252*sc_y;
				level_addr <= cam_REG[15:5]>>4;
				if(level_q > 0) begin
					char_idx_b <= 6'b000001; //floor sprite 
					address_b <= ((252*208)+(sc_x)+(sc_y*252));
					rom_address_b <= (sc_y%16)*16 + ((sc_x%16) + (cam_REG[15:5]%16));
					data_b <= rom_q_b;
				end
			end
			else begin
				floor_done = 1'b1; 
			end
		end
		else
			wren_b <= 1'b1; 
    //Object Drawing Logic
      if (LD_fgd_sprite && ~blank && (DrawY > 480)) begin //Draws Objects based on state machine / object registers 
            //char_idx_a <= obj_REG[object][39:34];
			//char_idx_a <= 3'b100;
            rom_address_a <= (sp_x)+sp_y*16;
            data_a <= rom_q_a; 
            wr_address_a <= ((obj_REG[object][33:23]-cam_REG[15:5])+(sp_x)) + (obj_REG[object][17:7]+sp_y)*252;
			
	// 		//Collision Logic. If x coordinate shows object is directly above or below 
	// 		if ((obj_REG[8][33:23] >= obj_REG[object][33:23]-16)&&(obj_REG[8][33:23] <= obj_REG[object][33:23]+16))begin
	// 			if (obj_REG[object][17:7]-15 <= (obj_REG[8][17:7]) <= (obj_REG[object][17:7] - 17))		//Check if object above Mario
	// 				collision_up <= 1'b1;
	// 			if (((obj_REG[object][17:7]-1) <= (obj_REG[8][17:7]+16)) || ((obj_REG[8][17:7]+16) <= (obj_REG[object][17:7]+1)) || (obj_REG[8][17:7] == (floor-16)))		//stops Mario from going through floor/objects
	// 				collision_down <= 1'b1;	
	// 		end
	// 		if ((obj_REG[8][17:7] <= obj_REG[object][17:7]+16)&&(obj_REG[8][17:7] >= obj_REG[object][17:7]-16))begin
	// 			if (((obj_REG[object][33:23]-1) <= (obj_REG[8][33:23]+16) ) || ((obj_REG[8][33:23]+16) <= (obj_REG[object][33:23]+1 )))	//Check if object to right of Mario
	// 				collision_right <= 1'b1;
	// 			if (((obj_REG[object][33:23]-1) <= (obj_REG[8][33:23]) ) || ((obj_REG[8][33:23]) <= (obj_REG[object][33:23])) || ((cam_REG[15:5]-1) <= (obj_REG[8][33:23])) || ((obj_REG[8][33:23]) <= (cam_REG[15:5]+1))) 	//Check if object to left of Mario
	// 				collision_left <= 1'b1;

	// 		end
	// 		if (obj_REG[8][17:7] == (floor - 18))
	// 			collision_down <= 1'b1; 
      end
end

assign char_idx_a = obj_REG[object][39:34];
endmodule