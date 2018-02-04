 //<>//
import ddf.minim.*;
import g4p_controls.*;

AudioPlayer crashSound, cheerSound, startSound, endCheerSound;
Minim minim;//audio context

boolean startRound = false; // start button
boolean startCounter = false;  // used for countdown
boolean frontPage = true; // am I on front page
boolean blackScreen = false; // do I want black board or white
boolean endOfGame = false; // Any player reached numOfPointsToWin;

int numOfPlayers; // starting number of players
int playersLeft; // how many players are alive at any time during the game
int rectangleSize = 5;

int numOfPointsForWin = 30; //final number of points to win

Player playerOne, playerTwo, playerThree, playerFour;

ArrayList<Player> listOfPlayers;

int secondsToStart = 4; // one bigger than it really is
int startInterval; // counter 
float startTime; // time calculated with millis() when button is pressed.. Used for countdown

//colors for gradient.. Copied from internet
color b1 = color(255);
color b2 = color(0);
color c1 = color(204, 102, 0);
color c2 = color(0, 102, 153);

//choosing names
GTextField textField1, textField2, textField3, textField4;

GButton btnL1, btnR1, btnL2, btnR2, btnL3, btnR3, btnL4, btnR4;
GButton btn2Players, btn3Players, btn4Players;
GButton btnStart;

