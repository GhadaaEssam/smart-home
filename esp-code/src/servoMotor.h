#ifndef SERVOMOTOR_H
#define SERVOMOTOR_H
#include "baseActuator.h"
#include "Arduino.h"
#include "ESP32Servo.h"

class servoMotor: public baseActuator{
private:
    int degree;
    Servo myservo;
public:
    servoMotor(int pin) : baseActuator(pin) {}
    
    // Override deviceSetup to attach the servo
    void deviceSetup() override{
        myservo.attach(actuatorPin); 
    }

    // Additional methods for controlling the servo
    void setAngle(int angle) {
        if(angle>=0 && angle<=180)
        myservo.write(angle);  // Set the servo angle
    }

};
#endif

