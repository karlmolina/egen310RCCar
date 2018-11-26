// Import necessary libraries
import processing.serial.*;
import controlP5.*;

// Serial port
Serial serial;
// Serial port name
String portName = "COM9";
// Control booleans
boolean w, s, a, d;
// Half height and width for GUI
int halfHeight, 
  halfWidth, 
  // The max speed of both motors
  maxSpeed = 80, 
  // Left motor speed
  left = 0, 
  // Right motor speed
  right = 0, 
  // How fast the motor's speed changes when you move
  speedChange = 1, 
  // The change of the left motor's speed
  LChange, 
  // The change of the right motor's speed
  RChange, 
  // The speed to start at when you move
  startSpeed = 40;

// The top speed of the motors
final float TOP_SPEED = 255.0;
// The slowest speed of the motors that they will move at
final int SLOWEST_SPEED = 25;
// Whether the car is stopped or not
boolean stopped = true;

// Setup the program
void setup() {
  drawGUI();
  setGUI();
  size(800, 800);
  strokeWeight(5);
  stroke(255);
  halfHeight = height/2;
  halfWidth = width/2;
}

// Loop through this method
void draw() {
  // Direction changes
  if (a) {
    LChange = -speedChange;
    RChange = speedChange;
  } else if (d) {
    LChange = speedChange;
    RChange = -speedChange;
  } else if (w) {
    LChange = speedChange;
    RChange = speedChange;
  } else if (s) {
    LChange = -speedChange;
    RChange = -speedChange;
  } else {
    left = right = 0;
    stopped = true;
  }

  // Cause the left motor speed to skip the speeds that it won't move
  // between -25 and 25
  if (LChange < 0) {
    if (left >= SLOWEST_SPEED && left + LChange <= SLOWEST_SPEED) {
      left = -SLOWEST_SPEED;
    }
  } else if (LChange > 0) {
    if (left <= -SLOWEST_SPEED && left + LChange >= -SLOWEST_SPEED) {
      left = SLOWEST_SPEED;
    }
  }
  
  // Cause the right motor speed to skip values between -25 and 25
  if (RChange < 0) {
    if (right >= SLOWEST_SPEED && right + RChange <= SLOWEST_SPEED) {
      right = -SLOWEST_SPEED;
    }
  } else if (RChange > 0) {
    if (right <= -SLOWEST_SPEED && right + RChange >= -SLOWEST_SPEED) {
      right = SLOWEST_SPEED;
    }
  }

  // If you aren't stopped increase the motor speed by the change
  // of each motor
  if (!stopped) {
    left += LChange;
    right += RChange;
  }

  // Constrain the motor speeds between the max speeds (-255,255)
  left = constrain(left, -maxSpeed, maxSpeed);
  right = constrain(right, -maxSpeed, maxSpeed);
  background(0);

  // Set the visiblity of the labels for the speed sliders
  if (left >= 0) {
    leftTop.setLabelVisible(true);
    leftBot.setLabelVisible(false);
    leftTop.setValue(left);
    leftBot.setValue(0);
  } else {
    leftBot.setLabelVisible(true);
    leftTop.setLabelVisible(false);
    leftBot.setValue(left);
    leftTop.setValue(0);
  }
  if (right >= 0) {
    rightTop.setLabelVisible(true);
    rightBot.setLabelVisible(false);
    rightTop.setValue(right);
    rightBot.setValue(0);
  } else {
    rightBot.setLabelVisible(true);
    rightTop.setLabelVisible(false);
    rightTop.setValue(0);
    rightBot.setValue(right);
  }

  // The output string to be sent over bluetooth
  // Includes the speed of the left motor and the right motor
  // ex: "-089 233" "-255-255" " 013 024"
  String output = nfs(left, 3) + nfs(right, 3) +"\n";
  //println(output);

  // Send the output over bluetooth
  if (serial != null) {
    serial.write(output);
  }
  
  // Set the GUI's positioning for debugging
  //setGUI();

  // Show the mouse position for debugging
  //fill(255);
  //text(mouseX + ", " + mouseY, 10, height - 10);
}

// Function run everytime a key is pressed
void keyPressed() {
  // Set the boolean controls for the keys w, s, a, d
  if (key == 'w') {
    // If you press w from a stopped position the motor
    // speeds start at the startSpeed
    if (stopped) {
      right = startSpeed;
      left = startSpeed;
    }
    w = true;
  } else if (key == 's') {
    if (stopped) {
      right = -startSpeed;
      left = -startSpeed;
    }
    s = true;
  } else if (key == 'a') {
    if (stopped) {
      right = startSpeed;
      left = -startSpeed;
    }
    a = true;
  } else if (key == 'd') {
    if (stopped) {
      right = -startSpeed;
      left = startSpeed;
    }
    d = true;
  }
  // If you pressed a control key then you are no longer stopped
  if (key == 'w' || key == 's' || key == 'a' || key == 'd') {
    stopped = false;
  }
}

void keyReleased() {
  if (key == 'w') {
    w = false;
  } else if (key == 's') {
    s = false;
  } else if (key == 'a') {
    a = false;
  } else if (key == 'd') {
    d = false;
  }
}
