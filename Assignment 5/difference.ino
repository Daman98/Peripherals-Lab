int analogPin0 = A0;
int analogPin1 = A3;
float val0;
float val1;
float diff;
void setup() {
  Serial.begin(9600);
  pinMode(analogPin0, INPUT);
  pinMode(9, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(analogPin1, INPUT);
}

void loop() {
  val0 = analogRead(analogPin0);
  val1 = analogRead(analogPin1);
  diff = val1-val0;
  analogWrite(9,map(diff, 0, 1023, 0, 255));
  analogWrite(13, map(diff, 0, 1023, 0, 255));
  Serial.println(diff);
  delay(10);
}
