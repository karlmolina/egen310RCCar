import processing.serial.*;

Serial serial;

String portName = "COM9";

int halfHeight, halfWidth;

boolean forward, backward, left, right;

void setup() {
  serial = new Serial(this, portName, 9600);

  size(600, 600);
  strokeWeight(1);
  stroke(255);
  halfHeight = height/2;
  halfWidth = width/2;
}
char previousWrite;
char write = '0';
int count = 0;
void draw() {
  background(0);
  previousWrite = write;
  
  int rightVal = 0, leftVal = 0;
  if (forward) {
    write = 'w';
    leftVal = rightVal = 1;
  } else if (backward) {
    write = 's';
    leftVal = rightVal = -1;
  } else if (left) {
    write = 'a';
    leftVal = -1;
    rightVal = 1;
  } else if (right) {
    write = 'd';
    leftVal = 1;
    rightVal = -1;
  } else {
    write = '0';
  }

  serial.write(write);
  char readChar = serial.readChar();
  if (readChar == 'w' || readChar == 's') {
    count++;
  }
  println(readChar);

  background(0);
  
  fill(255);
  text(mouseX + ", " + mouseY, 10, 10);
  noStroke();
  text("Input values", 40, 20);
  text("Velocity", 220, 80);
  text("Acceleration", 220, 140);
  text("Bluetooth Status", 470, 20);
  text("Debug Console", 20, 410);
  text("Distance Traveled", 220, 20);
  text("Left", 60, 175);
  text("Right", 110, 175);
  text("Acceleration Graph", 400, 225);
  text("Velocity Graph", 200, 225);
  text("Car Gyro", 56, 225);
  noFill();
  stroke(255);
  rect(190, 250, 120, 120);
  rect(40, 30, 120, 120);
  rect(390, 250, 120, 120);
  rect(30, 430, 539, 120);
  if (previousWrite == readChar) {
    fill(0, 0, 255);
  } else {
    fill(255, 0, 0);
  }

  rect(450, 31, 120, 140);
  noFill();
  rect(30, 250, 120, 120);
  rect(330, 20, 60, 30);
  rect(330, 75, 60, 30);
  rect(330, 130, 60, 30);

  line (85, 90, 85, 90-leftVal*45);
  line (120, 90, 120, 90-rightVal*42);
}
void keyPressed() {
  forward = backward = left = right = false;
  if (key == 'w') {
    forward = true;
  } else if (key == 's') {
    backward = true;
  } else if (key == 'a') {
    left = true;
  } else if (key == 'd') {
    right = true;
  }
}

void keyReleased() {
  forward = backward = left = right = false;
}
