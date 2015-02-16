//USE CURVE STROKE WEIGHT TO CONTROL ANOTHER FACTOR USUALLY AMPLITUDE

class BezierCurve {
  // Constructor Variables //
  int ix;
  String clrname;
  color crvclr;
  int clrnum;
  float[]x = new float[4];
  float[]y = new float[4];

  // Class Variables //
  int crvStrkWt = 2;
  float l, t, r, bm;
  color bbclr;
  boolean active = false;
  int aptsz = 32;
  int ctptsz = 24;

  //// CURVE FOLLOWING VARIABLES ////
  float SMALL = 0.0000000001;
  int b;
  float [] OPL = new float[32];
  float yLookup;
  PVector xy;
  int crvflsz = 13;

  boolean on = false;

  // Constructor //
  BezierCurve(int aix, String argclrname, PVector A, PVector B, PVector C, PVector D) {
    clrname = argclrname;
    ix = aix;
    crvclr = clr.get(clrname);
   
    x[0] = A.x;
    x[1] = B.x;
    x[2] = C.x;
    x[3] = D.x;
    y[0] = A.y;
    y[1] = B.y;
    y[2] = C.y;
    y[3] = D.y;
  } //End Constructor

  void drw() {
    // Draw Curve //
    strokeWeight(crvStrkWt);
    stroke(crvclr);
    noFill();
    bezier(x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3]);
  } //End drw


  // ypos Method //
  float ypos(float xnow, int mode) {
    float curry;
    curry = getYPos(xnow, x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3]);
    if (mode==1) {
      fill(clr.getAlpha("yellow", 128));
      noStroke();
      ellipse(xnow, curry, crvflsz, crvflsz);
    }
    return curry;
  } //End ypos method

  ////////////////////////////////////
  /// METHODS FOR CURVE FOLLOWING ////
  ////////////////////////////////////
  int findroot(float x, float q0, float q1, float q2, float q3, float[] o) {
    // ripped straight from blenkernel/intern/fcurve.c : findzero()
    int nr = 0;
    float phi, a, b, c, p, q, d, c0, c1, c2, c3, t; // I've added this to the original function

    c0= q0 - x;
    c1= 3 * (q1 - q0);
    c2= 3 * (q0 - 2 * q1 + q2);
    c3= q3 - q0 + 3.0 * (q1 - q2);

    if (c3 != 0) {
      a= c2/c3;
      b= c1/c3;
      c= c0/c3;
      a= a/3;

      p= b/3 - a*a;
      q= (2*a*a*a - a*b + c) / 2;
      d= q*q + p*p*p;

      if (d > 0) {
        t= sqrt(d);
        o[0]= (sqrt3d(-q+t) + sqrt3d(-q-t) - a);

        if (o[0] >= SMALL && o[0] <= 1.000001) {
          return 1;
        } else {
          return 0;
        }
      } else if (d == 0) {
        t= sqrt3d(-q);
        o[0]= 2*t - a;

        if (o[0] >= SMALL && o[0] <= 1.000001) {
          nr = nr+1;
        }
        o[nr]= -t-a;

        if (o[nr] >= SMALL && o[nr] <= 1.000001) {
          return nr+1;
        } else {
          return nr;
        }
      } else {
        phi= acos(-q / sqrt(-(p*p*p)));
        t= sqrt(-p);
        p= cos(phi/3);
        q= sqrt(3 - 3*p*p);
        o[0]= 2*t*p - a;

        if (o[0] >= SMALL && o[0] <= 1.000001) {
          nr=nr+1;
        }
        o[nr]= -t * (p + q) - a;

        if (o[nr] >= SMALL && o[nr] <= 1.000001) {
          nr=nr+1;
        }
        o[nr]= -t * (p - q) - a;

        if (o[nr] >= SMALL && o[nr] <= 1.000001) {
          return nr+1;
        } else { 
          return nr;
        }
      }
    } else {
      a=c2;
      b=c1;
      c=c0;

      if (a != 0) {
        // discriminant
        p= b*b - 4*a*c;

        if (p > 0) {
          p= sqrt(p);
          o[0]= (-b-p) / (2 * a);

          if (o[0] >= SMALL && o[0] <= 1.000001) { 
            nr = nr+1;
          }
          o[nr]= (-b+p)/(2*a);

          if (o[nr] >= SMALL && o[nr] <= 1.000001) {
            return nr+1;
          } else { 
            return nr;
          }
        } else if (p == 0) {
          o[0]= -b / (2 * a);
          if (o[0] >= SMALL && o[0] <= 1.000001) {
            return 1;
          } else { 
            return 0;
          }
        }
      } else if (b != 0.0) {
        o[0]= -c/b;
        if (o[0] >= SMALL && o[0] <= 1.000001) { 
          return 1;
        } else { 
          return 0;
        }
      } else if (c == 0) {
        o[0]= 0;
        return 1;
      }  
      return 0;
    }
  }

  float sqrt3d(float d) {
    // ripped straight from blenlib/intern/math_base_inline.c
    if (d==0) {
      return 0;
    }
    if (d<0) {
      return -exp(log(-d)/3);
    } else {
      return exp(log(d)/3);
    }
  }


  PVector bezier2(float t, PVector A, PVector B, PVector C, PVector D) {
    float x = pow((1-t), 3)*A.x+3*pow((1-t), 2)*t*B.x+3*(1-t)*pow((t), 2)*C.x+pow((t), 3)*D.x;
    float y = pow((1-t), 3)*A.y+3*pow((1-t), 2)*t*B.y+3*(1-t)*pow((t), 2)*C.y+pow((t), 3)*D.y;
    PVector xy = new PVector(x, y);

    return xy;
  }


  float getYPos(float xSlider, float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3) {
    b = findroot(xSlider, x0, x1, x2, x3, OPL);
    if (b==1) {
      PVector xy = bezier2(OPL[0], new PVector(x0, y0), new PVector(x1, y1), new PVector(x2, y2), new PVector(x3, y3)); 
      yLookup = xy.y;
    }
    return yLookup;
  }
  //////////////////////////////////////////
  //// END METHODS FOR CURVE FOLLOWING ////
  /////////////////////////////////////////
} // End class BezierCurve

