#ifndef BASEACTUATOR_H
#define BASEACTUATOR_H

#include "smartDevice.h"
#include "Arduino.h"

class baseActuator : public smartDevice{
    // d
protected:
    bool isMoving = false;
    int actuatorPin;
    
public:
    baseActuator(int pin) : actuatorPin(pin) {  
    }


    void deviceSetup() override{
        pinMode(actuatorPin, OUTPUT);
    }

    void startAction(){
            digitalWrite(actuatorPin, HIGH);
    }

    void stopAction(){
            digitalWrite(actuatorPin, LOW);
    } 
};
#endif


