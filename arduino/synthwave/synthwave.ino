#define WIFI_Kit_32_V3 true

#include <WiFi.h>
#include <AsyncTCP.h>
#include <FS.h>
#include <SPIFFS.h>
#include <ESPAsyncWebServer.h>
#include <ElegantOTA.h>
#include "heltec.h"
#include <Wire.h>
#include "SparkFun_SCD30_Arduino_Library.h"  // Include the SCD30 library


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
#define DEVICE_ELECTRODE1 40
#define DEVICE_ELECTRODE2 41

#define SENSOR_FLOAT1 39
#define SENSOR_FLOAT2 20
#define SENSOR_PH1 3
#define SENSOR_PH2 4

SCD30 airSensor;

const char *ssid = "YOUR_SSID";
const char *password = "YOUR_PASSWORD";

// Choose whether you want to enable data logging, and if so, where you want to send the data.
// This must be an influxdb server, either hosted locally on your network or via Influx Cloud.
const bool DISABLE_LOGGING = false;
const char *influxdb_url = "http://192.168.1.42:8086/";

volatile bool startFilling = false;
String currentRoutine = "idle";
String currentStatus = "";
int co2 = 0;

AsyncWebServer server(80);

void setup(void) {

  Wire1.begin(1, 2);  // SDA on GPIO1, SCL on GPIO2

  delay(200);

  if (airSensor.begin(Wire1) == false) {
     display("No air sensor");
     delay(1000);
  }

  Heltec.begin(true /*DisplayEnable Enable*/, false /*LoRa Disable*/, true /*Serial Enable*/);
  delay(100);
  Heltec.display->clear();

  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.println("");
  Heltec.display->setFont(ArialMT_Plain_16);

  Wire1.begin(1,2);

  delay(200);
  
  if (airSensor.begin(Wire1) == false) {
    display("No air sensor");
    delay(1000);
  }

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

  digitalWrite(DEVICE_ELECTRODE1, LOW);
  pinMode(DEVICE_ELECTRODE1, OUTPUT);
  digitalWrite(DEVICE_ELECTRODE2, LOW);
  pinMode(DEVICE_ELECTRODE2, OUTPUT);

  // Initialize input pins
  pinMode(SENSOR_FLOAT1, INPUT);  // Surprise! Pin 39 needs a hardware pullup.
  pinMode(SENSOR_FLOAT2, INPUT_PULLUP);

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
    Heltec.display->drawString(0, 10, "Connecting...");
    Heltec.display->display();
  }

  delay(2000);

  /*
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  */

  Heltec.display->clear();
  Heltec.display->drawString(0, 10, WiFi.localIP().toString());
  Heltec.display->display();

  if (!SPIFFS.begin(true)) {
    Serial.println("An error has occurred while mounting SPIFFS");
    return;
  } else {
    Serial.println(" Total Bytes: " + String(SPIFFS.totalBytes()));
    Serial.println(" Used Bytes: " + String(SPIFFS.usedBytes()));
  }

  File root = SPIFFS.open("/");
  File file = root.openNextFile();
  
  
  while(file){
    Serial.println(file.name());
    file = root.openNextFile();
    delay(1000);
  }

  server.serveStatic("/", SPIFFS, "/").setDefaultFile("index.html");

  // Status endpoint
  server.on("/api/status", HTTP_GET, [](AsyncWebServerRequest *request) {
    getStatus(request);
  });

  // Individual device endpoints.  These probably shouldn't be available to the network,
  // although they can be useful for debugging.
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
  server.on("/api/device/electrode1", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("ELECTRODE1", request);
  });
  server.on("/api/device/electrode2", HTTP_POST, [](AsyncWebServerRequest *request) {
    toggleDevice("ELECTRODE2", request);
  });

  // Routines
  server.on("/api/routine/fill1", HTTP_POST, [](AsyncWebServerRequest *request) {
    currentRoutine = "FILL1";
    getStatus(request);
  });

  server.on("/api/routine/fill2", HTTP_POST, [](AsyncWebServerRequest *request) {
    currentRoutine = "FILL2";
    getStatus(request);
  });

  server.on("/api/routine/transfer1to2", HTTP_POST, [](AsyncWebServerRequest *request) {
    currentRoutine = "TRANSFER1TO2";
    getStatus(request);
  });

  server.on("/api/routine/transfer2to1", HTTP_POST, [](AsyncWebServerRequest *request) {
    currentRoutine = "TRANSFER2TO1";
    getStatus(request);
  });

  server.on("/api/routine/stop", HTTP_POST, [](AsyncWebServerRequest *request) {
    currentRoutine = "idle";
    everythingOff();
    getStatus(request);
  });

  server.on("/api/routine/electrodes_forward", HTTP_POST, [](AsyncWebServerRequest *request) {
    currentRoutine = "ELECTRODES_FORWARDS";
    getStatus(request);
  });

  server.on("/api/routine/electrodes_backward", HTTP_POST, [](AsyncWebServerRequest *request) {
    currentRoutine = "ELECTRODES_BACKWARDS";
    getStatus(request);
  });

  server.onNotFound([](AsyncWebServerRequest *request) {
    if (request->method() == HTTP_OPTIONS) {
      request->send(200);
    } else {
      request->send(404);
    }
  });

  ElegantOTA.begin(&server);    // Start ElegantOTA

  DefaultHeaders::Instance().addHeader("Access-Control-Allow-Headers", "Accept, Content-Type, Authorization");
  DefaultHeaders::Instance().addHeader("Access-Control-Allow-Credentials", "true");
  DefaultHeaders::Instance().addHeader("Access-Control-Allow-Origin", "*");

  server.begin();
  // Serial.println("HTTP server started");
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
  digitalWrite(DEVICE_ELECTRODE1, LOW);
  digitalWrite(DEVICE_ELECTRODE2, LOW);
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

