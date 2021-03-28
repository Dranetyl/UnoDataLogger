unsigned long time = 0;
unsigned long duration = 0;
unsigned long durationStart;
int acquisition;
boolean x = false;
#include <OneWire.h>
#include <DallasTemperature.h>
#define ONE_WIRE_BUS 2
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

void setup() {
  Serial.begin(115200);
  sensors.begin();
}

void loop() {
  if (Serial.available() > 0) {
    acquisition = Serial.readString().toInt();
    if (acquisition == 0) {
      x = false;
    }
    else {
      x = true;
      durationStart = millis();
      time = 0 ;
    }
  }

  if (x == true) {
    duration = millis() - durationStart;
    if (millis() - time >= acquisition) {
      time = millis();
      sensors.requestTemperatures();
  
      Serial.print(duration);    // time
      Serial.print(";");
      Serial.print(sensors.getTempCByIndex(0));  //first value
      //Serial.print(";");
      //Serial.print(analogRead(A1) * 5 / 1023.00); //second value
      Serial.println();
    }
  }
}
