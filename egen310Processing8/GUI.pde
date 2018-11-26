Button bluetoothBtn;
Slider maxSpeedSdr, startSpeedSdr, speedChangeSdr;
Slider leftTop, leftBot, rightTop, rightBot;
Textlabel leftLabel, rightLabel;

void drawGUI() {
  cp5 = new ControlP5(this);
  cp5.setFont(cp5.getFont().getFont(), 20);
  //cp5.setFont(createFont("Arial", 20));
  bluetoothBtn = cp5.addButton("Connect\nto Bluetooth");
  bluetoothBtn.onClick(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      println("Connecting to Bluetooth...");
      try {
        serial = new Serial(app, portName, 250000);
        println("Connection succeeded.");
      }
      catch (RuntimeException ex) {
        println("Connection failed. Try again.");
      }
    }
  }
  );

  maxSpeedSdr = cp5.addSlider("Max Speed").setRange(0, 255).setValue(maxSpeed).setDecimalPrecision(0);
  startSpeedSdr = cp5.addSlider("Start Speed").setRange(0, 255).setValue(startSpeed).setDecimalPrecision(0);
  leftTop = cp5.addSlider("leftTop").setRange(0, 255).setValue(80).setLabel("").lock().setDecimalPrecision(0);
  leftBot = cp5.addSlider("leftBot").setRange(-255, 0).setValue(80).setLabel("").lock().setDecimalPrecision(0);
  rightTop = cp5.addSlider("rightTop").setRange(0, 255).setValue(80).setLabel("").lock().setDecimalPrecision(0);
  rightBot = cp5.addSlider("rightBot").setRange(-255, 0).setValue(80).setLabel("").lock().setDecimalPrecision(0);
  println(rightBot.getColor());
  int background = rightBot.getColor().getBackground();
  int foreground = rightBot.getColor().getForeground();
  rightBot.setColorBackground(foreground);
  rightBot.setColorForeground(background);
  rightBot.setColorActive(background);
  rightTop.setColorActive(foreground);
  leftTop.setColorActive(foreground);
  leftBot.setColorBackground(foreground);
  leftBot.setColorForeground(background);
  leftBot.setColorActive(background);
  leftTop.setLabelVisible(false);
  rightTop.setLabelVisible(false);

  maxSpeedSdr.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      maxSpeed = (int)e.getController().getValue();
    }
  }
  );
  startSpeedSdr.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      startSpeed = (int)e.getController().getValue();
    }
  }
  );

  leftLabel = cp5.addLabel("LEFT MOTOR SPEED");
  rightLabel = cp5.addLabel("RIGHT MOTOR SPEED");
  
  int range = 10;
  speedChangeSdr = cp5.addSlider("Increase Rate").setRange(0,range).setNumberOfTickMarks(range+1).setDecimalPrecision(0);
  speedChangeSdr.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      speedChange = (int)e.getController().getValue();
    }
  }
  );
}

void setGUI() {
  bluetoothBtn.setPosition(619, 36).setSize(159, 102);

  int sliderSizeX = 62;
  int sliderSizeY = 244;
  int leftX = 418;
  int rightX = 656;
  int botY = 515;
  int topY = botY - sliderSizeY;
  float middleX = (leftX + rightX) / 2.0;

  maxSpeedSdr.setPosition(537, topY).setSize(sliderSizeX, sliderSizeY);
  startSpeedSdr.setPosition(291, topY).setSize(sliderSizeX, sliderSizeY);
  leftTop.setPosition(leftX, topY).setSize(sliderSizeX, sliderSizeY);
  leftBot.setPosition(leftX, botY).setSize(sliderSizeX, sliderSizeY);
  rightTop.setPosition(rightX, topY).setSize(sliderSizeX, sliderSizeY);
  rightBot.setPosition(rightX, botY).setSize(sliderSizeX, sliderSizeY);

  int rightLabelX = leftX - 30, 
    leftLabelX = rightX - 30, 
    labelY = botY + sliderSizeY + 3;

  rightLabel.setPosition(rightLabelX, labelY);
  leftLabel.setPosition(leftLabelX, labelY);
  
  speedChangeSdr.setPosition(140, topY).setSize(10, sliderSizeY);
}

public void controlEvent(ControlEvent theEvent) {
  //println(theEvent.getController().getName());
}