void display(String message) {
  Heltec.display->clear();
  Heltec.display->drawString(0, 10, message);
  Heltec.display->display();
}

void getStatus(AsyncWebServerRequest *request) {

  //AsyncResponseStream *response = request->beginResponseStream("application/json");
  //response->addHeader("Access-Control-Allow-Origin", "*");
  //response->addHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
  //response->print(results);
  currentStatus = buildStatusString();
  request->send(200, "text/plain", currentStatus);
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
  if (deviceName == "ELECTRODE1") return DEVICE_ELECTRODE1;
  if (deviceName == "ELECTRODE2") return DEVICE_ELECTRODE2;

  return -1;  // Invalid device name
}

// TODO: decide if this is dumb
String buildStatusString() {
  String status = "[";
  status += "\"" + currentRoutine + "\""
                                    ",";
  status += String(millis()) + ",";
  status += String(digitalRead(DEVICE_PUMP1)) + ",";
  status += String(digitalRead(DEVICE_PUMP2)) + ",";
  status += String(digitalRead(DEVICE_VAC1)) + ",";
  status += String(digitalRead(DEVICE_VAC2)) + ",";
  status += String(digitalRead(DEVICE_VALVE1)) + ",";
  status += String(digitalRead(DEVICE_VALVE2)) + ",";
  status += String(digitalRead(DEVICE_VALVE3)) + ",";
  status += String(digitalRead(DEVICE_VALVE4)) + ",";
  status += String(digitalRead(DEVICE_RELEASE1)) + ",";
  status += String(digitalRead(DEVICE_RELEASE2)) + ",";
  status += String(digitalRead(DEVICE_ELECTRODE1)) + ",";
  status += String(digitalRead(DEVICE_ELECTRODE2)) + ",";
  status += String(digitalRead(SENSOR_FLOAT1)) + ",";
  status += String(digitalRead(SENSOR_FLOAT2)) + ",";
  status += String(analogRead(SENSOR_PH1)) + ",";
  status += String(analogRead(SENSOR_PH2)) + ",";
  status += String(co2);
  status += "]";

  return status;
}

void loop(void) {
  if (currentRoutine == "FILL1") {
    if (digitalRead(SENSOR_FLOAT1) == HIGH) {
      // Continue filling a bit past the sensor level
      delay(500);
      currentRoutine = "idle";
      everythingOff();
      display("Filled!");
    } else if (digitalRead(DEVICE_VALVE3) == HIGH) {
      // Ensure VALVE3 is open before running pump
      digitalWrite(DEVICE_PUMP1, HIGH);
    } else {
      digitalWrite(DEVICE_VALVE3, HIGH);
    }
  }

  if (currentRoutine == "FILL2") {
    if (digitalRead(SENSOR_FLOAT2) == HIGH) {
      // Continue filling a bit past the sensor level
      delay(500);
      currentRoutine = "idle";
      everythingOff();
      display("Filled!");
    } else if (digitalRead(DEVICE_VALVE1) == HIGH) {
      // Ensure VALVE1 is open before running pump
      digitalWrite(DEVICE_PUMP2, HIGH);
    } else {
      digitalWrite(DEVICE_VALVE1, HIGH);
    }
  }

  if (currentRoutine == "TRANSFER1TO2") {
    // Float sensor should be active in order to begin transfer routine, but we won't enforce that for now.
    if (digitalRead(SENSOR_FLOAT2) == HIGH) {
      currentRoutine = "idle";
      everythingOff();
      display("Transferred!");
    } else if (digitalRead(DEVICE_VALVE1) == HIGH && digitalRead(DEVICE_VALVE4) == HIGH) {
      // Ensure VALVE1 and VALVE4 are open before running pump
      digitalWrite(DEVICE_PUMP2, HIGH);
    } else {
      digitalWrite(DEVICE_VALVE1, HIGH);
      delay(100);
      digitalWrite(DEVICE_VALVE4, HIGH);
    }
  }

  if (currentRoutine == "TRANSFER2TO1") {
    // Float sensor should be active in order to begin transfer routine, but we won't enforce that for now.
    if (digitalRead(SENSOR_FLOAT1) == HIGH) {
      currentRoutine = "idle";
      everythingOff();
      display("Transferred!");
    } else if (digitalRead(DEVICE_VALVE2) == HIGH && digitalRead(DEVICE_VALVE3) == HIGH) {
      // Ensure VALVE2 and VALVE3 are open before running pump
      digitalWrite(DEVICE_PUMP1, HIGH);
    } else {
      digitalWrite(DEVICE_VALVE2, HIGH);
      delay(100);
      digitalWrite(DEVICE_VALVE3, HIGH);
    }
  }

  if (airSensor.dataAvailable()) {
    co2 = airSensor.getCO2();
  }
  
  delay(20);
  currentStatus = buildStatusString();
  delay(1000);
}
