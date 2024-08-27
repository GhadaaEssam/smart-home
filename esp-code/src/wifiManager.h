#ifndef WIFIMANAGER_H
#define WIFIMANAGER_H

#include <WiFi.h>
#include "Connection.h"

class wifiManager: public Connection {
    // a class responsible for managing wifi connection; implements the Connection interface
public:
    wifiManager(const char* ssid, const char* pass) : ssid(ssid), pass(pass) {
    }

    // this method begins the connection and is revoked in the setup() and prints the local ip
    void connect() override{
        Serial.println();
        Serial.print("Connecting to ");
        Serial.println(ssid);

        WiFi.mode(WIFI_STA);
        WiFi.begin(ssid, pass);

        while (WiFi.status() != WL_CONNECTED) {
            delay(500);
            Serial.print(".");
        }
        randomSeed(micros());

        Serial.println("");
        Serial.println("WiFi connected");
        Serial.println("IP address: ");
        Serial.println(WiFi.localIP());
    }

    // Check if connected to WiFi
    bool isConnected() override{
        return WiFi.status() == WL_CONNECTED;
    }

    // disconnectt wifi
    void disconnect() override {
        WiFi.disconnect();
        Serial.println("WiFi disconnected");
    }

    // Get local IP address
    IPAddress getLocalIP() {
        return WiFi.localIP();
    }

    // checks the wifi connection
    void check_connection(){
        if (isConnected()) {
            Serial.print("Connected to WiFi. IP Address: ");
            Serial.println(getLocalIP());
        } else {
            Serial.println("Failed to connect to WiFi.");
        }
    }

private:
    const char* ssid;
    const char* pass;
};

#endif
