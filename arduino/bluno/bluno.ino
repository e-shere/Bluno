void setup()
{
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(115200);  //init the Serial
}

void loop()
{
  if (Serial.available())  {
    while (Serial.available())
    {
      Serial.write(Serial.read()); //send what has been received
      delay(100);
    }
    Serial.write("Arduino!");

    digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(500);                       // wait for a second
    digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
    delay(500);                       // wait for a second  
  }
}

