gesture-drone
=============

Gesture-Controlled Quadcopers


Installing Kinect Software:

OSX:

1. Install Homebrew
2. Run the following:
    brew install libfreenect
    brew install cmake`
    cd libfreenect
    mkdir build
    cd build
    cmake -L ..
    make

To compile PointViewer, cd into the PointViewer directory and run `make`

This will run the following:
`c++ -o ../Bin/x64-Release/Sample-PointViewer ./x64-Release/main.o
./x64-Release/PointDrawer.o ./x64-Release/signal_catch.o -framework
OpenGL -framework GLUT -arch x86_64  -L../Bin/x64-Release
-L/usr/local/lib/ -lOpenNI -lXnVNite_1_5_2`

OpenNI is automatically installed in /usr/lib, and for some reason it's
not recognized by the linker when it's in there, so you have to copy
/usr/lib/libOpenNI.dylib to /usr/local/lib/libOpenNI.dylib, and run make





Installing FTDI Drivers:
http://www.ftdichip.com/Support/Documents/InstallGuides.htm

download both dmgs, install the first, and follow the instructions to
install the second here:

http://www.ftdichip.com/Support/Documents/AppNotes/AN_134_FTDI_Drivers_Installation_Guide_for_MAC_OSX.pdf

Then to include FTDI header file:

sudo mkdir /usr/include/ftdi
sudo cp ftd2xx.h /usr/include/ftdi
sudo cp WinTypes.h /usr/include/ftdi

programming guide:
http://www.ftdichip.com/Support/Documents/ProgramGuides/D2XX_Programmer's_Guide(FT_000071).pdf
