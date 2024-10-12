#include <M5AtomS3.h>
#include <M5UnitENV.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <time.h>
#include "secrets.h"

/* secrets.h to contain:
#define WIFI_SSID "*****"
#define WIFI_PASSWORD "*****"
#define HOME_INFO_USER "*****"
#define HOME_INFO_PASSWORD "*****"
*/

// home-info sensor IDs
const String sensorIdCO2 = "22";
const String sensorIdTemp = "25";
const String sensorIdHum = "26";

// sensor values
uint16_t ppm = 0;
uint16_t temp = 0;
uint16_t hum = 0;

// sensor relevant stuff
SCD4X scd4x;
uint32_t errorCounter = 0;
bool silentMode = true;
bool permanentError = false;
const bool httpUploadEnabled = true;

// report cycle
uint32_t lastUpdate;

// TLS stuff
// lets-encrypt ISRG Root X1 pem
const char* rootCACertificate =
  "-----BEGIN CERTIFICATE-----\n"
  "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\n"
  "-----END CERTIFICATE-----\n";

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
    reportError("could not find SCD41!");
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
    if (millis() > lastUpdate + (1000 * 60 * 10)) {  // every 10 minutes
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
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    const uint32_t timeout = millis();
    while (millis() < timeout + 22222) {
      if (WiFi.status() == WL_CONNECTED) {
        break;
      }
      Serial.print(".");
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
      reportSilence();
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
  reportProgress("running data collection ...");

  Serial.println("awaiting measurement ...");
  bool measurement = false;
  const uint32_t timeout = millis();
  while (millis() < timeout + 5000) {
    if (scd4x.update()) {
      measurement = true;
      break;
    }
    Serial.print(".");
    delay(333);
  }
  Serial.println();

  if (measurement) {
    // it worked, we can read new measurement data now!
    ppm = scd4x.getCO2();
    temp = scd4x.getTemperature() - 1;
    hum = scd4x.getHumidity() + 1;
    Serial.print("CO2(ppm): ");
    Serial.print(ppm);
    Serial.print("\tTemperature(C): ");
    Serial.print(temp, 1);
    Serial.print("\tHumidity(%RH): ");
    Serial.print(hum, 1);
    Serial.println();

    // send data via HTTP API
    if (httpUploadEnabled) {
      bool upload = true;  // using a bool-var, because we want all httpUpload functions to always run, regardless if one of them fails
      upload = httpUpload(sensorIdCO2, ppm) && upload;
      upload = httpUpload(sensorIdTemp, temp) && upload;
      upload = httpUpload(sensorIdHum, hum) && upload;
      if (upload) {
        reportSuccess("http upload successful!");
      } else {
        // it failed :(
        reportError("http upload has failed!");
      }
    } else {
      reportSuccess("");
    }
  } else {
    // it failed :(
    reportError("measurement has failed!");
  }

  delay(2000);
  reportSilence();
  lastUpdate = millis();
}

bool httpUpload(String sensorId, uint32_t sensorValue) {
  reportProgress("doing HTTP upload ...");

  // correct time is required for certificate validation
  if (!setClockViaNTP()) {
    return false;
  }

  WiFiClientSecure wifiClient;
  wifiClient.setCACert(rootCACertificate);
  // client.setInsecure(); // alternative, comment out setCACert if used

  // timeout for TLS handling, in seconds
  wifiClient.setTimeout(15);

  bool failed = false;
  {
    // scoping block for HTTPClient https to make sure it is destroyed before WiFiClientSecure
    HTTPClient httpsClient;
    const String url = "https://home-info.jamesclonk.io/sensor/" + sensorId + "/value";

    Serial.println("[HTTPS] begin ...");
    if (httpsClient.begin(wifiClient, url)) {
      httpsClient.setAuthorization(HOME_INFO_USER, HOME_INFO_PASSWORD);
      httpsClient.addHeader("Content-Type", "application/x-www-form-urlencoded");

      char data[16];
      sprintf(data, "value=%u", sensorValue);
      Serial.printf("[HTTPS] POST to: %s\n", url.c_str());
      Serial.printf("[HTTPS] POST data: %s\n", data);

      const int httpCode = httpsClient.POST(data);
      Serial.printf("[HTTPS] POST, response code: %d\n", httpCode);
      if (httpCode > 0) {
        const String response = httpsClient.getString();
        if (httpCode == HTTP_CODE_CREATED) {  // home-info responds with StatusCreated|201 if okay
          Serial.println("[HTTPS] POST done");
          failed = false;
        } else {
          Serial.println(response);
          failed = true;
        }
      } else {
        Serial.printf("[HTTPS] POST... failed, error: %s\n", httpsClient.errorToString(httpCode).c_str());
        failed = true;
      }

      httpsClient.end();
    } else {
      Serial.println("[HTTPS] unable to connect!");
      failed = true;
    }
  }

  return !failed;
}

bool setClockViaNTP() {
  configTime(0, 0, "pool.ntp.org", "ntp.metas.ch", "time.nist.gov");  // utc

  Serial.print("awaiting NTP sync ...");
  const uint32_t timeout = millis();
  time_t now = time(nullptr);
  while (now < 8 * 3600 * 2) {
    if (millis() > timeout + 30000) {  // 30s timeout
      return false;
    }
    now = time(nullptr);
    Serial.print(".");
    delay(666);
  }

  Serial.println();
  struct tm timeinfo;
  gmtime_r(&now, &timeinfo);
  Serial.print("Current time: ");
  Serial.print(asctime(&timeinfo));
  return true;
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
