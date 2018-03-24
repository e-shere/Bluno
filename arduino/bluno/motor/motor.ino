
const int motorPin = 3;
const int buttonPin = 2;

int buttonState = 0;
void setup() {
pinMode(buttonPin,INPUT); //read from the button pin
pinMode(motorPin,OUTPUT); //write to the motor pin
}

void loop() {
  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) {    //if the button is pressed
    analogWrite(motorPin,153);  //vibrate the motor
  } else {
    analogWrite(motorPin,0);    //otherwise switch the motor off
  }
}
