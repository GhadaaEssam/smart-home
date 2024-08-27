#ifndef FLAMESENSOR_H
#define FLAMESENSOR_H
#include "Sensor.h"

class flameSensor : public Sensor{
    // a child of sensor that overrides sense() method as it reads digital 
private:
    /* data */
public:
    flameSensor(int pin,mqttManager* mqttClient) : Sensor(pin,mqttClient){}

    void sense() override {
        // reads digital instead of analog
        reading = digitalRead(sensorPin); 
    }
};
#endif