//// CLASS SET CLASS ////
class BezierSet {
  ArrayList<BezierCurve> clst = new ArrayList<BezierCurve>();

  // Make Instance Method //
  void mk(int ix, String clr, int anchorpt1x, int anchorpt1y, int ctlpt1x, int ctlpt1y, int ctlpt2x, int ctlpt2y, int anchorpt2x, int anchorpt2y) {
    
    clst.add( new BezierCurve( ix, clr,
    new PVector(anchorpt1x, anchorpt1y), 
    new PVector(ctlpt1x, ctlpt1y), 
    new PVector(ctlpt2x, ctlpt2y), 
    new PVector(anchorpt2x, anchorpt2y) ) );
    
  } //end mk method

  // Draw Set Method //
  void drst() {
    for (int i=clst.size ()-1; i>=0; i--) {
      BezierCurve inst = clst.get(i);
      inst.drw();
      //CURSOR CURVE FOLLOWING
      //Are there any cursors yet?
      if (csrs.clst.size()!=0) {
        //for loop for cursor set
        for (int j=csrs.clst.size ()-1; j>=0; j--) {
          Csr instcsr = csrs.clst.get(j);   
          //Is the cursor touching a curve
          if (instcsr.x >= inst.x[0] && instcsr.x <= inst.x[3] && 
            instcsr.y1 <= inst.ypos(instcsr.x, 0) && instcsr.y2 >= inst.ypos(instcsr.x, 0) ) {
            inst.ypos(instcsr.x, 1); //draws ypos indicator on curve
            //trigger on when cursor hits curve
            if (!inst.on) {
              inst.on = true;
              //  println(inst.clrnum);
            }
            //Normalized curve height data
            float normcrvH = norm( inst.ypos(instcsr.x, 0), instcsr.y2, instcsr.y1);
            // println(normcrvH);
          }
          //trigger off when cursor leaves curve
          else {
            //trigger off when cursor leaves curve
            if (inst.on) {
              inst.on = false;
              // println(inst.clrnum);
              //  println(inst.clrname);
            }
          }
        }
      }
    }
  } //end msdrg method // Draw Set Method //
 
} //end class set class

