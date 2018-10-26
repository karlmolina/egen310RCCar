#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "BluetoothSerial.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield();

Adafruit_DCMotor *motor1 = AFMS.getMotor(1);
Adafruit_DCMotor *motor2 = AFMS.getMotor(2);

BluetoothSerial SerialBT;

void setup() {
  // put your setup code here, to run once:
  SerialBT.begin("Tiger");
  Serial.begin(9600);

  AFMS.begin();

  motor1->setSpeed(150);
  motor1->run(FORWARD);
  motor1->run(RELEASE);
  motor2->setSpeed(150);
  motor2->run(FORWARD);
  motor2->run(RELEASE);
  // turn on motor

}

String input = "";

void loop() {
  // put your main code here, to run repeatedly:
  //  char input;
  //  if (SerialBT.available()) {
  //    input = SerialBT.read();
  //    Serial.write(input);
  //  }
  char received;
  if (SerialBT.available()) {
    received = SerialBT.read();
  }

  motor1->setSpeed(0);
  motor1->run(RELEASE);
  motor2->setSpeed(0);
  motor2->run(RELEASE);
  
  //Serial.println((int)received);
  if (received != 0) {
    int i = (int)received;
    int x = i / 15 - 7;
    int y = i % 15 - 7;
    float leftSpeed = x / 7.0 * 255;
    float rightSpeed = y / 7.0 * 255;
//      Serial.print("left: ");
//      Serial.println(leftSpeed);
//      Serial.print("right: ");
//      Serial.println(rightSpeed);

    if (rightSpeed < 0) {
      motor1->run(BACKWARD);
      motor1->setSpeed(-rightSpeed);
    } else {
      motor1->run(FORWARD);
      motor1->setSpeed(rightSpeed);
    }
    if (leftSpeed < 0) {
      motor2->run(BACKWARD);
      motor2->setSpeed(-leftSpeed);
    } else {
      motor2->run(FORWARD);
      motor2->setSpeed(leftSpeed);
    }
  }
  //    input += received;
  //
  //    if (received == '\n') {
  //      Serial.print("Received: ");
  //      Serial.print(input);
  //
  //      Serial.print(input.length());
  //
  //
  //      if (input.length() == 10) {
  //        char substr[5];
  //        strncpy(substr, input.c_str(), 4);
  //        substr[4] = '\0';
  //        int leftSpeed = atoi(substr);
  //        Serial.println("leftVal");
  //        Serial.println(leftSpeed);
  //        strncpy(substr, input.c_str() + 5, 4);
  //        substr[4] = '\0';
  //        int rightSpeed = atoi(substr);
  //        Serial.println("leftVal");
  //        Serial.println(rightSpeed);
  //

  //      }
  //
  //      input = "";
  //    }



  //  if (input == 'w') {
  //    Serial.write('w');
  //    forward = true;
  //  } else {
  //    Serial.write("doing nothing");
  //    forward = false;
  //  }

  //  if (forward) {
  //    motor1->run(FORWARD);
  //    if (motor1Speed < 240) {
  //      motor1Speed += 5;
  //    }
  //  } else if (motor1Speed > 0) {
  //    motor1Speed -= 5;
  //  }
  //
  //  motor1->setSpeed(motor1Speed);
  //  //Serial.print(motor1Speed);

}
