/*
Series of random number generators
*/

import oscP5.*;
import netP5.*;

OscP5 osc;
ArrayList <NetAddress> ips;
int myport = 12321;

String path, ippath;
File file, ipfile;

PFont monaco13;
int sketchw=500;
int sketchh=500;


void setup() {
  osc = new OscP5(this, myport);
  ips = new ArrayList<NetAddress>();
  monaco13 = loadFont("Monaco-13.vlw");
  textFont(monaco13);

  path = sketchPath("guidata.txt");
  file = new File(path);
  ippath = sketchPath("ips.txt");
  ipfile = new File(ippath);
  
if (ipfile.exists()) {
    String[] d1 = loadStrings("ips.txt");
    for (int i=0; i<d1.length; i++) {
      String[]d2 = split(d1[i], "\t");
        ips.add( new NetAddress( d2[0], int(d2[1]) ) );
    }
  }
  
  if (file.exists()) {
    String[] d1 = loadStrings("guidata.txt");
    String initdat = d1[0];
    String[]initdata = split(initdat, "\t");
    sketchw = int(initdata[0]);
    sketchh = int(initdata[1]);
    d1 = subset(d1, 1, d1.length-1);
    for (int i=0; i<d1.length; i++) {
      String[]d2 = split(d1[i], "\t");
      if (d2.length == 11) {
        pmos.mk(d2[0], int(d2[1]), int(d2[2]), int(d2[3]), 
        int(d2[4]), int(d2[5]), d2[6], int(d2[7]), d2[8], d2[9], d2[10]);
      }
    }
  }
  size(sketchw, sketchh);
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
void keyReleased(){
  pmos.keyrel();
}

