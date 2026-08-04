#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#include <NimBLEDevice.h>

// Bench wiring: ESP32 GPIO5 -> 330R -> 74AHCT125 -> LED DIN.
// LED strip uses external regulated 5V. ESP32 GND and LED GND must be common.
static constexpr uint8_t LED_PIN = 5;
static constexpr uint16_t LED_COUNT = 24;
static constexpr uint8_t SAFE_BRIGHTNESS = 32; // 12.5% of 255 for first tests
static constexpr char SERVICE_UUID[] = "7f4a0001-9d45-4d9e-b890-9f132c08a001";
static constexpr char COLOR_UUID[]   = "7f4a0002-9d45-4d9e-b890-9f132c08a001";

Adafruit_NeoPixel pixels(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);

void setColor(uint8_t r, uint8_t g, uint8_t b) {
  for (uint16_t i = 0; i < LED_COUNT; ++i) pixels.setPixelColor(i, pixels.Color(r, g, b));
  pixels.show();
}

class ColorCallback final : public NimBLECharacteristicCallbacks {
  void onWrite(NimBLECharacteristic* characteristic, NimBLEConnInfo&) override {
    std::string value = characteristic->getValue();
    if (value.size() != 3) return;
    setColor((uint8_t)value[0], (uint8_t)value[1], (uint8_t)value[2]);
  }
};

void setup() {
  pixels.begin();
  pixels.setBrightness(SAFE_BRIGHTNESS);
  setColor(0, 0, 16);

  NimBLEDevice::init("ShadeShifter-POC");
  NimBLEServer* server = NimBLEDevice::createServer();
  NimBLEService* service = server->createService(SERVICE_UUID);
  NimBLECharacteristic* color = service->createCharacteristic(
    COLOR_UUID, NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::WRITE);
  color->setValue(std::string("\0\0\x10", 3));
  color->setCallbacks(new ColorCallback());
  service->start();
  NimBLEDevice::getAdvertising()->addServiceUUID(SERVICE_UUID);
  NimBLEDevice::getAdvertising()->start();
}

void loop() { delay(100); }

