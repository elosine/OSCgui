import netP5.*;
import oscP5.*;
OscP5 osc;
NetAddress sc;
PFont font1;
SliderSet sls;
void setup() {
  size(800, 500);
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);
  font1 = loadFont("SourceCodePro-Regular-12.vlw");
  textFont(font1);
  sls = new SliderSet();
  osc.plug(sls, "mk", "/mksl");
  osc.plug(sls, "rmv", "/rmsl");
}
void draw() {
  background(255, 128, 0);
  sls.drw();
}
void mouseDragged() {
  sls.msdrg();
}