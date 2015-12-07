// DECLARE/INITIALIZE CLASS SET
SampleDisplaySet sampledisplayz = new SampleDisplaySet();
/********
 /// PUT IN SETUP ///
 osc.plug(sampledisplayz, "mk", "/mksampledisplay");
 osc.plug(sampledisplayz, "rmv", "/rmvsampledisplay");
 osc.plug(sampledisplayz, "rmvall", "/rmvallsampledisplay");
 /// PUT IN DRAW ///
 sampledisplayz.drw();
 ********/
/////////////   CLASS     //////////////////////////////
class SampleDisplay {
  // CONSTRUCTOR VARIALBES //
  int ix;
  // CLASS VARIABLES //
  // CONSTRUCTORS //
  /// Constructor 1 ///
  SampleDisplay(int aix) {
    ix = aix;
  } //end constructor 1
  //  DRAW METHOD //
  void drw() {
  } //End drw
  //
}  //End class
////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////
class SampleDisplaySet {
  ArrayList<SampleDisplay> cset = new ArrayList<SampleDisplay>();
  // Make Instance Method //
  void mk(int ix) {
    cset.add( new SampleDisplay(ix) );
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
  //
} // END CLASS SET CLASS