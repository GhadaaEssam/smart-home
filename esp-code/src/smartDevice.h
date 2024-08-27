#ifndef SMARTDEVICE_H
#define SMARTDEVICE_H

class smartDevice {
    // an interface for all actuatirs and sensors
public:
    // Pure virtual function for establishing a connection
    virtual void deviceSetup() = 0;

    // Virtual destructor
    virtual ~smartDevice() {}
};

#endif
