import ddf.minim.*;
import g4p_controls.*;

AudioPlayer crashSound; // playing and rewinding is called with method playSound(1)
AudioPlayer cheerSound; // 2
AudioPlayer startSound; // 
AudioPlayer endCheerSound; //3
Minim minim;//audio context

boolean startRound = false; // start button
boolean startCounter = false;  // used for countdown
boolean frontPage = true; // am I on front page
boolean blackScreen = false; // do I want black board or white
boolean endOfGame = false; // Any player reached numOfPointsToWin;

int numOfPlayers; // starting number of players
int playersLeft; // how many players are alive at any time during the game
int rectangleSize = 2;

int numOfPointsForWin = 10; //final number of points to win

Player playerOne;
Player playerTwo;
Player playerThree;
Player playerFour;

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
GTextField textField1;
GTextField textField2;
GTextField textField3;
GTextField textField4;

GButton btnL1;
GButton btnR1;
GButton btnL2;
GButton btnR2;
GButton btnL3;
GButton btnR3;
GButton btnL4;
GButton btnR4;

GButton btn2Players;
GButton btn3Players;
GButton btn4Players;

GButton btnStart;

GButton btnChooseColor1;
GButton btnChooseColor2;
GButton btnChooseColor3;
GButton btnChooseColor4;

int numOfButtons = 16;

GButton[] buttons = {btnL1, btnL2, btnL3, btnL4, btnR1, btnR2, btnR3, btnR4,
                      btn2Players, btn3Players, btn4Players, btnStart,
                      btnChooseColor1, btnChooseColor2, btnChooseColor3, btnChooseColor4};

