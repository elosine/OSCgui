boolean mouseOver(float l, float t, float r, float b){
  boolean mouseIsOver = false;
 if(mouseX>=l && mouseY>=t && mouseX<=r && mouseY<=b) {mouseIsOver = true;}
 return mouseIsOver;
}
