// Various GUI objects
// Buttons to connect to bluetooth and show status
Button bluetoothBtn, bluetoothStatus;
// Slider to change the max speed, start speed, and speed change
Slider maxSpeedSdr, startSpeedSdr, speedChangeSdr;
// Sliders to show the motor speeds
// Two sliders for each motor so there can be negative values
Slider leftTop, leftBot, rightTop, rightBot;
// Labels for the motor speeds and connection failure
Textlabel leftLabel, rightLabel, connectFail;
// Whether the bluetooth is connected or not
boolean connected = false;
// The main GUI object
ControlP5 cp5;
// This PApplet
PApplet app = this;

// Draws the GUI
void drawGUI() {
  // Initialize ControlP5
  cp5 = new ControlP5(this);
  // Make the font bigger
  cp5.setFont(cp5.getFont().getFont(), 20);
  // Add the bluetooth status button
  bluetoothStatus = cp5.addButton("Bluetooth\nStatus").lock().setColorBackground(color(255, 0, 0));
  // Title
  cp5.addLabel("EGEN 310, Group A.2 Control App").setPosition(100, 100);
  // Directions
  cp5.addLabel("DIRECTIONS\nConnect to bluetooth, then\nuse the keys W, S, A, D \nto control the vehicle").setPosition(130, 630);
  // Slider directions
  cp5.addLabel("Use theses sliders to control movement parameters").setPosition(29, 511);
  // Connection failure message
  connectFail = cp5.addLabel("Bluetooth connection.").setPosition(480, 155);
  // Bluetooth connection button
  bluetoothBtn = cp5.addButton("Connect\nto Bluetooth");
  // controlEvent for the bluetooth connection button
  // Called when the button is clicked
  bluetoothBtn.onClick(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      if (!connected) {
        println("Connecting to Bluetooth...");
        connectFail.setValueLabel("Connecting to Bluetooth...");
        connectFail.update();
        try {
          // Try to connect the serial bluetooth port
          serial = new Serial(app, portName, 250000);
          println("Connection succeeded.");
          connectFail.setValueLabel("Connected.");
          e.getController().lock();
          // If it succeeds set the status color to blue
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

  // Max speed slider
  maxSpeedSdr = cp5.addSlider("Max Speed").setRange(0, 255).setValue(maxSpeed).setDecimalPrecision(0);
  // Start speed slider
  startSpeedSdr = cp5.addSlider("Start Speed").setRange(0, 255).setValue(startSpeed).setDecimalPrecision(0);
  // Left motor speed sliders
  leftTop = cp5.addSlider("leftTop").setRange(0, 255).setValue(80).setLabel("").lock().setDecimalPrecision(0);
  leftBot = cp5.addSlider("leftBot").setRange(-255, 0).setValue(80).setLabel("").lock().setDecimalPrecision(0);
  // Right motor speed sliders
  rightTop = cp5.addSlider("rightTop").setRange(0, 255).setValue(80).setLabel("").lock().setDecimalPrecision(0);
  rightBot = cp5.addSlider("rightBot").setRange(-255, 0).setValue(80).setLabel("").lock().setDecimalPrecision(0);
  // Set the colors of the motor speed sliders
  int background = rightBot.getColor().getBackground();
  int foreground = rightBot.getColor().getForeground();
  rightBot.setColorBackground(foreground);
  rightBot.setColorForeground(background);
  leftBot.setColorBackground(foreground);
  leftBot.setColorForeground(background);
  leftTop.setLabelVisible(false);
  rightTop.setLabelVisible(false);

  // Max speed slider controlEvent
  // Called whenever the slider is changed
  maxSpeedSdr.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      maxSpeed = (int)e.getController().getValue();
    }
  }
  );
  // Start speed slider controlEvent
  // Called whenever the slider is changed
  startSpeedSdr.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      startSpeed = (int)e.getController().getValue();
    }
  }
  );

  // Labels for the motor speed sliders
  leftLabel = cp5.addLabel("LEFT MOTOR SPEED");
  rightLabel = cp5.addLabel("RIGHT MOTOR SPEED");

  int range = 10;
  // Speed change slider
  speedChangeSdr = cp5.addSlider("Increase Rate").setRange(0, range).setNumberOfTickMarks(range+1).setDecimalPrecision(0);
  speedChangeSdr.setValue(speedChange);
  // Called when the speed change slider is changed
  speedChangeSdr.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent e) {
      speedChange = (int)e.getController().getValue();
    }
  }
  );
}

// Sets the position and size of the GUI objects
void setGUI() {
  // bluetooth connection button
  bluetoothBtn.setPosition(465, 36).setSize(159, 102);
  // bluetooth status button
  bluetoothStatus.setPosition(650, 36).setSize(125, 102);

  // Positions of the motor speed sliders
  int sliderSizeX = 62;
  int sliderSizeXSmall = 20;
  int sliderSizeY = 244;
  int leftX = 481;
  int rightX = 656;
  int botY = 470;
  int topY = botY - sliderSizeY;

  // Set position of the max speed, start speed sliders
  maxSpeedSdr.setPosition(357, topY).setSize(sliderSizeXSmall, sliderSizeY);
  startSpeedSdr.setPosition(204, topY).setSize(sliderSizeXSmall, sliderSizeY);
  // Set position of motor speed sliders
  leftTop.setPosition(leftX, topY).setSize(sliderSizeX, sliderSizeY);
  leftBot.setPosition(leftX, botY).setSize(sliderSizeX, sliderSizeY);
  rightTop.setPosition(rightX, topY).setSize(sliderSizeX, sliderSizeY);
  rightBot.setPosition(rightX, botY).setSize(sliderSizeX, sliderSizeY);

  // Position of the motor speed labels
  int rightLabelX = leftX - 50, 
    leftLabelX = rightX - 30, 
    labelY = botY + sliderSizeY + 3;
  
  // Set position of the motor speed labels
  rightLabel.setPosition(rightLabelX, labelY);
  leftLabel.setPosition(leftLabelX, labelY);
  
  // Position of speed change slider
  speedChangeSdr.setPosition(56, topY).setSize(sliderSizeXSmall, sliderSizeY);
}
