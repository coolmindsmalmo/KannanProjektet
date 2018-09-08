import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SimpleReadarduino extends PApplet {

/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */



Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
boolean noPort=false,pKeyPressed;
float power, force,maxPower,minPower=-1.5f;

public void setup() 
{
  
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  try {
    String portName = Serial.list()[0];
    myPort = new Serial(this, portName, 9600);
    myPort.buffer(1);
    print(    myPort.read()   );      // read it and store it in val

  }
  catch(Exception e) {
    println(" No serial ports : presss space to activate ");
    noPort=true;
  }
}

public void draw()
{
  if ( !noPort) {  // If data is available,
    if(myPort.available() > 0)val = myPort.read();         // read it and store it in val
  } else {
    if (!pKeyPressed &&keyPressed && key==' ') {
      val=2;
    } else {
      val=0;
    }
  }
   /* if (myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
  } */
  
  pKeyPressed=keyPressed;
  background(255);             // Set background to white
  if (val == 2) {              // If the serial value is 0,
    fill(0);                   // set fill to black
  } else {                       // If the serial value is not 0,
    fill(204);                 // set fill to light gray
  }
  if (val == 2) {
    //fill(255, 0, 0);
    if (power<height){if(force<0)force/=2;
    force+=1;}
    else power=height;
  } 
    power+=force;
  if (power>0) { 
    force-=0.08f;
  }else power=0;
  if(power< minPower) power=minPower;
  
  //rect(50, height, 100, -power);
  ellipse(100,height-power,50,50);
}
class Wall{

  
  public void wall(){
  
  
  }

  
  public void update(){
  
  }
  
  public void hit(){
  
  }
  
}
  public void settings() {  size(1500, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SimpleReadarduino" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
