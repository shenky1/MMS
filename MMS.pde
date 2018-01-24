PImage backgroundImage;
boolean buttonPressed = false;
boolean started = false;

float buttonRadius;
float buttonCenterX;
float buttonCenterY;

int playerOneX;
int playerOneY;
int playerTwoX;
int playerTwoY;

color firstPlayerColor;
color secondPlayerColor;

int playerOneDirection; //1 = left, 2 = up, 3 = right, 4 = down
int playerTwoDirection;
int speed;

int scorePlayerOne;
int scorePlayerTwo;

int startInterval = 4; // sekunde da počne igra
float startTime;
color b1 = color(255);
color b2 = color(0);
color c1 = color(204, 102, 0);
color c2 = color(0, 102, 153);

ArrayList<Pair> firstPlayerPassedPoints;
ArrayList<Pair> secondPlayerPassedPoints;

class Pair {
    private int x;
    private int y;
  
    public Pair(int x, int y) {
        this.x = x;
        this.y = y;
    }
  
    public int getX() {
        return x;
    }
  
    public int getY() {
        return y;
    }
  
    @Override
    public boolean equals(Object p) {
      if(x == ((Pair)p).getX() && y == ((Pair)p).getY()) return true;
      return false;
    }
}

void setup() {
    fullScreen();
    frameRate(100);
    
    scorePlayerOne = 0;
    scorePlayerTwo = 0;
    
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
  //countdown 3,2,1 prije početka igre
    if(started) {
        drawSideBar();
        if(millis() - startTime > 1000 && startInterval >= 0) {
            background(255);
            text(str(startInterval - 1), (5*width/6)/2, (height - textWidth("0"))/2);
            startTime = millis();
            startInterval--;
        }
      
        if(startInterval == 0) {
            started = false;
            background(255);
            buttonPressed = true;
        }
    }
  //kraj countdowna 
    if(buttonPressed) {
        switch(playerOneDirection) {
            case 1: playerOneX--;
                    break;
            case 2: playerOneY--;
                    break;
            case 3: playerOneX++;
                    break;
            case 4: playerOneY++; 
                    break;    
        }
        firstPlayerPassedPoints.add(new Pair(playerOneX, playerOneY));

        switch(playerTwoDirection) {
            case 1: playerTwoX--;
                    break;
            case 2: playerTwoY--;
                    break;
            case 3: playerTwoX++;
                    break;
            case 4: playerTwoY++;
                    break;
        } 
        secondPlayerPassedPoints.add(new Pair(playerTwoX, playerTwoY));
    
        drawAllPoints();
        checkIfCollision();
        checkPlayerOutOfScreen();
        drawSideBar();
    }
}

void drawSideBar() {
    text("Exit: esc", 6*width/7, height/10);
    fill(127, 0, 0);
    rect(5*width/6, 0, 5, height);
    fill(127, 0, 0);
    text("Rezultat:", 6*width/7, height/3);
    fill(255, 0, 0);
    text("Igrač 1: ", 6*width/7, height/3 + 30);
    text(scorePlayerOne, 6*width/7 + textWidth("Igrač 1: "), height/3 + 30);
    fill(0, 0, 255);
    text("Igrač 2: ", 6*width/7, height/3 + 60);
    text(scorePlayerTwo, 6*width/7 + textWidth("Igrač 2: "), height/3 + 60);
}

void checkIfCollision() {
    Pair playerOnePos = new Pair(playerOneX, playerOneY);
    Pair playerTwoPos = new Pair(playerTwoX, playerTwoY);
    
    if(secondPlayerPassedPoints.contains(playerOnePos) || firstPlayerPassedPoints.subList(0, firstPlayerPassedPoints.size()-1).contains(playerOnePos)) {
        gameOverWinnerIs(2);  
    } else if(firstPlayerPassedPoints.contains(playerTwoPos) || secondPlayerPassedPoints.subList(0, secondPlayerPassedPoints.size()-1).contains(playerTwoPos)) {
        gameOverWinnerIs(1);
    }
}

void checkPlayerOutOfScreen() {
    if(playerOneX > 5*width/6 || playerOneX < 0 || playerOneY > height || playerOneY < 0) {
        gameOverWinnerIs(2);
    } else if (playerTwoX > 5*width/6 || playerTwoX < 0 || playerTwoY > height || playerTwoY < 0) {
        gameOverWinnerIs(1);
    }
}

void gameOverWinnerIs(int player) {
    noLoop();
    background(255);
    drawAllPoints();
    fill(255);
    if(player == 1) {
        scorePlayerOne++;
        float textWidth = textWidth("Igra završena! Pobjedio je prvi igrač!");
        rect((width - textWidth)/2, height/10, textWidth, 40);
        fill(firstPlayerColor);
        text("Igra završena! Pobjedio je prvi igrač!", (width - textWidth)/2, height/10 + 35);
    } else {
        scorePlayerTwo++;
        float textWidth = textWidth("Igra završena! Pobjedio je drugi igrač!");
        rect((width - textWidth)/2, height/10, textWidth, 40);
        fill(secondPlayerColor);
        text("Igra završena! Pobjedio je drugi igrač!", (width - textWidth)/2, height/10 + 35);
    }
    fill(0, 255, 0);
    ellipseMode(RADIUS);
    ellipse(buttonCenterX, buttonCenterY, buttonRadius, buttonRadius);
    fill(127, 0, 0);
    float textWidth = textWidth("Ponovo!");
    text("Ponovo!", buttonCenterX - textWidth/2, buttonCenterY + 15);
    buttonPressed = false;
    drawSideBar();
    loop();
}

void drawAllPoints() {
    fill(firstPlayerColor);
    stroke(firstPlayerColor);
    for(Pair p : firstPlayerPassedPoints) {
        rect(p.getX(), p.getY(), 5, 5);
    }
    fill(secondPlayerColor); 
    stroke(secondPlayerColor);
    for(Pair p : secondPlayerPassedPoints) {
        rect(p.getX(), p.getY(), 5, 5);
    }
}

void mousePressed() {
    if(overButton(buttonCenterX, buttonCenterY, buttonRadius) && !buttonPressed) {
        started = true;  
        playerOneX = (int)random(width/5, 2*width/3);
        playerOneY = (int)random(height/5, 4*height/5);
        playerTwoX = (int)random(width/5, 2*width/3);
        playerTwoY = (int)random(height/5, 4*height/5);
        playerOneDirection = (int) random(1, 4.99);
        playerTwoDirection = (int) random(1, 4.99);
        startTime = millis();
        startInterval = 4;
        firstPlayerPassedPoints.clear();
        secondPlayerPassedPoints.clear();
        background(255);
    }
}

boolean overButton(float buttonCenterX, float buttonCenterY, float buttonRadius)  {
    if(dist(mouseX, mouseY, buttonCenterX, buttonCenterY) <= buttonRadius) return true;
    else return false;
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
    } else if (axis == 2) {  // Left to right gradient
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