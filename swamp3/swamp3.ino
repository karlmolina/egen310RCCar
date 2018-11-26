int WATER_SENSOR = 8;
int RELAY = 13;

void setup() {
  // put your setup code here, to run once:
  pinMode(WATER_SENSOR, INPUT);
  pinMode(RELAY, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
  //Serial.begin(250000);
}

void loop() {
  // put your main code here, to run repeatedly:
  //Serial.println(digitalRead(WATER_SENSOR));
  if (digitalRead(WATER_SENSOR) == HIGH) {
    digitalWrite(RELAY, HIGH);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(10000);
  } else {
    digitalWrite(RELAY, LOW);
    digitalWrite(LED_BUILTIN, LOW);
  }
}
