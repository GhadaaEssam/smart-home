#ifndef SENSOR_H
#define SENSOR_H
#include "Arduino.h"
#include "smartDevice.h"
#include "mqttManager.h"

class Sensor:public smartDevice{

    // this class if for any basic sensor 
    // irsensor and soilmoisture sensor just instantiated from this class 
protected:    
    int sensorPin;
    int reading;
    mqttManager* sensorMqttClient;  

public:

    Sensor(int pin, mqttManager* mqttClient) 
        : sensorPin(pin), sensorMqttClient(mqttClient), reading(0) {
        
    }
    // takes the name of the reading and prints the reading to the serial
    void printtoSerial(String name){
        Serial.print(name);
        Serial.print(": ");
        Serial.println(reading);
    }
    //overriden from smartdevice interface used to attach the device to its pin in setup()
    void deviceSetup() override{
        pinMode(sensorPin , INPUT);
    }
    // the basic for all classes is analogread except for flame sensor so we overriden 
    // this method there
    virtual void sense(){
        reading = analogRead(sensorPin); 
    }

    // return the reading
    int getReading() const{
        return reading;
    }

    // a method for publishing reading to MQTT broker given the topic
    // it used the MQTTmanager instance that was taken in the constructor
    void publishReading(const char* topic) {
        if (sensorMqttClient && sensorMqttClient->isConnected()) {
            String readingStr = String(reading);
            sensorMqttClient->publishMessage(topic, readingStr);
        } else {
            Serial.println("MQTT client not connected.");
        }
    }
};
#endif

