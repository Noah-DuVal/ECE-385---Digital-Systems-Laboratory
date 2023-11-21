module framebuffer (   input logic  CLK, 
									RESET,
                                    blank,
									sp_done,
									done,
									floor_done, 
						input logic [9:0] DrawX, 
										  DrawY,
						input logic [39:0] obj_REG [101],
						input logic [15:0] cam_REG,
									//Run,
									//Continue,
									//Add ROM and OAR once created elsewhere
				  
				output logic        LD_bgd_all,
									
									LD_fgd_sprite,
                                    wren_a, 
                                 
                 output logic[7:0]  object,
                 output count_start,
                 output sp_count
				);

//

	enum logic [7:0] {  Rest, 	//Rest;
                        S_1,        // For loop to set every pixel to blue - moves when end of frame buffer
                        S_2,        // Read rom use oar to place backround objects (clouds, bushes) - moves on using ROM[31] == 1
						S_3,	    // Read rom use oar to place foreground objects (Characters & floor) - moves when OAR[31] == 1
                        S_4,
						S_5,
						S_6,
						S_7,
						S_8,
						S_9,
						S_10,
						S_11,
						S_12,
						S_13,
						S_14,
						S_15,
						S_16,
						S_17,
						S_18,
						S_19,
						S_20,
						S_21,
						S_22,
						S_23,
						S_24,
						S_25,
						S_26,
						S_27,
						S_28,
						S_29,
						S_30,
						S_31,
						S_32,
						S_33,
						S_34,
						S_35,
						S_36,
						S_37,
						S_38,
						S_39,
						S_40,
						// S_41,
						// S_42,
						// S_43,
						// S_44,
						// S_45,
						// S_46,
						// S_47,
						// S_48,
						// S_49,
						// S_50,
						// S_51,
						// S_52,
						// S_53,
						// S_54,
						// S_55,
						// S_56,
						// S_57,
						// S_58,
						// S_59,
						// S_60,
						// S_61,
						// S_62,
						// S_63,
						// S_64,
						// S_65,
						// S_66,
						// S_67,
						// S_68,
						// S_69,
						// S_70,
						// S_71,
						// S_72,
						// S_73,
						// S_74,
						// S_75,
						// S_76,
						// S_77,
						// S_78,
						// S_79,
						// S_80,
						// S_81,
						// S_82,
						// S_83,
						// S_84,
						// S_85,
						// S_86,
						// S_87,
						// S_88,
						// S_89,
						// S_90,
						// S_91,
						// S_92,
						// S_93,
						// S_94,
						// S_95,
						// S_96,
						// S_97,
						// S_98,
						// S_99,
						// S_100,
						 S_101,
						// S_102,
						// S_103,
						// S_104,
						// S_105,
						// S_106,
						// S_107,
						// S_108,
						// S_109,
						// S_110,
						// S_111,
						// S_112,
						// S_113,
						// S_114,
						// S_115,
						// S_116,
						// S_117,
						// S_118,
						// S_119,
						// S_120,
						W_1,
						W_2,
						W_3,
						W_4,
						W_5,
						W_6,
						W_7,
						W_8,
						W_9,
						W_10,
						W_11,
						W_12,
						W_13,
						W_14,
						W_15,
						W_16,
						W_17,
						W_18,
						W_19,
						W_20,
						W_21,
						W_22,
						W_23,
						W_24,
						W_25,
						W_26,
						W_27,
						W_28,
						W_29,
						W_30,
						W_101,
						W_31,
						W_32,
						W_33,
						W_34,
						W_35,
						W_36, W_37, W_38, W_39, W_40,
						S_wait      //stays until ~blank is over
						
						}   State, Next_state;

	always_ff @ (posedge CLK)
	begin
		if (RESET) 
			State <= Rest;
		else 
			State <= Next_state;
	end

