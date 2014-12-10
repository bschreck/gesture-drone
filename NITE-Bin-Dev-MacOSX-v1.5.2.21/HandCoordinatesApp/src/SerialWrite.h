#ifndef SERIAL_WRITE_H_
#define SERIAL_WRITE_H_

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <paths.h>
#include <termios.h>
#include <sysexits.h>
#include <sys/param.h>
#include <sys/select.h>
#include <sys/time.h>
#include <time.h>
#include <stdio.h>


//#include "ftd2xx.h"		//USB drivers

#include <CoreFoundation/CoreFoundation.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#include <pthread.h>

#define HAND_COORD_BUF_SIZE 1

#define LOCAL_ECHO

#ifdef LOCAL_ECHO
#define kOKResponseString "AT\r\r\nOK\r\n"
#else
#define kOKResponseString "\r\nOK\r\n"
#endif

#define kATCommandString        "AT\r"
#define kMyErrReturn            -1



typedef struct {
  uint16_t left_x;
  uint16_t left_y;
  uint16_t left_z;
  uint16_t right_x;
  uint16_t right_y;
  uint16_t right_z;
} HandCoordinates;

typedef char SerialHandCoordinates[sizeof(uint16_t)*6+1];
//tets
void serialize(HandCoordinates* hc, SerialHandCoordinates serial_hc);


//int writeToSerialPort(FT_HANDLE fd, HandCoordinates *in_coords);
//FT_HANDLE initializeSerialPort();
int initializeSerialPort(char *portname);

static struct termios gOriginalTTYAttrs;

static kern_return_t MyFindModems(io_iterator_t *matchingServices);
static kern_return_t MyGetModemPath(io_iterator_t serialPortIterator, char *deviceFilePath, CFIndex maxPathSize);
static int MyOpenSerialPort(const char *deviceFilePath);
static Boolean MyInitializeModem(int fileDescriptor);
static char *MyLogString(char *str);
void MyCloseSerialPort(int fileDescriptor);

#endif