void setup() {
    fullScreen();
    frameRate(100);
    
    playerOne = new Player((char)49, (char)51, color(255, 0, 0)); // 1, 3
    playerTwo = new Player((char)65,(char)68, color(0, 0, 255)); // A, D
    playerThree = new Player((char)74,(char)76, color(0, 255, 0)); // J, L
    playerFour = new Player((char)52,(char)54, color(255, 0, 255)); // 4, 6

    listOfPlayers = new ArrayList<Player>();
    listOfPlayers.add(playerOne);
    listOfPlayers.add(playerTwo);
    
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
    

    int buttonRadius = width/15;
    btnStart = new GButton(this, (width - buttonRadius)/2, 3*height/7 - buttonRadius/2, buttonRadius, buttonRadius, "START");
    btnStart.setLocalColor(4, color(0, 255, 0));
    

    PFont startPageFont = createFont("CaviarDreams_Bold.ttf", 60);
    textFont(startPageFont);
    fill(0, 0, 255);
    
    textSize(titleSize);
    float titleWidth = textWidth(title);
    text(title, (width - titleWidth)/2, height/6);
  
    fill(0, 0, 120);
    textSize(playerSize);
    text(player + " 1", width/7, height/4);  
    text(player + " 2", 3*width/4, height/4);    
    text(player + " 3", width/7, height/2);
    text(player + " 4", 3*width/4, height/2);
    
    
    
    textSize(nameSize);
    float chooseColorWidth = textWidth(chooseColor);
    float chooseColorHeight = textAscent() - textDescent();
    textField1 = new GTextField(this, width/7, height/4 + chooseColorHeight, chooseColorWidth, chooseColorHeight);
    textField1.setPromptText(player + "1");
    text(left, width/7, height/4 + 4*chooseColorHeight);
    text(right, width/7, height/4 + 6*chooseColorHeight);  
    text(chooseColor, width/7, height/4 + 8*chooseColorHeight);
    textField2 = new GTextField(this, 3*width/4, height/4 + chooseColorHeight, chooseColorWidth, chooseColorHeight);
    textField2.setPromptText(player + "2");
    text(left, 3*width/4, height/4 + 4*chooseColorHeight);
    text(right, 3*width/4, height/4 + 6*chooseColorHeight);
    text(chooseColor, 3*width/4, height/4 + 8*chooseColorHeight);
    textField3 = new GTextField(this, width/7, height/2 + chooseColorHeight, chooseColorWidth, chooseColorHeight);
    textField3.setPromptText(player + "3");
    text(left, width/7, height/2 + 4*chooseColorHeight);
    text(right, width/7, height/2 + 6*chooseColorHeight);  
    text(chooseColor, width/7, height/2 + 8*chooseColorHeight);
    textField4 = new GTextField(this, 3*width/4, height/2 + chooseColorHeight, chooseColorWidth, chooseColorHeight);
    textField4.setPromptText(player + "4");
    text(left, 3*width/4, height/2 + 4*chooseColorHeight);
    text(right, 3*width/4, height/2 + 6*chooseColorHeight);    
    text(chooseColor, 3*width/4, height/2 + 8*chooseColorHeight);

  
  //button for players to choose keys
    btnL1 = new GButton(this, width/7 + chooseColorWidth, height/4 + 3*chooseColorHeight, playerSize, playerSize, "1");
    btnR1 = new GButton(this, width/7 + chooseColorWidth, height/4 + 5*chooseColorHeight, 60, 30, "3");
    btnChooseColor1 = new GButton(this, width/7 + chooseColorWidth, height/4 + 7*chooseColorHeight, 60, 30, col);
    btnL2 = new GButton(this, 3*width/4 + chooseColorWidth, height/4 + 3*chooseColorHeight, 60, 30, "A");
    btnR2 = new GButton(this, 3*width/4 + chooseColorWidth, height/4 + 5*chooseColorHeight, 60, 30, "D"); 
    btnChooseColor2 = new GButton(this, 3*width/4 + chooseColorWidth, height/4 + 7*chooseColorHeight, 60, 30, col);   
    btnL3 = new GButton(this, width/7 + chooseColorWidth, height/2 + 3*chooseColorHeight, 60, 30, "J");
    btnR3 = new GButton(this, width/7 + chooseColorWidth, height/2 + 5*chooseColorHeight, 60, 30, "L"); 
    btnChooseColor3 = new GButton(this, width/7 + chooseColorWidth, height/2 + 7*chooseColorHeight, 60, 30, col); 
    btnL4 = new GButton(this, 3*width/4 + chooseColorWidth, height/2 + 3*chooseColorHeight, 60, 30, "4");
    btnR4 = new GButton(this, 3*width/4 + chooseColorWidth, height/2 + 5*chooseColorHeight, 60, 30, "6");   
    btnChooseColor4 = new GButton(this, 3*width/4 + chooseColorWidth, height/2 + 7*chooseColorHeight, 60, 30, col);

    float ruleWidth = textWidth(rule1);
    text(rule1, (width - ruleWidth)/2, height - 100);
    ruleWidth = textWidth(rule2);
    text(rule2, (width - ruleWidth)/2, height - 50);
    
    //positioning circles change to GButton
    fill(255, 0, 0);
    textSize(playerSize);
    float numOfPlayersWidth = textWidth(chooseNumOfPlayers);
    text(chooseNumOfPlayers, (width - numOfPlayersWidth)/2, height * 0.62);
    float numOfPlayersRadius = (numOfPlayersWidth - 100)/3;
    
    btn2Players = new GButton(this, (width - numOfPlayersWidth)/2 , 3*height/4 - numOfPlayersRadius/2, numOfPlayersRadius, numOfPlayersRadius, "2"); 
    btn3Players = new GButton(this, (width - numOfPlayersWidth)/2 + 50 + numOfPlayersRadius, 3*height/4 - numOfPlayersRadius/2, numOfPlayersRadius, numOfPlayersRadius, "3");
    btn4Players = new GButton(this, (width - numOfPlayersWidth)/2 + 100 + 2*numOfPlayersRadius, 3*height/4 - numOfPlayersRadius/2, numOfPlayersRadius, numOfPlayersRadius, "4");
    btn2Players.setLocalColor(4, color(255, 0, 0));
    btn3Players.setLocalColor(4, color(255, 0, 0));
    btn4Players.setLocalColor(4, color(255, 0, 0));
    btn2Players.setLocalColor(3, color(0, 0, 255));
    btn3Players.setLocalColor(3, color(0, 0, 255));
    btn4Players.setLocalColor(3, color(0, 0, 255));
    btnChooseColor1.setLocalColor(4, playerOne.getColor());
    btnChooseColor2.setLocalColor(4, playerTwo.getColor());
    btnChooseColor3.setLocalColor(4, playerThree.getColor());
    btnChooseColor4.setLocalColor(4, playerFour.getColor());


    //looping but not well.. Not continuous
    startSound.loop();
    
    
}

void draw() {
  //countdown before each round starts
    if(startCounter) {
        startCountdown();
    }
  //end of countdown
  
    if(startRound) {
      
        drawSideBar();
        for(Player p : listOfPlayers) 
            if(p.isAlive()) { 
                Move(p);
                checkIfCollision(p);
            }        
        
        drawAllPlayersCurrentPositions();
    }
    
    if(showColorPicker) {      
        drawColorPicker();
        drawLine();
        drawCross();
        drawActiveColor();
        drawValues();
        drawOK();   
        activeColor = color( LineY - ColorPickerY , CrossX - ColorPickerX , 255 - ( CrossY - ColorPickerY ) ); //set current active color

      }
      
  checkMouse();
}

