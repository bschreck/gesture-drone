#include "SerialWrite.h"

void serialize(HandCoordinates* hc, char *q)
{
    *q = 'S';                            q++;
    *q = *(((char*)&(hc->left_x))+1);    q++;
    *q = *((char*) &(hc->left_x));       q++;

    *q = *(((char*)&(hc->left_y))+1);    q++;
    *q = *((char*) &(hc->left_y));       q++;

    *q = *(((char*)&(hc->left_z))+1);    q++;
    *q = *((char*) &(hc->left_z));       q++;

    *q = *(((char*)&(hc->right_x))+1);   q++;
    *q = *((char*) &(hc->right_x));      q++;

    *q = *(((char*)&(hc->right_y))+1);   q++;
    *q = *((char*) &(hc->right_y));      q++;

    *q = *(((char*)&(hc->right_z))+1);   q++;
    *q = *((char*) &(hc->right_z));      q++;


    /*
     *char *toPrint = q;
     **q = 'S';              q++;
     *uint16_t *p = (uint16_t*)q;
     **p = hc->left_x;       p+=1;
     **p = hc->left_y;       p+=1;
     **p = hc->left_z;       p+=1;
     **p = hc->right_x;      p+=1;
     **p = hc->right_y;      p+=1;
     **p = hc->right_z;      p+=1;
     */


};


int
set_interface_attribs (int fd, int speed, int parity)
{
        struct termios tty;
        memset (&tty, 0, sizeof tty);
        if (tcgetattr (fd, &tty) != 0)
        {
                printf("error %d from tcgetattr", errno);
                return -1;
        }

        cfsetospeed (&tty, speed);
        cfsetispeed (&tty, speed);

        tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8;     // 8-bit chars
        // disable IGNBRK for mismatched speed tests; otherwise receive break
        // as \000 chars
        //tty.c_iflag &= ~IGNBRK;         // disable break processing
        tty.c_iflag &= IGNBRK;         // disable break processing
        tty.c_lflag = 0;                // no signaling chars, no echo,
                                        // no canonical processing
        tty.c_oflag = 0;                // no remapping, no delays
        tty.c_cc[VMIN]  = 0;            // read doesn't block
        tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

        tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl

        tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
                                        // enable reading
        tty.c_cflag &= ~(PARENB | PARODD);      // shut off parity
        tty.c_cflag |= parity;
        tty.c_cflag &= ~CSTOPB;
        tty.c_cflag &= ~CRTSCTS;

        if (tcsetattr (fd, TCSANOW, &tty) != 0)
        {
                printf("error %d from tcsetattr", errno);
                return -1;
        }
        return 0;
}

void
set_blocking (int fd, int should_block)
{
        struct termios tty;
        memset (&tty, 0, sizeof tty);
        if (tcgetattr (fd, &tty) != 0)
        {
                printf("error %d from tggetattr", errno);
                return;
        }

        tty.c_cc[VMIN]  = should_block ? 1 : 0;
        tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

        if (tcsetattr (fd, TCSANOW, &tty) != 0)
                printf("error %d setting term attributes", errno);
}


enum
{
    kNumRetries = 3
};

