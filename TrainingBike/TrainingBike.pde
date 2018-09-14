import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer smack;
final int MAX_BIKE_SPEED=190, MIN_ANGLE=-90, MAX_ANGLE=90;
PGraphics scrollingBG, UI;
int speed=5;
Serial myPort;             // Create object from Serial class
int bikeValue, bx, by, keyValue; // Data received from the serial port
boolean noPort, pKeyPressed, hit, keyBoard, dead, left, right;

float power, aimPower, force, maxPower, minPower=-1.5, angle, x=500, y, size=100, amplifyingPower=4, vy;
ArrayList<Obstacle> Obstacles= new ArrayList<Obstacle>(); 
ArrayList<Particle> particles= new ArrayList<Particle>(); 

PImage img, bg1, bg2, glider1, glider2;

void setup() 
{
  // rectMode(CENTER);
  //size(1500, 800);
  noStroke();
  fullScreen(P3D);
  textAlign(CENTER);
  minim = new Minim(this);
  smack = minim.loadFile("SMACK - Sound Effect.wav");
  try {
    String portName = Serial.list()[0];
    myPort = new Serial(this, portName, 9600);
    myPort.buffer(0);
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
  Obstacles.add(new Obstacle(new PImage[]{glider1, glider2}, width, 100, 70, 60).speed(-2, 0).randomize().recuring().setBehavior(Mode.GLIDE));
  Obstacles.add(new Obstacle(width, 200, 50, 250));
  scrollingBG = createGraphics(width*2, height);
  scrollingBG.beginDraw();
  scrollingBG.image(bg1, 0, 0);
  scrollingBG.image(bg1, width, 0);
  scrollingBG.endDraw();
  UI = createGraphics(width, height);
  updateUI();
}
void updateUI() {
  UI.beginDraw();
  UI.endDraw();
}
void draw()
{ 
  backgroundRender();
  for (Obstacle w : Obstacles) {
    w.display();
    w.update();
    if (w.hit(x, y, size*0.5, size*0.5)) {
      hit=true;
      playSound(smack);
    }
    if (w.dead) {
      Obstacles.remove(w);
      break;
    }
  }
  for (int i=particles.size ()-1; i>= 0; i--) { // checkStamps
    particles.get(i).update();  
    particles.get(i).display();
    if (  particles.get(i).dead) particles.remove(i);
  }
  sensePortInfo();
  keyBoardSensing();
  calcAngle();
  // hitDetection();

  y=height-power;
  particles.add( new Particle (int(-cos(radians(angle))*40 +x), int(-sin(radians(angle))*40+y), 10, 10, -speed, random(-2, 2)).setSize(30, 30, -1, -1));

  displayCharacter();
  image(UI, 0, 0);
  //println("cykel:"+bikeValue +"  key:"+ keyValue);
}
void backgroundRender() {
  background(255);
  bx+=speed*0.5;
  if (bx>width)bx-=width;
  image(scrollingBG, -bx, -y*0.1);
}
void calcAngle() {
  angle=-vy*7;
  angle=constrain(angle, MIN_ANGLE, MAX_ANGLE);
  y=constrain(y, 0, height);
}
void hitDetection() {
  if (hit) {
    x-=1;
    angle+=5;
  }
}
void sensePortInfo() {
  if (!noPort) {  
    if (myPort.available() > 0) {
      bikeValue = myPort.read();     
     // println(bikeValue);

      if (bikeValue<252) {
        aimPower=bikeValue*7;
        //map(bikeValue,0,MAX_BIKE_SPEED,0,height);
      } else { 
        switch(bikeValue) {
        case 256-1:
          left=true;
          particles.add( new Particle (int(-cos(radians(angle))*40 +x), int(-sin(radians(angle))*40+y)-100, 80, 80, -5, 0).setColor( color(0, 0, 255)));
          break;
        case 256-2:
          left=false;
          particles.add( new Particle (int(-cos(radians(angle))*40 +x), int(-sin(radians(angle))*40+y)-100, 80, 80, -5, 0).setColor(color(0, 0, 100)));
          break;
        case 256-3:
          right=true;
          particles.add( new Particle (int(-cos(radians(angle))*40 +x), int(-sin(radians(angle))*40+y), 80, 80, -5, 0).setColor( color(255, 0, 0)));
          break;
        case 256-4:
          right=false;
          particles.add( new Particle (int(-cos(radians(angle))*40 +x), int(-sin(radians(angle))*40+y), 80, 80, -5, 0).setColor(color(100, 0, 0)));
          break;
        }
      }
    }

    if (left) {
      particles.add( new Particle (int(-cos(radians(angle))*40 +x), int(-sin(radians(angle))*40+y)-100, 40, 40, -5,0).setColor( color(0, 0, 255)));
      x++;
      speed--;
    }


    if (right) {
      particles.add( new Particle (int(-cos(radians(angle))*40 +x), int(-sin(radians(angle))*40+y), 40, 40, -5, 0).setColor( color(255, 0, 0)));
      x--;
      speed++;
    }
  } 
  power+=(aimPower-power)*0.5;
  /* try { 
   if (myPort.available() > 0) {  
   val = myPort.read();
   }
   }
   catch(Exception e) {
   }*/
}

void keyBoardSensing() {
  if (keyBoard) {
    pKeyPressed=keyPressed;
    if (keyPressed && key==' ') {
      vy+=0.5 ;
    } else {
      vy-=.2;
    }
    power=keyValue;
    keyValue+=vy;

    /*if (val == 2) {
     //fill(255, 0, 0);
     if (power<height) {
     if (force<0)force/=2;
     if (keyBoard)force+=3-(0.0001*power);
     else force+=1-(0.0001*amplifyingPower*power);
     angle=(20-angle)*.5;
     } else power=height;
     }*/
  }
}

void displayCharacter() {
  text(power, x, y-50);
  pushMatrix();
  //if (hit)tint(255, 0, 0);
  translate(x, y);
  rotate(radians(angle));
  image(img, -size*0.5, -size*0.5, size, size);
  //noTint();
  popMatrix();
}
void keyPressed() {
  if (keyCode==LEFT) {
    speed--;
  }
  if (keyCode==RIGHT) {
    speed++;
  }
}

void playSound(AudioPlayer au) {
  au.rewind();
  au.play();
}
