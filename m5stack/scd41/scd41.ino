#include <M5AtomS3.h>
#include <M5UnitENV.h>
#include <WiFi.h>

// wifi stuff
const char* wifiSSID = "blub";
const char* wifiPassword = "blub";

// sensor relevant stuff
SCD4X scd4x;
uint32_t errorCounter = 0;
bool silentMode = true;
bool permanentError = false;

// report cycle
uint32_t lastUpdate;

void setup() {
  AtomS3.begin(true);  // init, bool ledEnable

  AtomS3.dis.setBrightness(100);
  AtomS3.dis.drawpix(0x000000);

  Serial.begin(9600);
  Serial.println("starting ...");

  // setup CO2 unit
  if (!scd4x.begin(&Wire, SCD4X_I2C_ADDR, 2, 1, 400000U)) {
    silentMode = false;
    permanentError = true;
    reportError("could not find SCD4X");
    while (true) delay(1000);  // block endlessly here, no point in continuing if CO2 unit was not found! Hard reset of AtomS3 device required!
  }
  scd4x.stopPeriodicMeasurement();
  scd4x.startPeriodicMeasurement();

  // reset wifi
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(1000);

  // reset timestamp
  lastUpdate = millis();
}

void loop() {
  AtomS3.update();

  // funky control loop xD
  while (true) {
    // WIFI
    if (!checkWifi()) {
      break;
    }

    // MANUAL ON-DEMAND DATA COLLECTION
    if (AtomS3.BtnA.wasPressed()) {
      silentMode = !silentMode;  // toggle silent mode (aka the LED's)

      Serial.println("button A was pressed ...");
      runCollection();
      break;
    }

    // PERIODIC DATA COLLECTION
    if (millis() > lastUpdate + (1000*60*10)) { // every 10 minutes
      runCollection();
      break;
    }

    break;  // make sure to always exit our funky control loop at the end
  }

  // dont cycle main loop too fast
  delay(100);
}

bool checkWifi() {
  if (WiFi.status() != WL_CONNECTED) {
    reportProgress("connecting to Wifi ...");
    WiFi.begin(wifiSSID, wifiPassword);

    uint32_t timeout = millis();
    while (millis() < timeout + 22222) {
      if (WiFi.status() == WL_CONNECTED) {
        break;
      }
      Serial.print(F("."));
      delay(666);
    }

    if (WiFi.status() == WL_CONNECTED) {
      reportSuccess("connected to Wifi:");
      Serial.println(WiFi.SSID());
      Serial.print("IP address: ");
      Serial.println(WiFi.localIP());
      Serial.print("RSSI: ");
      Serial.println(WiFi.RSSI());
      delay(2000);
      return true;
    }
  }
  if (WiFi.status() != WL_CONNECTED) {
    reportError("could not connect to Wifi!");
    delay(2000);
    return false;
  }
  return true;
}

void runCollection() {
  reportProgress("awaiting measurement ...");

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
  lastUpdate = millis();
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
  Serial.println(msg);
  if (!silentMode) {
    AtomS3.dis.drawpix(0xffff00);
    AtomS3.update();
  }
}

void reportSuccess(const char* msg) {
  Serial.println(msg);
  if (!silentMode) {
    AtomS3.dis.drawpix(0x00ff00);
    AtomS3.update();
  }
  errorCounter = 0;
}

void reportError(const char* msg) {
  Serial.println(msg);
  if (!silentMode || permanentError) {
    AtomS3.dis.drawpix(0xff0000);
    AtomS3.update();
  }
  errorCounter++;
  if (errorCounter >= 5) {
    permanentError = true;
  }
}
