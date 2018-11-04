int WATER_SENSOR = 8;
int RELAY = 13;

void setup() {
  // put your setup code here, to run once:
  pinMode(WATER_SENSOR, INPUT);
  pinMode(RELAY, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println(digitalRead(WATER_SENSOR));
  if (digitalRead(WATER_SENSOR) == HIGH) {
    digitalWrite(RELAY, HIGH);
  } else {
    digitalWrite(RELAY, LOW);
  }
}
