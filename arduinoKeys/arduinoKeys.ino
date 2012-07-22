/*
 John Brieger
 
 Paperkeys: an android keyboard
 Created for Greylock university hackfest
 */

String toSend = "";         // a string to hold incoming data
int numKeys=2;
int startKey=2;
int pinStates[2];

void setup() {
  // initialize serial:
  Serial.begin(9600);
  // reserve 200 bytes for the inputString:
  int currentKey= startKey;
  pinMode(startKey, INPUT);
  pinMode(startKey+1, INPUT);
  for(int i = 0; i<numKeys; i++){
     pinMode(2*i+startKey, INPUT);
    //pullupResistor
    pinMode(2*i+1+startKey, INPUT);
    digitalWrite(2*i+1+startKey, HIGH);
    pinStates[i] = HIGH;
  }
 
}

void loop() {
  for(int i =0; i<numKeys; i++){
   int cur = 2*i+startKey;
  if(digitalRead(cur)==LOW &&  pinStates[i] == HIGH){
   Serial.print(i); 
   Serial.print(1); 
   pinStates[i] = LOW;
  }
  else if (digitalRead(cur)==HIGH && pinStates[i] == LOW){
   pinStates[i] = HIGH;
   Serial.print(i); 
   Serial.print(0);
  }
  }
  
  toSend= "";
  /*
  for(int i = 0; i<numKeys; i++){
    int current = 2*i+startKey;
    char chCurrent = (char)current;
    
    if(digitalRead(current)==LOW){
      Serial.write(chCurrent);
      Serial.write('1');
    }  
  }*/
}
