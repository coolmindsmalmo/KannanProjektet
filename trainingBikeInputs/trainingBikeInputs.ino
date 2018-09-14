const int MIN=0,MAX=600;
int  afterTimer, interval = 100;
bool pl, pr, l, r;
int pInput, currentInput;
long timer;

int lastNumbers[24] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
void setup() {
  Serial.begin(9600);
  pinMode(11, INPUT_PULLUP); //left
  pinMode(12, INPUT_PULLUP); //right
  pinMode(A0, INPUT); //wheelSpeed
}

void loop() {
  delay(10);
  if (timer + interval < millis()) {
    timer = millis();
    Serial.write(pushArray());
  }
  updateArray();
  l = !digitalRead(11);
  r = !digitalRead(12);
  if (pl != l) Serial.write(l?-1:-2); // vänster (-1)ner (-2)up
  if (pr != r)Serial.write(r?-3:-4); // höger (-3)ner (-4)up
  pr = r;
  pl = l;
}
void updateArray() {
  int numberTotal;
  for (int i = 1; i < 25; i++) {
    lastNumbers[i - 1] = lastNumbers[i];
    numberTotal += lastNumbers[i - 1];
  }
  lastNumbers[24] = map(analogRead(0),MIN,MAX,0,252);
  numberTotal += lastNumbers[24];
  int avgTotal = numberTotal / 24;
}
int pushArray() {
  int numberTotal;
  for (int i = 1; i < 25; i++) {
    lastNumbers[i - 1] = lastNumbers[i];
    numberTotal += lastNumbers[i - 1];
  }
  lastNumbers[24] = map(analogRead(0),MIN,MAX,0,252);
  numberTotal += lastNumbers[24];
  int avgTotal = numberTotal / 24;
  return avgTotal;
}

