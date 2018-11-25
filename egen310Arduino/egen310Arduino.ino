#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "BluetoothSerial.h"

Adafruit_MotorShield AFMS = Adafruit_MotorShield();

Adafruit_DCMotor *rightMotor = AFMS.getMotor(1); //right motor
Adafruit_DCMotor *leftMotor = AFMS.getMotor(4); //left motor

BluetoothSerial SerialBT;

uint8_t count = 0;
int LMS = 0, // left motor speed
    RMS = 0, // right motor speed
    LChange = 0, // the change in the left motor speed
    RChange = 0, // the change in the right motor speed
    speedIncrease = 1, // how fast the motors speed increases
    maxSpeed = 80, // the intial max speed of the motor
    startSpeed = 25; // the starting speed of a motor

bool ledOn = false,
     forward = false,
     backward = false,
     left = false,
     right = false,
     speedUp = false;

char controls[] = {'0', 'w', 's', 'a', 'd', 'q', 'e', 'z', 'x'};
char valid[] = {'0', 'w', 's', 'a', 'd', 'q', 'e', 'z', 'x', '1', '2', '3', '4'};

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);

  SerialBT.begin("Tiger");
  Serial.begin(250000);

  AFMS.begin();

  rightMotor->setSpeed(255);
  rightMotor->run(FORWARD);
  rightMotor->run(RELEASE);
  leftMotor->setSpeed(255);
  leftMotor->run(FORWARD);
  leftMotor->run(RELEASE);
}

char last;

void loop() {
  char current = '1';

  if (SerialBT.available()) {
    current = SerialBT.read();

    SerialBT.write(current);
    if (current == '1') {
      maxSpeed = 25;
    } else if (current == '2') {
      maxSpeed = 50;
    } else if (current == '3') {
      maxSpeed = 150;
    } else if (current == '4') {
      maxSpeed = 255;
    }
    if (isControls(current)) {
      // If you current 0 then stop
      if (current == '0') {
        rightMotor->run(RELEASE);
        leftMotor->run(RELEASE);
        LMS = RMS = 0;
      } else {
        if (current != last) {
          if (current == 'w' || current == 's' || current == 'a'
              || current == 'd') {
            forward = false;
            backward = false;
            left = false;
            right = false;
          }

          LChange = RChange = speedIncrease;

          if (current == 'w' && (last != 'q' || last != 'e')) {
            resetMotorSpeed();
            forward = true;
          } else if (current == 's' && (last != 'z' || last != 'x')) {
            resetMotorSpeed();
            backward = true;
          } else if (current == 'a') {
            resetMotorSpeed();
            left = true;
          } else if (current == 'd') {
            resetMotorSpeed();
            right = true;
          } else if (current == 'q' && last == 'w') {
            LChange = -speedIncrease;
          } else if (current == 'e' && last == 'w') {
            RChange = -speedIncrease;
          } else if (current == 'z' && last == 's') {
            LChange = -speedIncrease;
          } else if (current == 'x' && last == 's') {
            RChange = -speedIncrease;
          }
        } else {
          //          Serial.println("LMS");
          //          Serial.println(LMS);
          //          Serial.println("RMS");
          //          Serial.println(RMS);
          Serial.println("LChange");
          Serial.println(LChange);
          Serial.println("RChange");
          Serial.println(RChange);
          LMS += LChange;
          RMS += RChange;
          LMS = cap(LMS);
          RMS = cap(RMS);
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
      last = current;
    }
  }

  count++;

  if (count == 0) {
    ledOn = !ledOn;
    if (ledOn) {
      digitalWrite(LED_BUILTIN, HIGH);
    } else {
      digitalWrite(LED_BUILTIN, LOW);
    }
  }
  //Serial.println("Count: ");
  //Serial.println(count);
}

bool isValid(char c) {
  for (int i = 0; i < sizeof(valid) / sizeof(valid[0]); i++) {
    if (c == valid[i]) {
      return true;
    }
  }
  return false;
}

bool isControls(char c) {
  for (int i = 0; i < sizeof(controls) / sizeof(controls[0]); i++) {
    if (c == controls[i]) {
      return true;
    }
  }
  return false;
}

void setMotorSpeed() {
  rightMotor->setSpeed(RMS);
  leftMotor->setSpeed(LMS);
  //Serial.println(RMS);
  //Serial.println(LMS);
}

void goForward() {
  setMotorSpeed();
  rightMotor->run(FORWARD);
  leftMotor->run(FORWARD);
}

void goBackward() {
  setMotorSpeed();
  rightMotor->run(BACKWARD);
  leftMotor->run(BACKWARD);
}
void goLeft() {
  setMotorSpeed();
  rightMotor->run(FORWARD);
  leftMotor->run(BACKWARD);
}
void goRight() {
  setMotorSpeed();
  rightMotor->run(BACKWARD);
  leftMotor->run(FORWARD);
}

int cap(int value) {
  if (value > maxSpeed) {
    return maxSpeed;
  }
  if (value < 0) {
    return 0;
  }

  return value;
}

int resetMotorSpeed() {
  LMS = startSpeed;
  RMS = 10;
}

