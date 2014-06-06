
// BUTTONS
RectButton checkButt, newButt, revealButt, tutorialButt;

color clicked;
boolean ready = false, gameStarted = false, check = false, selected = false, set = false;

// game modes
int CURRENT_PROGRAM_MODE = -1, GUESS_MODE = 1, FEEDBACK_MODE = 2, CODE_MODE = 3;

// game variables
int numGuess = 0, numWhite = 0, numBlack = 0;
int position = 0;

// peg maps
HashMap<Integer, RandomPeg> c = new HashMap<Integer, RandomPeg>(4);
HashMap<Integer, Peg> g = new HashMap<Integer, Peg>(4);
HashMap<Integer, Peg> colorpegs = new HashMap<Integer, Peg>(8);
ArrayList colorMap = new ArrayList();
FeedbackPeg[] fb = new FeedbackPeg[4];
ArrayList pQ; // =  new ArrayList<Integer>(4);

// Define and create rectangle button
color buttoncolor = color(204);
color highlight = color(153);

//drawing locations
int off = 25;
int xLoc, yLoc;
int sizer;
int xoff, yoff;
int xScale, yScale;

//colors
color RED, ORANGE, YELLOW, GREEN, TEAL, BLUE, PURPLE, PINK, EMPTY, WHITE, BLACK;

void setup ()
{
  size( 570, 900 );
  set = false;
  //checkButt = new RectButton(20, 20, 160, buttoncolor, highlight, 20, 25, 25);
//  textSize(20);
//  text("Check", 100, 100);
  
  CURRENT_PROGRAM_MODE = -1;
  xScale = width/570;
  yScale = height/900;
  xoff = (off + 25)*xScale;
  yoff = 100*yScale;

  checkButt = new RectButton((xoff-5*xScale)+(307*xScale), (824*yScale), 80*xScale, buttoncolor, highlight, 46, 15, 19);
//  checkButt.addText("Check");
  newButt = new RectButton(480*xScale, (148*yScale), 85*xScale, buttoncolor, highlight, 32, 6, 25);
  //newButt.addText("New Game");
  revealButt = new RectButton(480*xScale, ((int)192.5*yScale), 85*xScale, buttoncolor, highlight, 30, 2, 27);
  //revealButt.addText("Reveal Code");
  tutorialButt = new RectButton(480*xScale, (237*yScale), 85*xScale, buttoncolor, highlight, 30, 3, 27);
  //tutorialButt.addText("How-to Play");
  
  setColors();
  noStroke();
  setColorMap();
}

  //textSize(20);
  //text("Check", 70, 70);
void draw() 
{
  update(mouseX, mouseY);
  newButt.display();
  checkButt.display();
  revealButt.display();
  tutorialButt.display();
  if (CURRENT_PROGRAM_MODE == GUESS_MODE) 
  {
    if(clicked != null && g.size() < 4)
    {
      position = pQ.remove(0);
      console.log(position);
      sizer = 50;
      xLoc = ((position*70)+45)*xScale + (xoff-5*xScale);
      yLoc = 842*yScale;
      Peg p = new Peg(xLoc, yLoc, sizer, clicked);
//      console.log(p);
      g.put(position, p);  //add to guess peg map
      stroke(0);
      p.drawPeg();  //draw peg
      clicked = null;
    }
  }
  else if (CURRENT_PROGRAM_MODE == FEEDBACK_MODE) 
  {
   // console.log("numGuess = " + numGuess);
    yLoc = (yoff-(10*yScale))+((725-(numGuess*65))*yScale);
    commitGuess();
    xLoc = xoff+(314*xScale);
    
    fb[0] = new FeedbackPeg(xLoc+(14*xScale), yLoc+(14*yScale), 0, EMPTY);  
    fb[1] = new FeedbackPeg(xLoc+(40*xScale), yLoc+(14*yScale), 0, EMPTY);
    fb[2] = new FeedbackPeg(xLoc+(14*xScale), yLoc+(40*yScale), 0, EMPTY);
    fb[3] = new FeedbackPeg(xLoc+(40*xScale), yLoc+(40*yScale), 0, EMPTY);
    
    for (int i = 0; i <numBlack; i++) {
      fb[i].setColor(BLACK);
      fb[i].drawPeg();
    }
    for (int i = numBlack; i < numBlack+numWhite; i++) {
      fb[i].setColor(WHITE);
      fb[i].drawPeg();
    }
    //empties
    noStroke();
    for (int i = numBlack+numWhite; i < fb.length; i++) {
      fb[i].setColor(EMPTY);
      fb[i].drawPeg();
    }
    //CASE 1: REVEAL CODE IN CODE PANEL IF...
    if (numBlack == 4 || numGuess == 10)
    {
      stroke(0);
      fill(255);
      rect(xoff-5*xScale, yoff, 300*xScale, 54*yScale);  // code panel
      for (int i = 0; i < 4; i++) {
        c.get(i).setColor(getColorValue(c.get(i).getValue()));
        c.get(i).drawPeg();  // draw code pegs
      }
    }
    //CASE 2: DIDN'T BREAK CODE && HAVEN'T REACHED MAX # OF GUESSES
    else {
      //prepare for next guess 
      drawNewGuess();  //--> draw empty pegs holes, initialize PositionQueue
    }
  }
  else if (CURRENT_PROGRAM_MODE == CODE_MODE) 
  {
    stroke(0);
    fill(255);
    rect(xoff-5*xScale, yoff, 300*xScale, 54*yScale);  // code panel
    for (int i = 0; i < 4; i++) {
      c.get(i).setColor(getColorValue(c.get(i).getValue()));
      c.get(i).drawPeg();  // draw code pegs
    }
  }
  else {
    if (!set) {
      initializeBoard();
      initializeControlPanel();
      initializeColors();  // color options panel
      set = true;
    }
  }
}

