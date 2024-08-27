#ifndef CONNECTION_H
#define CONNECTION_H

class Connection {
    // an interface to define the main methods in the connections used in the system
public:
    // Pure virtual function for establishing a connection
    virtual void connect() = 0;

    // Pure virtual function to check if connected
    virtual bool isConnected() = 0;

    // Pure virtual function for disconnecting
    virtual void disconnect() = 0;

    // Virtual destructor
    virtual ~Connection() {}
};

#endif
