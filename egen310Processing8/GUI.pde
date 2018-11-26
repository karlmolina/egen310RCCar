Button bluetoothBtn, bluetoothStatus;
Slider maxSpeedSdr, startSpeedSdr, speedChangeSdr;
Slider leftTop, leftBot, rightTop, rightBot;
Textlabel leftLabel, rightLabel, connectFail;
boolean connected = false;

void drawGUI() {
  cp5 = new ControlP5(this);
  cp5.setFont(cp5.getFont().getFont(), 20);
  //cp5.setFont(createFont("Arial", 20));
  bluetoothStatus = cp5.addButton("Bluetooth\nStatus").lock().setColorBackground(color(255, 0, 0));
  cp5.addLabel("EGEN 310, Group A.2 Control App").setPosition(100, 100);
  cp5.addLabel("DIRECTIONS\nConnect to bluetooth, then\nuse the keys W, S, A, D \nto control the vehicle").setPosition(130, 630);
  cp5.addLabel("Use theses sliders to control movement parameters").setPosition(29, 511);
  connectFail = cp5.addLabel("Bluetooth connection.").setPosition(480, 155);
  bluetoothBtn = cp5.addButton("Connect\nto Bluetooth");
  bluetoothBtn.onClick(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      if (!connected) {
        println("Connecting to Bluetooth...");
        connectFail.setValueLabel("Connecting to Bluetooth...");
        connectFail.update();
        try {
          serial = new Serial(app, portName, 250000);
          println("Connection succeeded.");
          connectFail.setValueLabel("Connected.");
          e.getController().lock();
          bluetoothStatus.setColorBackground(color(0,0,255));
          connected = true;
        }
        catch (RuntimeException ex) {
          println("Connection failed. Try again.");
          connectFail.setValueLabel("Connection failed.\nTry again.");
        }
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
  speedChangeSdr = cp5.addSlider("Increase Rate").setRange(0, range).setNumberOfTickMarks(range+1).setDecimalPrecision(0);
  speedChangeSdr.setValue(speedChange);
  speedChangeSdr.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      speedChange = (int)e.getController().getValue();
    }
  }
  );
}

void setGUI() {
  bluetoothBtn.setPosition(465, 36).setSize(159, 102);
  bluetoothStatus.setPosition(650, 36).setSize(125, 102);

  int sliderSizeX = 62;
  int sliderSizeXSmall = 20;
  int sliderSizeY = 244;
  int leftX = 481;
  int rightX = 656;
  int botY = 470;
  int topY = botY - sliderSizeY;

  maxSpeedSdr.setPosition(357, topY).setSize(sliderSizeXSmall, sliderSizeY);
  startSpeedSdr.setPosition(204, topY).setSize(sliderSizeXSmall, sliderSizeY);
  leftTop.setPosition(leftX, topY).setSize(sliderSizeX, sliderSizeY);
  leftBot.setPosition(leftX, botY).setSize(sliderSizeX, sliderSizeY);
  rightTop.setPosition(rightX, topY).setSize(sliderSizeX, sliderSizeY);
  rightBot.setPosition(rightX, botY).setSize(sliderSizeX, sliderSizeY);

  int rightLabelX = leftX - 50, 
    leftLabelX = rightX - 30, 
    labelY = botY + sliderSizeY + 3;

  rightLabel.setPosition(rightLabelX, labelY);
  leftLabel.setPosition(leftLabelX, labelY);

  speedChangeSdr.setPosition(56, topY).setSize(sliderSizeXSmall, sliderSizeY);
}
