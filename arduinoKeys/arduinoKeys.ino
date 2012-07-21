/*
 John Brieger
 
 Paperkeys: an android keyboard
 Created for Greylock university hackfest
 */

String toSend = "";         // a string to hold incoming data
int numKeys=1;
int startKey=2;

void setup() {
  // initialize serial:
  Serial.begin(9600);
  // reserve 200 bytes for the inputString:
  int currentKey= startKey;
  pinMode(startKey, INPUT);
  pinMode(startKey+1, INPUT);
  
  /*
  for(int i =0; i<numKeys;i++){
    
    pinMode(2*i+startKey, INPUT);
    //pullupResistor
    pinMode(2*i+1+startKey, INPUT);
    digitalWrite(2*i+1+startKey, HIGH);
  }
  */
}

void loop() {
  digitalWrite(3, HIGH);
  if(digitalRead(2)==LOW){
   Serial.println("1T"); 
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