void update(int x, int y)
{
  if(mousePressed) {
    if(newButt.over() && ready == false) 
    {
      gameStarted = true;
      numGuess = 0;  //(re)initialize game variables
      numBlack = 0;
      numWhite = 0;
      
      clearBoard(); //initalize game board
      g.clear();    //clear guess structure
      
      generateCodeMap();  //set new random code
      setGuessMode();
      redraw();
    }
    else if(checkButt.over()) 
    {
      if (gameStarted) 
      {
        console.log("numGuess = " + numGuess);
        if (numGuess == 9 && g.size() == 4) 
        {
          numGuess = 10;
          getNumBlack();
          getNumWhite();
          setFeedbackMode();
          redraw();
          if (numBlack == 4) {
            String s = "YOU WON! ...on your last chance!";
            console.log(s);
            gameStarted = false;
          }
          else {
            String s = "Gameover!";
            console.log(s);
            gameStarted = false;
          }
        }
        else if(numGuess < 10 && g.size() == 4) 
        {
          numGuess++;  //increment number of guesses
          getNumBlack();
          getNumWhite();
          setFeedbackMode();  //display feedback
          //redraw();
          if (numBlack == 4)  {
            String s = "You broke the code in " + numGuess + " guesses!";
            console.log(s);
            gameStarted = false;
          }
        }//end else if
      }//end if (gameStarted)
    }//end checkButt.pressed()
    else if (revealButt.over()) 
    {
      if (gameStarted) {
        setCodeMode();
        redraw();
        gameStarted = false;
      }
    }//end revealButt.pressed()
    else if (tutorialButt.over()) 
    {
      //show tutorial !!! 
      //make boolean to let game known what state its in and only update screen if backButt is pressed?
//      getTutorial();
//      set = true;
//      redraw();
    }
  }//end if (mousePressed)
}//end update()

void mousePressed() 
{  
  clicked = null;
  if (CURRENT_PROGRAM_MODE == GUESS_MODE && (mouseX > 470*xScale) && (mouseY > 265*yScale))
  {
    float closest = 48;
    Iterator it = colorpegs.entrySet().iterator();  // Get an iterator
    while (it.hasNext()) {
      Map.Entry me = (Map.Entry)it.next();
      Peg p = (Peg)me.getValue();
      float d = dist(mouseX, mouseY, p.getX(), p.getY());
      if (d < closest) {
        closest = d;
        clicked = p.getColor();
      }
    }
  }
  else if (CURRENT_PROGRAM_MODE == GUESS_MODE && (mouseX < (xoff+300*xScale)) && (mouseY > (11*65*yScale)+yoff))
  {
    //REMOVE A PEG
    float closest = 48;
    Iterator<Integer> keySetIterator = g.keySet().iterator();
    
    Integer temp = null;

    while (keySetIterator.hasNext()) 
    {
      Integer keys = keySetIterator.next();
      Peg p = g.get(keys);
      float d = dist(mouseX, mouseY, p.getX(), p.getY());
      if (d < closest) {
        temp = keys;
        closest = d;
      }
    }
    if (temp != null && (CURRENT_PROGRAM_MODE == GUESS_MODE))
    {
      //Removes the mapping for this key from guess peg map 
      setEmpty(g.remove(temp));
      console.log(temp);
      pQ.add(temp);
    }
  }
  redraw();
}

