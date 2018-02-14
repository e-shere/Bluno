
const int motorPin = 3;
const int buttonPin = 2;

int buttonState = 0;
void setup() {
  // put your setup code here, to run once:
pinMode(buttonPin,INPUT);
pinMode(motorPin,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) {
    analogWrite(motorPin,153);
  } else {
    analogWrite(motorPin,0);
  }
}
