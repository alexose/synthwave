#include <WiFi.h>
#include <AsyncTCP.h>
#include <FS.h>
#include <SPIFFS.h>
#include <ESPAsyncWebServer.h>
#include <AsyncElegantOTA.h>
#include "heltec.h"

#define DEVICE_PUMP1 14
#define DEVICE_PUMP2 27  // maybe
#define DEVICE_VAC1 13
#define DEVICE_VAC2 12
#define DEVICE_SOLENOID1 25  // also LED?
#define DEVICE_SOLENOID2 33
#define DEVICE_SOLENOID3 32
#define DEVICE_SOLENOID4 17
#define DEVICE_RELEASE1 2
#define DEVICE_RELEASE2 23

const char *ssid = "Thompson Creek Yacht Club";
const char *password = "winecountry";

AsyncWebServer server(80);

void setup(void) {
  Heltec.begin(true /*DisplayEnable Enable*/, false /*LoRa Disable*/, true /*Serial Enable*/);
  delay(100);
  Heltec.display->clear();

  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");
  Heltec.display->setFont(ArialMT_Plain_16);

  // Initialize pins as OUTPUT
  digitalWrite(DEVICE_PUMP1, LOW);
  pinMode(DEVICE_PUMP1, OUTPUT);
  digitalWrite(DEVICE_PUMP2, LOW);
  pinMode(DEVICE_PUMP2, OUTPUT);
  digitalWrite(DEVICE_VAC1, LOW);
  pinMode(DEVICE_VAC1, OUTPUT);
  digitalWrite(DEVICE_VAC2, LOW);
  pinMode(DEVICE_VAC2, OUTPUT);
  digitalWrite(DEVICE_SOLENOID1, LOW);
  pinMode(DEVICE_SOLENOID1, OUTPUT);
  digitalWrite(DEVICE_SOLENOID2, LOW);
  pinMode(DEVICE_SOLENOID2, OUTPUT);
  digitalWrite(DEVICE_SOLENOID3, LOW);
  pinMode(DEVICE_SOLENOID3, OUTPUT);
  digitalWrite(DEVICE_SOLENOID4, LOW);
  pinMode(DEVICE_SOLENOID4, OUTPUT);
  digitalWrite(DEVICE_RELEASE1, LOW);
  pinMode(DEVICE_RELEASE1, OUTPUT);
  digitalWrite(DEVICE_RELEASE2, LOW);
  pinMode(DEVICE_RELEASE2, OUTPUT);

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    Heltec.display->drawString(0, 10, "Connecting...");
    Heltec.display->display();
  }

  delay(2000);

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  Heltec.display->clear();
  Heltec.display->drawString(0, 10, WiFi.localIP().toString());
  Heltec.display->display();

  if (!SPIFFS.begin(true)) {
    Serial.println("An error has occurred while mounting SPIFFS");
    return;
  }


  File root = SPIFFS.open("/");
  File file = root.openNextFile();

  while (file) {
    Serial.print("FILE: ");
    Serial.println(file.name());
    Heltec.display->clear();
    Heltec.display->drawString(0, 10, file.name());
    Heltec.display->display();
    delay(2000);
    file = root.openNextFile();
  }

  server.serveStatic("/", SPIFFS, "/").setDefaultFile("index.html");

  // Route for root / web page
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send(SPIFFS, "/index.html", "text/html", false);
  });

  server.on("/api/status", HTTP_GET, [](AsyncWebServerRequest *request) {
    getStatus(request);
  });
  server.on("/api/device/vac1", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("VAC1", request);
  });
  server.on("/api/device/vac2", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("VAC2", request);
  });
  server.on("/api/device/pump1", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("PUMP1", request);
  });
  server.on("/api/device/pump2", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("PUMP2", request);
  });
  server.on("/api/device/solenoid1", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("SOLENOID1", request);
  });
  server.on("/api/device/solenoid2", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("SOLENOID2", request);
  });
  server.on("/api/device/solenoid3", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("SOLENOID3", request);
  });
  server.on("/api/device/solenoid4", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("SOLENOID4", request);
  });
  server.on("/api/device/release1", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("RELEASE1", request);
  });
  server.on("/api/device/release2", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("RELEASE2", request);
  });

  server.onNotFound([](AsyncWebServerRequest *request) {
    if (request->method() == HTTP_OPTIONS) {
      request->send(200);
    } else {
      request->send(404);
    }
  });

  AsyncElegantOTA.begin(&server);  // Start ElegantOTA

  DefaultHeaders::Instance().addHeader("Access-Control-Allow-Headers", "Accept, Content-Type, Authorization");
  DefaultHeaders::Instance().addHeader("Access-Control-Allow-Credentials", "true");
  DefaultHeaders::Instance().addHeader("Access-Control-Allow-Origin", "*");

  server.begin();
  Serial.println("HTTP server started");
}

void toggleDevice(const String &deviceName, AsyncWebServerRequest *request) {
  int devicePin = getDevicePin(deviceName);

  if (devicePin == -1) {
    request->send(400, "text/plain", "Invalid device name: " + deviceName);
    return;
  }

  // Read pin high/low status
  int currentState = digitalRead(devicePin);

  // Toggle the state
  if (currentState == LOW) {
    digitalWrite(devicePin, HIGH);
  } else {
    digitalWrite(devicePin, LOW);
  }

  getStatus(request);
}

void getStatus(AsyncWebServerRequest *request) {
  String results = "[";
  results += String(digitalRead(DEVICE_PUMP1)) + ",";
  results += String(digitalRead(DEVICE_PUMP2)) + ",";
  results += String(digitalRead(DEVICE_VAC1)) + ",";
  results += String(digitalRead(DEVICE_VAC2)) + ",";
  results += String(digitalRead(DEVICE_SOLENOID1)) + ",";
  results += String(digitalRead(DEVICE_SOLENOID2)) + ",";
  results += String(digitalRead(DEVICE_SOLENOID3)) + ",";
  results += String(digitalRead(DEVICE_SOLENOID4)) + ",";
  results += String(digitalRead(DEVICE_RELEASE1)) + ",";
  results += String(digitalRead(DEVICE_RELEASE2));
  results += "]";

  //AsyncResponseStream *response = request->beginResponseStream("application/json");
  //response->addHeader("Access-Control-Allow-Origin", "*");
  //response->addHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
  //response->print(results);
  request->send(200, "text/plain", results);
}

int getDevicePin(const String &deviceName) {
  if (deviceName == "PUMP1") return DEVICE_PUMP1;
  if (deviceName == "PUMP2") return DEVICE_PUMP2;
  if (deviceName == "VAC1") return DEVICE_VAC1;
  if (deviceName == "VAC2") return DEVICE_VAC2;
  if (deviceName == "SOLENOID1") return DEVICE_SOLENOID1;
  if (deviceName == "SOLENOID2") return DEVICE_SOLENOID2;
  if (deviceName == "SOLENOID3") return DEVICE_SOLENOID3;
  if (deviceName == "SOLENOID4") return DEVICE_SOLENOID4;
  if (deviceName == "RELEASE1") return DEVICE_RELEASE1;
  if (deviceName == "RELEASE2") return DEVICE_RELEASE2;

  return -1;  // Invalid device name
}


void loop(void) {
}