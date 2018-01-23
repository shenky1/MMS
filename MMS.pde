PImage backgroundImage;
boolean buttonPressed = false;

float buttonRadius;
float buttonCenterX;
float buttonCenterY;

float playerOneX;
float playerOneY;
float playerTwoX;
float playerTwoY;

color firstPlayerColor;
color secondPlayerColor;

int playerOneDirection; //1 = left, 2 = up, 3 = right, 4 = down
int playerTwoDirection;
int speed;

color b1 = color(255);
color b2 = color(0);
color c1 = color(204, 102, 0);
color c2 = color(0, 102, 153);

ArrayList<Pair> firstPlayerPassedPoints;
ArrayList<Pair> secondPlayerPassedPoints;

class Pair {
  private float x;
  private float y;
  
  Pair(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
}

void setup() {
  fullScreen();
  frameRate(100);
  
  firstPlayerPassedPoints = new ArrayList<Pair>();
  secondPlayerPassedPoints = new ArrayList<Pair>();
  
  setGradient(0, 0, width/2, height, b1, b2, 2);
  setGradient(width/2, 0, width/2, height, b2, b1, 2); 
  // backgroundImage = loadImage("background.jpg");
  // background(backgroundImage);
  buttonRadius = width/20;
  buttonCenterX = width/2;
  buttonCenterY = height/2;
  fill(0, 255, 0);
  ellipseMode(RADIUS);
  ellipse(buttonCenterX, buttonCenterY, buttonRadius, buttonRadius);

  PFont startPageFont = createFont("CaviarDreams_Bold.ttf", 60);
  textFont(startPageFont);
  fill(0, 0, 255);
  float textWidth = textWidth("Achtung die Kurve");
  text("Achtung die Kurve", (width - textWidth)/2, height/4);
  
  fill(0, 0, 120);
  textSize(50);
  text("Igrač 1", width/7, height/2);
  text("Igrač 2", 3*width/4, height/2);

  textSize(30);
  text("Lijevo: <-", width/7, height/2 + 50);
  text("Desno: ->", width/7, height/2 + 100);  
  text("Lijevo: A", 3*width/4, height/2 + 50);
  text("Desno: D", 3*width/4, height/2 + 100);
  
  textWidth = textWidth("Pravila: Upravljati svojom zmijicom i izbjegavati tragove koje ostavljaju ostale zmijice.");
  text("Pravila: Upravljati svojom zmijicom i izbjegavati tragove koje ostavljaju ostale zmijice", (width - textWidth)/2, height - 100);
  textWidth = textWidth("Pobjednik je igrač koji duže preživi.");
  text("Pobjednik je igrač koji duže preživi.", (width - textWidth)/2, height - 50);
  
  fill(127, 0, 0);
  textWidth = textWidth("START");
  text("START", buttonCenterX - textWidth/2, buttonCenterY + 15);
  
  firstPlayerColor = color(255, 0, 0);
  secondPlayerColor = color(0, 0, 255);
}

void draw() {
  if(buttonPressed) {
    switch(playerOneDirection) {
      case 1: {
        playerOneX = playerOneX - 4;
        break;
      }
      case 2: {
        playerOneY = playerOneY - 4;
        break;
      }
      case 3: {
        playerOneX = playerOneX + 4;
        break;
      }
      case 4: {
        playerOneY = playerOneY + 4; 
        break;
      }
      default: {};      
  }
  firstPlayerPassedPoints.add(new Pair(playerOneX, playerOneY));

    switch(playerTwoDirection) {
      case 1: {
          playerTwoX = playerTwoX - 5;
          break;
      }
      case 2: {
          playerTwoY = playerTwoY - 5;
          break;
      }
      case 3: {
          playerTwoX = playerTwoX + 5;
          break;
      }
      case 4: {
          playerTwoY = playerTwoY + 5;
          break;
      }
      default: {};
    } 
    
    secondPlayerPassedPoints.add(new Pair(playerTwoX, playerTwoY));
    
    drawAllPoints();
  }
}

void drawAllPoints() {
  fill(firstPlayerColor);
  for(Pair p : firstPlayerPassedPoints) {
      rect(p.getX(), p.getY(), 5, 5);
  }
  fill(secondPlayerColor); 
  for(Pair p : secondPlayerPassedPoints) {
    rect(p.getX(), p.getY(), 5, 5);
  }
}

void mousePressed() {
  if(overButton(buttonCenterX, buttonCenterY, buttonRadius) && !buttonPressed) {
        buttonPressed = true;
        playerOneX = random(width);
        playerOneY = random(height);
        firstPlayerPassedPoints.add(new Pair(playerOneX, playerOneY));
        playerTwoX = random(width);
        playerTwoY = random(height);
        secondPlayerPassedPoints.add(new Pair(playerTwoX, playerTwoY));
        playerOneDirection = (int) random(1, 4.99);
        playerTwoDirection = (int) random(1, 4.99);
        background(255);
  }
}

boolean overButton(float buttonCenterX, float buttonCenterY, float buttonRadius)  {
 // if (sqrt(pow(mouseX - buttonCenterX, 2.0) + pow(mouseY - buttonCenterY, 2.0)) <= buttonRadius) {
   if(dist(mouseX, mouseY, buttonCenterX, buttonCenterY) <= buttonRadius) {
    return true;
  } else {
    return false;
  }
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == 1) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == 2) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

void keyPressed() {
  if(key == 'D' || key == 'd') {
    if(playerTwoDirection == 4) 
      playerTwoDirection = 1;
    else playerTwoDirection++;
  }
  if(key == 'A' || key == 'a') {
    if(playerTwoDirection == 1) {
      playerTwoDirection = 4;
    } else playerTwoDirection--;
  }
  if(key == CODED && keyCode == RIGHT) {
    if(playerOneDirection == 4) 
      playerOneDirection = 1;
    else playerOneDirection++;
  }
  if(key == CODED && keyCode == LEFT) {
     if(playerOneDirection == 1) {
      playerOneDirection = 4;
     } else playerOneDirection--;
  }
}