void setEmpty(Peg toRemove) {
  xLoc = toRemove.getX();
  yLoc = toRemove.getY();
  stroke(209);
  strokeWeight(2);
  color selected = EMPTY;  //empty peg color
  fill(red(selected), green(selected), blue(selected));
  ellipse(xLoc, yLoc, sizer, sizer);
  strokeWeight(1);
}

// Game control methods
 
void setGuessMode() {
  CURRENT_PROGRAM_MODE = GUESS_MODE;
  initializeGuess();
  initPositionQueue();
}

void setFeedbackMode() {
  CURRENT_PROGRAM_MODE = FEEDBACK_MODE;
  displayNumGuess("" + numGuess);
}

void drawNewGuess() {
  CURRENT_PROGRAM_MODE = GUESS_MODE;
  initPositionQueue();
  initializeGuess();
}
  
void setCodeMode() {
  CURRENT_PROGRAM_MODE = CODE_MODE;
}

void clearBoard() {
  initializeBoard();
  initializeControlPanel();
  displayNumGuess("0");
}

//Updates guess peg y-coords & draws them in their perminant location
void commitGuess() {
  if (g.size() > 0){
    for (int i = 0; i < 4; i++) 
    {
      g.get(i).setY(yLoc+(27*yScale));  //set respective y location
      g.get(i).drawPeg();    //update peg component
      g.remove(i);  //remove from guess peg map
    }
  }
  //clear guess panel
  stroke(0);  
  fill(255);
  rect(xoff-5*xScale, (11*65*yScale)+yoff, 300*xScale, 54*yScale);
}

void initPositionQueue() {
  pQ = new ArrayList();
  console.log("pQ.size() => " + pQ.size());
  for(int i = 0; i < 4; i++) {
    pQ.add(i);
  }
  console.log("pQ.size() => " + pQ.size());
}

void initializeGuess() 
{
  console.log("initializeGuess");
  int x = (xoff-5*xScale);
  int y = (yoff-(10*yScale));
  stroke(0);
  fill(255);
  rect(xoff-5*xScale, (11*65*yScale)+yoff, 300*xScale, 54*yScale);  // clears guess panel
  stroke(209);
 // color selected = EMPTY;  //empty peg color
  //fill(EMPTY);
  //fill(red(selected), green(selected), blue(selected));
  for (int position = 0; position < 4; position++) 
  {  
    xLoc = ((position*70)+45)*xScale;
    yLoc = 752*yScale;
    ellipse(x+xLoc, y+yLoc, sizer, sizer); 
  }
}

void displayNumGuess(String s) {
  stroke(0);
  fill(255);
  rect(480*xScale, 107*yScale, 85*xScale, 68);  //refresh score panel
  textSize(16);
  fill(0);
  text(s, 517*xScale, 131*yScale);//guess tracker -- for user
}

void initializeControlPanel() 
{
  stroke(0);
  fill(247);
  rect(470*xScale, 84*yScale, 105*xScale, 198*yScale);  //control panel border
  fill(255);
  rect(480*xScale, 107*yScale, 85*xScale, 68);  //score panel
  textSize(16);
  fill(0);
  text("Guesses:", 485*xScale, 89*yScale, 145*xScale, 84*yScale);//header text
}

void initializeColors() {
  stroke(0);
  fill(247);
  rect(470*xScale, (299*yScale), 105*xScale, (487*yScale)+yoff); //color peg panel (450, 265, 95, 550)
  fill(255);
  rect(486*xScale, (315*yScale), 73*xScale, (455*yScale)+yoff);  //inner panel (460, 275, 75, 530)
  color[] clr = getColors(); 
  int sizer = 55*yScale;
  Peg p;
  for (int i = 0; i < 8; i++) {
    p = new Peg((487*xScale)+(36*xScale), ((325+(i*70))*yScale)+(22*yScale), sizer, clr[i]);
    colorpegs.put(i, p);
    stroke(0);
    p.drawPeg();  //draw peg
  }
}

