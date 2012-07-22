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
String[] modes = {
  "Synthesizer", "Keyboard", "Organ"
};
int currentMode;
boolean displayWave = true;


PImage backgroundImage;
PImage sineImage;
PImage chordImage;
PImage organImage;
PImage[] modeImages = new PImage[3]; 
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
  modeImages[0] = loadImage("sine.png");
  modeImages[1] = loadImage("chord.png");
  modeImages[2] = loadImage("organ.png");

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
  if (displayWave) {
    frameRate(50);
  }
  else {
    frameRate(60);
  }

  while ( myPort.available () > 1) {
    dirty=true;  // If data is available,
    int curKey = (int)myPort.read() - 48; 
    keyStates[curKey]=myPort.read();
    println("Key "+curKey+" now "+keyStates[curKey]);
    //println("Framerate: "+frameRate);
  }

  if (dirty) {
    out.clearSignals();
    constructSine(); 
    dirty = false;
  }
  background(255);
  image(backgroundImage, 0, 0);

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

  fill(66, 66, 66, 180);
  textFont(helv, 25);
  textAlign(RIGHT);
  image(modeImages[currentMode], width-370 + 20*currentMode, height-40);
  text("Current Mode: "+modes[currentMode], width-20, height-20);

  if (displayWave) {
    drawWave();
  }
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
    dirty=true;
  }
  else if (key == 'w') {
    displayWave = !displayWave;
  }
  else if(key == 'a'){
    keyStates[4] = KEYDOWN;
    dirty=true;
  }
    else if(key == 's'){
    keyStates[3] = KEYDOWN;
    dirty=true;
  }
    else if(key == 'd'){
    keyStates[2] = KEYDOWN;
    dirty=true;
  }
    else if(key == 'f'){
    keyStates[1] = KEYDOWN;
    dirty=true;
  }
    else if(key == 'g'){
    keyStates[0] = KEYDOWN;
    dirty=true;
  }
}

void keyReleased(){
 if(key == 'a'){
  keyStates[4] = KEYUP;
  dirty=true;
 } 
 else if(key == 's'){
  keyStates[3] = KEYUP;
  dirty=true;
 } 
 else if(key == 'd'){
  keyStates[2] = KEYUP;
  dirty=true;
 } 
 else if(key == 'f'){
  keyStates[1] = KEYUP;
  dirty=true;
 } 
 else if(key == 'g'){
  keyStates[0] = KEYUP;
  dirty=true;
 } 
}
void drawWave() {
  fill(66);
  //using kevin o'hora's algorithm
  for (int i = 0; i < out.bufferSize() - 1; i++) 
  { 
    float x1 = map(i, 0, out.bufferSize(), width/4, width*3/4); 
    float x2 = map(i+1, 0, out.bufferSize(), width/4, width*3/4); 
    line(x1, 600 + out.left.get(i)*50, x2, 600 + out.left.get(i+1)*50);
  }
}

void drawKeys() {
  stroke(0);
  for (int i = 0; i<numKeys; i++) {
    if (keyStates[numKeys-1-i]== KEYUP) { 
      fill(255, 255, 255, 180);
      rect(width/4+i*width/10, height/3+50, width/10, height/2-100);
      fill(66, 66, 66, 180);
      textFont(helvB, 50);
      text(noteNames[i], width/4+i*width/10+ width/20, height/3+ height/2-60);
    } 
    else {
      fill(66, 66, 66, 180);
      rect(width/4+i*width/10, height/3+50, width/10, height/2-100);
      fill(255, 255, 255, 180);
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

