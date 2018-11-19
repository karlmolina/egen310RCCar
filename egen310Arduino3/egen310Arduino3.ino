#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "BluetoothSerial.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield();

Adafruit_DCMotor *motor1 = AFMS.getMotor(1); //right motor
Adafruit_DCMotor *motor2 = AFMS.getMotor(2); //left

BluetoothSerial SerialBT;

void setup() {
  SerialBT.begin("Tiger");
  Serial.begin(9600);

  AFMS.begin();

  motor1->setSpeed(255);
  motor1->run(FORWARD);
  motor1->run(RELEASE);
  motor2->setSpeed(255);
  motor2->run(FORWARD);
  motor2->run(RELEASE);
}

void loop() {
  char received = '1';
  
  if (SerialBT.available()) {
    received = SerialBT.read();
    
    if (received == 'w') {
      motor1->run(FORWARD);
      motor2->run(FORWARD);
    } else if (received == 's') {
      motor1->run(BACKWARD);
      motor2->run(BACKWARD);
    } else if (received == 'a') {
      motor1->run(FORWARD);
      motor2->run(BACKWARD);
    } else if (received == 'd') {
      motor1->run(BACKWARD);
      motor2->run(FORWARD);
    }

    if (received == '0') {
      motor1->run(RELEASE);
      motor2->run(RELEASE);
    }
    SerialBT.write(received);
  } 
  
  Serial.println(received);
}
