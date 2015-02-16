import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress sc;
int myport = 12321;

String path;
File file;

PFont monaco13;


void setup() {
  size(500, 500);
  osc = new OscP5(this, myport);
  sc = new NetAddress("127.0.0.1", 57120);
  monaco13 = loadFont("Monaco-13.vlw");
  textFont(monaco13);

  path = sketchPath("guidata.txt");
  file = new File(path);
  


  if (file.exists()) {
    String[] d1 = loadStrings("guidata.txt");
    for (int i=0; i<d1.length; i++) {
      String[]d2 = split(d1[i], "\t");
      if (d2.length == 11) {
        String[]d3 = split(d2[9], "#");
        String[]d4 = split(d2[10], "#");
        pmos.mk(d2[0], int(d2[1]), int(d2[2]), int(d2[3]), 
        int(d2[4]), int(d2[5]), d2[6], d2[7], d2[8], d3, d4);
      }
    }
  }
}

void draw() {
  background(0); 
  pmos.drw();
}

void mouseDragged() {
  pmos.msdrg();
}
void mousePressed() {
  pmos.msprs();
}
void mouseReleased() {
  pmos.msrel();
}

void keyPressed() {
  pmos.keyprs();
}