int initializeSerialPort(char *portname) {
  int fd = open (portname, O_RDWR | O_NOCTTY | O_SYNC);
  printf("FD OPEN, fd = %d", fd);
  if (fd < 0)
  {
          printf("error %d opening %s: %s", errno, portname, strerror (errno));
          return -1;
  }

  set_interface_attribs (fd, B9600, 0);  // set speed to 115,200 bps, 8n1 (no parity)
  set_blocking (fd, 0);                // set no blocking
  return fd;

}
//FT_HANDLE initializeSerialPort()
//{
//
//    FT_STATUS ftStatus = FT_IO_ERROR;
//    FT_HANDLE ftHandle;
//    int target = 0;
//
//    DWORD dwVID;
//    DWORD dwPID;
//    ftStatus = FT_SetVIDPID(dwVID, dwPID);
//
//    DWORD numDevs;
//    ftStatus = FT_CreateDeviceInfoList(&numDevs);
//    if (ftStatus == FT_OK) {
//      printf("Number of devices is %d\n",numDevs);
//      FT_DEVICE_LIST_INFO_NODE *devInfo;
//
//if (numDevs > 0) {
//// allocate storage for list based on numDevs
//devInfo = (FT_DEVICE_LIST_INFO_NODE*)malloc(sizeof(FT_DEVICE_LIST_INFO_NODE)*numDevs);
//// get the device information list
//ftStatus = FT_GetDeviceInfoList(devInfo,&numDevs);
//if (ftStatus == FT_OK) {
//for (int i = 0; i < numDevs; i++) {
//printf("Dev %d:\n",i);
//printf(" Flags=0x%x\n",devInfo[i].Flags);
//printf(" Type=0x%x\n",devInfo[i].Type);
//printf(" ID=0x%x\n",devInfo[i].ID);
//printf(" LocId=0x%x\n",devInfo[i].LocId);
//printf(" SerialNumber=%s\n",devInfo[i].SerialNumber);
//printf(" Description=%s\n",devInfo[i].Description);
//printf(" ftHandle=0x%x\n",devInfo[i].ftHandle);
//}
//}
//}
//
//    }
//    else {
//      printf("info list ceration failed");
//    // FT_CreateDeviceInfoList failed
//    }
//
//    ftStatus = FT_Open(target, &ftHandle);
//    printf("code = %u\n", ftStatus);
//    if (ftStatus == FT_DEVICE_NOT_OPENED) printf("not opened");
//    if (ftStatus == FT_DEVICE_NOT_FOUND) printf("not found");
//    /*
//     *while (ftStatus != FT_OK) {
//     *  ftStatus = FT_Open(target, &ftHandle);
//     *  printf("code = %u\n", ftStatus);
//     *  if (ftStatus == FT_DEVICE_NOT_OPENED) printf("not opened");
//     *  if (ftStatus == FT_DEVICE_NOT_FOUND) printf("not found");
//     *  target++;
//     *  if (target == 5) break;
//     *}
//     */
//    return ftHandle;



//    int         fileDescriptor;
//    kern_return_t   kernResult;
//
//    io_iterator_t   serialPortIterator;
//    char        deviceFilePath[MAXPATHLEN];
//
//    kernResult = MyFindModems(&serialPortIterator);
//
//    kernResult = MyGetModemPath(serialPortIterator, deviceFilePath,
//                     sizeof(deviceFilePath));
//
//    printf("deviceFilePath = %s\n", deviceFilePath);
//    IOObjectRelease(serialPortIterator);    // Release the iterator.
//
//
//    // Open the modem port, initialize the modem, then close it.
//    if (!deviceFilePath[0])
//    {
//        printf("No modem port found.\n");
//        return EX_UNAVAILABLE;
//    }
//
//    fileDescriptor = MyOpenSerialPort("/dev/cu.usbmodem1411");//deviceFilePath);
//    if (fileDescriptor == kMyErrReturn)
//    {
//        return EX_IOERR;
//    }
//
//    return fileDescriptor;
//    /*
//     *if (MyInitializeModem(fileDescriptor))
//     *{
//     *    printf("Modem initialized successfully.\n");
//		 *    return fileDescriptor;
//     *}
//     *else {
//     *    printf("Could not initialize modem.\n");
//		 *    return -1;
//     *}
//     */


//int writeToSerialPort(FT_HANDLE fd, HandCoordinates *in_coords) {
//    char send_buffer[sizeof(HandCoordinates)+2];
//    send_buffer[0] = 's';
//    send_buffer[sizeof(HandCoordinates)+1] = '\n';
//    memcpy((&send_buffer)+1, in_coords, sizeof(HandCoordinates));
//    //printf("Hand %d, Point (%d,%d,%d)\n", in_coords[0].hand_id, in_coords[0].left_x, in_coords[0].left_y, in_coords[0].left_z);
//    //int n = write(fd, send_buffer, sizeof(HandCoordinates)+2);
//
//    //return n;
//    //
//    //
//    //
//    //
//
//
//    DWORD BytesWritten;
//    FT_STATUS ftStatus;
//    ftStatus = FT_Write(fd, send_buffer, sizeof(send_buffer), &BytesWritten);
//    if (ftStatus == FT_OK) {
//      // FT_Write OK
//      printf("write ok");
//      return 0;
//    }
//    else {
//      printf("write failed");
//      return 0;
//      // FT_Write Failed
//      return -1;
//    }
//}



