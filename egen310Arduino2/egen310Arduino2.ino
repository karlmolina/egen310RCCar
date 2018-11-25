#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "BluetoothSerial.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield();

Adafruit_DCMotor *rightMotor = AFMS.getMotor(1);
Adafruit_DCMotor *leftMotor = AFMS.getMotor(4);

BluetoothSerial SerialBT;

void setup() {
  // put your setup code here, to run once:
  SerialBT.begin("Tiger");
  Serial.begin(250000);

  AFMS.begin();

  rightMotor->setSpeed(150);
  rightMotor->run(FORWARD);
  rightMotor->run(RELEASE);
  leftMotor->setSpeed(150);
  leftMotor->run(FORWARD);
  leftMotor->run(RELEASE);
  // turn on motor

}

void loop() {

  char received = 225;
  if (SerialBT.available()) {
    received = SerialBT.read();

    if (received >= 0 && received <= 224) {
      int i = (int)received;
      int x = i / 15 - 7;
      int y = i % 15 - 7;
      Serial.print(i);
      Serial.print(" = ");
      Serial.print(x);
      Serial.print(", ");
      Serial.print(y);
      float leftSpeed = x / 7.0 * 255;
      float rightSpeed = y / 7.0 * 255;
      Serial.print("left: ");
      Serial.println(leftSpeed);
      Serial.print("right: ");
      Serial.println(rightSpeed);
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
  }
}