void setup() {
   // size(900,600);
    fullScreen();
    frameRate(100);
    textSize(width/60);
    playerOne = new Player(37, 39, color(255, 0, 0), new Pair(int(textWidth("POBJEDNIK!")/2), height/12)); // <-, ->
    playerTwo = new Player(65, 68, color(0, 0, 255), new Pair(int(6*width/7 - 2*textWidth("POBJEDNIK!")), height/12)); // A, D
    playerThree = new Player(66, 77, color(0, 255, 0), new Pair(int(textWidth("POBJEDNIK!")/2), 17*height/18)); // B,M
    playerFour = new Player(52, 54, color(255, 0, 255), new Pair(int(6*width/7 - 2*textWidth("POBJEDNIK!")), 17*height/18)); // 4, 6

    listOfPlayers = new ArrayList<Player>();
    listOfPlayers.add(playerOne);
    listOfPlayers.add(playerTwo);
    listOfPlayers.add(playerThree);
    listOfPlayers.add(playerFour);
    
    minim = new Minim(this);
    crashSound = minim.loadFile("crash.mp3");
    cheerSound = minim.loadFile("cheer.mp3");
    startSound = minim.loadFile("startMusic.mp3");
    endCheerSound = minim.loadFile("endCheer.mp3");    
 
    //initial number of players
    numOfPlayers = 2;
    playersLeft = 2;
    
    setGradient(0, 0, width/2, height, b1, b2, 2);
    setGradient(width/2, 0, width/2, height, b2, b1, 2); 

    PFont startPageFont = createFont("CaviarDreams_Bold.ttf", 60);
    textFont(startPageFont);
    fill(0, 0, 255);   
    
    textSize((height + width)/50);
    float textWidth = textWidth(title);
    float textHeight = textAscent() - textDescent();
    text(title, (width - textWidth)/2, height/7 - textHeight);
  
    float buttonWidth = width/20;
    float buttonHeight = textHeight;
    
    textSize((height + width)/70);
    textWidth = textWidth(chooseColor);
    textHeight = textAscent() - textDescent();
    
    fill(0, 0, 120);
    textSize((height + width)/60); 
    fill(playerOne.getColor());
    text(player + "1", width/3 - textWidth - buttonWidth, height/7 + textAscent() - textDescent());  
    fill(playerTwo.getColor());
    text(player + "2", 2*width/3, height/7 + textAscent() - textDescent());    
    fill(playerThree.getColor());
    text(player + "3", width/3 - textWidth - buttonWidth, height/2 + textAscent() - textDescent());
    fill(playerFour.getColor());
    text(player + "4", 2*width/3, height/2 + textAscent() - textDescent());
     
    fill(0, 0, 120);
    textSize((height + width)/70);
    textWidth = textWidth(chooseColor);
    textHeight = textAscent() - textDescent();
    float textNameWidth = textWidth(name);
    float textFieldWidth = textWidth + buttonWidth - textNameWidth;
    text(name, width/3 - textWidth - buttonWidth, height/7 + 4*textHeight);
    textField1 = new GTextField(this, width/3 - textWidth - buttonWidth + textNameWidth, height/7 + 3*textHeight, textFieldWidth, textHeight);
    textField1.setPromptText(player + "1");
    text(left, width/3 - textWidth - buttonWidth, height/7 + 6*textHeight);
    text(right, width/3 - textWidth - buttonWidth, height/7 + 8*textHeight);  
    text(name, 2*width/3, height/7 + 4*textHeight);
    textField2 = new GTextField(this, 2*width/3 + textNameWidth, height/7 + 3*textHeight, textFieldWidth, textHeight);
    textField2.setPromptText(player + "2");
    text(left, 2*width/3, height/7 + 6*textHeight);
    text(right, 2*width/3, height/7 + 8*textHeight);
    text(name, width/3 - textWidth - buttonWidth, height/2 + 4*textHeight); 
    textField3 = new GTextField(this, width/3 - textWidth - buttonWidth + textNameWidth, height/2 + 3*textHeight, textFieldWidth, textHeight);
    textField3.setPromptText(player + "3");
    text(left, width/3 - textWidth - buttonWidth, height/2 + 6*textHeight);
    text(right, width/3 - textWidth - buttonWidth, height/2 + 8*textHeight);  
    text(name, 2*width/3, height/2 + 4*textHeight);
    textField4 = new GTextField(this, 2*width/3 + textNameWidth, height/2 + 3*textHeight, textFieldWidth, textHeight);
    textField4.setPromptText(player + "4");
    text(left, 2*width/3, height/2 + 6*textHeight);
    text(right, 2*width/3, height/2 + 8*textHeight);    
   //button for players to choose keys
    btnL1 = new GButton(this, width/3 - textWidth - buttonWidth + textWidth, height/7 + 5*textHeight, buttonWidth, buttonHeight, "LIJEVO");
    btnR1 = new GButton(this, width/3 - textWidth - buttonWidth + textWidth, height/7 + 7*textHeight, buttonWidth, buttonHeight, "DESNO");
    btnL2 = new GButton(this, 2*width/3 + textWidth, height/7 + 5*textHeight, buttonWidth, buttonHeight, "A");
    btnR2 = new GButton(this, 2*width/3 + textWidth, height/7 + 7*textHeight, buttonWidth, buttonHeight, "D"); 
    btnL3 = new GButton(this, width/3 - textWidth - buttonWidth + textWidth, height/2 + 5*textHeight, buttonWidth, buttonHeight, "B");
    btnR3 = new GButton(this, width/3 - textWidth - buttonWidth + textWidth, height/2 + 7*textHeight, buttonWidth, buttonHeight, "M"); 
    btnL4 = new GButton(this, 2*width/3 + textWidth, height/2 + 5*textHeight, buttonWidth, buttonHeight, "4");
    btnR4 = new GButton(this, 2*width/3 + textWidth, height/2 + 7*textHeight, buttonWidth, buttonHeight, "6");   
    
    

    float buttonRadius = width/10;
    btnStart = new GButton(this, (width - buttonRadius)/2, 5*height/14 - buttonRadius/2, buttonRadius, buttonRadius, "START");
    btnStart.setLocalColor(4, color(0, 255, 0));   
    
    textSize((height + width)/70);
    textWidth = textWidth(rule1);
    textHeight = textAscent() - textDescent();
    text(rule1, (width - textWidth)/2, 6*height/7 + textHeight);
    textWidth = textWidth(rule2);
    text(rule2, (width - textWidth)/2, 6*height/7 + 3*textHeight);
    
    
    fill(255, 0, 0);
    textWidth = textWidth(chooseNumOfPlayers);
    text(chooseNumOfPlayers, (width - textWidth)/2, 4*height/7 + textHeight);
    buttonRadius = (textWidth - (height + width)/60)/3;
    
    btn2Players = new GButton(this, (width - textWidth)/2 , 5*height/7 - buttonRadius/2, buttonRadius, buttonRadius, "2"); 
    btn3Players = new GButton(this, (width - textWidth)/2 + (height + width)/120 + buttonRadius, 5*height/7 - buttonRadius/2, buttonRadius, buttonRadius, "3");
    btn4Players = new GButton(this, (width -textWidth)/2 + (height + width)/60 + 2*buttonRadius, 5*height/7 - buttonRadius/2, buttonRadius, buttonRadius, "4");
    btn2Players.setLocalColor(4, color(255, 0, 0));
    btn3Players.setLocalColor(4, color(255, 0, 0));
    btn4Players.setLocalColor(4, color(255, 0, 0));
    btn2Players.setLocalColor(3, color(0, 0, 255));
    btn3Players.setLocalColor(3, color(0, 0, 255));
    btn4Players.setLocalColor(3, color(0, 0, 255));
    

    //looping but not well.. Not continuous
    startSound.loop();
    
    rectMode(CORNERS);
    ellipseMode(RADIUS);

}

