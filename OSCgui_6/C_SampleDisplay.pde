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
  float r1=0.0;
  float r2=0.0;
  boolean ranger = false;

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
          sampw = l+6+(30*sampnames.length)+100;
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
      if (mo(l+6+(30*i)+100, l+6+(30*i)+24+100, t-30, t-30+24)) { //if moused over
        stroke(255);
        textAlign(LEFT, CENTER);
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
      rect(l+6+(30*i)+100, t-30, 24, 24);
    } // end for (int i=0; i<sampnames.length; i++) { //make a box for each sample
    //playbutton
    noStroke();
    fill(0, 255, 0);
    rect(l+4, t-31, 50, 28, 5);
    //loop off button
    noStroke();
    fill(0, 0, 255);
    rect(l+60, t-31, 30, 28, 5);
    //Sample Display Background
    noStroke();
    fill(clr.get("beet"));
    rect(l, t, w, h);
    //Waveform Display ///////////////
    stroke(255, 153, 51);
    // stroke(255,255,0);
    strokeWeight(1);
    for (int i=1; i<samparray.length; i++) line( i-1+l, m-( samparray[i-1]*(h/2) ), i+l, m-( samparray[i]*(h/2) ) );
    fill(255, 255, 0);
    textAlign(LEFT, CENTER);
    text(currsampname, l+10, t+15);
    //Cursor
    if (edit==0) osc.send("/getix", new Object[]{ix}, sc);
    strokeWeight(3);
    stroke(153, 255, 0);
    line(cx, t, cx, b);
    // Range Selection ///////
    if (ranger) {
      noStroke();
      fill(0, 0, 255, 100);
      if (r1<=r2) rect( r1, t, r2-r1, h );
      else rect( r2, t, r1-r2, h );
    }
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
      textAlign(CENTER, CENTER );
      text(ix, c, t-87);
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
        //Play Button to play and pause
        if ( mo(inst.l, inst.l+54, inst.t-36, inst.t) ) {
          if (inst.edit==0) { //if not in editing mode
            inst.playtog = (inst.playtog+1)%2;
            inst.play(inst.playtog);
            break;
          } //end  if (inst.edit==0)
        } //end  if ( mo(inst.l, inst.r, inst.t, inst.b) ) 
        //Remove Loop Button
        if ( mo(inst.l+60, inst.l+90, inst.t-36, inst.t) ) {
          if (inst.edit==0) { //if not in editing mode
            inst.ranger = false;
            osc.send("/setix", new Object[]{inst.ix, inst.currsamp, 0.0, 1.0}, sc );
            break;
          } //end  if (inst.edit==0)
        } //end  if ( mo(inst.l, inst.r, inst.t, inst.b) )
        //grab range
        if (mo(inst.l, inst.r, inst.t, inst.b)) { //if moused over main sample area
          if (inst.edit==0) { //if not in editing mode
            inst.ranger = true;
            inst.r1 = mouseX;
            inst.r2 = mouseX;
          }
        }//end if (mo(inst.l,inst.r,inst.t,inst.b))
      } //end else if (mouseButton==LEFT)
    } // end for (SampleDisplay inst : cset)
  }//end msprs method
  // mouse dragged //////////////////////////////////////////
  void msdrg() {
    for (SampleDisplay inst : cset) {
      //Right Drag
      if (mouseButton==RIGHT) {
        if ( mo(inst.l, inst.r, inst.t, inst.b) ) {
          break;
        } //end if ( mo(inst.l, inst.r, inst.t, inst.b) )
      } //end if (mouseButton==RIGHT)
      //Left Drag
      else if (mouseButton==LEFT) { 
        //grab range
        if (mo(inst.l, inst.r, inst.t, inst.b)) { //if moused over main sample area
          if (inst.edit==0) { //if not in editing mode
            inst.r2 = mouseX;
            break;
          }
        }//end if (mo(inst.l,inst.r,inst.t,inst.b))
      } //end else if (mouseButton==LEFT)
    } // end for (SampleDisplay inst : cset)
  }//end drg method
  // mouse released //////////////////////////////////////////
  void msrel() {
    for (SampleDisplay inst : cset) {
      //Right Rel
      if (mouseButton==RIGHT) {
        if ( mo(inst.l, inst.r, inst.t, inst.b) ) {
          break;
        } //end if ( mo(inst.l, inst.r, inst.t, inst.b) )
      } //end if (mouseButton==RIGHT)
      //Left Rel
      else if (mouseButton==LEFT) { 
        //grab range
        if (mo(inst.l, inst.r, inst.t, inst.b)) { //if moused over main sample area
          float start = norm(inst.r1, inst.l, inst.r);
          float end = norm(inst.r2, inst.l, inst.r);
          osc.send("/setix", new Object[]{inst.ix, inst.currsamp, min(start, end), max(start, end)}, sc );
          break;
        }//end if (mo(inst.l,inst.r,inst.t,inst.b))
      } //end else if (mouseButton==LEFT)
    } // end for (SampleDisplay inst : cset)
  }//end drg method
  // ix Method //
  void ix(int ix, float val) {
    for (SampleDisplay inst : cset) {
      if (inst.ix == ix) inst.ix(val);
    }
  }//end ix method 
  //
} // END CLASS SET CLASS