private void startCountdown() {
        drawSideBar();
        if(millis() - startTime > 1000 && startInterval >= 0) {
            background(255);
            drawBackground(blackScreen);
            fill(127, 0, 0);
            text(str(startInterval - 1), (5*width/6)/2, (height - textWidth("0"))/2);
            startTime = millis();
            startInterval--;
        }
      
        if(startInterval == 0) {
            startCounter = false;
            drawBackground(blackScreen);
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

//drawing side bar every frame
private void drawSideBar() {
    //white rectangle first
    fill(255);
    rect(5*width/6, 0, width, height);
    
    //information about exit
    textSize(30);
    fill(127, 0, 0);
    text("Exit: esc", 6*width/7, height/10);

    //current score
    text("Rezultat:", 6*width/7, height/3);
    drawPlayerScore(playerOne, 30);
    drawPlayerScore(playerTwo, 60);
    if(numOfPlayers == 3 ||numOfPlayers == 4) {
        drawPlayerScore(playerThree, 90);
    }
    if(numOfPlayers == 4) {
        drawPlayerScore(playerFour, 120);
    }
    
    //buttons for black or white screen
    stroke(0, 0, 0);
    fill(255);
    ellipse(width * 0.9 + 50, height*0.2, 20, 20);
    fill(0);
    ellipse(width * 0.9, height*0.2, 20, 20);
}

private void drawPlayerScore(Player player, int distance) {
    float tw = textWidth("2");
    fill(player.getColor());
    text(player.getName() + ":", 6*width/7, height/3 + distance);
    text(player.getScore(), 6*width/7 + textWidth(player.getName()) + tw, height/3 + distance);
}

private boolean hasCrashed(Player player) {
      rectMode(CORNERS);

  for(int i = 0; i < rectangleSize; ++i) {
      for(int j = 0; j < rectangleSize; ++j) {
          color col = get(i + player.getX(), j + player.getY());
          if(col != color(255) && col != color(0)) return true;
      }
  }
   return false;
}

private void checkIfCollision(Player player) {
   if(player.isAlive() && (isPlayerOutOfScreen(player) || hasCrashed(player))) {
        playSound(Sound.CRASH);
               
                
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

private boolean isPlayerOutOfScreen(Player player) {
    if(player.getX() >= 5*width/6 || player.getX() <= 0 || player.getY() >= height || player.getY() <= 0) {
        return true;
    }
    return false;
}

private void announceRoundWinner(Player player) {
    playSound(Sound.CHEER);
    startRound = false;
    drawBackground(blackScreen);
    
    for(Player p : listOfPlayers) {
        drawWholePath(p);
    }
    
    fill(255);
    int pointsWon = (int)pow(2, numOfPlayers - playersLeft - 1);
    player.setScore(player.getScore() + pointsWon);
    float textWidth1 = textWidth("Igra završena! Pobjedio je " + player.getName());
    rect((width - textWidth1)/2, height/10, (width - textWidth1)/2 + textWidth1, height/10 + 40);
    fill(player.getColor());
    text("Igra završena! Pobjedio je " + player.getName(), (width - textWidth1)/2, height/10 + 35); 
    drawSideBar();
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

enum Sound {
  CRASH, CHEER, END_CHEER, START;
}

void playSound(Sound sound) {
  if(sound == Sound.CRASH) {
    crashSound.play();
    crashSound.rewind();
  } else if(sound == Sound.CHEER) {
    cheerSound.play();
    cheerSound.rewind();
  } else if(sound == Sound.END_CHEER) {
    endCheerSound.play();
  }
}

private void checkIfGameOver() {
    if(playerOne.getScore() >= numOfPointsForWin) {
      announceFinalWinner(playerOne);
    } else if(playerTwo.getScore() >= numOfPointsForWin) {
      announceFinalWinner(playerTwo);
    } else if(playerThree.getScore() >= numOfPointsForWin) {
      announceFinalWinner(playerThree);
    } else if(playerFour.getScore() >= numOfPointsForWin) {
      announceFinalWinner(playerFour);
    } else {
      drawAgainButton();
    }
}

private void drawAgainButton() {
      fill(0, 255, 0); //<>//
      ellipseMode(RADIUS);
      ellipse(11*width/12, height*0.8, width/20, width/20);
      fill(127, 0, 0);
      textSize(30);
      float textWidth = textWidth("Ponovo!");
      text("Ponovo!", 11*width/12 - textWidth/2, height*0.8 + 15);  
}

private void announceFinalWinner(Player player) {
      fill(player.getColor());
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth(player.getName() + "je pobjednik!");
      fill(0);
      text(player.getName() + " je pobjednik!", 5*width/12 - textWidth/2, height/2);
      endCheerSound.play();
      endOfGame = true;
}

void drawBackground(boolean blackScreen) {
   if(blackScreen) {
      fill(0);
   } else {
     fill(255);
   }
   rect(0, 0, 5*width/6, height);
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
    } else if(overButton(width * 0.9, height * 0.2, 20) && !frontPage) {
      if(!endOfGame) {
          blackScreen = true;
          drawBackground(blackScreen);
          for(Player p : listOfPlayers)
              drawWholePath(p);
      }
    } else if(overButton(width * 0.9 + 50, height * 0.2, 20) && !frontPage) {
       if(!endOfGame) {
           blackScreen = false;
           drawBackground(blackScreen);
           for(Player p : listOfPlayers)
              drawWholePath(p);
       }
    }
}

void initializePlayersOnStart() {
        for(Player p : listOfPlayers) {
          initializePlayer(p);
        }
        playersLeft = numOfPlayers;
}

private void initializePlayer(Player player) {
        player.setAlive(true);
        player.setDirection((int) random(1, 4.99));
        player.setX((int)random(width/5, 2*width/3));
        player.setY((int)random(height/5, 4*height/5));
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
    }/*else {
      setPlayerKeysCoded(playerOne, btnL1, Turn.LEFT);
      setPlayerKeysCoded(playerOne, btnR1, Turn.RIGHT);
      setPlayerKeysCoded(playerTwo, btnL2, Turn.LEFT);
      setPlayerKeysCoded(playerTwo, btnR2, Turn.RIGHT);
      setPlayerKeysCoded(playerThree, btnL3, Turn.LEFT);
      setPlayerKeysCoded(playerThree, btnR3, Turn.RIGHT);
      setPlayerKeysCoded(playerFour, btnL4, Turn.LEFT);
      setPlayerKeysCoded(playerFour, btnR4, Turn.RIGHT);
    }
    */
  }
}

private void changeDirection(Player player) {
  if(key != CODED) {
    if(key == player.getLeft() || key == Character.toLowerCase(player.getLeft())) {
          if(player.getDirection() == 1) 
              player.setDirection(4);
          else player.setDirection(player.getDirection() - 1);
    } else if (key == player.getRight() || key == Character.toLowerCase(player.getRight())) {
          if(player.getDirection() == 4) 
              player.setDirection(1);
          else player.setDirection(player.getDirection() + 1);
    }
  } /*else {
    if(keyCode == player.getLeftCoded()) {
      if(player.getDirection() == 1)
        player.setDirection(4);
      else player.setDirection(player.getDirection() - 1);
    } else if(keyCode == player.getRightCoded()) {
      if(player.getDirection() == 4) 
              player.setDirection(1);
          else player.setDirection(player.getDirection() + 1);
    }
  }
  */
}


enum Turn {
  LEFT, RIGHT;
}

private void setPlayerKeys(Player player, GButton button, Turn direction) {
    char wishedKey = Character.toUpperCase(key);
    String keyStr = wishedKey + "";

    if (button.hasFocus()) {
         button.setText(keyStr);
         if(direction == Turn.LEFT) player.setLeft(wishedKey);
         else player.setRight(wishedKey);
         button.setFocus(false);
    }
}

/*
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
       if(direction == Turn.LEFT) player.setLeftCoded(keyCode);
       else player.setRightCoded(keyCode);
       button.setFocus(false);
    }
}

*/

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
          playerOne.setName(textField1.getText().isEmpty() ? "Igrač 1" : textField1.getText());
          textField1.setVisible(false);
          playerTwo.setName(textField2.getText().isEmpty() ? "Igrač 2" : textField2.getText());
          textField2.setVisible(false);
          playerThree.setName(textField3.getText().isEmpty() ? "Igrač 3" : textField3.getText());
          textField3.setVisible(false);
          playerFour.setName(textField4.getText().isEmpty() ? "Igrač 4" : textField4.getText());
          textField4.setVisible(false);
    
          btnR1.setVisible(false);
          btnL1.setVisible(false);
          btnR2.setVisible(false);
          btnL2.setVisible(false);
          btnR3.setVisible(false);
          btnL3.setVisible(false);
          btnR4.setVisible(false);
          btnL4.setVisible(false);
          btnChooseColor1.setVisible(false);
          btnChooseColor2.setVisible(false);
          btnChooseColor3.setVisible(false);
          btnChooseColor4.setVisible(false);
          btn2Players.setVisible(false);
          btn3Players.setVisible(false);
          btn4Players.setVisible(false);
          
          btnStart.setVisible(false);
          if(numOfPlayers == 3) listOfPlayers.add(playerThree);
          if(numOfPlayers == 4) {
              listOfPlayers.add(playerThree);
              listOfPlayers.add(playerFour);
          }
      }
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
  } else if (button == btnChooseColor1) {
     showColorPicker = true;
     btnL1.setVisible(false);
     btnR1.setVisible(false);
     btnChooseColor1.setVisible(false);
     textField1.setVisible(false);
} else if (button == btnChooseColor2) {
  } else if (button == btnChooseColor3) {
  } else if (button == btnChooseColor4) {
  } else if (button == btnChooseColor1 && event == GEvent.CLICKED) {
  }// if
}
}
 