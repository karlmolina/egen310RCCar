import processing.serial.*;

Serial serial;

String portName = "COM9";

int halfHeight, halfWidth;

boolean forward, backward, left, right;

PGraphics bg;

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

  textSize(20);
  drawBackground();
}

char previousWrite;
char write = '0';
int count = 0;

void draw() {
  background(0);
  previousWrite = write;

  int rightVal = 0, leftVal = 0;
  
  String going = "nowhere";
  
  if (forward) {
    if (left) {
      write = 'q';
      leftVal = 0;
      rightVal = 1;
      going = "forward to the left";
    } else if (right) {
      write = 'e';
      leftVal = 1;
      rightVal = 0;
      going = "forward to the right";
    } else {
      write = 'w';
      leftVal = rightVal = 1;
      going = "forward";
    }
  } else if (backward) {
    if (left) {
      write = 'z';
      leftVal = 0;
      rightVal = -1;
      going = "backward to the left";
    } else if (right) {
      write = 'x';
      leftVal = -1;
      rightVal = 0;
      going = "backward to the right";
    } else {
      write = 's';
      leftVal = rightVal = -1;
      going = "backward";
    }
  } else if (left) {
    write = 'a';
    leftVal = -1;
    rightVal = 1;
    going = "left";
  } else if (right) {
    write = 'd';
    leftVal = 1;
    rightVal = -1;
    going = "right";
  } else {
    write = '0';
  }

  char readChar = '\0';
  if (serial != null) {
    serial.write(write);
    readChar = serial.readChar();
  }

  println(readChar);


  //draw the gui
  drawBackground();
  image(bg, 0, 0);
  fill(255);
  noStroke();

  // Mouse coordinates for GUI creation
  text(mouseX + ", " + mouseY, 14, 31);
  
  text("You are currently going\n" + going, 118,97);

  if (previousWrite == readChar) {
    fill(0, 0, 255);
  } else {
    fill(255, 0, 0);
  }

  // bluetooth status box
  rect(495, 74, 50, 50);
  noFill();

  stroke(255);
  strokeWeight(5);
  //left and right control values
  int leftX = 275, y = 360, rightX = 390, controlSize = 140;
  line (leftX, y, leftX, y-leftVal*controlSize);
  line (rightX, y, rightX, y-rightVal*controlSize);
}
void keyPressed() {
  if (key == '1' || key == '2' || key == '3' || key == '4') {
    if (serial != null) {
      serial.write(key);
    }
  } else if (key == 'w') {
    forward = true;
  } else if (key == 's') {
    backward = true;
  } else if (key == 'a') {
    left = true;
  } else if (key == 'd') {
    right = true;
  } else if (key == CODED) {
    if (keyCode == UP) {
      forward = true;
    } else if (keyCode == LEFT) {
      left = true;
    } else if (keyCode == RIGHT) {
      right = true;
    } else if (keyCode == DOWN) {
      backward = true;
    }
  }
}

void keyReleased() {
  println("keyReleased");
  if (key == 'w') {
    forward = false;
  } else if (key == 's') {
    backward = false;
  } else if (key == 'a') {
    left = false;
  } else if (key == 'd') {
    right = false;
  } 
  if (key == CODED) {
    if (keyCode == UP) {
      forward = false;
    } else if (keyCode == LEFT) {
      left = false;
    } else if (keyCode == RIGHT) {
      right = false;
    } else if (keyCode == DOWN) {
      backward = false;
    }
  }
}

void drawBackground() {
  bg = createGraphics(width, height);
  bg.beginDraw();
  bg.textSize(20);

  bg.fill(255);

  bg.noStroke();
  bg.text("Use wsad to control the rc car", 122, 32);

  bg.text("Input values", 280, 199);

  bg.text("Left", 256, 536);
  bg.text("Right", 370, 537);

  bg.text("Bluetooth\nStatus", 484, 27);
  bg.noFill();
  bg.stroke(255);
  // input values box
  bg.rect(194, 212, 282, 299);

  bg.endDraw();
}
