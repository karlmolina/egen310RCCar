import processing.serial.*;
import controlP5.*;

Serial serial;

String portName = "COM9";

boolean w, s, a, d;

float power, turn;
int halfHeight, 
  halfWidth, 
  maxSpeed = 80, 
  left = 0, 
  right = 0, 
  speedChange = 1, 
  LChange, 
  RChange, 
  startSpeed = 25;
final float TOP_SPEED = 255.0;
final int SLOWEST_SPEED = 25;
boolean stopped = true;

PGraphics bg;

ControlP5 cp5;

PApplet app = this;

void setup() {
  drawGUI();

  size(800, 800);
  strokeWeight(5);
  stroke(255);
  halfHeight = height/2;
  halfWidth = width/2;
}

void draw() {
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

  if (LChange < 0) {
    if (left >= SLOWEST_SPEED && left + LChange <= SLOWEST_SPEED) {
      left = -SLOWEST_SPEED;
    }
  } else if (LChange > 0) {
    if (left <= -SLOWEST_SPEED && left + LChange >= -SLOWEST_SPEED) {
      left = SLOWEST_SPEED;
    }
  }

  if (RChange < 0) {
    if (right >= SLOWEST_SPEED && right + RChange <= SLOWEST_SPEED) {
      right = -SLOWEST_SPEED;
    }
  } else if (RChange > 0) {
    if (right <= -SLOWEST_SPEED && right + RChange >= -SLOWEST_SPEED) {
      right = SLOWEST_SPEED;
    }
  }

  if (!stopped) {
    left += LChange;
    right += RChange;
  }

  left = constrain(left, -maxSpeed, maxSpeed);
  right = constrain(right, -maxSpeed, maxSpeed);
  background(0);
  
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
  
  
  String output = nfs(left, 3) + nfs(right, 3) +"\n";
  //println(output);

  if (serial != null) {
    serial.write(output);
  }
  setGUI();
}

void keyPressed() {
  if (key == 'w') {
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
