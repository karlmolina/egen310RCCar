#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "BluetoothSerial.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield();

Adafruit_DCMotor *motor1 = AFMS.getMotor(1); //right motor
Adafruit_DCMotor *motor2 = AFMS.getMotor(4); //left

BluetoothSerial SerialBT;

uint8_t count = 0,
        motorSpeed = 0,
        speedIncrease = 1,
        maxSpeed = 80;

bool ledOn = false,
     forward = false,
     backward = false,
     left = false,
     right = false,
     speedUp = false;

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);

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

char lastReceived;

void loop() {
  char received = '1';

  if (SerialBT.available()) {
    received = SerialBT.read();

    SerialBT.write(received);
    if (received == '1') {
      maxSpeed = 25;
    } else if (received == '2') {
      maxSpeed = 50;
    } else if (received == '3') {
      maxSpeed = 150;
    } else if (received == '4') {
      maxSpeed = 255;
    } 
    if (received == 'w' || received == 's' || received == 'a'
        || received == 'd' || received == '0') {
      // If you received 0 then stop
      if (received == '0') {
        motor1->run(RELEASE);
        motor2->run(RELEASE);
        motorSpeed = 0;
      } else {
        if (received != lastReceived) {
          motorSpeed = 5;
          forward = false;
          backward = false;
          left = false;
          right = false;

          if (received == 'w') {
            forward = true;
          } else if (received == 's') {
            backward = true;
          } else if (received == 'a') {
            left = true;
          } else if (received == 'd') {
            right = true;
          }
        } else {
          if (motorSpeed + speedIncrease <= maxSpeed) {
            motorSpeed += speedIncrease;
          }
        }

        if (forward) {
          goForward();
        } else if (backward) {
          goBackward();
        } else if (right) {
          goRight();
        } else if (left) {
          goLeft();
        }
      }
      lastReceived = received;
    }
  }
  Serial.println(motorSpeed);

  count++;

  if (count == 0) {
    ledOn = !ledOn;
    if (ledOn) {
      digitalWrite(LED_BUILTIN, HIGH);
    } else {
      digitalWrite(LED_BUILTIN, LOW);
    }
  }
}

void setMotorSpeed() {
  motor1->setSpeed(motorSpeed);
  motor2->setSpeed(motorSpeed);
}

void goForward() {
  setMotorSpeed();
  motor1->run(FORWARD);
  motor2->run(FORWARD);
}

void goBackward() {
  setMotorSpeed();
  motor1->run(BACKWARD);
  motor2->run(BACKWARD);
}
void goLeft() {
  setMotorSpeed();
  motor1->run(FORWARD);
  motor2->run(BACKWARD);
}
void goRight() {
  setMotorSpeed();
  motor1->run(BACKWARD);
  motor2->run(FORWARD);
}

