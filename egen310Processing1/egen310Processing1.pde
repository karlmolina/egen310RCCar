import processing.serial.*;
import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

ControlIO controlIO;
ControlDevice device;

Serial serial;

String portName = "COM9";

boolean forward = false;

float power, turn;
int halfHeight, halfWidth;

void setup() {
  serial = new Serial(this, portName, 9600);

  controlIO = ControlIO.getInstance(this);
  device = controlIO.getMatchedDevice("controller1");

  if (device == null) {
    println("no suitable device configured");
    System.exit(-1);
  }
  size(400, 600);
  strokeWeight(5);
  stroke(255);
  halfHeight = height/2;
  halfWidth = width/2;
}

void draw() {
  background(0);
  getUserInput();
  float left = constrain(turn + power, -1, 1);
  float right = constrain(-turn + power, -1, 1);

  int mult = 7;
  int leftI = round(left * mult + mult);
  int rightI = round(right * mult + mult);

  int output = leftI*(15) + rightI;
  line (120, halfHeight, 120, halfHeight-left*255);
  line (280, halfHeight, 280, halfHeight-right*255);
  println("power: " + power + " turn: " + turn);
  println("left: " + leftI + " right: " + rightI);

  println("output: ");
  println(output);
  byte b = (byte)output;
  println(b);
  println();

  serial.write(b);
  //serial.write(0);

  int i = (int)b&0xFF;
  println(i + " = " + (i / 15 - 7) + ", " + (i%15 -7));
}

void keyPressed() {
  if (key == 'w') {
    forward = true;
  }
}

void keyReleased() {
  forward = false;
}

void getUserInput() {
  power = device.getSlider("power").getValue();
  turn = device.getSlider("turn").getValue();
}
