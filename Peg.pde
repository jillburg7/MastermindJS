class Peg {
  int x, y, sizer;
  color paint;
  color EMPTY = color(209, 209, 209); 
  
  Peg() {
    this(0, 0, 100, EMPTY);  //#000000);
  }
  
  Peg(int x, int y, int sizer, color c) {
    this.x = x;
    this.y = y;
    this.sizer = sizer;
    this.paint = c;
  }
  
  void drawPeg() {
    fill(red(paint), green(paint), blue(paint));
    ellipse(x, y, sizer, sizer);
  }
  
  int getX() {
    return x;
  }
  
  void setX(int x) {
    this.x = x;
  }
  
  int getY() {
    return y;
  }
  
  void setY(int y) {
    this.y = y;
  }
  
  color getColor() {
    return paint;
  }
  
  void setColor(color someColor) {
    this.paint = someColor;
  }
} //end Peg class

class RandomPeg extends Peg {
  int value;
  
  RandomPeg() {
    super();
  }
  
  RandomPeg(int x, int y, int sizer, color c) {
    super(x, y, sizer, c);
//    this.x = x;
//    this.y = y;
    value = (int) random(0, 7);
  }
  
  int getValue() {
    return value;
  }
  
  void drawPeg() {
    super.drawPeg();
  }
  
  int getX() {
    super.getX();
    return x;
  }
  
  void setX(int x) {
    super.setX(x);
  }
  
  int getY() {
    super.getY();
    return y;
  }
  
  void setY(int y) {
    super.setY(y);
  }
  
  color getColor() {
    super.getColor();
    return paint;
  }
  
  void setColor(color someColor) {
    super.setColor(someColor);
  }
  
} //end RandomPeg class

class FeedbackPeg extends Peg {
  
  FeedbackPeg() {
    super();
  }
  
  FeedbackPeg(int x, int y, int sizer, color c) {
    super(x, y, 15*xScale, EMPTY);
    //this.x = x;
    //this.y = y;
    //paint = EMPTY;  //#D1D1D1;  //PrettyColor.EMPTY;
    //sizer = 15*xScale;
  }
  
  void drawPeg() {
    super.drawPeg();
  }
  
  int getX() {
    super.getX();
    return x;
  }
  
  void setX(int x) {
    super.setX(x);
  }
  
  int getY() {
    super.getY();
    return y;
  }
  
  void setY(int y) {
    super.setY(y);
  }
  
  color getColor() {
    super.getColor();
    return paint;
  }
  
  void setColor(color someColor) {
    super.setColor(someColor);
  }
  
} //end FeedbackPeg class
