import ddf.minim.*;
import g4p_controls.*;

AudioPlayer crashSound; // playing and rewinding is called with method playSound(1)
AudioPlayer cheerSound; // 2
AudioPlayer startSound; // 
AudioPlayer endCheerSound; //3
Minim minim;//audio context

//choosing names
GTextField textField1;
GTextField textField2;
GTextField textField3;
GTextField textField4;

//choosing keys
GButton btnL1;
GButton btnR1;
GButton btnL2;
GButton btnR2;
GButton btnL3;
GButton btnR3;
GButton btnL4;
GButton btnR4;

boolean buttonPressed = false; // start button
boolean started = false;  // used for countdown
boolean frontPage = true; // am I on front page
boolean blackScreen = false; // do I want black board or white
boolean endOfGame = false; // Any player reached numOfPointsToWin;

int numOfPlayers; // starting number of players
int playersLeft; // how many players are alive at any time during the game

int numOfPointsForWin = 10; //final number of points to win

float buttonRadius;
float buttonCenterX;
float buttonCenterY;

Player playerOne;
Player playerTwo;
Player playerThree;
Player playerFour;

ArrayList<Player> listOfPlayers;

float numOfPlayersWidth; // width of string "Number of players: " used for positioning buttons on start screen.. Global because choosing a player is pressing button event  
float numOfPlayersRadius; //radius of buttons depends on width... Bad implementation

int secondsToStart = 4; // one bigger than it really is
int startInterval; // counter 
float startTime; // time calculated with millis() when button is pressed.. Used for countdown

//colors for gradient.. Copied from internet
color b1 = color(255);
color b2 = color(0);
color c1 = color(204, 102, 0);
color c2 = color(0, 102, 153);

class Player {
  private String name;
  private int x;
  private int y;
  private int direction;
  private color col;
  private int score;
  private boolean alive;
  private ArrayList<Pair> listOfPassedPoints;
  private char left;
  private char right;
//  private int leftCoded;
//  private int rightCoded;
  
 public Player(String name, int x, int y, int direction, color col) {
    this.name = name;
    this.x = x;
    this.y = y;
    this.direction = direction;
    this.col = col;
    score = 0;
    alive = false;
    listOfPassedPoints = new ArrayList<Pair>();
 }
 
 public Player(char left, char right) { 
   this("player", 0, 0, 1, color(0, 0, 0));
   this.left = left;
   this.right = right;
 }
 
 /*public Player(int leftCoded, int rightCoded) {
   this((char)0, (char)0);
   this.leftCoded = leftCoded;
   this.rightCoded = rightCoded;
 }
 */
 
 public String getName() {
   return name;
 }
 
 public void setName(String name) {
    this.name = name;
 }
 
 public int getX() {
   return x;
 }
 
 public int getY() {
   return y;
 }
 
 public void setX(int x) {
   this.x = x;
 }
 
 public void setY(int y) {
   this.y = y;
 }
 
 public int getDirection(){
   return direction;
 }
 
 public void setDirection(int direction) {
   this.direction = direction;
 }
 
 public color getColor() {
   return col;
 }
 
 public void setColor(color col) {
   this.col = col;
 }
 
  public int getScore() {
    return score;
  }
  
  public void setScore(int score) {
    this.score = score;
  }
  
  public boolean isAlive() {
    return alive;
  }
  
  public void setAlive(boolean alive) {
    this.alive = alive;
  }
  
  public void updateList(Pair p) {
     listOfPassedPoints.add(p);
  }
  
  public ArrayList<Pair> getListOfPassedPoints() {
    return listOfPassedPoints;
  }
  
  public char getLeft() {
    return left;
  }
  
  public void setLeft(char c) {
    this.left = c;
  }
  
  public char getRight() {
    return right;
  }
  
  public void setRight(char c) {
    this.right = c;
  }
  
 /*   public int getLeftCoded() {
    return leftCoded;
  }
  
  public void setLeftCoded(int c) {
    this.leftCoded = c;
  }
  
  public int getRightCoded() {
    return rightCoded;
  }
  
  public void setRightCoded(int c) {
    this.rightCoded = c;
  }
  */
}

