const int motorPin = 3;
void setup() {
  // put your setup code here, to run once:
  pinMode(motorPin,OUTPUT);
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available() > 0) {
    Serial.read();
    analogWrite(motorPin,153);
    delay(300);
  } else {
    analogWrite(motorPin,0);
  }
}