static kern_return_t MyFindModems(io_iterator_t *matchingServices)
{
    kern_return_t       kernResult;
    mach_port_t         masterPort;
    CFMutableDictionaryRef  classesToMatch;

    kernResult = IOMasterPort(MACH_PORT_NULL, &masterPort);
    if (KERN_SUCCESS != kernResult)
    {
        printf("IOMasterPort returned %d\n", kernResult);
    goto exit;
    }

    // Serial devices are instances of class IOSerialBSDClient.
    classesToMatch = IOServiceMatching(kIOSerialBSDServiceValue);
    if (classesToMatch == NULL)
    {
        printf("IOServiceMatching returned a NULL dictionary.\n");
    }
    else {
        CFDictionarySetValue(classesToMatch,
                             CFSTR(kIOSerialBSDTypeKey),
                             CFSTR(kIOSerialBSDModemType));

        // Each serial device object has a property with key
        // kIOSerialBSDTypeKey and a value that is one of
        // kIOSerialBSDAllTypes, kIOSerialBSDModemType,
        // or kIOSerialBSDRS232Type. You can change the
        // matching dictionary to find other types of serial
        // devices by changing the last parameter in the above call
        // to CFDictionarySetValue.
    }

    kernResult = IOServiceGetMatchingServices(masterPort, classesToMatch, matchingServices);
    if (KERN_SUCCESS != kernResult)
    {
        printf("IOServiceGetMatchingServices returned %d\n", kernResult);
    goto exit;
    }

exit:
    return kernResult;
}

static kern_return_t MyGetModemPath(io_iterator_t serialPortIterator, char *deviceFilePath, CFIndex maxPathSize)
{
    io_object_t     modemService;
    kern_return_t   kernResult = KERN_FAILURE;
    Boolean     modemFound = false;

    // Initialize the returned path
    *deviceFilePath = '\0';

    // Iterate across all modems found. In this example, we exit after
    // finding the first modem.

    while ((!modemFound) && (modemService = IOIteratorNext(serialPortIterator)))
    {
        CFTypeRef   deviceFilePathAsCFType;
        CFStringRef deviceFilePathAsCFString;

    // Get the callout device's path (/dev/cu.xxxxx).
    // The callout device should almost always be
    // used. You would use the dialin device (/dev/tty.xxxxx) when
    // monitoring a serial port for
    // incoming calls, for example, a fax listener.

    deviceFilePathAsCFType = IORegistryEntryCreateCFProperty(modemService,
                            CFSTR(kIOCalloutDeviceKey),
                            kCFAllocatorDefault,
                            0);
        if (CFGetTypeID(deviceFilePathAsCFType) == CFStringGetTypeID()) {
            deviceFilePathAsCFString = (CFStringRef)deviceFilePathAsCFType;
        } else {
           // panic!
        }
        if (deviceFilePathAsCFString)
        {
            Boolean result;

        // Convert the path from a CFString to a NULL-terminated C string
        // for use with the POSIX open() call.

        result = CFStringGetCString(deviceFilePathAsCFString,
                                        deviceFilePath,
                                        maxPathSize,
                                        kCFStringEncodingASCII);
            CFRelease(deviceFilePathAsCFString);

            if (result)
            {
                printf("BSD path: %s", deviceFilePath);
                modemFound = true;
                kernResult = KERN_SUCCESS;
            }
        }

        printf("\n");

        // Release the io_service_t now that we are done with it.

    (void) IOObjectRelease(modemService);
    }

    return kernResult;
}

