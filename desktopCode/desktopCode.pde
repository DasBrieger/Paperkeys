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
float[] notesHz = {
  49.00, 43.25, 41.20, 36.71, 32.70
};
boolean dirty = false;
String[] noteNames = {
  "C", "D", "E", "F", "G"
};
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int numKeys=5;
int[] keyStates;
final int KEYUP = 48;
final int KEYDOWN = 49;

final int MONOTONIC = 0;
final int KEYBOARD = 1;
final int ORGAN = 2;
String[] modes = {"Synthesizer", "Keyboard", "Organ"};
int currentMode;

PImage backgroundImage;
PFont helv;
PFont helvB;
PFont paper;

void setup() 
{
  size(1080, 720);
  helv = loadFont("Helvetica100.vlw"); 
  helvB = loadFont("HelveticaBold100.vlw"); 
  paper = loadFont("StrokeDimension100.vlw"); 
  backgroundImage = loadImage("background.jpg");
  currentMode = MONOTONIC;
  keyStates= new int[numKeys];
  for (int i = 0; i<numKeys; i++) {
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
  while ( myPort.available () > 1) {
    frameRate(60);
    dirty=true;  // If data is available,
    int curKey = (int)myPort.read() - 48; 
    keyStates[curKey]=myPort.read();
    println("Key "+curKey+" now "+keyStates[curKey]);
  }

  if (dirty) {
    out.clearSignals();
    constructSine(); 
    dirty = false;
  }
  background(255);
  image(backgroundImage, 0,0);
  
  fill(66);
  textFont(paper, 150);
  textAlign(CENTER);
  text("Paperkeys", width/2, 120);
  fill(33);
  textFont(paper, 50);
  textAlign(RIGHT);
  text("by John Brieger", width/2+290, 190);
  textAlign(CENTER);
  drawKeys();
  
  fill(66,66,66,180);
  textFont(helvB, 25);
  textAlign(RIGHT);
  text("Current Mode: "+modes[currentMode], width-20, height-20);
}

void constructSine() 
{ 
  int keysDown = 0;
  for (int j = 0; j<numKeys; j++) {
    if (keyStates[j]==KEYDOWN) {
      keysDown++;
    }
  }
  amp = MAXAMP/keysDown;
  for (int i=0;i<numKeys;i++) 
  { 
    if (keyStates[i]==KEYDOWN) 
    { 

      //electronic organ sound
      if (currentMode == ORGAN) {
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

      else if (currentMode == KEYBOARD) {
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

      else if (currentMode == MONOTONIC) {
        sine = new SineWave(32*notesHz[i], amp, out.sampleRate()); 
        sine.portamento(40); 
        out.addSignal(sine);
      }
    }
  }
} 

void keyPressed() {
  if (key == ' ') {
    currentMode++;
    currentMode= currentMode%3;
  }
}

void drawKeys(){
 stroke(0);
  for (int i = 0; i<numKeys; i++) {
    if (keyStates[numKeys-1-i]== KEYUP) { 
      fill(255,255,255,180);
      rect(width/4+i*width/10, height/3+50, width/10, height/2-100);
      fill(66,66,66,180);
      textFont(helvB, 50);
      text(noteNames[i], width/4+i*width/10+ width/20, height/3+ height/2-60);
    } 
    else {
      fill(66,66,66,180);
      rect(width/4+i*width/10, height/3+50, width/10, height/2-100);
      fill(255,255,255,180);
      textFont(helvB, 50);
      text(noteNames[i], width/4+i*width/10+ width/20, height/3+ height/2-60);
    }
  } 
}

void stop() 
{ 
  out.close(); 
  minim.stop(); 

  super.stop();
}