//Java has its own implementation of pair.. Should change
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
    frameRate(200);
    
    playerOne = new Player((char)49, (char)51); // 1, 3
    playerTwo = new Player((char)65,(char)68); // A, D
    playerThree = new Player((char)74,(char)76); // J, L
    playerFour = new Player((char)52,(char)54); // 4, 6

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
    
    //startButton
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
    float textWidth30 = textWidth("Lijevo: A");
    float textHeight30 = textAscent() - textDescent();
    textField1 = new GTextField(this, width/7, height/4 + textHeight30, textWidth30, textHeight30);
    textField1.setPromptText("Igrač 1");
    text("Lijevo: ", width/7, height/4 + 4*textHeight30);
    text("Desno: ", width/7, height/4 + 6*textHeight30);  
    textField2 = new GTextField(this, 3*width/4, height/4 + textHeight30, textWidth30, textHeight30);
    textField2.setPromptText("Igrač 2");
    text("Lijevo: ", 3*width/4, height/4 + 4*textHeight30);
    text("Desno: ", 3*width/4, height/4 + 6*textHeight30);
    textField3 = new GTextField(this, width/7, height/2 + textHeight30, textWidth30, textHeight30);
    textField3.setPromptText("Igrač 3");
    text("Lijevo: ", width/7, height/2 + 4*textHeight30);
    text("Desno: ", width/7, height/2 + 6*textHeight30);  
    textField4 = new GTextField(this, 3*width/4, height/2 + textHeight30, textWidth30, textHeight30);
    textField4.setPromptText("Igrač 4");
    text("Lijevo: ", 3*width/4, height/2 + 4*textHeight30);
    text("Desno: ", 3*width/4, height/2 + 6*textHeight30);
  
  //button for players to choose keys
    btnL1 = new GButton(this, width/7 + textWidth30, height/4 + 3*textHeight30, 60, 30, "1");
    btnR1 = new GButton(this, width/7 + textWidth30, height/4 + 5*textHeight30, 60, 30, "3");
    btnL2 = new GButton(this, 3*width/4 + textWidth30, height/4 + 3*textHeight30, 60, 30, "A");
    btnR2 = new GButton(this, 3*width/4 + textWidth30, height/4 + 5*textHeight30, 60, 30, "D"); 
    btnL3 = new GButton(this, width/7 + textWidth30, height/2 + 3*textHeight30, 60, 30, "J");
    btnR3 = new GButton(this, width/7 + textWidth30, height/2 + 5*textHeight30, 60, 30, "L"); 
    btnL4 = new GButton(this, 3*width/4 + textWidth30, height/2 + 3*textHeight30, 60, 30, "4");
    btnR4 = new GButton(this, 3*width/4 + textWidth30, height/2 + 5*textHeight30, 60, 30, "6");


    textWidth = textWidth("Pravila: Upravljati svojom zmijicom i izbjegavati tragove koje ostavljaju ostale zmijice.");
    text("Pravila: Upravljati svojom zmijicom i izbjegavati tragove koje ostavljaju ostale zmijice.", (width - textWidth)/2, height - 100);
    textWidth = textWidth("Pobjednik je igrač koji duže preživi. Prvi igrač do 10 bodova pobjeđuje.");
    text("Pobjednik je igrač koji duže preživi. Prvi igrač do 10 bodova pobjeđuje.", (width - textWidth)/2, height - 50);
    
    fill(127, 0, 0);
    textWidth = textWidth("START");
    text("START", buttonCenterX - textWidth/2, buttonCenterY + 15);
    
    //positioning circles change to GButton
    fill(255, 0, 0);
    numOfPlayersWidth = textWidth("Odaberite broj igrača: ");
    text("Odaberite broj igrača: ", (width - numOfPlayersWidth)/2, height * 0.62);
    numOfPlayersRadius = (numOfPlayersWidth - 20)/6;
    ellipse((width - numOfPlayersWidth)/2 + numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
    ellipse((width - numOfPlayersWidth)/2 + 10 + 3*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
    ellipse((width - numOfPlayersWidth)/2 + 20 + 5*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
    
    //positioning number 2,3,4 in the center of circles
    textSize(40);
    fill(0, 0, 255);
    text("2", (width - numOfPlayersWidth - textWidth("2"))/2 + numOfPlayersRadius, 3*height/4 + (textAscent() - textDescent()) / 2);
    text("3", (width - numOfPlayersWidth - textWidth("3"))/2 + 10 + 3*numOfPlayersRadius, 3*height/4 + (textAscent() - textDescent()) / 2);
    text("4", (width - numOfPlayersWidth - textWidth("4"))/2 + 20 + 5*numOfPlayersRadius, 3*height/4 + (textAscent() - textDescent()) / 2);
  
    playerOne.setColor(color(255, 0, 0));
    playerTwo.setColor(color(0, 0, 255));
    playerThree.setColor(color(0, 255, 0));
    playerFour.setColor(color(255, 0, 255));
    
    //looping but not well.. Not continuous
    startSound.loop();
    
}

void draw() {
  //countdown before each round starts
    if(started) {
        startCountdown();
    }
  //end of countdown
  
    if(buttonPressed) {
      //move each player if he is alive based on his direction and adding current position in the list of passed points
        ifAliveMove(playerOne);
        ifAliveMove(playerTwo);
        ifAliveMove(playerThree);
        ifAliveMove(playerFour);
        
        //changing screen black or white
        drawBackground(blackScreen);
        
        drawSideBar();
        drawAllPoints();
        checkIfCollision();
    }
}

private void startCountdown() {
        drawSideBar();
        if(millis() - startTime > 1000 && startInterval >= 0) {
            drawBackground(blackScreen);
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

private void ifAliveMove(Player player) {
    if(player.isAlive()) {  
      switch(player.getDirection()) {
        case 1: player.setX(player.getX() - 1);
                break;
        case 2: player.setY(player.getY() - 1);
                break;
        case 3: player.setX(player.getX() + 1);
                break;
        case 4: player.setY(player.getY() + 1); 
                break;    
      }
      player.updateList(new Pair(player.getX(), player.getY())); 
    }
}

//drawing side bar every frame
private void drawSideBar() {
    //white rectangle first
    fill(255);
    rect(5*width/6, 0, width/6, height);
    
    //information about exit
    textSize(30);
    fill(127, 0, 0);
    text("Exit: esc", 6*width/7, height/10);
    rect(5*width/6, 0, 5, height);

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

private boolean hasCrashedIntoOtherPlayer(Player player) {
   for(Player p : listOfPlayers) {
     if(player != p && p.getListOfPassedPoints().contains(new Pair(player.getX(), player.getY()))) return true;
   }
     return false;
}

private boolean hasCrashedIntoSelf(Player player) {
    Pair p = new Pair(player.getX(), player.getY());
    if(player.getListOfPassedPoints().subList(0, player.getListOfPassedPoints().size()-1).contains(p)) return true;
    return false;
}

void checkIfCollision() {
    checkIfCollision(playerOne);
    checkIfCollision(playerTwo);
    checkIfCollision(playerThree);
    checkIfCollision(playerFour);
    checkPlayerOutOfScreen(playerOne);
    checkPlayerOutOfScreen(playerTwo);
    checkPlayerOutOfScreen(playerThree);
    checkPlayerOutOfScreen(playerFour);
}

private void checkIfCollision(Player player) {
   if(player.isAlive() && (hasCrashedIntoOtherPlayer(player) || hasCrashedIntoSelf(player))) {
        //if crash play crash sound
        playSound(1);
        // if first to die get 0 points, if second to die get 1 point etc (exponents of number 2).. If n players were in the game winner of round wins 2^(n-2) points
        player.setScore(player.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        player.setAlive(false);
        if(playersLeft == 1) {
          for(Player p : listOfPlayers) {
            if(player != p && p.isAlive()) announceRoundWinner(p);
          }
        }
    }
}

void playSound(int n) {
  if(n == 1) {
    crashSound.play();
    crashSound.rewind();
  } else if(n == 2) {
    cheerSound.play();
    cheerSound.rewind();
  } else if(n == 3) {
    endCheerSound.play();
  }
}


void checkPlayerOutOfScreen(Player player) {
  //for each player check the boundaries play sound, increase the score, kill the player who crosses the boundaries, if it is the last player to die announce the winner
    if(player.isAlive() && (player.getX() >= 5*width/6 || player.getX() <= 0 || player.getY() >= height || player.getY() <= 0)) {
        playSound(1);
        player.setScore(player.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        player.setAlive(false);
        if(playersLeft == 1) {
         for(Player p : listOfPlayers) {
            if(player != p && p.isAlive()) announceRoundWinner(p);
          }
        }
    }
}

private void announceRoundWinner(Player player) {
    playSound(2);
    buttonPressed = false;
    drawBackground(blackScreen);
    drawAllPoints();
    fill(255);
    player.setScore(player.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
    float textWidth1 = textWidth("Igra završena! Pobjedio je " + player.getName());
    rect((width - textWidth1)/2, height/10, textWidth1, 40);
    fill(player.getColor());
    text("Igra završena! Pobjedio je " + player.getName(), (width - textWidth1)/2, height/10 + 35); 
    drawSideBar();
    checkIfGameOver();
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
      fill(0, 255, 0);
      ellipseMode(RADIUS);
      ellipse(11*width/12, height*0.8, buttonRadius, buttonRadius);
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

void drawAllPoints() {
    drawPlayer(playerOne);
    drawPlayer(playerTwo);
    if(numOfPlayers == 3 || numOfPlayers == 4) {
      drawPlayer(playerThree);
    }
    if(numOfPlayers == 4) {
      drawPlayer(playerFour);
    }
}

private void drawPlayer(Player player) {
  fill(player.getColor());
      stroke(player.getColor());
      for(Pair p : player.getListOfPassedPoints()) {
        ellipse(p.getX(), p.getY(), 5, 5);
      }
}

void mousePressed() {
    if((overButton(buttonCenterX, buttonCenterY, buttonRadius) && !started && !buttonPressed) || (!endOfGame && !buttonPressed && !started && overButton(11*width/12, height*0.8, buttonRadius) && !frontPage)) {
        if(frontPage) {
          playerOne.setName(textField1.getText().isEmpty() ? "Igrač 1" : textField1.getText());
          textField1.setVisible(false);
          playerTwo.setName(textField2.getText().isEmpty() ? "Igrač 2" : textField2.getText());
          textField2.setVisible(false);
          playerThree.setName(textField3.getText().isEmpty() ? "Igrač 3" : textField3.getText());
          textField3.setVisible(false);
          playerFour.setName(textField4.getText().isEmpty() ? "Igrač 4" : textField4.getText());
          textField4.setVisible(false);
          btnL1.setVisible(false);
          btnR1.setVisible(false);
          btnL2.setVisible(false);
          btnR2.setVisible(false);
          btnL3.setVisible(false);
          btnR3.setVisible(false);
          btnL4.setVisible(false);
          btnR4.setVisible(false);
        }
        startSound.close();
        started = true;  
        initializePlayersOnStart();
        startTime = millis();
        playerOne.getListOfPassedPoints().clear();
        playerTwo.getListOfPassedPoints().clear();
        playerThree.getListOfPassedPoints().clear();
        playerFour.getListOfPassedPoints().clear();
        startInterval = secondsToStart;
        drawBackground(blackScreen);
        frontPage = false;
    } else if(overButton(width * 0.9, height * 0.2, 20) && !frontPage) {
      if(!endOfGame) {
          blackScreen = true;
          drawBackground(blackScreen);
          drawAllPoints();
      }
    } else if(overButton(width * 0.9 + 50, height * 0.2, 20) && !frontPage) {
       if(!endOfGame) {
           blackScreen = false;
           drawBackground(blackScreen);
           drawAllPoints();
       }
    } else  chooseNumberOfPlayers();
    
}

void initializePlayersOnStart() {
        initializePlayer(playerOne);
        initializePlayer(playerTwo);
        if(numOfPlayers == 3 || numOfPlayers == 4) {
            initializePlayer(playerThree);
        }
        if(numOfPlayers == 4) {
          initializePlayer(playerFour);
        }
        playersLeft = numOfPlayers;
}

private void initializePlayer(Player player) {
        player.setAlive(true);
        player.setDirection((int) random(1, 4.99));
        player.setX((int)random(width/5, 2*width/3));
        player.setY((int)random(height/5, 4*height/5));
} 

void chooseNumberOfPlayers() {
 if(overButton((width - numOfPlayersWidth)/2 + 10 + 3*numOfPlayersRadius, 3*height/4, numOfPlayersRadius) && frontPage && !started && !buttonPressed) {
      fill(0, 255, 0);
      ellipse((width - numOfPlayersWidth)/2 + 10 + 3*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      fill(255, 0, 0);
      ellipse((width - numOfPlayersWidth)/2 + numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      ellipse((width - numOfPlayersWidth)/2 + 20 + 5*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      writeTexts();
      numOfPlayers = 3;
      playersLeft = 3;
    } else if(overButton((width - numOfPlayersWidth)/2 + 20 + 5*numOfPlayersRadius, 3*height/4, numOfPlayersRadius) && frontPage && !started && !buttonPressed) {
      fill(0, 255, 0);
      ellipse((width - numOfPlayersWidth)/2 + 20 + 5*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      fill(255, 0, 0);
      ellipse((width - numOfPlayersWidth)/2 + numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      ellipse((width - numOfPlayersWidth)/2 + 10 + 3*numOfPlayersRadius, 3*height/4, numOfPlayersRadius, numOfPlayersRadius);
      writeTexts();
      numOfPlayers = 4;
      playersLeft = 4;
    } else if(overButton((width - numOfPlayersWidth)/2 + numOfPlayersRadius, 3*height/4, numOfPlayersRadius) && frontPage && !started && !buttonPressed) {
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

void handleButtonEvents(GButton button, GEvent event) {
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