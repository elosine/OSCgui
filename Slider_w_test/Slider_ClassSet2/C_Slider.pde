class Slider {
  //Constructor Variables
  int ix;
  String lbl;
  float x, y, w, h, slo, shi;
  String clrstr;
  //Class Variables
  float l, t, m;
  float r, b;
  float sl, st, sw;
  float sh = 12;
  float sb, sr, sm;
  float sv = 0.0;

  //Constructor 1
  Slider(int aix, String albl, float ax, float ay, float aw, float ah, 
    float aslo, float ashi) {
    ix = aix;
    lbl = albl;
    x = ax;
    y = ay;
    w = aw;
    h = ah;
    slo = aslo;
    shi = ashi;
    l = x;
    t = y;
    r = l+w;
    b = t+h;
    m = l+(w/2);
    sl=l;
    st = t+50;
    sw = w;
    sb=st+sh;
    sr = sl+sw;
    sm = st+(sh/2);
  } //end constructor


  //Constructor 2
  Slider(int aix, String albl, float ax, float ay, 
    float aw, float ah, float aslo, float ashi, String aclrstr) {
    ix = aix;
    lbl = albl;
    x = ax;
    y = ay;
    w = aw;
    h = ah;
    slo = aslo;
    shi = ashi;
    l = x;
    t = y;
    r = l+w;
    b = t+h;
    m = l+(w/2);
    sl=l;
    st = t+50;
    sw = w;
    sb=st+sh;
    sr = sl+sw;
    sm = st+(sh/2);
    clrstr = aclrstr;
  } //end constructor

  void drw() {
    //slider background
    rectMode(CORNER);
    fill(153, 255, 0);
    // fill( unhex(clrstr) );
    rect(l, t, w, h, 7);
    //slider y-axis
    stroke(0);
    strokeWeight(4);
    line(m, t, m, b);
    //slider
    fill(255);
    strokeWeight(2);
    stroke(0);
    rect(sl, st, sw, sh);
    //slider middle
    stroke(0, 0, 255);
    line(l, sm, r, sm);
    //slider value
    noStroke();
    fill(0);
    rect(l, b+2, w, 18, 3);
    fill(153, 255, 0);
    textAlign(LEFT, CENTER);
    text(sv, l, b+10);
    //label
    text(lbl, l, t-20);
  }//end drw method

  void mvsl(float val) {
    sv = val;
    st = constrain( map(val, slo, shi, b-sh, t ), t, b-sh );
    sb = st+sh;
    sm = st+(sh/2);
    osc.send("/slider", new Object[]{ix, sv}, sc);
  }

  void mvslnorm(float val) {
    sv = map(val, 0.0, 1.0, slo, shi);
    st = constrain( map(sv, slo, shi, b-sh, t ), t, b-sh );
    sb = st+sh;
    sm = st+(sh/2);
    osc.send("/slider", new Object[]{ix, sv}, sc);
  }

  void msdrg() {
    if (mouseX>=sl&&mouseX<=sr&&mouseY>=st&&mouseY<=sb) {
      st = constrain(st + (mouseY-pmouseY), t, b-sh);
      sb = st+sh;
      sm = st+(sh/2);
      sv = map(sm, t+(sh/2), b-(sh/2), shi, slo);
      osc.send("/slider", new Object[]{ix, sv}, sc);
    }
  }//end msdrg method
} //end class

class SliderSet {
  ArrayList<Slider> cset = new ArrayList<Slider>();

  void mk(int aix, String albl, float ax, float ay, float aw, float ah, 
    float aslo, float ashi) {
    cset.add( new Slider(aix, albl, ax, ay, aw, ah, aslo, ashi) );
    for (Slider inst : cset) inst.mvslnorm(0.5); //set initial value
  }

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Slider inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  void drw() {
    for (Slider inst : cset) inst.drw();
  }//end drw method

  void msdrg() {
    for (Slider inst : cset) inst.msdrg();
  }//end drw method
}