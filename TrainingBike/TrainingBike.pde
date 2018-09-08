
import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer smack;
PGraphics scrollingBG;
Serial myPort;  // Create object from Serial class
int val, bx, by;        // Data received from the serial port
boolean noPort, pKeyPressed, hit, keyBoard, dead;
float power, force, maxPower, minPower=-1.5, angle, x=150, y, size=100;
ArrayList<Obstacle> Obstacles= new ArrayList<Obstacle>(); 
PImage img, bg1, bg2, glider1, glider2;

void setup() 
{
  rectMode(CENTER);
  fullScreen(P3D);
  minim = new Minim(this);
  smack = minim.loadFile("SMACK - Sound Effect.wav");
  try {
    String portName = Serial.list()[0];
    myPort = new Serial(this, portName, 9600);
    myPort.buffer(1);
    keyBoard=false;
  }
  catch(Exception e) {
    println(" No serial ports : presss space to activate ");
    noPort=true;
    keyBoard=true;
  }
  img=loadImage("IceShardMinor.png");
  bg1=loadImage("pixel-landscape-background.png");
  glider1=loadImage("glider1.png");
  glider2=loadImage("glider2.png");
  Obstacles.add(new Obstacle(width, 100, 50, 550).speed(-5, 0).randomize().recuring());
  Obstacles.add(new Obstacle(width, 100, 50, 550).speed(-8, 0).randomize().recuring());
  Obstacles.add(new Obstacle(width, 100, 50, 550).speed(-9, 0).randomize().recuring());
  Obstacles.add(new Obstacle(width, 100, 50, 550).speed(-10, 0).randomize().recuring());
  Obstacles.add(new Obstacle(width, 100, 50, 300).speed(-3, 0).randomize().recuring());
  Obstacles.add(new Obstacle(new PImage[]{glider1, glider2}, width, 100, 50, 40).speed(-2, 0).randomize().recuring().setBehavior(Mode.GLIDE));
  Obstacles.add(new Obstacle(width, 200, 50, 250));
  scrollingBG = createGraphics(width*2, height);
  scrollingBG.beginDraw();
  scrollingBG.image(bg1, 0, 0);
  scrollingBG.image(bg1, width, 0);
  scrollingBG.endDraw();
}

void draw()
{  
  background(255);             // Set background to white
  bx+=5;
  if(bx>width)bx-=width;
  image(scrollingBG, -bx, -y*0.1); 
  for (Obstacle w : Obstacles) {
    w.display();
    w.update();
    if (w.hit(x, y, size*0.5, size*0.5)) {
      hit=true;
      smack.rewind();
      smack.play();
    }
    if (w.dead) {
      Obstacles.remove(w);
      break;
    }
  }

  if ( !noPort) {  // If data is available,
    if (myPort.available() > 0)val = myPort.read();         // read it and store it in val
  } else {
    if (!pKeyPressed &&keyPressed && key==' ') {
      val=2;
    } else {
      val=0;
    }
  }
  try { 
    if (myPort.available() > 0) {  // If data is available,
      val = myPort.read();         // read it and store it in val
    }
  }
  catch(Exception e) {
  }

  pKeyPressed=keyPressed;

  if (val == 2) {
    //fill(255, 0, 0);
    if (power<height) {
      if (force<0)force/=2;
      if (keyBoard)force+=3-(0.0001*power);
      else force+=1-(0.0001*power);
      angle=(20-angle)*.5;
    } else power=height;
  } 
  if (hit) {
    x-=1;
    angle+=5;
  }
  x+=0.1;
  power+=force;
  if (power>0) { 
    force-=0.1;
    //angle+=2;
    angle=-force*20;
    if (angle<-80)angle=-80;
    if (angle>80)angle=80;
  } else power=0;
  if (power< minPower) power=minPower;
  y=height-power;
  //rect(50, height, 100, -power);
  display();
}

void display() {
  pushMatrix();
  if (hit)tint(255, 0, 0);
  translate(x, y);
  rotate(radians(angle));
  image(img, -size*0.5, -size*0.5, size, size);
  noTint();
  popMatrix();
}
