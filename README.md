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
