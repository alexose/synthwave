#define WIFI_Kit_32_V3 true

#include <WiFi.h>
#include <AsyncTCP.h>
#include <FS.h>
#include <SPIFFS.h>
#include <ESPAsyncWebServer.h>
#include <AsyncElegantOTA.h>
#include "heltec.h"

#define DEVICE_PUMP1 7
#define DEVICE_PUMP2 6
#define DEVICE_VAC1 5
#define DEVICE_VAC2 34
#define DEVICE_VALVE1 33
#define DEVICE_VALVE2 47
#define DEVICE_VALVE3 48
#define DEVICE_VALVE4 46
#define DEVICE_RELEASE1 45
#define DEVICE_RELEASE2 42

#define DEVICE_FLOAT1 26
#define DEVICE_FLOAT2 39

// const char *ssid = "YOUR_SSID";
// const char *password = "YOUR_PASSWORD";
const char *ssid = "Thompson Creek Yacht Club";
const char *password = "winecountry";

// Choose whether you want to enable data logging, and if so, where you want to send the data.
// This must be an influxdb server, either hosted locally on your network or via Influx Cloud.
const bool DISABLE_LOGGING = false;
const char *influxdb_url = "http://192.168.1.42:8086/"

volatile bool startFilling = false;

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

  // Initialize output pins as OUTPUT
  digitalWrite(DEVICE_PUMP1, LOW);
  pinMode(DEVICE_PUMP1, OUTPUT);
  digitalWrite(DEVICE_PUMP2, LOW);
  pinMode(DEVICE_PUMP2, OUTPUT);
  digitalWrite(DEVICE_VAC1, LOW);
  pinMode(DEVICE_VAC1, OUTPUT);
  digitalWrite(DEVICE_VAC2, LOW);
  pinMode(DEVICE_VAC2, OUTPUT);
  digitalWrite(DEVICE_VALVE1, LOW);
  pinMode(DEVICE_VALVE1, OUTPUT);
  digitalWrite(DEVICE_VALVE2, LOW);
  pinMode(DEVICE_VALVE2, OUTPUT);
  digitalWrite(DEVICE_VALVE3, LOW);
  pinMode(DEVICE_VALVE3, OUTPUT);
  digitalWrite(DEVICE_VALVE4, LOW);
  pinMode(DEVICE_VALVE4, OUTPUT);
  digitalWrite(DEVICE_RELEASE1, LOW);
  pinMode(DEVICE_RELEASE1, OUTPUT);
  digitalWrite(DEVICE_RELEASE2, LOW);
  pinMode(DEVICE_RELEASE2, OUTPUT);

  // Initialize input pins as INPUT_PULLUP, set interrupts
  pinMode(DEVICE_FLOAT1, INPUT_PULLUP);
  pinMode(DEVICE_FLOAT2, INPUT_PULLUP);
  // attachInterrupt(digitalPinToInterrupt(FLOAT1), handleFloat1Interrupt, CHANGE);
  // attachInterrupt(digitalPinToInterrupt(FLOAT2), handleFloat2Interrupt, CHANGE);

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

  server.serveStatic("/", SPIFFS, "/").setDefaultFile("index.html");

  /*
  // Route for root / web page
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send(SPIFFS, "/index.html", "text/html", false);
  });
  */

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
  server.on("/api/device/valve1", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("VALVE1", request);
  });
  server.on("/api/device/valve2", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("VALVE2", request);
  });
  server.on("/api/device/valve3", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("VALVE3", request);
  });
  server.on("/api/device/valve4", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("VALVE4", request);
  });
  server.on("/api/device/release1", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("RELEASE1", request);
  });
  server.on("/api/device/release2", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("RELEASE2", request);
  });

  server.on("/api/routine/fill1", HTTP_POST, [](AsyncWebServerRequest *request) {
    display("Filling 1...");
    everythingOff();
    digitalWrite(DEVICE_VALVE3, HIGH);
    digitalWrite(DEVICE_PUMP1, HIGH);

    // Set a flag to start the filling process
    startFilling = true;

    // Immediately return status
    getStatus(request);
  });

  server.on("/api/routine/fill2", HTTP_POST, [](AsyncWebServerRequest *request) {
    display("Filling 2...");
    everythingOff();
    digitalWrite(DEVICE_VALVE1, HIGH);
    digitalWrite(DEVICE_PUMP2, HIGH);

    // Set a flag to start the filling process
    startFilling = true;

    // Immediately return status
    getStatus(request);
  });

  // TODO: decide if we want to read these directly
  server.on("/api/sensor/ph1", HTTP_POST, [](AsyncWebServerRequest *request) {
    float result = readPH(PH1);
    request->send(400, "text/plain", "Invalid device name: " + deviceName);
  }

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

void everythingOff() {
  digitalWrite(DEVICE_PUMP1, LOW);
  digitalWrite(DEVICE_PUMP2, LOW);
  digitalWrite(DEVICE_VAC1, LOW);
  digitalWrite(DEVICE_VAC2, LOW);
  digitalWrite(DEVICE_VALVE1, LOW);
  digitalWrite(DEVICE_VALVE2, LOW);
  digitalWrite(DEVICE_VALVE3, LOW);
  digitalWrite(DEVICE_VALVE4, LOW);
  digitalWrite(DEVICE_RELEASE1, LOW);
  digitalWrite(DEVICE_RELEASE2, LOW);
}

void toggleDevice(const String &deviceName, AsyncWebServerRequest *request) {
  int devicePin = getDevicePin(deviceName);
  String output = deviceName;

  if (devicePin == -1) {
    request->send(400, "text/plain", "Invalid device name: " + deviceName);
    return;
  }

  // Read pin high/low status
  int currentState = digitalRead(devicePin);

  // Toggle the state
  if (currentState == LOW) {
    digitalWrite(devicePin, HIGH);
    output = output + " " + "on";
  } else {
    digitalWrite(devicePin, LOW);
    output = output + " " + "off";
  }

  display(output);
  getStatus(request);
}

void display(String message){
  Heltec.display->clear();
  Heltec.display->drawString(0, 10, message);
  Heltec.display->display();
}

void getStatus(AsyncWebServerRequest *request) {
  String results = "[";
  results += String(digitalRead(DEVICE_PUMP1)) + ",";
  results += String(digitalRead(DEVICE_PUMP2)) + ",";
  results += String(digitalRead(DEVICE_VAC1)) + ",";
  results += String(digitalRead(DEVICE_VAC2)) + ",";
  results += String(digitalRead(DEVICE_VALVE1)) + ",";
  results += String(digitalRead(DEVICE_VALVE2)) + ",";
  results += String(digitalRead(DEVICE_VALVE3)) + ",";
  results += String(digitalRead(DEVICE_VALVE4)) + ",";
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
  if (deviceName == "VALVE1") return DEVICE_VALVE1;
  if (deviceName == "VALVE2") return DEVICE_VALVE2;
  if (deviceName == "VALVE3") return DEVICE_VALVE3;
  if (deviceName == "VALVE4") return DEVICE_VALVE4;
  if (deviceName == "RELEASE1") return DEVICE_RELEASE1;
  if (deviceName == "RELEASE2") return DEVICE_RELEASE2;

  return -1;  // Invalid device name
}

void readPH(const String &deviceName) {

}

void readCO2() {

}

void 

void loop(void) {
  if (startFilling) {
    if (digitalRead(DEVICE_FLOAT2) == HIGH || digitalRead(DEVICE_FLOAT1) == HIGH){ 
       startFilling = false;
       everythingOff();
       display("Filled!");
    } else {
      //nothin
    }
  }
}