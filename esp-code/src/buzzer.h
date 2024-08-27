#ifndef BUZZER_H
#define BUZZER_H
#include "baseActuator.h"
class buzzer: public baseActuator{
private:
    /* data */
public:
    buzzer(int pin) : baseActuator(pin) {}
    // class defines different beeps of buzzer

    void doorBuzzSuccess(){
        startAction();
        delay(50);
        stopAction();
        delay(50);
        startAction();
        delay(50);
        stopAction();
        delay(1000);
    }

    void doorBuzzDenied(){
        startAction();
        delay(500);
        stopAction();
        delay(800);
    }

    void shortBeep() {
        startAction();
        delay(100);  
        stopAction();
    }

    void longBeep() {
        startAction();
        delay(500);  
        stopAction();
    }
};
#endif


