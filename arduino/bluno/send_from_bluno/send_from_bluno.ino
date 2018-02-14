
const int ledPin =  13;      // the number of the LED pin

void setup() {
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
  //Serial.begin(115200);  //init the Serial
}

void loop() {
   digitalWrite(ledPin, HIGH);
   Serial.write("C");
   digitalWrite(ledPin, LOW);
   delay(1000);
}
