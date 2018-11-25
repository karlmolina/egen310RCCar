import processing.serial.*;

Serial serial;

String portName = "COM9";

int halfHeight, halfWidth;

boolean forward, backward, left, right;

void setup() {
  try {
    serial = new Serial(this, portName, 9600);
  }
  catch (Exception e )
  {
    println("Serial was not initialized");
    //throw e;
  }

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

  char readChar = '\0';
  if (serial != null) {
    serial.write(write);
    readChar = serial.readChar();
  }
  if (readChar == 'w' || readChar == 's') {
    count++;
  }
  println(readChar);

  background(0);
  fill(255);
  noStroke();
  
  text(mouseX + ", " + mouseY, 10, 10);
  text("Input values", 309, 195);
  
  text("Distance Traveled", 220, 20);
  
  text(count, 350, 41);
  text("Left", 256, 553);
  text("Right", 365, 557);
  
  text("Bluetooth Status", 483, 27);
  noFill();
  stroke(255);
  // input values box
  rect(194, 209, 282, 330);
  
  if (previousWrite == readChar) {
    fill(0, 0, 255);
  } else {
    fill(255, 0, 0);
  }
  // bluetooth status box
  rect(450, 50, 50, 50);
  noFill();
  
  // distance traveled box
  rect(350, 20, 60, 30);

  //left and right control values
  line (249, 342, 245, 348-leftVal*178);
  line (379, 370, 390, 357-rightVal*210);
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
  } else if (key == '1' || key == '2' || key == '3' || key == '4') {
    if (serial != null) {
      serial.write(key);
    }
  }
}

void keyReleased() {
  forward = backward = left = right = false;
}
