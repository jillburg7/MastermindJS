class Button
{
  int x, y;
  int sizer;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;  
  String text = ""; 
  int tsize, tx, ty;

  void update() 
  {
    if(over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }
  }

  boolean pressed() 
  {
    if(over) {
      locked = true;
      return true;
    } 
    else {
      locked = false;
      return false;
    }    
  }

  boolean over() 
  { 
    return true; 
  }

  boolean overCircle(int x, int y, int diameter) 
  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } 
    else {
      return false;
    }
  }

}

class CircleButton extends Button
{ 
  CircleButton(int ix, int iy, int isize, color icolor) //, color ihighlight) 
  {
    x = ix;
    y = iy;
    sizer = isize;
    basecolor = icolor;
//    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overCircle(x, y, sizer) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    ellipse(x, y, sizer, sizer);
  }
}

class RectButton extends Button
{
  RectButton(int ix, int iy, int isize, color icolor, color ihighlight, int textsize, int textx, int texty) 
  {
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

  boolean over() 
  {
    return overRect(x, y, sizer, 36);
//    if( overRect(x, y, sizer, 36) ) {
//      over = true;
//      return true;
//    } 
//    else {
//      over = false;
//      return false;
//    }
  }

  boolean overRect(int x, int y, int someWidth, int someHeight) 
  {
    if (mouseX >= x && mouseX <= x+someWidth && 
      mouseY >= y && mouseY <= y+someHeight) {
      return true;
    } 
    else {
      return false;
    }
  }

  void addText(String s) {
    text = s;
  }
  
  void drawText() {
    textSize(18);
    fill(#000000);
    text(text, 380, 840, 350*xScale, 75*yScale);
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    rect(x, y, sizer, 36);
    fill(0);
    drawText();
  }
}

