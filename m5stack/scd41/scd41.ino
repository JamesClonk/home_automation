#include <M5AtomS3.h>
#include <M5UnitENV.h>

SCD4X scd4x;
uint32_t errorCounter = 0;
bool silentMode = true;
bool permanentError = false;

void setup() {
  AtomS3.begin(true);  // init, bool ledEnable

  AtomS3.dis.setBrightness(100);
  AtomS3.dis.drawpix(0x000000);

  Serial.begin(9600);
  Serial.println("starting ...");

  // CO2 unit
  if (!scd4x.begin(&Wire, SCD4X_I2C_ADDR, 2, 1, 400000U)) {
    Serial.println("Couldn't find SCD4X");
    while (1) delay(1);
  }

  uint16_t error;
  // stop potentially previously started measurement
  error = scd4x.stopPeriodicMeasurement();
  if (error) {
    Serial.print("Error trying to execute stopPeriodicMeasurement(): ");
  }

  // start Measurement
  error = scd4x.startPeriodicMeasurement();
  if (error) {
    Serial.print("Error trying to execute startPeriodicMeasurement(): ");
  }

  Serial.println("Waiting for first measurement... (5 sec)");
}

void loop() {
  AtomS3.update();

  if (AtomS3.BtnA.wasPressed()) {
    silentMode = !silentMode; // toggle silent mode (aka the LED's)

    reportProgress("Button A was pressed ...");

    Serial.print(F("awaiting measurement ..."));
    bool measurement = false;
    uint32_t timeout = millis();
    while (millis() < timeout + 5000) {
      if (scd4x.update()) {
        measurement = true;
        break;
      }
      Serial.print(F("."));
      delay(333);
    }
    Serial.println();

    if (measurement) {
      // it worked, we can read new measurement data now!
      uint16_t ppm = scd4x.getCO2();
      uint16_t temp = scd4x.getTemperature();
      uint16_t hum = scd4x.getHumidity();
      Serial.print(F("CO2(ppm): "));
      Serial.print(ppm);
      Serial.print(F("\tTemperature(C): "));
      Serial.print(temp, 1);
      Serial.print(F("\tHumidity(%RH): "));
      Serial.print(hum, 1);
      reportSuccess("");
    } else {
      // it failed :(
      reportError("measurement has failed!");
    }
    delay(2000);

    reportSilence();
  }

  // dont cycle main loop too fast
  delay(100);
}

void reportSilence() {
  if (permanentError) {
    AtomS3.dis.drawpix(0xff0000);
  } else {
    AtomS3.dis.drawpix(0x000000);
  }
  AtomS3.update();
}

void reportProgress(const char* msg) {
  if (!silentMode) {
    Serial.println(msg);
    AtomS3.dis.drawpix(0xffff00);
    AtomS3.update();
  }
}

void reportSuccess(const char* msg) {
  if (!silentMode) {
    Serial.println(msg);
    AtomS3.dis.drawpix(0x00ff00);
    AtomS3.update();
  }
  errorCounter = 0;
}

void reportError(const char* msg) {
  if (!silentMode) {
    Serial.println(msg);
    AtomS3.dis.drawpix(0xff0000);
    AtomS3.update();
  }
  errorCounter++;
  if (errorCounter >= 5) {
    permanentError = true;
  }
}
