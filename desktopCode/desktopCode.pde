/*
 * Paperkeys DesktopApp
 * John Brieger for GreyLockU Hackfest
 */

import ddf.minim.*; 
import ddf.minim.signals.*; 
import processing.serial.*;

Minim minim; 
AudioOutput out; 
SineWave sine; 
SineWave nullWave; 
float MAXAMP = .6;  
float amp  = MAXAMP; 
// C, D, E, F, G from Kevin O'Hara via openprocessing
float[] notesHz = {32.70, 36.71, 41.20, 43.25, 49.00};
boolean dirty = false;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int numKeys=2;
int[] keyStates;
final int KEYUP = 48;
final int KEYDOWN = 49;
void setup() 
{
  
  keyStates= new int[numKeys];
  for(int i = 0; i<numKeys; i++){
     keyStates[i]= KEYUP; 
  }
  String portName = Serial.list()[0];
  println("New Port Created: "+portName);
  myPort = new Serial(this, portName, 9600);
  
  minim = new Minim(this); 
  out = minim.getLineOut(Minim.STEREO); 
  nullWave= new SineWave(0, 0, out.sampleRate()); 
  sine = new SineWave(0, amp, out.sampleRate()); 
  sine.portamento(40); 
}

void draw()
{
  frameRate(10);
  while ( myPort.available() > 1) {
    dirty=true;  // If data is available,
    int curKey = (int)myPort.read() - 48; 
    keyStates[curKey]=myPort.read();
    println("Key "+curKey+" now "+keyStates[curKey]);
  }
  
  if(dirty){
  out.clearSignals();
  constructSine(); 
  dirty = false;
  }
  background(255);
  
}

void constructSine() 
{ 
  int keysDown = 0;
  for (int j = 0; j<numKeys; j++){
   if(keyStates[j]==KEYDOWN){
     keysDown++;
   } 
  }
  amp = MAXAMP/keysDown;
  for(int i=0;i<numKeys;i++) 
  { 
    if(keyStates[i]==KEYDOWN) 
    { 
      sine = new SineWave(32*notesHz[i], amp, out.sampleRate()); 
      sine.portamento(40); 
      out.addSignal(sine); 
    } 
  }  
} 


void stop() 
{ 
  out.close(); 
  minim.stop(); 

  super.stop();
}
