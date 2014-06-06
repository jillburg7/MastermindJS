class RectButton {
  int x, y;
  int sizer;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean pressed = false;  
  String text = ""; 
  int tsize, tx, ty;
  
  RectButton(int ix, int iy, int isize, color icolor, color ihighlight, int textsize, int textx, int texty)   {
    x = ix;
    y = iy;
    sizer = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
    tsize = textsize;
    tx = textx;
    ty = texty;
  }

  boolean over() {
    pressed = overRect(x, y, sizer, 36);
    return pressed;
  }

  boolean overRect(int x, int y, int someWidth, int someHeight) {
    if (mouseX >= x && mouseX <= x+someWidth && mouseY >= y && mouseY <= y+someHeight) {
      return true;
    }
    else {
      return false;
    }
  }

  void display() {
    stroke(255);
    fill(currentcolor);
    rect(x, y, sizer, 36);
    fill(0);
  }
  
} //end RectButton class

