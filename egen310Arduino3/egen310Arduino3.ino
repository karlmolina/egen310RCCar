#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "BluetoothSerial.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield();

Adafruit_DCMotor *rightMotor = AFMS.getMotor(1);
Adafruit_DCMotor *leftMotor = AFMS.getMotor(4);

BluetoothSerial SerialBT;

void setup() {
  SerialBT.begin("Tiger");
  //Serial.begin(250000);

  AFMS.begin();
}

String received = "";

void loop() {
  if (SerialBT.available()) {
    char c = SerialBT.read();
    received += c;
    if (c == '\n') {
      if (received.length() == 9) {
        String leftSub = received.substring(0, 4);
        String rightSub = received.substring(4, 8);
        int leftSpeed = leftSub.toInt();
        int rightSpeed = rightSub.toInt();

        if (rightSpeed < 0) {
          rightMotor->setSpeed(-rightSpeed);
          rightMotor->run(BACKWARD);
        } else if (rightSpeed > 0) {
          rightMotor->setSpeed(rightSpeed);
          rightMotor->run(FORWARD);
        } else if (rightSpeed == 0) {
          rightMotor->run(RELEASE);
        }
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
      received = "";
    }
  }
}

