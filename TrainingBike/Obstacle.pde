class Obstacle extends Object {
  PImage img;
  PImage[] imgList;
  boolean rand, recuring, graphics,hit;
  int imgIndex;
  Behavior behavior=new Behavior() ;
  Obstacle(int _x, int _y, int _w, int _h) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
  }
  Obstacle(PImage _img, int _x, int _y, int _w, int _h) {
    this( _x, _y, _w, _h);
    graphics=true;
    img=_img;
    x=_x;
    y=_y;
    w=_w;
    h=_h;
  }
  Obstacle(PImage[] _imgList, int _x, int _y, int _w, int _h) {
    this( _x, _y, _w, _h);
    graphics=true;
    imgList=_imgList;
    img=imgList[0];
    imgIndex=0;
    x=_x;
    y=_y;
    w=_w;
    h=_h;
  }
  void respawn() {
    x=width;
    if (rand) {
      y=int(random(height));
    }
  }
  void display() {
    if (graphics) {
      image(img, x, y, w, h);
    } else {
      fill(0);
      stroke(0);
      rect(x, y, w, h);
    }
  }
  void update() {
    px=x;
    py=y;
    x+=vx;
    y+=vy;
    behavior.update();
    pvx=vx;
    pvy=vy;
    if (x+w<0)kill();
    if(hit)dead=true;
  }

  boolean hit(float _x, float _y, float _w, float _h) {
    if (_x<x+w) {
      if (_x+_w>x) {
        if (_y<y+h) {
          if (_y+_h>y) {
            hit=true;
            dead=true;
            return true;
          }
        }
      }
    }
    return false;
  }
  void kill() {
    super.kill();
    if (recuring) {
      respawn();
    } else dead=true;
  }

  void switchImage(int next) {
    imgIndex+=next;
    if (imgIndex>imgList.length-1) {
      imgIndex=0;
    }
    if (imgIndex<0) {
      imgIndex=imgList.length-1;
    }
    print(imgIndex);
    img=imgList[imgIndex];
  }

  Obstacle speed(int _vx, int _vy) {
    vx=_vx;
    vy=_vy;
    return this;
  }
  Obstacle randomize() {
    rand=true;
    return this;
  }
  Obstacle setBehavior(Mode m) {
    behavior= new Behavior(this, m);
    return this;
  }
  Obstacle recuring() {
    recuring=true;
    return this;
  }
}
