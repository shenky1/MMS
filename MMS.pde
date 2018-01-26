import ddf.minim.*;

AudioPlayer crashSound;
AudioPlayer cheerSound;
AudioPlayer startSound;
AudioPlayer endCheerSound;
Minim minim;//audio context

boolean buttonPressed = false;
boolean started = false;
boolean frontPage = true;
boolean blackScreen = false;

int numOfPlayers;
int playersLeft;

int numOfPointsForWin = 10;

float buttonRadius;
float buttonCenterX;
float buttonCenterY;

int playerOneX;
int playerOneY;
int playerTwoX;
int playerTwoY;
int playerThreeX;
int playerThreeY;
int playerFourX;
int playerFourY;

color firstPlayerColor;
color secondPlayerColor;
color thirdPlayerColor;
color fourthPlayerColor;

int playerOneDirection; //1 = left, 2 = up, 3 = right, 4 = down
int playerTwoDirection;
int playerThreeDirection;
int playerFourDirection;
int speed;

int scorePlayerOne;
int scorePlayerTwo;
int scorePlayerThree;
int scorePlayerFour;

boolean playerOneAlive;
boolean playerTwoAlive;
boolean playerThreeAlive;
boolean playerFourAlive;

float numOfPlayersWidth;
float numOfPlayersRadius; 

int startInterval = 4; // sekunde da počne igra
float startTime;
color b1 = color(255);
color b2 = color(0);
color c1 = color(204, 102, 0);
color c2 = color(0, 102, 153);

