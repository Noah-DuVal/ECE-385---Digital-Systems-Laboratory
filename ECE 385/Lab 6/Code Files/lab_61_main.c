// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
    int wait = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; 	//make a pointer to access the PIO block
	volatile unsigned int *sw = (unsigned int*)0x60; 		//Makes pointer to Switches
	volatile unsigned int *acc = (unsigned int*)0x50;		//pointer to buttons
	//volatile unsigned int *reset = (unsigned int*)0x60;		//pointer to buttons

	volatile unsigned int sum = 0; 
	volatile unsigned int ovflow = 0;

	*LED_PIO = 0; 						//clear all LEDs


    while ((1+1) != 3)
    {
        
        if (*acc == 1 && wait == 0)
        {
            
            sum += *sw;

            if (sum > 255)	//accounts for overflow
            {
                ovflow = sum - 255;
                sum = 0 + ovflow;
            }
            *LED_PIO = sum;
            wait = 1;
        }
        
        if (*acc == 0)
        {
            wait = 0;
        }

    }
    return 1;
}







	/*
	while ( (1+1) != 3) 				//infinite loop
	{
		for (i = 0; i < 100000; i++); 	//software delay
		*LED_PIO |= 0x1; 				//set LSB
		for (i = 0; i < 100000; i++); 	//software delay
		*LED_PIO &= ~0x1;				//clear LSB
	}
	return 1; 							//never gets here
	*/





	// while ((1+1) !=3)				//infitie loo to constantly check if accum is pressed
	// {
	// 	if (*acc == 1)				//When accumulate pressed start
	// 	{
	// 		sum = *sw;   			//loads switch to sum and LEDs (havnet created sw yet)
	// 		*LED_PIO = sum;
	// 		while (*reset == 0)		//accumulate until reset is pressed
	// 		{
	// 			sum += *sw;
			
	// 			if (sum > 255)	//accounts for overflow
	// 			{
	// 				ovflow = sum - 255;
	// 				sum = 0 + ovflow;
	// 			}
				
	// 			*LED_PIO = sum;
	// 		}
	// 		*LED_PIO = 0;				//Set accum/LEDS to zero once rest is pressed
	// 	}
	// }	
    // return 1;                           //Never gets here



    

    