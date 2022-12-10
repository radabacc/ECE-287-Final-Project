# ECE-287-Final-Project

This project is for my ECE 287 end of the year Verilog project.

The original idea for this Verilog project was to make an old game called Tron Light Cycles. This idea would take a fully working VGA module including the controller and the adapter. The original plan also had laid out a players class, a enormous register holding both of the players' trails coordinates, and a creation of the game board. The two tron bikes would move around the map leaving a trail behind them trying to get the other bike to run into their trail all while dodging the opponents trail. The players were gonna be controlled by the PS2 keyboard WASD and ARROW keys.

The project turned out to be a struggle trying to get various VGA modules to work. Just this week we were able to find someone in the class who had a working VGA module(Chris Lallo). We then looked on the internet and through the code to figure out how to get an output to the screen. We finally figured it out and are able to change the pixels of a 32x16 bit image. The color is a 3 bit register which can ouput 8 colors to the screen. The pixels of the image can be altered by hardcoding each individual bit of the image starting from top left and working across the screen to the right and then repeat for the next row.

Our design is using a working VGA controller and VGA adapter to display our VGA output on to the screen. This VGA can display in multiple resolutions including 320x240 or 160x120. This can be changed by editing a value inside of the code.

The class used to display the image consists of a finite state machine that loops through each indvidual pixel and changing the color of those pixels if the parameter is defined on or off for that given pixel. The parameter is made to declare the bits of the different sizes images. The image in our project is 32x16 which are defined in imageWidth and imageHeight respectively.

To summarize this project is a working VGA module which can display an image to the screen which the color and pixels of the image can be altered along with the width and height of the image can also be altered.