void draw() {   
    if(startCounter) {    
        startCountdown();
    }
  
    if(startRound) {
      
        drawSideBar();
        for(Player p : listOfPlayers) 
            if(p.isAlive()) { 
                Move(p);
                checkIfCollision(p);
            }        
        
        drawAllPlayersCurrentPositions();
    }
}

private void startCountdown() {
        drawSideBar();
        if(millis() - startTime > 1000 && startInterval >= 0) {
            drawPlayingArea();
            drawBackground(blackScreen);
            for(Player p : listOfPlayers) {
              fill(p.getColor());
              stroke(p.getColor());
              rect(p.getX(), p.getY(), p.getX() + rectangleSize - 1, p.getY() + rectangleSize - 1);
            }
            fill(127, 0, 0);
            text(str(startInterval - 1), 5*width/12, (height - textWidth("0"))/2);
            startTime = millis();
            startInterval--;
        }
        if(startInterval == 0) {
            startCounter = false;
            drawBackground(blackScreen);
            drawPlayingArea();
            startRound = true;
        }
}

private void Move(Player player) {
    if(player.isAlive()) {  
      switch(player.getDirection()) {
        case 1: player.setX(player.getX() - rectangleSize);
                break;
        case 2: player.setY(player.getY() - rectangleSize);
                break;
        case 3: player.setX(player.getX() + rectangleSize);
                break;
        case 4: player.setY(player.getY() + rectangleSize); 
                break;    
      }
    }
}

private void drawPlayingArea() {
    int heightHalf = height/2;
    int widthHalf = 5*width/12;
    float widthSqr = pow(widthHalf,2);
    float heightSqr = pow(heightHalf, 2);
    ellipse(widthHalf, heightHalf, widthHalf, heightHalf);
    for(int i = 0; i < 5*width/6; ++i) 
        for(int j = 0; j < height; ++j) {
            if(pow(i - widthHalf, 2)/widthSqr + pow(j - heightHalf, 2)/heightSqr > 1) {
               if(i > widthHalf && j > heightHalf) {
                   set(i, j, playerFour.getColor());
               } else if(i > widthHalf && j < heightHalf) {
                 set(i, j, playerTwo.getColor());
               } else if(i < widthHalf && j < heightHalf) {
                 set(i, j, playerOne.getColor());
               } else set (i, j, playerThree.getColor());
            }
        }
}

//drawing side bar every frame
private void drawSideBar() {
    //white rectangle first
    fill(255);
    rect(5*width/6, 0, width, height);
    
    //information about exit
    textSize((width + height)/60);
    fill(127, 0, 0);
    text("Izlaz: esc", 6*width/7, height/10);

    //current score
    text("Rezultat:", 6*width/7, height/3);
    textSize((width + height)/100);
    float textHeight = textAscent() - textDescent();
    drawPlayerScore(playerOne, 2*textHeight);
    drawPlayerScore(playerTwo, 4*textHeight);
    if(numOfPlayers == 3 ||numOfPlayers == 4) {
        drawPlayerScore(playerThree, 6*textHeight);
    }
    if(numOfPlayers == 4) {
        drawPlayerScore(playerFour, 8*textHeight);
    }
    
    //buttons for black or white screen
    stroke(0, 0, 0);
    fill(255);
    ellipse(width * 0.9 + 50, height*0.2, width/60, width/60);
    fill(0);
    ellipse(width * 0.9, height*0.2, width/60, width/60);
}

private void drawPlayerScore(Player player, float distance) {
    fill(player.getColor());
    text(player.getName()+ ": ", 6*width/7, height/3 + distance);
    text(player.getScore(), 6*width/7 + textWidth(player.getName()+ ": "), height/3 + distance);
}

