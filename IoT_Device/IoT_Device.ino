#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <ArduinoJson.h>
#include <Arduino.h>
#include <LiquidCrystal_I2C.h>
#include <HX711_ADC.h>
#include <OneWire.h>
#include <Wire.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <WiFiManager.h>
#include "MAX30100_PulseOximeter.h"

#define trig 13 //d7
#define echo 15 //d8

#define weightDT 0 //d3
#define weightSCK 4 //d4

#define hartRate 14 //d5

long t1, t2, cm1, cm2;

float k, hartRate;


LiquidCrystal_I2C lcd(0x27,  16,  4);

const int HX711_dout = weightDT;
const int HX711_sck = weightSCK;

HX711_ADC LoadCell(HX711_dout, HX711_sck);

const int calVal_eepromAdress = 0;
unsigned long t = 0;

PulseOximeter pox;

uint32_t tsLastReport = 0;

void onBeatDetected() {
  Serial.println("Beat!");
}


WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org");

//Week Days
String weekDays[7] = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};

//Month names
String months[12] = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

int con = 0;

#define FIREBASE_HOST "healthy-kid-8a121-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "kkaTICC1ma2tyJpoDd3egdu9UB61OXO8Fy00Jqgr"

WiFiServer server(80);

void setup() {
  Serial.begin(9600);

  lcd.begin(16, 4);
  lcd.init();
  lcd.backlight();

  pinMode(echo1, INPUT);
  pinMode(trig1, OUTPUT);

  pinMode(echo2, INPUT);
  pinMode(trig2, OUTPUT);

  lcd.setCursor(0, 1);
  lcd.print("HealthyKid");
  lcd.setCursor(0, 2);
  lcd.print("20230101");
  delay(5000);


  WiFiManager wifiManager;
  while (con == 0)
  {
    con = wifiManager.autoConnect("HealthyKid_20230101");
    lcd.clear();
    Serial.print("conn fail");
    lcd.setCursor(0, 2);
    lcd.print("CONNECT");
    lcd.setCursor(0, 3);
    lcd.print("TO WIFI");
    delay(50);
    Serial.print(".");
    digitalWrite(ledPin, HIGH);
    delay(200);
    digitalWrite(ledPin, LOW);
    delay(200);
  }

  Serial.println(con);
  server.begin();
  Serial.println("Server started");
  Serial.println(WiFi.localIP());
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  digitalWrite(ledPin, HIGH);


  timeClient.begin();
  timeClient.setTimeOffset(19800);

  Serial.print("Initializing pulse oximeter..");

  if (!pox.begin()) {
    Serial.println("FAILED");
    for (;;);
  } else {
    Serial.println("SUCCESS");
  }

  pox.setIRLedCurrent(MAX30100_LED_CURR_7_6MA);

  pox.setOnBeatDetectedCallback(onBeatDetected);


  LoadCell.begin();

  float calibrationValue;
  calibrationValue = 220.0;
#if defined(ESP8266)|| defined(ESP32)

#endif


  unsigned long stabilizingtime = 2000;
  boolean _tare = true;
  LoadCell.start(stabilizingtime, _tare);
  if (LoadCell.getTareTimeoutFlag()) {
    Serial.println("Timeout, check MCU>HX711 wiring and pin designations");
    while (1);
  }
  else {
    LoadCell.setCalFactor(calibrationValue);
    Serial.println("Startup is complete");
  }

}

void loop() {

  Hart_Rate();
  Height_Unit_1();
  Height_Unit_2();
  Weight();
  DisplayLCD();
  timeset();

}

void Hart_Rate() {
  pox.update();

  if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
    Serial.print("Heart rate:");
    Serial.print(pox.getHeartRate());
    Serial.print("bpm / SpO2:");
    Serial.print(pox.getSpO2());
    Serial.println("%");
    hartRate=pox.getHeartRate()

    Firebase.setInt("Devices/20230101/SensorValues/BPM", pox.getHeartRate());

    tsLastReport = millis();
  }
}

void Height_Unit_1() {

  digitalWrite(trig1, LOW);
  delayMicroseconds(2);
  digitalWrite(trig1, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig1, LOW);


  t1 = pulseIn(echo1, HIGH);
  cm1 = t1 / 29 / 2 ;

  Serial.print("Sonic_1: ");
  Serial.print(cm1);
  Serial.println("cm1");

  Firebase.setFloat("Devices/20230101/SensorValues/height", cm1);
  delay(10);

}

void Height_Unit_1() {

  digitalWrite(trig2, LOW);
  delayMicroseconds(2);
  digitalWrite(trig2, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig2, LOW);


  t2 = pulseIn(echo2, HIGH);
  cm2 = t2 / 29 / 2 ;

  Serial.print("Sonic_2: ");
  Serial.print(cm2);
  Serial.println("cm2");

  Firebase.setFloat("Devices/20230101/SensorValues/height_1", cm2);
  delay(10);

}

void Weight() {

  static boolean newDataReady = 0;
  const int serialPrintInterval = 0;

  if (LoadCell.update()) newDataReady = true;

  if (newDataReady) {
    if (millis() > t + serialPrintInterval) {
      float i = LoadCell.getData();
      k = i / 1000.0;
      Serial.print("Load_cell output val: ");
      Serial.print(k);
      Serial.println(" kg");

      lcd.setCursor(-4, 3);
      lcd.print("Weight: ");
      lcd.print(k);

      Firebase.setFloat("Devices/20230101/SensorValues/weight", k);

      newDataReady = 0;
      t = millis();
    }
  }

  if (Serial.available() > 0) {
    char inByte = Serial.read();
    if (inByte == 't') LoadCell.tareNoDelay();
  }


  if (LoadCell.getTareStatus() == true) {
    Serial.println("Tare complete");
  }
}


}

void DisplayLCD()
{
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("HartRate: ");
  lcd.print(hartRate);

  lcd.setCursor(0, 1);
  lcd.print("Height: ");
  lcd.print(cm1);

  lcd.setCursor(-4, 2);
  lcd.print("Height_2: ");
  lcd.print(cm2);

  lcd.setCursor(-4, 3);
  lcd.print("Weight: ");
  lcd.print(k);

   delay(2000);

}


void timeset() {

  timeClient.update();

  unsigned long epochTime = timeClient.getEpochTime();

  String formattedTime = timeClient.getFormattedTime();

  int currentHour = timeClient.getHours();

  int currentMinute = timeClient.getMinutes();

  int currentSecond = timeClient.getSeconds();

  String weekDay = weekDays[timeClient.getDay()];

  struct tm *ptm = gmtime ((time_t *)&epochTime);

  int monthDay = ptm->tm_mday;

  int currentMonth = ptm->tm_mon + 1;

  String currentMonthName = months[currentMonth - 1];

  int currentYear = ptm->tm_year + 1900;

  String mon = String(currentMonth);
  String da  = String(monthDay);
  if (currentMonth < 10)
  {
    mon = "0" + mon;
  }

  if (monthDay < 10)
  {
    da = "0" + da;
  }


  String currentDate = String(currentYear) + "-" + mon + "-" + da + " " + String(formattedTime);
  Serial.print("Current date: ");
  Serial.println(currentDate);
  Serial.println("");

  Firebase.setString("Devices/20230101/SensorValues/date_time", currentDate);
}
