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

	1. 24hrs Clock
		a. First Press the Go button
		b. Enter 9000 as that is the start address of where the instructions are stored exec.
		c. Press GO on the address display CLOC will be written. after that press 0 2 times.
		d. Now you will see 4 0's 0000 now enter the time your want to start the clock from in the format HH:MM
		e. After that press the next button, so now the clock will start running.
		f. If the HH value is greater than 24 it is automatically initialised to 00.

	2. Timer
		a. First we will need to set the interrupt routine for the program, so that will be done by adding the Code of "LAB" to 8fbf location.
		b. To do this we will open the test.lst file and see from where the code starts for lab, enter that particular address and opcode data in the field in the order OPCODE, INSTr(lower), INSTR(higher).
		c. First Press the Go button
		d. Enter 9000 as that is the start address of where the instructions are stored
		e. Press GO on the address display CLOC will be written. after that press 0 2 times.
		f. Now you will see 4 0's 0000 now enter the time your want to start the clock from in the format HH:MM
		g. After that press the next button, so now the timer will start running.

