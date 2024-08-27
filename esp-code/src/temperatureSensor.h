#ifndef TEMPERATURESENSOR_H
#define TEMPERATURESENSOR_H
#include "Sensor.h"

class temperatureSensor:public Sensor{
    // a class for temperature sensor a child of Sensor 
private:
    const float BETA = 3950 ; // Beta parameter for NTC Thermistor
public:
    temperatureSensor(int pin,mqttManager* mqttClient) : Sensor(pin,mqttClient){}

    float readTemperature() {
        sense(); // Call base class's sense method
        // Convert the analog value to resistance
        float resistance = 10000.0 * (4095.0 / reading - 1.0);

        // Calculate the temperature in Celsius using the Beta parameter equation
        float temperatureC = 1.0 / (log(resistance / 10000.0) / BETA + 1.0 / 298.15) - 273.15;
        reading =  (int)(-temperatureC);
        return -temperatureC;  // Return the temperature in Celsius
    }

};
#endif

