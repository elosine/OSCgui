// DECLARE/INITIALIZE CLASS SET
SampleDisplaySet sampledisplayz = new SampleDisplaySet();
/********
 /// PUT IN SETUP ///
 osc.plug(sampledisplayz, "mk", "/mksamp");
 osc.plug(sampledisplayz, "rmv", "/rmvsamp");
 /// PUT IN DRAW ///
 sampledisplayz.drw();
 ********/
/////////////   CLASS     //////////////////////////////
class SampleDisplay {
  // CONSTRUCTOR VARIALBES //
  int ix, x, y;
  // CLASS VARIABLES //
  int jjj=0;
  float cx, l, r, t, b, w, h, m, c; 
  int edit = 0;
  String[]sampnames = new String[0];
  float[]samparray = new float[0];
  boolean sgate = true;
  boolean getsampgate = true;
  int currsamp = -1;
  String currsampname = "";
  float sampw = 0;
  int playtog = 0;

  // CONSTRUCTORS //
  /// Constructor 1 ///
  SampleDisplay(int aix, int ax, int ay) {
    ix = aix;
    x = ax;
    y = ay;

    l=x;
    t=y;
    w=1000;
    h=150;
    r=l+w;
    b=t+h;
    c = l+(w/2);
    m = t+(h/2);
    cx=x;
  } //end constructor 1
  //  DRAW METHOD //
  void drw() {
    //Sample Area
    rectMode(CORNER);
    noStroke();
    fill(clr.get("sunshine"));
    rect(l, t-36, w, 36);
    //Click blank sample area to load samples
    if ( mo(l, r, t-36, t) && mouseX>sampw ) {
      //Get Sample Names & make gui when sample area other than the part cover by buttons is pressed
      if (mousePressed) {
        if (getsampgate) {
          osc.send("/getsampnames", new Object[]{ix}, sc);
          sampw = l+6+(30*sampnames.length);
          getsampgate = false;
        } //end if (getsampgate)
      } // end  if (mousePressed) 
      else { //if mouse not pressed
        if (!getsampgate) getsampgate = true;
      } //end else if mouse not pressed
    } //end  if ( mo(l, r, t-36, t) )
    //Individual samples
    strokeWeight(3);
    for (int i=0; i<sampnames.length; i++) { //make a box for each sample
      fill( clr.getByIx( (i+24)%clr.clrs.size() ) ); //colors from clr class
      if (mo(l+6+(30*i), l+6+(30*i)+24, t-30, t-30+24)) { //if moused over
        stroke(255);
        text(sampnames[i], l+10, t-50);
        if (mousePressed) { //if pressed load the waveform & display sample name
          if (sgate) {
            osc.send("/getwf", new Object[]{ix, i, w}, sc);
            currsampname = sampnames[i];
            currsamp = i;
            sgate = false;
          } //end if (sgate)
        } // end  if (mousePressed)
        else { //if mouse is not pressed
          if (!sgate) sgate = true;
        } //  end else { //if mouse is not pressed
      } // end if (mo(l+6+(30*i), l+6+(30*i)+24, t-30, t-30+24)) { //if moused over
      else { //sample buttons not pressed
        noStroke();
      } //end  else { //sample buttons not pressed
      rect(l+6+(30*i), t-30, 24, 24);
    } // end for (int i=0; i<sampnames.length; i++) { //make a box for each sample
    //Sample Display Background
    noStroke();
    fill(clr.get("beet"));
    rect(l, t, w, h);
    //Waveform Display ///////////////
    stroke(255, 153, 51);
    // stroke(255,255,0);
    strokeWeight(1);
    for (int i=1; i<samparray.length; i++) line( i-1+l, m+( samparray[i-1]*(h/2) ), i+l, m+( samparray[i]*(h/2) ) );
    fill(255, 255, 0);
    text(currsampname, l+10, t+15);
    //Cursor
    if (edit==0) osc.send("/getix", new Object[]{ix}, sc);
    strokeWeight(3);
    stroke(153, 255, 0);
    line(cx, t, cx, b);
    //Edit Behavior//////
    if (edit==1) {
      //Draw outline to indicate in editing mode
      noFill();
      stroke(255, 255, 0);
      strokeWeight(5);
      rect(l-17, t-70, w+34, h+84, 3);
      //Make a resize square
      noStroke();
      fill(100);
      rect(r-7, b-7, 17, 17, 3);
      //Display GUI Index Num
      fill(255, 255, 0);
      text(ix, c, t-25);
      //Move button
      if (mousePressed) {
        if (mo(l+8, r-8, t+8, b-8)) {
          l = l-pmouseX+mouseX;
          t = t-pmouseY+mouseY;
          // l=x;
          // t=y;
          r=l+w;
          b=t+h;
          c=l+(w/2.0);
          m=t+(h/2.0);
          cx=l;
        } // end if (mo(l+8, r-8, t+8, b-8))
        //Resize Button
        if (mo(r-7, r+12, b-7, b+12)) {
          w=w-pmouseX+mouseX;
          h=h-pmouseY+mouseY;
          r=l+w;
          b=t+h;
          c=l+(w/2.0);
          m=t+(h/2.0);
        } // end if (mo(r-7, r+12, b-7, b+12))
      } // end if (mousePressed)
    } //end if (edit==1)
  } //End drw
  //  ix method //
  void ix(float val) {
    float ixtmp = map(val, 0.0, 1.0, l, r);
    cx = ixtmp;
  } //end ix method
  //  ix method //
  void play(int mode) {
    osc.send("/playsamp", new Object[]{ix, currsamp, mode}, sc);
  } //end play method
  //
}  //End class
////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////
class SampleDisplaySet {
  ArrayList<SampleDisplay> cset = new ArrayList<SampleDisplay>();
  // Make Instance Method //
  void mk(int ix, int x, int y) {
    cset.add( new SampleDisplay(ix, x, y) );
  } //end mk method
  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      SampleDisplay inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method
  // Draw Set Method //
  void drw() {
    for (SampleDisplay inst : cset) {
      inst.drw();
    }
  }//end drw method 
  // mouse pressed //////////////////////////////////////////
  void msprs() {
    for (SampleDisplay inst : cset) {
      if (mouseButton==RIGHT) {
        if ( mo(inst.l, inst.r, inst.t, inst.b) ) {
          inst.edit = (inst.edit+1)%2;
          break;
        } //end if ( mo(inst.l, inst.r, inst.t, inst.b) )
      } //end if (mouseButton==RIGHT)
      //Left Click
      else if (mouseButton==LEFT) { 
        if ( mo(inst.l, inst.r, inst.t, inst.b) ) {
          if (inst.edit==0) { //if not in editing mode
            inst.playtog = (inst.playtog+1)%2;
            inst.play(inst.playtog);
            break;
          } //end  if (inst.edit==0)
        } //end  if ( mo(inst.l, inst.r, inst.t, inst.b) )
      } //end else if (mouseButton==LEFT)
    } // end for (SampleDisplay inst : cset)
  }//end msprs method
  // ix Method //
  void ix(int ix, float val) {
    for (SampleDisplay inst : cset) {
      if (inst.ix == ix) inst.ix(val);
    }
  }//end drw method 
  //
} // END CLASS SET CLASS