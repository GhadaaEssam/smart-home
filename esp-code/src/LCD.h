#ifndef LCD_H
#define LCD_H

#include <LiquidCrystal_I2C.h>
#include "baseActuator.h"

class LCD : public smartDevice {
public:
    // Constructor
    LCD() :  lcd(0x27, lcdColumns, lcdRows) {}

    // Override setup method to initialize the LCD
    void deviceSetup() override {
        lcd.init();
        lcd.backlight();
        lcd.setCursor(0,0);
        lcd.print("Approximate your Card");
    }

    // Method to print a message on the LCD
    void printMessage(int row, int col, const String &message) {
        lcd.setCursor(col, row);
        lcd.print(message);
    }

    // Method to clear the display
    void clear() {
        lcd.clear();
    }

private:
    static const int lcdColumns = 16;
    static const int lcdRows = 2;
    LiquidCrystal_I2C lcd;
};

#endif