private boolean hasCrashed(Player player) {
  boolean result = false;
  for(int i = 0; i < rectangleSize; ++i) {
      for(int j = 0; j < rectangleSize; ++j) {
          color col = get(i + player.getX(), j + player.getY());
          if(col != color(255) && col != color(0)) result = true;
          else set(i + player.getX(), j + player.getY(), player.getColor());
      }
  }
   return result;
}

private void checkIfCollision(Player player) {
   if(player.isAlive() && hasCrashed(player)) {
        playSound(crashSound);
               
                
        // if first to die get 0 points, if second to die get 1 point etc (exponents of number 2).. If n players were in the game winner of round wins 2^(n-2) points
        int pointsWon = (int)pow(2, numOfPlayers - playersLeft - 1);
        player.setScore(player.getScore() + pointsWon);
        player.setAlive(false);

        playersLeft--;
        if(playersLeft == 1) {
          for(Player p : listOfPlayers) {
            if(player != p && p.isAlive()) announceRoundWinner(p);
          }
        }
    }
}

private void announceRoundWinner(Player player) {
    playSound(cheerSound);
    startRound = false;
    
    int pointsWon = (int)pow(2, numOfPlayers - playersLeft - 1);
    player.setScore(player.getScore() + pointsWon);
    float textHeight = textAscent() - textDescent();
    drawSideBar();
    fill(player.getColor());
    text("Runda završena!", 6*width/7, height/2 + 2*textHeight);
    text("Pobjednik:", 6*width/7, height/2 + 4*textHeight); 
    text(player.getName(), 6*width/7, height/2 + 6*textHeight);
    fill(255);
    textSize(width/60);
    text("POBJEDNIK!", player.getWinTextPosition().getX(), player.getWinTextPosition().getY());
    checkIfGameOver();
}

void drawAllPlayersCurrentPositions() {
    for(Player p : listOfPlayers) {
      if(p.isAlive()) drawPlayersCurrentPosition(p);
    }
}

private void drawPlayersCurrentPosition(Player player) {
      fill(player.getColor());
      stroke(player.getColor());
      rect(player.getX(), player.getY(), player.getX() + rectangleSize - 1, player.getY() + rectangleSize - 1);
      player.updateListOfPassedPoints(new Pair(player.getX(), player.getY()));
}

private void drawWholePath(Player player) {
   ArrayList<Pair> passedPoints = player.getListOfPassedPoints();
   fill(player.getColor());
   stroke(player.getColor());
   for(Pair p : passedPoints) {
       rect(p.getX(), p.getY(), p.getX() + rectangleSize - 1, p.getY() + rectangleSize - 1);
   }
}

void playSound(AudioPlayer sound) {
    sound.play();
    sound.rewind();
}

private void checkIfGameOver() {
    Player winPlayer = null;
    if(playerOne.getScore() >= numOfPointsForWin || playerTwo.getScore() >= numOfPointsForWin 
    || playerThree.getScore() >= numOfPointsForWin || playerFour.getScore() >= numOfPointsForWin) {
      int topPoints = 0;
      for(Player p : listOfPlayers) {
        if(p.getScore() > topPoints) {
          topPoints = p.getScore();
          winPlayer = p;
        }
      }
      announceFinalWinner(winPlayer);
    } else {
      drawAgainButton();
    }
}

private void drawAgainButton() {
      fill(0, 255, 0);
      ellipse(11*width/12, height*0.8, width/20, width/20);
      fill(127, 0, 0);
      textSize((width + height)/70);
      float textHeight = textAscent() - textDescent();
      float textWidth = textWidth("Nastavi!");
      text("Nastavi!", 11*width/12 - textWidth/2, height*0.8 + textHeight/2);  
}

private void announceFinalWinner(Player player) {
      fill(player.getColor());
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth(player.getName() + "je pobjednik!");
      fill(0);
      text(player.getName() + " je pobjednik!", 5*width/12 - textWidth/2, height/2);
      playSound(endCheerSound);
      endOfGame = true;
      noLoop();
}

void drawBackground(boolean blackScreen) {
   if(blackScreen) {
      fill(0);
   } else {
     fill(255);
   }
   ellipse(5*width/12, height/2, 5*width/12, height/2);
}