static int MyOpenSerialPort(const char *deviceFilePath)
{
    int         fileDescriptor = -1;
    int         handshake;
    struct termios  options;

    // Open the serial port read/write, with no controlling terminal,
    // and don't wait for a connection.
    // The O_NONBLOCK flag also causes subsequent I/O on the device to
    // be non-blocking.
    // See open(2) ("man 2 open") for details.

    fileDescriptor = open(deviceFilePath, O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (fileDescriptor == -1)
    {
        printf("Error opening serial port %s - %s(%d).\n",
               deviceFilePath, strerror(errno), errno);
        goto error;
    }

    // Note that open() follows POSIX semantics: multiple open() calls to
    // the same file will succeed unless the TIOCEXCL ioctl is issued.
    // This will prevent additional opens except by root-owned processes.
    // See tty(4) ("man 4 tty") and ioctl(2) ("man 2 ioctl") for details.

    if (ioctl(fileDescriptor, TIOCEXCL) == kMyErrReturn)
    {
        printf("Error setting TIOCEXCL on %s - %s(%d).\n",
            deviceFilePath, strerror(errno), errno);
        goto error;
    }

    // Now that the device is open, clear the O_NONBLOCK flag so
    // subsequent I/O will block.
    // See fcntl(2) ("man 2 fcntl") for details.

    if (fcntl(fileDescriptor, F_SETFL, 0) == kMyErrReturn)
    {
        printf("Error clearing O_NONBLOCK %s - %s(%d).\n",
            deviceFilePath, strerror(errno), errno);
        goto error;
    }

    // Get the current options and save them so we can restore the
    // default settings later.
    if (tcgetattr(fileDescriptor, &gOriginalTTYAttrs) == kMyErrReturn)
    {
        printf("Error getting tty attributes %s - %s(%d).\n",
            deviceFilePath, strerror(errno), errno);
        goto error;
    }

    // The serial port attributes such as timeouts and baud rate are set by
    // modifying the termios structure and then calling tcsetattr to
    // cause the changes to take effect. Note that the
    // changes will not take effect without the tcsetattr() call.
    // See tcsetattr(4) ("man 4 tcsetattr") for details.

    options = gOriginalTTYAttrs;

    // Print the current input and output baud rates.
    // See tcsetattr(4) ("man 4 tcsetattr") for details.

    printf("Current input baud rate is %d\n", (int) cfgetispeed(&options));
    printf("Current output baud rate is %d\n", (int) cfgetospeed(&options));

    // Set raw input (non-canonical) mode, with reads blocking until either
    // a single character has been received or a one second timeout expires.
    // See tcsetattr(4) ("man 4 tcsetattr") and termios(4) ("man 4 termios")
    // for details.

    cfmakeraw(&options);
    options.c_cc[VMIN] = 1;
    options.c_cc[VTIME] = 10;

    // The baud rate, word length, and handshake options can be set as follows:

    cfsetspeed(&options, B19200);   // Set 19200 baud
    options.c_cflag |= (CS7        |// Use 7 bit words
            PARENB     |        // Enable parity (even parity if PARODD
                                // not also set)
            CCTS_OFLOW |        // CTS flow control of output
            CRTS_IFLOW);        // RTS flow control of input

    // Print the new input and output baud rates.

    printf("Input baud rate changed to %d\n", (int) cfgetispeed(&options));
    printf("Output baud rate changed to %d\n", (int) cfgetospeed(&options));

    // Cause the new options to take effect immediately.
    if (tcsetattr(fileDescriptor, TCSANOW, &options) == kMyErrReturn)
    {
        printf("Error setting tty attributes %s - %s(%d).\n",
            deviceFilePath, strerror(errno), errno);
        goto error;
    }

    // To set the modem handshake lines, use the following ioctls.
    // See tty(4) ("man 4 tty") and ioctl(2) ("man 2 ioctl") for details.

    if (ioctl(fileDescriptor, TIOCSDTR) == kMyErrReturn)
    // Assert Data Terminal Ready (DTR)
    {
        printf("Error asserting DTR %s - %s(%d).\n",
            deviceFilePath, strerror(errno), errno);
    }

    if (ioctl(fileDescriptor, TIOCCDTR) == kMyErrReturn)
    // Clear Data Terminal Ready (DTR)
    {
        printf("Error clearing DTR %s - %s(%d).\n",
            deviceFilePath, strerror(errno), errno);
    }

    handshake = TIOCM_DTR | TIOCM_RTS | TIOCM_CTS | TIOCM_DSR;
    // Set the modem lines depending on the bits set in handshake.
    if (ioctl(fileDescriptor, TIOCMSET, &handshake) == kMyErrReturn)
    {
        printf("Error setting handshake lines %s - %s(%d).\n",
            deviceFilePath, strerror(errno), errno);
    }

    // To read the state of the modem lines, use the following ioctl.
    // See tty(4) ("man 4 tty") and ioctl(2) ("man 2 ioctl") for details.

    if (ioctl(fileDescriptor, TIOCMGET, &handshake) == kMyErrReturn)
    // Store the state of the modem lines in handshake.
    {
        printf("Error getting handshake lines %s - %s(%d).\n",
            deviceFilePath, strerror(errno), errno);
    }

    printf("Handshake lines currently set to %d\n", handshake);

    // Success:
    return fileDescriptor;

    // Failure:
error:
    if (fileDescriptor != kMyErrReturn)
    {
        close(fileDescriptor);
    }

    return -1;
}

static Boolean MyInitializeModem(int fileDescriptor)
{
    char    buffer[256];    // Input buffer
    char    *bufPtr;        // Current char in buffer
    ssize_t numBytes;       // Number of bytes read or written
    int     tries;          // Number of tries so far
    Boolean result = false;

    for (tries = 1; tries <= kNumRetries; tries++)
    {
        printf("Try #%d\n", tries);

        // Send an AT command to the modem
        numBytes = write(fileDescriptor, kATCommandString,
                         strlen(kATCommandString));

    if (numBytes == kMyErrReturn)
        {
            printf("Error writing to modem - %s(%d).\n", strerror(errno),
                        errno);
            continue;
        }
    else {
        printf("Wrote %zd bytes \"%s\"\n", numBytes,
                        MyLogString(kATCommandString));
    }

    if (numBytes < strlen(kATCommandString))
    {
            continue;
    }

        printf("Looking for \"%s\"\n", MyLogString(kOKResponseString));

    // Read characters into our buffer until we get a CR or LF.
        bufPtr = buffer;
        do
        {
            numBytes = read(fileDescriptor, bufPtr, &buffer[sizeof(buffer)]
                        - bufPtr - 1);
            if (numBytes == kMyErrReturn)
            {
                printf("Error reading from modem - %s(%d).\n", strerror(errno),
                        errno);
            }
            else if (numBytes > 0)
            {
                bufPtr += numBytes;
                if (*(bufPtr - 1) == '\n' || *(bufPtr - 1) == '\r')
                {
                    break;
                }
            }
            else {
                printf("Nothing read.\n");
            }
        } while (numBytes > 0);

        // NULL terminate the string and see if we got a response of OK.
        *bufPtr = '\0';

        printf("Read \"%s\"\n", MyLogString(buffer));

        if (strncmp(buffer, kOKResponseString, strlen(kOKResponseString)) == 0)
        {
            result = true;
            break;
        }
    }

    return result;
}

static char *MyLogString(char *str)
{
    static char     buf[2048];
    char            *ptr = buf;
    int             i;

    *ptr = '\0';

    while (*str)
    {
        if (isprint(*str))
        {
            *ptr++ = *str++;
        }
        else {
            switch(*str)
            {
            case ' ':
                *ptr++ = *str;
                break;

            case 27:
                *ptr++ = '\\';
                *ptr++ = 'e';
                break;

            case '\t':
                *ptr++ = '\\';
                *ptr++ = 't';
                break;

            case '\n':
                *ptr++ = '\\';
                *ptr++ = 'n';
                break;

            case '\r':
                *ptr++ = '\\';
                *ptr++ = 'r';
                break;

            default:
                i = *str;
                (void)sprintf(ptr, "\\%03o", i);
                ptr += 4;
                break;
            }

            str++;
        }
        *ptr = '\0';
    }
    return buf;
}

void MyCloseSerialPort(int fileDescriptor)
{
    // Block until all written output has been sent from the device.
    // Note that this call is simply passed on to the serial device driver.
    // See tcsendbreak(3) ("man 3 tcsendbreak") for details.
    if (tcdrain(fileDescriptor) == kMyErrReturn)
    {
        printf("Error waiting for drain - %s(%d).\n",
            strerror(errno), errno);
    }

    // It is good practice to reset a serial port back to the state in
    // which you found it. This is why we saved the original termios struct
    // The constant TCSANOW (defined in termios.h) indicates that
    // the change should take effect immediately.
    if (tcsetattr(fileDescriptor, TCSANOW, &gOriginalTTYAttrs) ==
                    kMyErrReturn)
    {
        printf("Error resetting tty attributes - %s(%d).\n",
                    strerror(errno), errno);
    }

    close(fileDescriptor);
}
