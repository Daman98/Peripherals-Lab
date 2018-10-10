Group 15- 
1. Apurva N. Sarogi 160101013
2. Daman Tekchandani 160101024
3. Samyak Jain 160101059
4. Shreyanshi Bharadia 160101067

Steps to Run - 
1. Open command prompt as administrator.
2. Change directory to the folder containing asm file.
3. run command "c16 -h test.hex -l test.lst file_name.asm".
4. Run xt85.exe.
5. Keep dip switch 1 on always.
6. Switch on 4th dip switch and press reset on board.
7. Press ctrl+d and enter file name test.hex
8. Press enter till download is complete.
9. Enter the input as mentioned below-

	The folder consist of two files-

	1. Assingment 3.1
		a. Connect the LCI to the 8255 port. Verify that it is working properly and lower all the values in DIP switch.
		b. First Press the Go button
		c. Enter 9000 as that is the start address of where the instructions are stored exec.
		d. Press GO on the address display.
		e. Now once you high the 6th DIP switch the serial blinking of led lights will begin.
		f. On making 5th switch high the blinking pauses.
		g. On making it low the blinking will start again given that 6th swith is high.
		g. On making 2nd switch high the blinking terminates.

	2. Angry Birds v0.0001
		a. First connect the LCI to 8255 port. Verify that it is working properly and lower all the values in DIP switch.
		b. Now set the location 8200 with any number, same goes for 8201. Also set 8206 as 28. If the high score needs to be updated, reset 8700 to 0.
		c. First Press the Go button
		d. Enter 9000 as that is the start address of where the instructions are stored
		e. Press GO button and the game will start.
		f. Now the level 0 of the game will start. In level 0 we have turn the dip switch on whose led is glowing, if we complete this more than or equal to three times. Once a level is over you can see its stats by pressing the next button, ultimately it will show LEVL 1, after pressing next level 1 will start.
		g. If you are in level 1 the rules are same as level 0, but the speed is faster.
		h. Now the rules for level 2 are different, you will have to count the number of lights on and turn that dip switch on.
		i. On Completion High Score will also be displayed.