void initializeBoard()
{
  textSize(60);
  fill(0, 102, 153, 204);
  text("mastermind", off*xScale, 25*yScale, 350*xScale, 75*yScale); //GAME NAME
  stroke(0);
  fill(247);
  rect(off*xScale, 84*yScale, 415*xScale, 801*yScale);  //board panel 405, 790
  fill(175);
  rect(xoff-5*xScale, yoff, 300*xScale, 54*yScale);  // code panel
  stroke(0);
  fill(255);
  //10 previous guess panels
  for(int i = 0; i < 10; i++)       // 10 guess attempt panels
  {
    rect(xoff-5*xScale, yoff+(i*65*yScale)+(65*yScale), 300*xScale, 54*yScale);    //guess peg panels
    rect(xoff+314*xScale, yoff+(i*65*yScale)+(65*yScale), 54*xScale, 54*yScale);  //feedback peg panels
  }
  rect(xoff-5*xScale, (11*65*yScale)+yoff, 300*xScale, 54*yScale);  //bottom guess panel
}

color getColorValue(int val) 
{
  //color[] clrs = getColors();
//  console.log(clrs[val]);
  return color(unhex(colorMap.get(val)));
}

void setColorMap() {
 color[] clr = getColors();
  for (int i = 0; i < 8; i++) {
    colorMap.add(hex(clr[i]));
//    console.log(hex(clr[i]));
  }
}

void setColors() {
  RED = #FF3C32;// color(255, 60, 50); // 0 ---starting vals
  ORANGE = #FF9D28; //color(255, 157, 40);  // 1
  YELLOW = #FFD923; //color(255, 235, 0);  // 2
  GREEN = #A8FF0C; //D1FF2B; //color(168, 255, 12);  // 3
  TEAL = #5BFFC6; //color(91, 255, 198);  // 4
  BLUE = #6DD6FF; //color(109, 214, 255);  // 5
  PURPLE = #AA66CC; //color(196, 119, 255);  // 6
  PINK = #FF9BF0; //color(255, 155, 240);  // 7 ---ending vals
  EMPTY = #D1D1D1; //color(209, 209, 209);  //(229, 229, 229),  // 8 -- empty
  WHITE = #FFFFFF; //color(255, 255, 255);  // 9 --feedback
  BLACK = #000000; //color(0, 0, 0);    // 10 --feedback
  
}

color[] getColors() {
  color[] p = {#FF3C32, #FF9D28, #FFD923, #A8FF0C, #5BFFC6, #6DD6FF, #AA66CC, #FF9BF0};
  return p; 
}

//computes the number of correct colors in the correct positions
void getNumBlack()
{
  int b = 0;
  // Iterate through the return 
  Iterator<Integer> keySetIterator = c.keySet().iterator();

  while (keySetIterator.hasNext()) 
  {
    Integer keys = keySetIterator.next();
    if (hex(getColorValue(c.get(keys).getValue())) == hex(g.get(keys).getColor()))
      b++;  //increment number of black pegs
  }
  numBlack = b;
}

//computes the number of colors that are in the code but not in the correct positions
void getNumWhite() 
{
  int w = 0, cNum = 0, gNum = 0;

  // Iterate through the return 
  Iterator keySetIteratorC = c.keySet().iterator();
  Iterator keySetIteratorG = g.keySet().iterator();

  //for each color in the color peg options
  for (String hexColor : colorMap)  
  {
    //1. find the # of times a color appears in the guess & in the code
    while(keySetIteratorC.hasNext() && keySetIteratorG.hasNext()) 
    {
      Integer keyCodes = keySetIteratorC.next();
      if (hexColor == hex(getColorValue(c.get(keyCodes).getValue())))  
        cNum++;  //increment number of times the color is in the code

      Integer keyGuess = keySetIteratorG.next();
      if (hexColor == hex(g.get(keyGuess).getColor()))  
        gNum++;  //increment number of times the color is in the guess
    }

    //2. sum the minimum number of times a color appears in both the 
    // code, c and the guess, g
    w += Math.min(cNum, gNum);

    //reset color counters
    cNum = 0;
    gNum = 0;

    //reset iterator back to the beginning to check next PrettyColor entry
    keySetIteratorC = c.keySet().iterator();
    keySetIteratorG = g.keySet().iterator();
  }

  //3. # of white pegs can be computed by subtracting the number of black
  //   pegs from the sum of the minumum number of color appearances 
  numWhite = w - numBlack;
}

void generateCodeMap() {
  for (int i = 0; i < 4; i++) {
    c.put(i, new RandomPeg( ((i*70)+45)*xScale + (xoff-5*xScale), (yoff-(10*yScale)) + ( ( 752-(11*65) )*yScale ), 50, EMPTY));
  }
  ready = true;
}

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