void mousePressed() {
    if((!endOfGame && !startRound && !startCounter && overButton(11*width/12, height*0.8, width/20) && !frontPage)) {  
        startSound.close();
        drawBackground(blackScreen);
        startCounter = true;  
        initializePlayersOnStart();
        startTime = millis();
        playerOne.getListOfPassedPoints().clear();
        playerTwo.getListOfPassedPoints().clear();
        playerThree.getListOfPassedPoints().clear();
        playerFour.getListOfPassedPoints().clear();
        startInterval = secondsToStart;
        frontPage = false;
    } else if(overButton(width * 0.9, height * 0.2, width/60) && !frontPage) {
      if(!endOfGame) {
          blackScreen = true;
          drawBackground(blackScreen);
          for(Player p : listOfPlayers)
              drawWholePath(p);
      }
    } else if(overButton(width * 0.9 + 50, height * 0.2, width/60) && !frontPage) {
       if(!endOfGame) {
           blackScreen = false;
           drawBackground(blackScreen);
           for(Player p : listOfPlayers)
              drawWholePath(p);
       }
    }
}

void initializePlayersOnStart() {
        initializePlayer(playerOne);
        initializePlayer(playerTwo);
        if(numOfPlayers >= 3) initializePlayer(playerThree);
        if(numOfPlayers == 4) initializePlayer(playerFour);
        playersLeft = numOfPlayers;
}

private void initializePlayer(Player player) {
        player.setAlive(true);
        player.setDirection((int) random(1, 4.99));
        float u = random(0, 1);
        float v = random(0, 1);
        
        float w = height/4 * u;
        float t = 2 * PI * v;
        int x = int(w * cos(t));
        int y = int(w * sin(t));
        
        player.setX(width/2 + x);
        player.setY(height/2 + y);
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
  if(!frontPage) {
    changeDirection(playerOne);
    changeDirection(playerTwo);
    changeDirection(playerThree);
    changeDirection(playerFour); 
  } else {
    if(key != CODED) {
      setPlayerKeys(playerOne, btnL1, Turn.LEFT);
      setPlayerKeys(playerOne, btnR1, Turn.RIGHT);
      setPlayerKeys(playerTwo, btnL2, Turn.LEFT);
      setPlayerKeys(playerTwo, btnR2, Turn.RIGHT);
      setPlayerKeys(playerThree, btnL3, Turn.LEFT);
      setPlayerKeys(playerThree, btnR3, Turn.RIGHT);
      setPlayerKeys(playerFour, btnL4, Turn.LEFT);
      setPlayerKeys(playerFour, btnR4, Turn.RIGHT);
    } else {
      setPlayerKeysCoded(playerOne, btnL1, Turn.LEFT);
      setPlayerKeysCoded(playerOne, btnR1, Turn.RIGHT);
      setPlayerKeysCoded(playerTwo, btnL2, Turn.LEFT);
      setPlayerKeysCoded(playerTwo, btnR2, Turn.RIGHT);
      setPlayerKeysCoded(playerThree, btnL3, Turn.LEFT);
      setPlayerKeysCoded(playerThree, btnR3, Turn.RIGHT);
      setPlayerKeysCoded(playerFour, btnL4, Turn.LEFT);
      setPlayerKeysCoded(playerFour, btnR4, Turn.RIGHT);
    }
  }
}

private void changeDirection(Player player) {
    if(key == player.getLeft() || key == Character.toLowerCase(player.getLeft()) || keyCode == player.getLeft() || keyCode  == Character.toLowerCase(player.getLeft())) {
          if(player.getDirection() == 1) 
              player.setDirection(4);
          else player.setDirection(player.getDirection() - 1);
    } else if (key == player.getRight() || key == Character.toLowerCase(player.getRight()) || keyCode == player.getRight() || keyCode  == Character.toLowerCase(player.getRight())) {
          if(player.getDirection() == 4) 
              player.setDirection(1);
          else player.setDirection(player.getDirection() + 1);
    }
}


enum Turn {
  LEFT, RIGHT;
}

private void setPlayerKeys(Player player, GButton button, Turn direction) {
    char wishedKey = Character.toUpperCase(key);
    String keyStr = wishedKey + "";

    if (button.hasFocus()) {
        if(isAvailable(wishedKey)) {
           button.setText(keyStr);
           if(direction == Turn.LEFT) player.setLeft(wishedKey);
           else player.setRight(wishedKey);
           button.setFocus(false);
         } else {
           button.setText("Zauzeto!");
         }
    }
}

