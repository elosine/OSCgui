class Csr {
  // CONSTRUCTOR VARIALBES //
  int ix, wt;
  float x1, x2, y1, y2, dur;
  String cl;
  float spdpxperfr;

  // CLASS VARIABLES //
  float x;
  float currtime = 0.0;
  int dir = 1;
  boolean go = false;

  // CONSTRUCTORS //
  //Constructor 1 
  Csr(int aix, float ax1, float ax2, float ay1, float ay2, String acl, int awt, float aspdpxperfr) {
    ix = aix;
    x1 = ax1;
    x2 = ax2;
    y1 = ay1;
    y2 = ay2;
    cl = acl;
    wt = awt;
    spdpxperfr = aspdpxperfr;
    
    x = x1;
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    
    /// Boundary Conditions ///
    if (x>x2) x=x1;
    if (x<x1) x=x2;
  
    /// Draw Cursor ///
    strokeWeight(wt); 
    stroke(clr.get(cl));
    line(x, y1, x, y2);   

    /// Animate ///
    if (go) x = x+(spdpxperfr*dir);
    //
  } //End drw
}  //End class

//// CLASS SET CLASS ////
class CsrSet {
  ArrayList<Csr> clst = new ArrayList<Csr>();

  // Make Instance Method //
  void mkins(int ix, int stave, String cl, float spd) {
    //println(cl);
    Win w1 = wins.clst.get(stave);
    clst.add(new Csr(ix, stave, cl, 3, spd*pxperframe));
  } //end mk method

  // Draw Set Method //
  void drst() {
    for (int i=clst.size()-1; i>=0; i--) {
      Csr inst = clst.get(i);
      inst.drw();
    }
  } //end dr method

  // Cursor Go //
  void play(int ix, int dir, float spd) {
    for (int i=clst.size()-1; i>=0; i--) {
      Csr inst = clst.get(i);
      if (inst.ix == ix) {
        inst.go = true;
        inst.dir = dir;
        inst.spdpxperfr = spd*pxperframe;
      }
    }
  } //end play method

  // Cursor Pause //
  void pause(int ix) {
    for (int i=clst.size()-1; i>=0; i--) {
      Csr inst = clst.get(i);
      if (inst.ix == ix) {
        inst.go = false;
      }
    }
  } //end pause method
} //end class set class

