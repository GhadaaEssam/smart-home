#include <Arduino.h>
#include "smartHome.h"

smartHome mySmartHome;

void setup() {
    delay(500);
    Serial.begin(115200);
    delay(500);
    mySmartHome.setup();
    mySmartHome.establishConnections();
}

void loop() {
    mySmartHome.loop();
}

