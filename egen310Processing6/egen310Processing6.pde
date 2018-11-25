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

//float xpos, ypos;

void setup() {
  serial = new Serial(this, portName, 250000);
  
  size(400, 400);
  strokeWeight(5);
  stroke(255);
  halfHeight = height/2;
  halfWidth = width/2;
}

void draw() {
  background(0);
  
  //turn = (mouseX - halfWidth) / (float)halfWidth;
  //power = (halfHeight - mouseY) / (float)halfHeight;
  
  
  println("turn " + turn + " power " + power);
  
  float left = constrain(turn + power, -1, 1);
  float right = constrain(-turn + power, -1, 1);

  int mult = 7;
  int leftI = round(left * mult + mult);
  int rightI = round(right * mult + mult);

  int output = leftI*(15) + rightI;
  line (120, halfHeight, 120, halfHeight-left*150);
  line (280, halfHeight, 280, halfHeight-right*150);
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
    power += 0.1;
  } else if (key == 's') {
    power -= 0.1;
  } else if (key == 'a') {
    turn -= 0.1;
  } else if (key == 'd') {
    turn += 0.1;
  }
  if (key == ' ') {
    power = 0;
    turn = 0;
  }
}
