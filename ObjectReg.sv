module OAR (    
                input CLK,

);

/////////////////////////////////////
/////////////// OAR ////////////////
///////////////////////////////////


local [22:0] obj_REG [42];       //Set values later
local [9:0] obj_X, obj_Y;
local [3] Brick, Mario, Goomba, Shell, Cloud, Bush, Q_Block;
local [8] floor;

///////////////////////////////////
///// Sets the Char indicies /////
/////////////////////////////////

assign Q_Block = 0;
assign Brick = 1;
assign Mario = 2;
assign Goomba = 3;
assign Shell = 3;

/***************
assign Cloud = ;
assign Bush = ;
***************/


assign floor = 240 - 32;

////////////////////////////////////////////////////////////
////// Set of 3 bricks in middle right of the screen //////
//////////////////////////////////////////////////////////

always_ff @( posedge CLK ) begin : Screen

    obj_REG[[5][22:19]] = Brick;      //Char index
    obj_REG[[5][19:10]] = 252-96;     //X-position of top left corner
    obj_REG[[5][9:0]] = 240-80;       //Y-position of top left corner

    obj_REG[[6][22:19]] = Q_Block;    //Puts question block in middle     
    obj_REG[[6][19:10]] = 252-80;     
    obj_REG[[6][9:0]] = 240-80;       

    obj_REG[[7][22:19]] = Brick;      
    obj_REG[[7][19:10]] = 252-64;     
    obj_REG[[7][9:0]] = 240-80; 

    ////////////////////////////////////////////////////////////
    /////////////// Draws Mario in bottom right ///////////////
    //////////////////////////////////////////////////////////

    obj_REG[[8][22:19]] = Mario;      
    obj_REG[[8][19:10]] = 16;     
    obj_REG[[8][9:0]] = floor-16; 

    ////////////////////////////////////////////////////////////
    //////////////// Draws Shell in the middle ////////////////
    //////////////////////////////////////////////////////////

    obj_REG[[9][22:19]] = Shell;      
    obj_REG[[9][19:10]] = 96;     
    obj_REG[[9][9:0]] = floor-16; 

    ////////////////////////////////////////////////////////////
    //////////////// Draws Goomba on the right ////////////////
    //////////////////////////////////////////////////////////

    obj_REG[[10][22:19]] = Goomba;      
    obj_REG[[10][19:10]] = 252-64;     
    obj_REG[[10][9:0]] = floor-16; 

    ////////////////////////////////////////////////////////////
    ////////////// Draws the first layer of floor /////////////
    //////////////////////////////////////////////////////////

    obj_REG[[11][22:19]] = Brick;      //1
    obj_REG[[11][19:10]] = 0;     
    obj_REG[[11][9:0]] = floor; 

    obj_REG[[12][22:19]] = Brick;      //2
    obj_REG[[12][19:10]] = 16;     
    obj_REG[[12][9:0]] = floor; 

    obj_REG[[13][22:19]] = Brick;      //3
    obj_REG[[13][19:10]] = 32;     
    obj_REG[[13][9:0]] = floor; 

    obj_REG[[14][22:19]] = Brick;      //4
    obj_REG[[14][19:10]] = 48;     
    obj_REG[[14][9:0]] = floor; 

    obj_REG[[15][22:19]] = Brick;      //5
    obj_REG[[15][19:10]] = 64;     
    obj_REG[[15][9:0]] = floor; 

    obj_REG[[16][22:19]] = Brick;      //6
    obj_REG[[16][19:10]] = 80;     
    obj_REG[[16][9:0]] = floor; 

    obj_REG[[17][22:19]] = Brick;      //7
    obj_REG[[17][19:10]] = 96;     
    obj_REG[[17][9:0]] = floor; 

    obj_REG[[18][22:19]] = Brick;      //8
    obj_REG[[18][19:10]] = 112;     
    obj_REG[[18][9:0]] = floor; 

    obj_REG[[19][22:19]] = Brick;      //9
    obj_REG[[19][19:10]] = 128;     
    obj_REG[[19][9:0]] = floor; 

    obj_REG[[20][22:19]] = Brick;      //10
    obj_REG[[20][19:10]] = 144;     
    obj_REG[[20][9:0]] = floor; 

    obj_REG[[20][22:19]] = Brick;      //11
    obj_REG[[20][19:10]] = 160;     
    obj_REG[[20][9:0]] = floor; 

    obj_REG[[21][22:19]] = Brick;      //12
    obj_REG[[21][19:10]] = 176;     
    obj_REG[[21][9:0]] = floor; 

    obj_REG[[22][22:19]] = Brick;      //13
    obj_REG[[22][19:10]] = 192;     
    obj_REG[[22][9:0]] = floor; 

    obj_REG[[23][22:19]] = Brick;      //14
    obj_REG[[23][19:10]] = 208;     
    obj_REG[[23][9:0]] = floor; 

    obj_REG[[24][22:19]] = Brick;      //15
    obj_REG[[24][19:10]] = 224;     
    obj_REG[[24][9:0]] = floor; 

    obj_REG[[25][22:19]] = Brick;      //16
    obj_REG[[25][19:10]] = 236;     
    obj_REG[[25][9:0]] = floor; 

    ////////////////////////////////////////////////////////////
    //////////////// Draws second layer of floor //////////////
    //////////////////////////////////////////////////////////

    obj_REG[[26][22:19]] = Brick;      //1
    obj_REG[[26][19:10]] = 0;     
    obj_REG[[26][9:0]] = floor+16; 

    obj_REG[[27][22:19]] = Brick;      //2
    obj_REG[[27][19:10]] = 16;     
    obj_REG[[27][9:0]] = floor+16; 

    obj_REG[[28][22:19]] = Brick;      //3
    obj_REG[[28][19:10]] = 32;     
    obj_REG[[28][9:0]] = floor+16; 

    obj_REG[[29][22:19]] = Brick;      //4
    obj_REG[[29][19:10]] = 48;     
    obj_REG[[29][9:0]] = floor+16; 

    obj_REG[[30][22:19]] = Brick;      //5
    obj_REG[[30][19:10]] = 64;     
    obj_REG[[30][9:0]] = floor+16; 

    obj_REG[[31][22:19]] = Brick;      //6
    obj_REG[[31][19:10]] = 80;     
    obj_REG[[31][9:0]] = floor+16; 

    obj_REG[[32][22:19]] = Brick;      //7
    obj_REG[[32][19:10]] = 96;     
    obj_REG[[32][9:0]] = floor+16; 

    obj_REG[[33][22:19]] = Brick;      //8
    obj_REG[[33][19:10]] = 112;     
    obj_REG[[33][9:0]] = floor+16; 

    obj_REG[[34][22:19]] = Brick;      //9
    obj_REG[[34][19:10]] = 128;     
    obj_REG[[34][9:0]] = floor+16; 

    obj_REG[[35][22:19]] = Brick;      //10
    obj_REG[[35][19:10]] = 144;     
    obj_REG[[35][9:0]] = floor+16; 

    obj_REG[[36][22:19]] = Brick;      //11
    obj_REG[[36][19:10]] = 160;     
    obj_REG[[36][9:0]] = floor+16; 

    obj_REG[[37][22:19]] = Brick;      //12
    obj_REG[[37][19:10]] = 176;     
    obj_REG[[37][9:0]] = floor+16; 

    obj_REG[[38][22:19]] = Brick;      //13
    obj_REG[[38][19:10]] = 192;     
    obj_REG[[38][9:0]] = floor+16; 

    obj_REG[[39][22:19]] = Brick;      //14
    obj_REG[[39][19:10]] = 208;     
    obj_REG[[39][9:0]] = floor+16; 

    obj_REG[[40][22:19]] = Brick;      //15
    obj_REG[[40][19:10]] = 224;     
    obj_REG[[40][9:0]] = floor+16; 

    obj_REG[[41][22:19]] = Brick;      //16
    obj_REG[[41][19:10]] = 236;     
    obj_REG[[41][9:0]] = floor+16; 

end

endmodule