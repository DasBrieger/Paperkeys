/*
 * Paperkeys DesktopApp
 *
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int numKeys=2;
int[] keyStates;
final int KEYUP = 48;
final int KEYDOWN = 49;
void setup() 
{
  keyStates= new int[numKeys];
  for(int i = 0; i<numkeys; i++){
     keyStates[i]= KEYUP; 
  }
  String portName = Serial.list()[0];
  println("New Port Created: "+portName);
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  
  while ( myPort.available() > 0) {  // If data is available,
    int curKey = (int)myPort.read() - 48; 
    keyStates[curKey]=myPort.read();
  }
  background(255);
  
}
