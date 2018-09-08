enum Mode { 
  NONE, FLY, GLIDE, WAVE, HOMING
};

class Behavior {
  Mode mode=Mode.NONE;
  Obstacle o;
  float range=1, angle;
  Behavior() {
  }
  Behavior(Obstacle _o, Mode _mode) {
    mode=_mode;
    o=_o;
  }

  void update() {
    switch(mode) {
    case NONE:
      break;
    case FLY:
      break;
    case GLIDE:
      angle++;
      o.vy=sin(radians(angle))*range;
      if ((o.vy<0 && o.pvy>0) ||(o.vy>0 && o.pvy<0)) {
        o.switchImage(1);
      }
      break;
    case WAVE:
      break;
    case HOMING:
      break;
    default:
    }
  }
}
