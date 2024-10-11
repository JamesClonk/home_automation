#include <M5AtomS3.h>

void setup() {
  AtomS3.begin(true);  // init
  AtomS3.dis.setBrightness(100);
  Serial.begin(9600);
  Serial.println("starting ...");
}

void loop() {
  AtomS3.dis.drawpix(0xff0000);
  AtomS3.update();
  delay(500);
  AtomS3.dis.drawpix(0x00ff00);
  AtomS3.update();
  delay(500);
  AtomS3.dis.drawpix(0x0000ff);
  AtomS3.update();
  delay(500);
  Serial.println("cycling LED ...");
}
