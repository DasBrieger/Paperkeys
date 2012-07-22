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
float MAXAMP = .4;  
float amp  = MAXAMP; 
// GFEDCfrom Kevin O'Hara via openprocessing
float[] notesHz = {49.00, 43.25, 41.20, 36.71, 32.70};
boolean dirty = false;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int numKeys=5;
int[] keyStates;
final int KEYUP = 48;
final int KEYDOWN = 49;

final int MONOTONIC = 0;
final int KEYBOARD = 1;
final int ORGAN = 2;
int currentMode;
void setup() 
{
  currentMode = MONOTONIC;
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
  while ( myPort.available() > 1) {
    frameRate(60);
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
      
      //electronic organ sound
      if(currentMode == ORGAN){
      sine = new SineWave(32*notesHz[i], amp, out.sampleRate()); 
      sine.portamento(40); 
      out.addSignal(sine); 
      sine = new SineWave(2*32*notesHz[i], amp/8, out.sampleRate()); 
      sine.portamento(200); 
      out.addSignal(sine);
      sine = new SineWave(4*32*notesHz[i], amp/8, out.sampleRate()); 
      sine.portamento(200); 
      out.addSignal(sine);
      sine = new SineWave(16*notesHz[i], amp/8, out.sampleRate()); 
      sine.portamento(200); 
      out.addSignal(sine);
        sine = new SineWave(8*notesHz[i], amp/8, out.sampleRate()); 
      sine.portamento(200); 
      out.addSignal(sine);
      }
      
      else if(currentMode == KEYBOARD){
        //simple 5th chord to do standard electronic keyboard sound   
      sine = new SineWave(32*notesHz[i], amp/3, out.sampleRate()); 
      sine.portamento(40); 
      out.addSignal(sine); 
      sine = new SineWave(2*32*notesHz[i], amp/3, out.sampleRate()); 
      sine.portamento(200); 
      out.addSignal(sine);
      sine = new SineWave(16*notesHz[i], amp/3, out.sampleRate()); 
      sine.portamento(200); 
      out.addSignal(sine);
      }
      
      else if(currentMode == MONOTONIC){
         sine = new SineWave(32*notesHz[i], amp, out.sampleRate()); 
      sine.portamento(40); 
      out.addSignal(sine); 
      }
      
    } 
  }  
} 

void keyReleased(){
 currentMode++;
currentMode= currentMode%3;
}

void stop() 
{ 
  out.close(); 
  minim.stop(); 

  super.stop();
}