always_comb
	begin 
		// Rest; next state is staying at current state
		Next_state = State;
		
		// Rest; controls signal values
		
		LD_bgd_all = 1'b0;
        LD_fgd_sprite = 1'b0;
        sp_count = 1'b1; 
        count_start = 1'b1; 
        wren_a = 1'b0; 
       
        object = 8'b00000000;

		// Assign next state
		unique case (State)
			Rest : 
				if (~blank && (DrawY > 480)) 
					Next_state = S_1;                      
			S_1 : 
                if (done)    //change later to corect address
				    Next_state = W_1;
			W_1 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>(cam_REG[15:5])+252) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_2; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_2;
			S_2 : //LD object 0
				if(sp_done)
                    Next_state = W_2;
			W_2 : 
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>(cam_REG[15:5])+252) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_3; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_3;
					
            S_3 ://LD object 1

                 if (sp_done)
                    Next_state = W_3;
			W_3 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>(cam_REG[15:5])+252) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_4; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_4;
			S_4 ://etc.

                 if (sp_done)
                    Next_state = W_4;
			W_4 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>(cam_REG[15:5])+252) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_5;
				else
					Next_state = S_5;
			S_5 :

                 if (sp_done)
                    Next_state = W_5;
			W_5 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_6;
				else
					Next_state = S_6;
			S_6 :

             	 if (sp_done)
                    Next_state = W_6;
			W_6 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_7;
				else
					Next_state = S_7;
			S_7 :

             	 if (sp_done)
                    Next_state = W_7;
			W_7 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_8;
				else
					Next_state = S_8;
			S_8 :

             	 if (sp_done)
                    Next_state = W_8;
			W_8 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_9;
				else
					Next_state = S_9;
			S_9 :

             	 if (sp_done)
                    Next_state = W_9;
			W_9 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_10;
				else
					Next_state = S_10;
			S_10 :
             	 if (sp_done )
                    Next_state = W_10;
			W_10 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_11;
				else
					Next_state = S_11;
			S_11 : 
                if (sp_done)    //change later to corect address
				    Next_state = W_11;
			W_11 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_12; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_12;
			S_12 : //LD object 0
				if(sp_done)
                    Next_state = W_12;
			W_12 : 
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_13; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_13;
					
            S_13 ://LD object 1

                 if (sp_done)
                    Next_state = W_13;
			W_13 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_14; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_14;
			S_14 ://etc.

                 if (sp_done)
                    Next_state = W_14;
			W_14 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_15;
				else
					Next_state = S_15;
			S_15 :

                 if (sp_done)
                    Next_state = W_15;
			W_15 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_16;
				else
					Next_state = S_16;
			S_16 :

             	 if (sp_done && floor_done)
                    Next_state = W_16;

					//////////////////
			W_16 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_17;
				else
					Next_state = S_17;
			S_17 :

             	 if (sp_done)
                    Next_state = W_17;
			W_17 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_18;
				else
					Next_state = S_18;
			S_18 :

             	 if (sp_done)
                    Next_state = W_18;
			W_18 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_19;
				else
					Next_state = S_19;
			S_19 :

             	 if (sp_done)
                    Next_state = W_19;
			W_19 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_20;
				else
					Next_state = S_20;
			S_20 :

             	 if (sp_done)
                    Next_state = W_20;
			W_20 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_21;
				else
					Next_state = S_21;
			S_21 : 
                if (sp_done)    //change later to corect address
				    Next_state = W_21;
			W_21 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_22; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_22;
			S_22 : //LD object 0
				if(sp_done)
                    Next_state = W_22;
			W_22 : 
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_23; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_23;
					
            S_23 ://LD object 1

                 if (sp_done)
                    Next_state = W_23;
			W_23 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_24; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_24;
			S_24 ://etc.

                 if (sp_done)
                    Next_state = W_24;
			W_24 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_25;
				else
					Next_state = S_25;
			S_25 :

                 if (sp_done)
                    Next_state = W_25;
			W_25 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5]))))
				 	Next_state = W_26;
				else
					Next_state = S_26;
			S_26 :

             	 if (sp_done)
                    Next_state = W_26;
			W_26 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_27;
				else
					Next_state = S_27;
			S_27 :

             	 if (sp_done)
                    Next_state = W_27;
			W_27 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_28;
				else
					Next_state = S_28;
			S_28 :

             	 if (sp_done)
                    Next_state = W_28;
			W_28 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_29;
				else
					Next_state = S_29;
			S_29 :

             	 if (sp_done)
                    Next_state = W_29;
			W_29 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_30;
				else
					Next_state = S_30;
			S_30 :

             	 if (sp_done)
                    Next_state = W_30;
			W_30 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_101;
				else
					Next_state = S_101;
			S_101 :

             	 if (sp_done)
                    Next_state = W_101;
			W_101 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_31;
				else
					Next_state = S_31;
			S_31 : 
                if (sp_done)    //change later to corect address
				    Next_state = W_31;
			W_31 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_32; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_32;
			S_32 : //LD object 0
				if(sp_done)
                    Next_state = W_32;
			W_32 : 
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_33; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_33;
					
            S_33 ://LD object 1

                 if (sp_done)
                    Next_state = W_33;
			W_33 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_34; //This goes to next state early if object is dead or not on screen
				else
					Next_state = S_34;
			S_34 ://etc.

                 if (sp_done)
                    Next_state = W_34;
			W_34 :  
				if ((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])))
				 	Next_state = W_35;
				else
					Next_state = S_35;
			S_35 :

                 if (sp_done)
                    Next_state = W_35;
			W_35 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_36;
				else
					Next_state = S_36;
			S_36 :

             	 if (sp_done)
                    Next_state = W_36;
			W_36 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_37;
				else
					Next_state = S_37;
			S_37 :

             	 if (sp_done)
                    Next_state = W_37;
			W_37 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_38;
				else
					Next_state = S_38;
			S_38 :

             	 if (sp_done)
                    Next_state = W_38;
			W_38 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) ))
				 	Next_state = W_39;
				else
					Next_state = S_39;
			S_39 :

             	 if (sp_done)
                    Next_state = W_39;
			W_39 :  
				if (((obj_REG[object][0]==1'b0) || (obj_REG[object][33:23]>((cam_REG[15:5])+252)) || (obj_REG[object][33:23]<(cam_REG[15:5])) )&&floor_done)
				 	Next_state = S_wait;
				else
					Next_state = S_40;
			S_40 :

             	 if (sp_done && floor_done)
                    Next_state = S_wait;

			

///////////////////////////////////////////////////////
					
					
			
				
            S_wait: 
                if (blank)
                    Next_state = Rest; 
			default : ;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Rest : 
				begin 
                	
                	sp_count = 1'b0; 
					count_start = 1'b0; 
            	end

            S_1 : //Load Background Color
				begin 
					LD_bgd_all = 1'b1;
					
					LD_fgd_sprite = 1'b0;
                    count_start = 1'b1; 
                   
					wren_a = 1'b1; 
                    sp_count = 1'b0; 
				end
            S_2 : //Load  Object 0
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
                    object = 8'b00000000; 
					sp_count = 1'b1; 
				end
            S_3 : //Load fgd obj 1
				begin 
					LD_bgd_all = 1'b0;
			
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
                    object = 8'b00000001; 
				end
            S_4 : //fgd obj 2
				begin 
					LD_bgd_all = 1'b0;
			
					wren_a = 1'b1; 
					LD_fgd_sprite = 1'b1;
                    object = 8'b00000010; 
				end
            S_5 : //3
				begin 
					LD_bgd_all = 1'b0;
			
					wren_a = 1'b1; 
					LD_fgd_sprite = 1'b1;
                    object = 8'b00000011; 
				end
            S_6 : //4
				begin 
					LD_bgd_all = 1'b0;
			
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00000100; 
				end
            S_7 : //5
				begin 
					LD_bgd_all = 1'b0;
			
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00000101; 
				end
            S_8 : //6
				begin 
					LD_bgd_all = 1'b0;
		
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00000110; 
				end
			S_9 : //7
				begin 
					LD_bgd_all = 1'b0;
		
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00000111; 
				end
			S_10 : //8
				begin 
					LD_bgd_all = 1'b0;
	
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00001000; 
				end
			S_11 : //9
				begin 
					LD_bgd_all = 1'b0;
	
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00001001; 
				end
			S_12 : //10
				begin 
					LD_bgd_all = 1'b0;
		
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00001010; 
				end
			S_13 : //11
				begin 
					LD_bgd_all = 1'b0;
		
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00001011; 
				end
			S_14 : //12
				begin 
					LD_bgd_all = 1'b0;
	
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00001100; 
				end
			S_15 : //13
				begin 
					LD_bgd_all = 1'b0;
	
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00001101; 
				end
			S_16 : //14
				begin 
					LD_bgd_all = 1'b0;
	
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00001110; 
				end
			S_17 : //15
				begin 
					LD_bgd_all = 1'b0;
	
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00001111; 
				end
			S_18 : //16
				begin 
					LD_bgd_all = 1'b0;
	
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00010000; 
				end
			S_19 : //17
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00010001; 
				end
			S_20 : //18			//////////// Start of C&P ///////////
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00010010; 
				end
			S_21 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00010011; 
				end
			S_22 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00010100; 
				end
			S_23 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00010101; 
				end
			S_24 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00010110; 
				end
			S_25 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00010111; 
				end
			S_26 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00011000; 
				end
			S_27 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00011001; 
				end
			S_28 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00011010; 
				end
			S_29 : //27
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00011011; 
				end
			S_30 : //28
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00011100; 
				end
			S_101 : //accounts for error in object count
				begin //29
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00011101; 
				end
			S_31 : //30								
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00011110; 
				end
			S_32 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00011111; 
				end
			S_33 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00100000; 
				end
			S_34 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00100001; 
				end
			S_35 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00100010; 
				end
			S_36 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00100011; 
				end
			S_37 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00100100; 
				end
			S_38 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00100101; 
				end
			S_39 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00100110; 
				end
			S_40 : //18
				begin 
					LD_bgd_all = 1'b0;
					LD_fgd_sprite = 1'b1;
					wren_a = 1'b1; 
					object = 8'b00100111; 
				end
			// S_41 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00101000; 
			// 	end
			// S_42 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00101001; 
			// 	end
			// S_43 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00101010; 
			// 	end
			// S_44 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00101011; 
			// 	end
			// S_45 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00101100; 
			// 	end
			// S_46 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00101101; 
			// 	end
			// S_47 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00101110; 
			// 	end
			// S_48 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00101111; 
			// 	end
			// S_49 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00110000; 
			// 	end
			// S_50 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00110001; 
			// 	end
			// S_51 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00110010; 
			// 	end
			// S_52 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00110011; 
			// 	end
			// S_53 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00110100; 
			// 	end
			// S_54 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00110101; 
			// 	end
			// S_55 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00110110; 
			// 	end
			// S_56 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00110111; 
			// 	end
			// S_57 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00111000; 
			// 	end
			// S_58 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00111001; 
			// 	end
			// S_59 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00111010; 
			// 	end
			// S_60 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00111011; 
			// 	end
			// S_61 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00111100; 
			// 	end
			// S_62 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00111101; 
			// 	end
			// S_63 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00111110; 
			// 	end
			// S_64 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b00111111; 
			// 	end
			// S_65 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01000000; 
			// 	end
			// S_66 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01000001; 
			// 	end
			// S_67 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01000010; 
			// 	end
			// S_68 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01000011; 
			// 	end
			// S_69 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01000100; 
			// 	end
			// S_70 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01000101; 
			// 	end
			// S_71 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01000110; 
			// 	end
			// S_72 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01000111; 
			// 	end
			// S_73 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01001000; 
			// 	end
			// S_74 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01001001; 
			// 	end
			// S_75 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01001010; 
			// 	end
			// S_76 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01001011; 
			// 	end
			// S_77 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01001100; 
			// 	end
			// S_78 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01001101; 
			// 	end
			// S_79 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01001110; 
			// 	end
			// S_80 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01001111; 
			// 	end
			// S_81 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01010000; 
			// 	end
			// S_82 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01010001; 
			// 	end
			// S_83 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01010010; 
			// 	end
			// S_84 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01010011; 
			// 	end
			// S_85 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01010100; 
			// 	end
			// S_86 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01010101; 
			// 	end
			// S_87 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01010110; 
			// 	end
			// S_88 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01010111; 
			// 	end
			// S_89 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01011000; 
			// 	end
			// S_90 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01011001; 
			// 	end
			// S_91 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01011010; 
			// 	end
			// S_92 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01011011; 
			// 	end
			// S_93 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01011100; 
			// 	end
			// S_94 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01011101; 
			// 	end
			// S_95 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01011110; 
			// 	end
			// S_96 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01011111; 
			// 	end
			// S_97 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100000; 
			// 	end
			// S_98 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100001; 
			// 	end
			// S_99 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100010; 
			// 	end
			// S_100 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100011; 
			// 	end
			// S_102 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100100; 
			// 	end
			// S_103 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100101; 
			// 	end
			// S_104 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100110; 
			// 	end
			// S_105 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100111; 
			// 	end
			// S_106 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01101000; 
			// 	end
			// S_107 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01101001; 
			// 	end
			// S_108 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01101010; 
			// 	end
			// S_109 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01101011; 
			// 	end
			// S_110 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01101100; 
			// 	end
			// S_111 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01101101; 
			// 	end
			// S_112 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01101110; 
			// 	end
			// S_113 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01101111; 
			// 	end
			// S_114 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01110000; 
			// 	end
			// S_115 : //113
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01110001; 
			// 	end
			// S_116 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01110010; 
			// 	end
			// S_117 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01110011; 
			// 	end
			// S_118 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100011; 
			// 	end
			// S_119 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100011; 
			// 	end
			// S_120 : //18
			// 	begin 
			// 		LD_bgd_all = 1'b0;
			// 		LD_fgd_sprite = 1'b1;
			// 		wren_a = 1'b1; 
			// 		object = 8'b01100011; 
			// 	end
			S_wait : 
				begin 
					LD_bgd_all = 1'b0;
					count_start = 1'b0; 
					LD_fgd_sprite = 1'b0;
                   
                    sp_count = 1'b0; 
					//object = 8'b00000111; 
				end
			W_1 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00000000; 
				end
			W_2 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00000001; 
				end
			W_3 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00000010; 
				end
			W_4 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00000011; 
				end
			W_5 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00000100; 
				end
			W_6 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00000101; 
				end
			W_7 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00000110; 
				end
			W_8 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00000111; 
				end
			W_9 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00001000; 
				end
			W_10 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00001001; 
				end
			W_11 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00001010; 
				end
			W_12 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00001011; 
				end
			W_13 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00001100; 
				end
			W_14 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00001101; 
				end
			W_15 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00001110; 
				end
			W_16 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00001111; 
				end
			W_17 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00010000; 
				end
			W_18 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00010001; 
				end
			W_19 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00010010; 
				end
			W_20 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00010011; 
				end
			W_21 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00010100; 
				end
			W_22 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00010101; 
				end
			W_23 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00010110; 
				end
			W_24 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00010111; 
				end
			W_25 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00011000; 
				end
			W_26 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00011001; 
				end
			W_27 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00011010; 
				end
			W_28 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00011011; 
				end
			W_29 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00011100; 
				end
			W_30 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00011101; 
				end
			W_101 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00011110; 
				end
			W_31 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00011111; 
				end
			W_32 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00100000; 
				end
			W_33 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00100001; 
				end
			W_34 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00100010; 
				end
			W_35 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00100011; 
				end
			W_36 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00100100; 
				end
			W_37 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00100101; 
				end
			W_38 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00100110; 
				end
			W_39 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00100111; 
				end
			W_40 :
				begin
					sp_count = 1'b0; 
					LD_fgd_sprite = 1'b0; 
					LD_bgd_all = 1'b0; 
					object = 8'b00101000; 
				end
	
			default : ;
		endcase
	end 
endmodule