ArrayList<Pair> firstPlayerPassedPoints;
ArrayList<Pair> secondPlayerPassedPoints;
ArrayList<Pair> thirdPlayerPassedPoints;
ArrayList<Pair> fourthPlayerPassedPoints;

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
    
    minim = new Minim(this);
    crashSound = minim.loadFile("crash.mp3");
    cheerSound = minim.loadFile("cheer.mp3");
    startSound = minim.loadFile("startMusic.mp3");
    endCheerSound = minim.loadFile("endCheer.mp3");
    
    scorePlayerOne = 0;
    scorePlayerTwo = 0;
    scorePlayerThree = 0;
    scorePlayerFour = 0;
    
    numOfPlayers = 2;
    playersLeft = 2;
    
    firstPlayerPassedPoints = new ArrayList<Pair>();
    secondPlayerPassedPoints = new ArrayList<Pair>();
    thirdPlayerPassedPoints = new ArrayList<Pair>();
    fourthPlayerPassedPoints = new ArrayList<Pair>();
    
    setGradient(0, 0, width/2, height, b1, b2, 2);
    setGradient(width/2, 0, width/2, height, b2, b1, 2); 
  // backgroundImage = loadImage("background.jpg");
  // background(backgroundImage);
    buttonRadius = width/20;
    buttonCenterX = width/2;
    buttonCenterY = 3*height/7;
    fill(0, 255, 0);
    ellipseMode(RADIUS);
    ellipse(buttonCenterX, buttonCenterY, buttonRadius, buttonRadius);

    PFont startPageFont = createFont("CaviarDreams_Bold.ttf", 60);
    textFont(startPageFont);
    fill(0, 0, 255);
    textSize(60);
    float textWidth = textWidth("Pazi krivulja!");
    text("Pazi krivulja!", (width - textWidth)/2, height/6);
  
    fill(0, 0, 120);
    textSize(50);
    text("Igrač 1", width/7, height/4);
    text("Igrač 2", 3*width/4, height/4);
    text("Igrač 3", width/7, height/2);
    text("Igrač 4", 3*width/4, height/2);
    

    textSize(30);
    text("Lijevo: <-", width/7, height/4 + 50);
    text("Desno: ->", width/7, height/4 + 100);  
    text("Lijevo: A", 3*width/4, height/4 + 50);
    text("Desno: D", 3*width/4, height/4 + 100);
    text("Lijevo: J", width/7, height/2 + 50);
    text("Desno: K", width/7, height/2 + 100);  
    text("Lijevo: 4", 3*width/4, height/2 + 50);
    text("Desno: 6", 3*width/4, height/2 + 100);
  
    textWidth = textWidth("Pravila: Upravljati svojom zmijicom i izbjegavati tragove koje ostavljaju ostale zmijice.");
    text("Pravila: Upravljati svojom zmijicom i izbjegavati tragove koje ostavljaju ostale zmijice", (width - textWidth)/2, height - 100);
    textWidth = textWidth("Pobjednik je igrač koji duže preživi. Prvi igrač do 10 bodova pobjeđuje.");
    text("Pobjednik je igrač koji duže preživi. Prvi igrač do 10 bodova pobjeđuje.", (width - textWidth)/2, height - 50);
    
    fill(127, 0, 0);
    textWidth = textWidth("START");
    text("START", buttonCenterX - textWidth/2, buttonCenterY + 15);
    
    fill(255, 0, 0);
    numOfPlayersWidth = textWidth("Odaberite broj igrača: ");
    text("Odaberite broj igrača: ", (width - numOfPlayersWidth)/2, height * 0.62);
    numOfPlayersRadius = (numOfPlayersWidth - 20)/6;
    ellipse((width - numOfPlayersWidth)/2 + numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
    ellipse((width - numOfPlayersWidth)/2 + 10 + 3*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
    ellipse((width - numOfPlayersWidth)/2 + 20 + 5*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
    
    textSize(40);
    fill(0, 0, 255);
    text("2", (width - numOfPlayersWidth - textWidth("2"))/2 + numOfPlayersRadius, 3*height/4 + (textAscent() - textDescent()) / 2);
    text("3", (width - numOfPlayersWidth - textWidth("3"))/2 + 10 + 3*numOfPlayersRadius, 3*height/4 + (textAscent() - textDescent()) / 2);
    text("4", (width - numOfPlayersWidth - textWidth("4"))/2 + 20 + 5*numOfPlayersRadius, 3*height/4 + (textAscent() - textDescent()) / 2);

 //   rect((width - textWidth)/2, 3*height/4, (textWidth - 20)/4, height/20);
 //   rect((width - textWidth)/2, 3*height/4, (textWidth - 20)/4, height/20);
 //   rect((width - textWidth)/2, 3*height/4, (textWidth - 20)/4, height/20);

  
    firstPlayerColor = color(255, 0, 0);
    secondPlayerColor = color(0, 0, 255);
    thirdPlayerColor = color(0, 255, 0);
    fourthPlayerColor = color(255, 0, 255);
    
    startSound.loop();
    
}

void draw() {
  //countdown 3,2,1 prije početka igre
    if(started) {
        drawSideBar();
        if(millis() - startTime > 1000 && startInterval >= 0) {
            background(255);
            drawBackground();
            fill(127, 0, 0);
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
      if(playerOneAlive) {
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
      }
      if(playerTwoAlive) {
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
      }
        if(playerThreeAlive) {
          switch(playerThreeDirection) {
            case 1: playerThreeX--;
                    break;
            case 2: playerThreeY--;
                    break;
            case 3: playerThreeX++;
                    break;
            case 4: playerThreeY++;
                    break;
          }
          thirdPlayerPassedPoints.add(new Pair(playerThreeX, playerThreeY));
        }
        
        if(playerFourAlive) {
        switch(playerFourDirection) {
            case 1: playerFourX--;
                    break;
            case 2: playerFourY--;
                    break;
            case 3: playerFourX++;
                    break;
            case 4: playerFourY++; 
                    break;    
        }
        fourthPlayerPassedPoints.add(new Pair(playerFourX, playerFourY));
        }
        if(blackScreen) {
          fill(0);
          rect(0, 0, 5*width/6, height);
        } else {
          fill(255);
          rect(0, 0, 5*width/6, height);
        }
        drawSideBar();
        drawAllPoints();
        checkIfCollision();
        checkPlayerOutOfScreen();
    }
}

void drawSideBar() {
    fill(255);
    rect(5*width/6, 0, width/6, height);
    textSize(30);
    fill(127, 0, 0);
    text("Exit: esc", 6*width/7, height/10);
    rect(5*width/6, 0, 5, height);

    text("Rezultat:", 6*width/7, height/3);
    fill(firstPlayerColor);
    text("Igrač 1: ", 6*width/7, height/3 + 30);
    text(scorePlayerOne, 6*width/7 + textWidth("Igrač 1: "), height/3 + 30);
    fill(secondPlayerColor);
    text("Igrač 2: ", 6*width/7, height/3 + 60);
    text(scorePlayerTwo, 6*width/7 + textWidth("Igrač 2: "), height/3 + 60);
    if(numOfPlayers == 3 ||numOfPlayers == 4) {
    fill(thirdPlayerColor);
    text("Igrač 3: ", 6*width/7, height/3 + 90);
    text(scorePlayerThree, 6*width/7 + textWidth("Igrač 3: "), height/3 + 90);
    }
    if(numOfPlayers == 4) {
      fill(fourthPlayerColor);
      text("Igrač 4: ", 6*width/7, height/3 + 120);
      text(scorePlayerFour, 6*width/7 + textWidth("Igrač 4: "), height/3 + 120);
    }
    stroke(0, 0, 0);
    fill(255);
    ellipse(width * 0.9 + 50, height*0.2, 20, 20);
    fill(0);
    ellipse(width * 0.9, height*0.2, 20, 20);
}

void checkIfCollision() {
    Pair playerOnePos = new Pair(playerOneX, playerOneY);
    Pair playerTwoPos = new Pair(playerTwoX, playerTwoY);
    Pair playerThreePos = new Pair(playerThreeX, playerThreeY);
    Pair playerFourPos = new Pair(playerFourX, playerFourY);
    
    if(playerOneAlive && ( fourthPlayerPassedPoints.contains(playerOnePos) || thirdPlayerPassedPoints.contains(playerOnePos) ||
    secondPlayerPassedPoints.contains(playerOnePos) || firstPlayerPassedPoints.subList(0, firstPlayerPassedPoints.size()-1).contains(playerOnePos))) {
        crashSound.play();
        crashSound.rewind();
        scorePlayerOne = scorePlayerOne + (int)pow(2, numOfPlayers - playersLeft - 1);
        playersLeft--;
        playerOneAlive = false;
        if(playersLeft == 1 && playerTwoAlive) gameOverWinnerIs(2);
        else if(playersLeft == 1 && playerThreeAlive) gameOverWinnerIs(3);
        else if(playersLeft == 1 && playerFourAlive) gameOverWinnerIs(4);
    } else if(playerTwoAlive && (fourthPlayerPassedPoints.contains(playerTwoPos) || thirdPlayerPassedPoints.contains(playerTwoPos) 
    ||firstPlayerPassedPoints.contains(playerTwoPos) || secondPlayerPassedPoints.subList(0, secondPlayerPassedPoints.size()-1).contains(playerTwoPos))) {
        crashSound.play();
        crashSound.rewind();
        scorePlayerTwo = scorePlayerTwo + (int)pow(2, numOfPlayers - playersLeft - 1);
        playersLeft--;
        playerTwoAlive = false;  
        if(playersLeft == 1 && playerOneAlive) gameOverWinnerIs(1);
        else if(playersLeft == 1 && playerThreeAlive) gameOverWinnerIs(3);
        else if(playersLeft == 1 && playerFourAlive) gameOverWinnerIs(4);
    } else if(playerThreeAlive && (numOfPlayers == 3 || numOfPlayers == 4)
    && (fourthPlayerPassedPoints.contains(playerThreePos) || firstPlayerPassedPoints.contains(playerThreePos) || secondPlayerPassedPoints.contains(playerThreePos) 
    || thirdPlayerPassedPoints.subList(0, thirdPlayerPassedPoints.size()-1).contains(playerThreePos))) {
        crashSound.play();
        crashSound.rewind();
        scorePlayerThree = scorePlayerThree + (int)pow(2, numOfPlayers - playersLeft - 1);
        playersLeft--;
        playerThreeAlive = false;
        if(playersLeft == 1 && playerOneAlive) gameOverWinnerIs(1);
        else if(playersLeft == 1 && playerTwoAlive) gameOverWinnerIs(2);
        else if(playersLeft == 1 && playerFourAlive) gameOverWinnerIs(4);
    } else if(playerFourAlive && numOfPlayers == 4 && (firstPlayerPassedPoints.contains(playerFourPos) || secondPlayerPassedPoints.contains(playerFourPos) || thirdPlayerPassedPoints.contains(playerFourPos) 
    || fourthPlayerPassedPoints.subList(0, fourthPlayerPassedPoints.size()-1).contains(playerFourPos))) {
        crashSound.play();
        crashSound.rewind();
        scorePlayerFour = scorePlayerFour + (int)pow(2, numOfPlayers - playersLeft - 1);
        playersLeft--;
        playerFourAlive = false;
        if(playersLeft == 1 && playerOneAlive) gameOverWinnerIs(1);
        else if(playersLeft == 1 && playerTwoAlive) gameOverWinnerIs(2);
        else if(playersLeft == 1 && playerThreeAlive) gameOverWinnerIs(3);
    };
}

void checkPlayerOutOfScreen() {
    if(playerOneAlive && (playerOneX >= 5*width/6 || playerOneX <= 0 || playerOneY >= height || playerOneY <= 0)) {
        crashSound.play();
        crashSound.rewind();
        scorePlayerOne = scorePlayerOne + (int)pow(2, numOfPlayers - playersLeft - 1);
        playersLeft--;
        playerOneAlive = false;
        if(playersLeft == 1 && playerTwoAlive) gameOverWinnerIs(2);
        else if(playersLeft == 1 && playerThreeAlive) gameOverWinnerIs(3);
        else if(playersLeft == 1 && playerFourAlive) gameOverWinnerIs(4);   
    } else if (playerTwoAlive && (playerTwoX >= 5*width/6 || playerTwoX <= 0 || playerTwoY >= height || playerTwoY <= 0)) {
        crashSound.play();
        crashSound.rewind();
        scorePlayerTwo = scorePlayerTwo + (int)pow(2, numOfPlayers - playersLeft - 1);
        playersLeft--;
        playerTwoAlive = false;
        if(playersLeft == 1 && playerOneAlive) gameOverWinnerIs(1);
        else if(playersLeft == 1 && playerThreeAlive) gameOverWinnerIs(3);
        else if(playersLeft == 1 && playerFourAlive) gameOverWinnerIs(4);   
    } else if (playerThreeAlive && (numOfPlayers == 3 || numOfPlayers == 4) && (playerThreeX >= 5*width/6 || playerThreeX <= 0 || playerThreeY >= height ||playerThreeY <= 0)) {
        crashSound.play();
        crashSound.rewind();
        scorePlayerThree = scorePlayerThree + (int)pow(2, numOfPlayers - playersLeft - 1);
        playersLeft--;
        playerThreeAlive = false;
        if(playersLeft == 1 && playerOneAlive) gameOverWinnerIs(1);
        else if(playersLeft == 1 && playerTwoAlive) gameOverWinnerIs(2);
        else if(playersLeft == 1 && playerFourAlive) gameOverWinnerIs(4);   
    } else if (playerFourAlive && numOfPlayers == 4 && (playerFourX >= 5*width/6 || playerFourX <= 0 || playerFourY >= height ||playerFourY <= 0)) {
        crashSound.play();
        crashSound.rewind();
        scorePlayerFour = scorePlayerFour + (int)pow(2, numOfPlayers - playersLeft - 1);
        playersLeft--;
        playerFourAlive = false;
        if(playersLeft == 1 && playerOneAlive) gameOverWinnerIs(1);
        else if(playersLeft == 1 && playerTwoAlive) gameOverWinnerIs(2);
        else if(playersLeft == 1 && playerThreeAlive) gameOverWinnerIs(3);   
    }
}

void gameOverWinnerIs(int player) {
    cheerSound.play();
    cheerSound.rewind();
    buttonPressed = false;
    drawBackground();
    drawAllPoints();
    fill(255);
    if(player == 1) {
        scorePlayerOne = scorePlayerOne + (int)pow(2, numOfPlayers - playersLeft - 1);
        float textWidth = textWidth("Igra završena! Pobjedio je prvi igrač!");
        rect((width - textWidth)/2, height/10, textWidth, 40);
        fill(firstPlayerColor);
        text("Igra završena! Pobjedio je prvi igrač!", (width - textWidth)/2, height/10 + 35);
    } else if(player == 2) {
        scorePlayerTwo = scorePlayerTwo + (int)pow(2, numOfPlayers - playersLeft - 1);
        float textWidth = textWidth("Igra završena! Pobjedio je drugi igrač!");
        rect((width - textWidth)/2, height/10, textWidth, 40);
        fill(secondPlayerColor);
        text("Igra završena! Pobjedio je drugi igrač!", (width - textWidth)/2, height/10 + 35);
    } else if(player == 3) {
        scorePlayerThree = scorePlayerThree + (int)pow(2, numOfPlayers - playersLeft - 1);
        float textWidth = textWidth("Igra završena! Pobjedio je treći igrač!");
        rect((width - textWidth)/2, height/10, textWidth, 40);
        fill(thirdPlayerColor);
        text("Igra završena! Pobjedio je treći igrač!", (width - textWidth)/2, height/10 + 35);
    } else if(player == 4) {
        scorePlayerFour = scorePlayerFour + (int)pow(2, numOfPlayers - playersLeft - 1);
        float textWidth = textWidth("Igra završena! Pobjedio je četvrti igrač!");
        rect((width - textWidth)/2, height/10, textWidth, 40);
        fill(fourthPlayerColor);
        text("Igra završena! Pobjedio je četvrti igrač!", (width - textWidth)/2, height/10 + 35);
    }
    drawSideBar();
    if(scorePlayerOne >= numOfPointsForWin) {
      fill(firstPlayerColor);
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth("PRVI IGRAČ JE POBJEDNIK");
      fill(0);
      text("PRVI IGRAČ JE POBJEDNIK", 5*width/12 - textWidth/2, height/2);
    } else if(scorePlayerTwo >= numOfPointsForWin) {
      fill(secondPlayerColor);
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth("DRUGI IGRAČ JE POBJEDNIK");
      fill(0);
      text("DRUGI IGRAČ JE POBJEDNIK", 5*width/12 - textWidth/2, height/2);
    } else if(scorePlayerThree >= numOfPointsForWin) {
      fill(thirdPlayerColor);
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth("TREĆI IGRAČ JE POBJEDNIK");
      fill(0);
      text("TREĆI IGRAČ JE POBJEDNIK", 5*width/12 - textWidth/2, height/2);
    } else if(scorePlayerFour >= numOfPointsForWin) {
      fill(fourthPlayerColor);
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth("ČETVRTI IGRAČ JE POBJEDNIK");
      fill(0);
      text("ČETVRTI IGRAČ JE POBJEDNIK", 5*width/12 - textWidth/2, height/2);
    } else {
      fill(0, 255, 0);
      ellipseMode(RADIUS);
      ellipse(11*width/12, height*0.8, buttonRadius, buttonRadius);
      fill(127, 0, 0);
      textSize(30);
      float textWidth = textWidth("Ponovo!");
      text("Ponovo!", 11*width/12 - textWidth/2, height*0.8 + 15); 
    }
}
void drawBackground() {
  stroke(0);
  if(blackScreen) {
          fill(0);
    } else {
      fill(255);
    }
   rect(0, 0, 5*width/6, height);
}
void drawAllPoints() {
    fill(firstPlayerColor);
    stroke(firstPlayerColor);
    for(Pair p : firstPlayerPassedPoints) {
        ellipse(p.getX(), p.getY(), 5, 5);
    }
    fill(secondPlayerColor); 
    stroke(secondPlayerColor);
    for(Pair p : secondPlayerPassedPoints) {
        ellipse(p.getX(), p.getY(), 5, 5);
    }
    if(numOfPlayers == 3 || numOfPlayers == 4) {
      fill(thirdPlayerColor);
      stroke(thirdPlayerColor);
      for(Pair p: thirdPlayerPassedPoints) {
        ellipse(p.getX(), p.getY(), 5, 5);
      }
    }
    if(numOfPlayers == 4) {
      fill(fourthPlayerColor);
      stroke(fourthPlayerColor);
      for(Pair p: fourthPlayerPassedPoints) {
        ellipse(p.getX(), p.getY(), 5, 5);
      }
    }
}

void mousePressed() {
    if((overButton(buttonCenterX, buttonCenterY, buttonRadius) && !buttonPressed) || (!buttonPressed && !started && overButton(11*width/12, height*0.8, buttonRadius) && !frontPage)) {
        startSound.close();
        started = true;  
        initializePlayersOnStart();
        startTime = millis();
        startInterval = 4;
        firstPlayerPassedPoints.clear();
        secondPlayerPassedPoints.clear();
        thirdPlayerPassedPoints.clear();
        fourthPlayerPassedPoints.clear();
        background(255);
        drawBackground();
        frontPage = false;
    } else if(overButton(width * 0.9, height * 0.2, 20) && !frontPage) {
      blackScreen = true;
      drawBackground();
      drawAllPoints();
    } else if(overButton(width * 0.9 + 50, height * 0.2, 20) && !frontPage) {
      blackScreen = false;
      drawBackground();
      drawAllPoints();
    } else  chooseNumberOfPlayers();
    
}

void initializePlayersOnStart() {
   playerOneAlive = true;
        playerTwoAlive = true;
        playerOneX = (int)random(width/5, 2*width/3);
        playerOneY = (int)random(height/5, 4*height/5);
        playerTwoX = (int)random(width/5, 2*width/3);
        playerTwoY = (int)random(height/5, 4*height/5);
        if(numOfPlayers == 3 || numOfPlayers == 4) {
            playerThreeX = (int)random(width/5, 2*width/3);
            playerThreeY = (int)random(height/5, 4*height/5);
            playerThreeDirection = (int) random(1, 4.99);
            playerThreeAlive = true;
        }
        if(numOfPlayers == 4) {
          playerFourX = (int)random(width/5, 2*width/3);
          playerFourY = (int)random(height/5, 4*height/5);
          playerFourDirection = (int) random(1, 4.99);
          playerFourAlive = true;
        }
        playersLeft = numOfPlayers;
        playerOneDirection = (int) random(1, 4.99);
        playerTwoDirection = (int) random(1, 4.99); 
}

void chooseNumberOfPlayers() {
 if(overButton((width - numOfPlayersWidth)/2 + 10 + 3*numOfPlayersRadius, 3*height/4, numOfPlayersRadius)) {
      fill(0, 255, 0);
      ellipse((width - numOfPlayersWidth)/2 + 10 + 3*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      fill(255, 0, 0);
      ellipse((width - numOfPlayersWidth)/2 + numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      ellipse((width - numOfPlayersWidth)/2 + 20 + 5*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      writeTexts();
      numOfPlayers = 3;
      playersLeft = 3;
    } else if(overButton((width - numOfPlayersWidth)/2 + 20 + 5*numOfPlayersRadius, 3*height/4, numOfPlayersRadius)) {
      fill(0, 255, 0);
      ellipse((width - numOfPlayersWidth)/2 + 20 + 5*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      fill(255, 0, 0);
      ellipse((width - numOfPlayersWidth)/2 + numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      ellipse((width - numOfPlayersWidth)/2 + 10 + 3*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      writeTexts();
      numOfPlayers = 4;
      playersLeft = 4;
    } else if(overButton((width - numOfPlayersWidth)/2 + numOfPlayersRadius, 3*height/4, numOfPlayersRadius)) {
      fill(0, 255, 0);
      ellipse((width - numOfPlayersWidth)/2 + numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      fill(255, 0, 0);
      ellipse((width - numOfPlayersWidth)/2 + 10 + 3*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      ellipse((width - numOfPlayersWidth)/2 + 20 + 5*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      writeTexts();
      numOfPlayers = 2;
      playersLeft = 2;
    } 
}

void writeTexts() {
      fill(0, 0, 255);
      text("2", (width - numOfPlayersWidth - textWidth("2"))/2 + numOfPlayersRadius, 3*height/4 + (textAscent() - textDescent()) / 2);
      text("3", (width - numOfPlayersWidth - textWidth("3"))/2 + 10 + 3*numOfPlayersRadius, 3*height/4 + (textAscent() - textDescent()) / 2);
      text("4", (width - numOfPlayersWidth - textWidth("4"))/2 + 20 + 5*numOfPlayersRadius, 3*height/4 + (textAscent() - textDescent()) / 2);
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
    if(numOfPlayers == 3 ||numOfPlayers == 4) {
      if(key == 'J' || key == 'j') {
        if(playerThreeDirection == 1) {
          playerThreeDirection = 4;
        } else playerThreeDirection--;
      }
      if(key == 'K' || key == 'k') {
        if(playerThreeDirection == 4) {
          playerThreeDirection = 1;
        } else playerThreeDirection++;
      }
    }
    if(numOfPlayers == 4) {
      if(key == '4') {
        if(playerFourDirection == 1) {
          playerFourDirection = 4;
        } else playerFourDirection--;
      }
      if(key == '6') {
        if(playerFourDirection == 4) {
          playerFourDirection = 1;
        } else playerFourDirection++;
      }
    }
}