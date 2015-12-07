import netP5.*;
import oscP5.*;
//GLOBAL VARIABLES//////////////////////////////////////////////////////
////OSC//////////////////
OscP5 osc;
NetAddress sc, me;
////Text/////////////////
PFont font1;
////Buttons//////////////
int btct = 0;
boolean mkbt_m = false;
boolean mkbt_t = false;
////Sliders//////////////
int slct = 0;
boolean mksl = false;
//SETUP/////////////////////////////////////////////////////////////////
void setup() {
  size(1000, 800);
  //OSC//////////////////////////////////////////
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);
  me = new NetAddress("127.0.0.1", 12321);
  //TEXT//////////////////////////////////////////
  font1 = loadFont("Monaco-12.vlw");
  textFont(font1);
  //OSC PLUGS/////////////////////////////////////
  osc.plug(pushmez, "mk", "/mkbt");
  osc.plug(pushmez, "rmv", "/rmvbt");
  osc.plug(sliderz, "mk", "/mksl");
  osc.plug(sliderz, "rmv", "/rmsl");
}//end setup
//DRAW/////////////////////////////////////////////////////////////////
void draw() {
  background(0);
  pushmez.drw();
  sliderz.drw();
}//end draw
//KEY PRESSED////////////////////////////////////////////////////////////
void keyPressed() {
  // b to make a new momentary button
  if (key=='b') {
    mkbt_m = true;
  }
  // t to make a new toggle button
  if (key=='t') {
    mkbt_t = true;
  }
  // s to make a new slider
  if (key=='s') {
    mksl = true;
  }
  pushmez.keyprs();
  sliderz.keyprs();
}//end keyPressed
//KEY RELEASED////////////////////////////////////////////////////////////
void keyReleased() {
  // b to make a new momentary button
  if (key=='b') {
    mkbt_m = false;
  }
  // t to make a new toggle button
  if (key=='t') {
    mkbt_t = false;
  }
  // s to make a new slider
  if (key=='s') {
    mksl = false;
  }
}//end keyPressed
//MOUSE PRESSED////////////////////////////////////////////////////////////
void mousePressed() {
  //Make a new momentary button when mouse pressed and 'b' key pressed
  if (mkbt_m) {
    osc.send("/mkbt", new Object[]{btct, mouseX, mouseY, 0}, me);
    btct++;
  }
  //Make a new toggle button when mouse pressed and 't' key pressed
  if (mkbt_t) {
    osc.send("/mkbt", new Object[]{btct, mouseX, mouseY, 1}, me);
    btct++;
  }
  //Make a new slider when mouse pressed and 's' key pressed
  if (mksl) {
    osc.send("/mksl", new Object[]{slct, mouseX, mouseY}, me);
    slct++;
  }
  pushmez.msprs();
  sliderz.msprs();
}//end mouse pressed
//MOUSE RELEASED////////////////////////////////////////////////////////////
void mouseReleased() {
  pushmez.msrel();
}//end mouse released
//MOUSE MOVED////////////////////////////////////////////////////////////
void mouseMoved() {
  pushmez.msmvd();
  sliderz.msmvd();
}//end mouse pressed
//MOUSE DRAGGED////////////////////////////////////////////////////////////
void mouseDragged() {
  sliderz.msdrg();
}//end mouse pressed
//IS MOUSE OVER? FUNCTION////////////////////////////////////////////////
boolean mo( float l, float r, float t, float b ) {
  boolean on = false;
  if ( mouseX>=l && mouseX <=r && mouseY>=t && mouseY<=b) on = true;
  return on;
}