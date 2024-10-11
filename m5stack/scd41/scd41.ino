#include <M5AtomS3.h>
#include <M5UnitENV.h>

SCD4X scd4x;

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
    Serial.println("Button A was pressed ...");

    AtomS3.dis.drawpix(0x00ff00);
    AtomS3.update();

    delay(1000);

    AtomS3.dis.drawpix(0x000000);
    AtomS3.update();
  }

  // if (AtomS3.BtnA.wasReleased()) {
  //   Serial.println("Released");
  //   AtomS3.dis.drawpix(0x000000);
  //   delay(1000);
  // }

  delay(100);

  // AtomS3.dis.drawpix(0xff0000);
  // AtomS3.update();
  // delay(500);
  // AtomS3.dis.drawpix(0x00ff00);
  // AtomS3.update();
  // delay(500);
  // AtomS3.dis.drawpix(0x0000ff);
  // AtomS3.update();
  // delay(500);
  // Serial.println("cycling LED ...");
}
