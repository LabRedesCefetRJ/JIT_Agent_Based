#include <SoftwareSerial.h>

// RX não usado, TX no pino 3
SoftwareSerial fakeReader(255, 3);

byte tag1[14] = {2,48,48,49,49,49,49,49,49,49,49,48,48,3};
byte tag2[14] = {2,48,48,50,50,50,50,50,50,50,50,48,48,3};
byte tag3[14] = {2,48,48,51,51,51,51,51,51,51,51,48,48,3};

const int buttonPin10 = 10;
const int buttonPin11 = 11;
const int buttonPin12 = 12;

bool lastState10 = LOW;
bool lastState11 = LOW;
bool lastState12 = LOW;

void setup() {
  fakeReader.begin(9600);
  pinMode(buttonPin10, INPUT);
  pinMode(buttonPin11, INPUT);
  pinMode(buttonPin12, INPUT);
}

void loop() {
  bool currentState10 = digitalRead(buttonPin10);
  bool currentState11 = digitalRead(buttonPin11);
  bool currentState12 = digitalRead(buttonPin12);

  if (currentState10 == HIGH && lastState10 == LOW) {
    sendFakeCard(1);
  }

  if (currentState11 == HIGH && lastState11 == LOW) {
    sendFakeCard(2);
  }

  if (currentState12 == HIGH && lastState12 == LOW) {
    sendFakeCard(3);
  }

  lastState10 = currentState10;
  lastState11 = currentState11;
  lastState12 = currentState12;
}

void sendFakeCard(int card) {
  if (card == 1) { fakeReader.write(tag1, 14); }
  else if (card == 2) { fakeReader.write(tag2, 14); }
  else if (card == 3) { fakeReader.write(tag3, 14); } 
}
