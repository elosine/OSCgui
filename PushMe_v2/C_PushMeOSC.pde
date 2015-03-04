
PushMeOSCset pmos = new PushMeOSCset();
class PushMeOSC {
  //constructor args
  String id;
  int l, t, w, h;
  int toggle;
  String[] msgonargs, msgoffargs;
  String dclr;
  int ipnum;
  String kee;

  //class variables
  int r, b, m, c;
  int msxdist, msydist;
  color bclr = color(153, 255, 0);
  color bstkclr = color(255, 128, 0);
  color msovrclr = color(255, 255, 0);
  color violetred = color(208, 32, 144);
  int togswitch = 0;
  int edit = 0;
  NetAddress nadr;

  PushMeOSC( String _id, int _l, int _t, int _w, int _h, 
  int _toggle, String _dclr, int aipnum, String akee, 
  String _msgonargs, String _msgoffargs ) {
    id = _id;
    l = _l;
    t = _t;
    w = _w;
    h = _h;
    toggle = _toggle;
    dclr = _dclr;
    ipnum = aipnum;
    kee = akee;

    msgonargs = split(_msgonargs, '$');
    msgoffargs = split(_msgoffargs, '$');

    nadr = ips.get(ipnum);

    r = l+w;
    b = t+h;
    m = l + int(w/2);
    c = t + int(h/2);
    bclr = clr.get(dclr);
  }

  void drw() {

    if (toggle==1) {
      if (togswitch==0)bclr = clr.get(dclr);
      if (togswitch==1)bclr = violetred;
    } 

    //DRAW BUTTON
    rectMode(CORNER);
    noStroke();
    fill(bclr);
    rect(l, t, w, h, 9);

    //DRAW LABEL
    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    fill(0);
    text(id, m, c, w-6, h-6);

    if (edit==1) {
      //Resize box
      rectMode(CORNER);
      noStroke();
      fill(100);
      rect(r-2, b-2, 15, 15);
    }
  }

  void msdrg() {
    if (edit==1) {
      //MOVE BUTTON
      if (mouseX>=l && mouseX<=r && mouseY>=t && mouseY<=b) {
        l = l + mouseX-pmouseX;
        t = t + mouseY-pmouseY;
        r = l+w;
        b = t+h;
        m = l + int(w/2);
        c = t + int(h/2);
        println(id+ " - " + "x:" + l + "  " + "y:" + t + "  " +"w:" + w + "  " + "h:" + h  );
      }
      //RESIZE BUTTON
      if (mouseX>=r && mouseX<=r+15 && mouseY>=b && mouseY<=b+15) {
        w = w + mouseX-pmouseX;
        h = h + mouseY-pmouseY;
        r = l+w;
        b = t+h;
        m = l + int(w/2);
        c = t + int(h/2);
        println(id+ " - " +"x:" + l + "  " + "y:" + t + "  " +"w:" + w + "  " + "h:" + h  );
      }
    }
  }

  void msprs() {
    if (edit==0) {
      if (mouseX>=l && mouseX<=r && mouseY>=t && mouseY<=b) {
        if (toggle==1) {
          //action when turning toggle on
          if (togswitch==0) {
            onmsg();
          }
          //action when turning toggle off
          if (togswitch==1) {
            offmsg();
          }
          togswitch = (togswitch+1)%2;
        }
        //
        else {
          //Normal Button pressed action
          bclr = violetred;
          //Button pressed action when not toggle
          onmsg();
        }
      }
    }
  }

  void msrel() {
    if (edit==0) {
      if (mouseX>=l && mouseX<=r && mouseY>=t && mouseY<=b) {
        if (toggle==0) {
          //Normal Button
          bclr = clr.get(dclr);
          offmsg();
        }
      }
    }
  }

  void keyprs() {
    if (key == 'e') {
      edit = (edit +1)%2;
    }
    if (edit==0) {
      if (!kee.equals("zz")) {
        if (kee.equals(str(key))) {
          if (toggle==1) {
            //action when turning toggle on
            if (togswitch==0) {
              onmsg();
            }
            //action when turning toggle off
            if (togswitch==1) {
              offmsg();
            }
            togswitch = (togswitch+1)%2;
          }
          //
          else {
            //Normal Button pressed action
            bclr = violetred;
            onmsg();
          }
        }
      }
    }
  }

  void keyrel() {
    if (edit==0) {
      if (!kee.equals("zz")) {
        if (kee.equals(str(key))) {
          if (toggle==0) {
            //Normal Button
            bclr = clr.get(dclr);
            offmsg();
          }
        }
      }
    }
  }

  void onmsg() {
    for (int i=0; i<msgonargs.length; i++) {
      String[] a1 = split(msgonargs[i], "#");
      String msgonadr = a1[0];
      String[]a2 = subset(a1, 1, a1.length-1);
      OscMessage msgtemp = new OscMessage(msgonadr);
      for (int j=0; j<a2.length; j++) {
        msgtemp.add(a2[j]);
      }
      osc.send(msgtemp, nadr);
    }
  }

  void offmsg() {
    for (int i=0; i<msgoffargs.length; i++) {
      String[] a1 = split(msgoffargs[i], "#");
      String msgoffadr = a1[0];
      String[]a2 = subset(a1, 1, a1.length-1);
      OscMessage msgtemp = new OscMessage(msgoffadr);
      for (int j=0; j<a2.length; j++) {
        msgtemp.add(a2[j]);
      }
      osc.send(msgtemp, nadr);
    }
  }

  ////
  ///
  //end of class
}

class PushMeOSCset {
  ArrayList<PushMeOSC> cset = new ArrayList<PushMeOSC>();

  void mk(String _id, int _l, int _t, int _w, int _h, 
  int _toggle, String _dclr, int aipnum, String akee, 
  String _msgonargs, String _msgoffargs) {
    cset.add( new PushMeOSC(_id, _l, _t, _w, _h, _toggle, _dclr, aipnum, akee, 
    _msgonargs, _msgoffargs) );
  }

  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      PushMeOSC inst = cset.get(i);
      inst.drw();
    }
  }

  void msprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      PushMeOSC inst = cset.get(i);
      inst.msprs();
    }
  }

  void msdrg() {
    for (int i=cset.size ()-1; i>=0; i--) {
      PushMeOSC inst = cset.get(i);
      inst.msdrg();
    }
  }

  void msrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      PushMeOSC inst = cset.get(i);
      inst.msrel();
    }
  }

  void keyprs() {
    for (int i=cset.size ()-1; i>=0; i--) {
      PushMeOSC inst = cset.get(i);
      inst.keyprs();
    }
  }

  void keyrel() {
    for (int i=cset.size ()-1; i>=0; i--) {
      PushMeOSC inst = cset.get(i);
      inst.keyrel();
    }
  }

  //end class set
  //
}

