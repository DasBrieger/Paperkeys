/**
 * Paperkeys DesktopApp
 *
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port

void setup() 
{
  size(200, 200);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  println("New Port Created: "+portName);
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read(); 
    println(val);    // read it and store it in val
  }
  background(255);             // Set background to white
  if (val == 48) {              // If the serial value is 0,
    fill(0);                   // set fill to black
  } 
  else if(val== 50) {                       // If the serial value is not 0,
    fill(204);                 // set fill to light gray
  }
  rect(50, 50, 100, 100);
  
}