private boolean isAvailable(char wishedKey) {
    for(Player p : listOfPlayers) {
      if(p.getLeft() == wishedKey || p.getRight() == wishedKey) {
          return false;
      }
    }
      return true;
}


private void setPlayerKeysCoded(Player player, GButton button, Turn direction) {
 
  if (button.hasFocus()) {
       switch(keyCode) {
         case LEFT:
           button.setText("LEFT");
           break;
         case RIGHT:
           button.setText("RIGHT");
           break;
         case UP:
           button.setText("UP");
           break;
         case DOWN:
           button.setText("DOWN");
           break;
         case ALT:
           button.setText("ALT");
           break;
         case CONTROL:
           button.setText("CTRL");
           break;
         case SHIFT:
           button.setText("SHIFT");
           break;
       }
       if(isAvailable((char)keyCode)) {
         if(direction == Turn.LEFT) player.setLeft((char)keyCode);
         else player.setRight((char)keyCode);
         button.setFocus(false);
       } else {
         button.setText("Zauzeto!");
       }
    }
}

void handleButtonEvents(GButton button , GEvent event) {
  if (button == btn2Players) {
    btn2Players.setLocalColor(4, color(0, 255, 0));
    btn3Players.setLocalColor(4, color(255, 0, 0));
    btn4Players.setLocalColor(4, color(255, 0, 0));
    numOfPlayers = 2;
    playersLeft = 2;
  } else if (button == btn3Players) {
    btn2Players.setLocalColor(4, color(255, 0, 0));
    btn3Players.setLocalColor(4, color(0, 255, 0));
    btn4Players.setLocalColor(4, color(255, 0, 0));
    numOfPlayers = 3;
    playersLeft = 3;
  } else if (button == btn4Players) {
    btn2Players.setLocalColor(4, color(255, 0, 0));
    btn3Players.setLocalColor(4, color(255, 0, 0));
    btn4Players.setLocalColor(4, color(0, 255, 0));
    numOfPlayers = 4;
    playersLeft = 4;
  } else if (button == btnStart) {
    if(frontPage) {
          playerOne.setName(textField1.getText().isEmpty() ? "Igrač 1" : textField1.getText().length() > 8 ? textField1.getText().substring(0,8) : textField1.getText());
          textField1.setVisible(false);
          playerTwo.setName(textField2.getText().isEmpty() ? "Igrač 2" : textField2.getText().length() > 8 ? textField2.getText().substring(0,8) : textField2.getText());
          textField2.setVisible(false);
          playerThree.setName(textField3.getText().isEmpty() ? "Igrač 3" : textField3.getText().length() > 8 ? textField3.getText().substring(0,8) : textField3.getText());
          textField3.setVisible(false);
          playerFour.setName(textField4.getText().isEmpty() ? "Igrač 4" : textField4.getText().length() > 8 ? textField4.getText().substring(0,8) : textField4.getText());
          textField4.setVisible(false);
          btnR1.setVisible(false);
          btnL1.setVisible(false);
          btnR2.setVisible(false);
          btnL2.setVisible(false);
          btnR3.setVisible(false);
          btnL3.setVisible(false);
          btnR4.setVisible(false);
          btnL4.setVisible(false);
          btn2Players.setVisible(false);
          btn3Players.setVisible(false);
          btn4Players.setVisible(false);
          btnStart.setVisible(false);
          background(255);
          frontPage = false;
      }
      startSound.close();
      startCounter = true;  
      initializePlayersOnStart();
      startTime = millis();
      playerOne.getListOfPassedPoints().clear();
      playerTwo.getListOfPassedPoints().clear();
      playerThree.getListOfPassedPoints().clear();
      playerFour.getListOfPassedPoints().clear();
      startInterval = secondsToStart;

  } else { 
    button.setFocus(true);
  if (button == btnL1) {
    btnL1.setText("Pritisni tipku");
  } else if (button == btnR1) {
    btnR1.setText("Pritisni tipku");
  } else if (button == btnL2) { 
    btnL2.setText("Pritisni tipku");
  } else if (button == btnR2) {
    btnR2.setText("Pritisni tipku");
  } else if (button == btnL3) {
    btnL3.setText("Pritisni tipku");
  } else if (button == btnR3) {
    btnR3.setText("Pritisni tipku");
  } else if (button == btnL4) {
    btnL4.setText("Pritisni tipku");
  } else if (button == btnR4) {
    btnR4.setText("Pritisni tipku");
  }
 }
}