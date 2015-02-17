/// Initialize empty csr set ///
CsrSet csrs = new CsrSet();

class Csr {
  // CONSTRUCTOR VARIALBES //
  int ix, wt;
  float x1, x2, y1, y2, dur1cyc;
  String cl;

  // CLASS VARIABLES //
  float w;
  float spdpxperfr;
  float x;
  float currtime = 0.0;
  int dir = 1;
  boolean go = false;
  boolean drwcsr = false;

  // CONSTRUCTORS //
  //Constructor 1 
  Csr(int aix, float ax1, float ax2, float ay1, float ay2, String acl, int awt, float adur1cyc) {
    ix = aix;
    x1 = ax1;
    x2 = ax2;
    y1 = ay1;
    y2 = ay2;
    cl = acl;
    wt = awt;
    dur1cyc = adur1cyc;

    w = x2-x1;
    spdpxperfr =  w/(dur1cyc * fr) ; //fr is a global variable - frameRate
    x = x1;
  } //end constructor 1

    //  DRAW METHOD //
  void drw() {

    /// Boundary Conditions ///
    if (x>x2) x=x1;
    if (x<x1) x=x2;

    /// Draw Cursor ///
    if (drwcsr) {
      strokeWeight(wt); 
      stroke(clr.get(cl));
      line(x, y1, x, y2);
    }  

    /// Animate ///
    if (go) x = x+(spdpxperfr*dir);
    //
  } //End drw
}  //End class

//// CLASS SET CLASS ////
class CsrSet {
  ArrayList<Csr> clst = new ArrayList<Csr>();

  // Make Instance Method //
  void mk(int ix, float ax1, float ax2, float ay1, float ay2, String cl, int awt, float adur1cyc) {
    clst.add(new Csr(ix, ax1, ax2, ay1, ay2, cl, awt, adur1cyc));
  } //end mk method

  // Draw Set Method //
  void drw() {
    for (int i=clst.size ()-1; i>=0; i--) {
      Csr inst = clst.get(i);
      inst.drw();
    }
  } //end dr method

  // Rmv Method //
  void rmv(int ix) {
    for (int i=clst.size ()-1; i>=0; i--) {
      Csr inst = clst.get(i);
      if (inst.ix == ix) {
        clst.remove(i);
      }
    }
  } //end dr method

  // Cursor Go //
  void play(int ix, int dir, float dur1cyc) {
    for (int i=clst.size ()-1; i>=0; i--) {
      Csr inst = clst.get(i);
      if (inst.ix == ix) {
        inst.go = true;
        inst.dir = dir;
        inst.spdpxperfr =  inst.w/(dur1cyc * fr) ; //fr is a global variable - frameRate
      }
    }
  } //end play method

  // Cursor Pause //
  void pause(int ix) {
    for (int i=clst.size ()-1; i>=0; i--) {
      Csr inst = clst.get(i);
      if (inst.ix == ix) {
        inst.go = false;
      }
    }
  } //end pause method
} //end class set class

