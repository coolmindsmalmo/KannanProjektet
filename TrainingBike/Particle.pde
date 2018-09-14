class Particle {
  color fillColor=color(255,100),strokeColor=color(200,50);
  boolean dead;
  int x, y, vx, vy, w, h, vw, vh, updateSkips, scaleSkips;

  Particle(int _x, int _y, int _w, int _h) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
  }

  Particle(int _x, int _y, int _w, int _h, float _vx, float _vy) {
    this(_x, _y, _w, _h);
    vx=int(_vx);
    vy=int(_vy);
  }
  Particle setSize(int _w, int _h) {
    w=_w;
    h=_h;
    return this;
  }

  Particle setSize(int _w, int _h, int _vw, int _vh) {
    this.setSize(  _w, _h);
    vw =_vw;
    vh =_vh;
    return this;
  }
  Particle setColor(color c){
  fillColor=c;
  strokeColor=c;
  return this;
  }
  void update() {
    x+=vx;
    y+=vy;
    if (vw!=0 || vh!=0) {
      w+=vw;
      h+=vh;
    }
    if (x<0 || w<0 || h<0)dead=true;
  }
  void display() {
    fill(fillColor);
    stroke(strokeColor);
    ellipse(x, y, w, h);
  }
}
