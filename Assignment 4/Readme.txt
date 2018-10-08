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

	1. Assingment 4.1
		a. Connect the ADC convertor and stepper motor to the board via the 8255 ports on the board.
		b. Connect the Oscilloscope to the ADC Convertor.
		c. Turn on the oscilloscope, turn on output, set the value to 0
		d. Press the GO button
		e. Enter 9000 as that is the start address of where the instructions are stored exec.
		f. Press Exec button to start the program.
		g. Now depending on the voltage on the oscilloscope the rpm of motor will depend.
		h. The values are to be given from 0V to 4.75V only.
		i. Also the converted digital output is shown on the data display of the board and channel number on the address display.

	2. Assignment 4.2
		a. Connect the ADC convertor and stepper motor to the board via the 8255 ports on the board.
		b. Connect the Oscilloscope to the ADC Convertor.
		c. Turn on the oscilloscope, turn on output, set the value to 0.
		d. Press the GO button.
		e. Enter 9000 as that is the start address of where the instructions are stored exec.
		f. Press Exec button to start the program.
		g. Now set a voltage depending on how much you want to rotate, where on 0V angle rotated is 0 and 3.9V angle rotated is 360.
		h. When voltage is set press any key to rotate the motor, in which the motor will first go to 0 degree and then to the required angle.
