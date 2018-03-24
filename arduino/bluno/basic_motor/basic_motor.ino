const int motorPin = 3;
void setup() {
  pinMode(motorPin,OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  analogWrite(motorPin,153);         // turn the motor on
  delay(1000);                       // wait for a second
  analogWrite(motorPin,0);           // turn the motor off
  delay(1000);                       // wait for a second
}

