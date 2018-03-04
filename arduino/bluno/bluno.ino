const int buttonPin = 2;     // the number of the pushbutton pin
const int ledPin =  13;      // the number of the LED pin
const int motorPin = 3;
int buttonState = 0;

void setup() {
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
  pinMode(motorPin,OUTPUT);
  //Serial.begin(9600);  //init the Serial
  Serial.begin(115200);  // correct speed for standalone mode
}

void loop() {
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (buttonState == HIGH) {
    // turn LED on:
    digitalWrite(ledPin, HIGH);
    Serial.write("B");
    delay(100);
  } else {
    // turn LED off:
    digitalWrite(ledPin, LOW);
  }
  if (Serial.available() > 0) {
    Serial.read();
    analogWrite(motorPin,153);
    delay(300);
  } else {
    analogWrite(motorPin,0);
  }
}
