// Include the necessary libraries
#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "BluetoothSerial.h"

// The motorshield
Adafruit_MotorShield AFMS = Adafruit_MotorShield();

// The right and left motors
Adafruit_DCMotor *rightMotor = AFMS.getMotor(1);
Adafruit_DCMotor *leftMotor = AFMS.getMotor(4);

// Bluetooth serial port
BluetoothSerial SerialBT;

void setup() {
  // Start the bluetooth
  SerialBT.begin("Tiger");

  // Start the motorshield
  AFMS.begin();

  // Turn on the power LED
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
}

// String buffer to store the received bluetooth data
String received = "";

void loop() {
  if (SerialBT.available()) {
    // Read the bluetooth data
    char c = SerialBT.read();
    // Add it to the buffer
    received += c;
    // If the data is done sending
    if (c == '\n') {
      if (received.length() == 9) {
        // Get the motor speed data
        String leftSub = received.substring(0, 4);
        String rightSub = received.substring(4, 8);
        int leftSpeed = leftSub.toInt();
        int rightSpeed = rightSub.toInt();

        // Turn on the right motor according to the data
        if (rightSpeed < 0) {
          rightMotor->setSpeed(-rightSpeed);
          rightMotor->run(BACKWARD);
        } else if (rightSpeed > 0) {
          rightMotor->setSpeed(rightSpeed);
          rightMotor->run(FORWARD);
        } else if (rightSpeed == 0) {
          rightMotor->run(RELEASE);
        }
        // Turn on the left motor
        if (leftSpeed < 0) {
          leftMotor->setSpeed(-leftSpeed);
          leftMotor->run(BACKWARD);
        } else if (leftSpeed > 0) {
          leftMotor->setSpeed(leftSpeed);
          leftMotor->run(FORWARD);
        } else if (leftSpeed == 0) {
          leftMotor->run(RELEASE);
        }
      }
      // Reset the buffer
      received = "";
    }
  }
}

