import ddf.minim.*;
import g4p_controls.*;

AudioPlayer crashSound; // playing and rewinding is called with method playSound(1)
AudioPlayer cheerSound; // 2
AudioPlayer startSound; // 
AudioPlayer endCheerSound; //3
Minim minim;//audio context

GTextField textField1;
GTextField textField2;
GTextField textField3;
GTextField textField4;

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
 
 public Player() { 
   this("player", 0, 0, 1, color(0, 0, 0));
 }
 
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
    
    playerOne = new Player();
    playerTwo = new Player();
    playerThree = new Player();
    playerFour = new Player();
    playerOne.setName("Igrač 1");
    playerTwo.setName("Igrač 2");
    playerThree.setName("Igrač 3");
    playerFour.setName("Igrač 4");
    
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
    
    
//should allow players to choose keys
    textSize(30);
    float textWidth30 = textWidth("Lijevo: A");
    float textHeight30 = textAscent() - textDescent();
    textField1 = new GTextField(this, width/7, height/4 + textHeight30, textWidth30, textHeight30);
    textField1.setPromptText("Igrač 1");
    text("Lijevo: <-", width/7, height/4 + 4*textHeight30);
    text("Desno: ->", width/7, height/4 + 6*textHeight30);  
    textField2 = new GTextField(this, 3*width/4, height/4 + textHeight30, textWidth30, textHeight30);
    textField2.setPromptText("Igrač 2");
    text("Lijevo: A", 3*width/4, height/4 + 4*textHeight30);
    text("Desno: D", 3*width/4, height/4 + 6*textHeight30);
    textField3 = new GTextField(this, width/7, height/2 + textHeight30, textWidth30, textHeight30);
    textField3.setPromptText("Igrač 3");
    text("Lijevo: J", width/7, height/2 + 4*textHeight30);
    text("Desno: K", width/7, height/2 + 6*textHeight30);  
    textField4 = new GTextField(this, 3*width/4, height/2 + textHeight30, textWidth30, textHeight30);
    textField4.setPromptText("Igrač 4");
    text("Lijevo: 4", 3*width/4, height/2 + 4*textHeight30);
    text("Desno: 6", 3*width/4, height/2 + 6*textHeight30);
  
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
  //end of countdown
  
    if(buttonPressed) {
      //move each player if he is alive based on his direction and adding current position in the list of passed points
      if(playerOne.isAlive()) {
        switch(playerOne.getDirection()) {
            case 1: playerOne.setX(playerOne.getX() - 1);
                    break;
            case 2: playerOne.setY(playerOne.getY() - 1);
                    break;
            case 3: playerOne.setX(playerOne.getX() + 1);
                    break;
            case 4: playerOne.setY(playerOne.getY() + 1); 
                    break;    
        }
        playerOne.updateList(new Pair(playerOne.getX(), playerOne.getY()));
      }
      if(playerTwo.isAlive()) {
        switch(playerTwo.getDirection()) {
            case 1: playerTwo.setX(playerTwo.getX() - 1);
                    break;
            case 2: playerTwo.setY(playerTwo.getY() - 1);
                    break;
            case 3: playerTwo.setX(playerTwo.getX() + 1);
                    break;
            case 4: playerTwo.setY(playerTwo.getY() + 1); 
                    break; 
        }
        playerTwo.updateList(new Pair(playerTwo.getX(), playerTwo.getY()));
      }
        if(playerThree.isAlive()) {
          switch(playerThree.getDirection()) {
            case 1: playerThree.setX(playerThree.getX() - 1);
                    break;
            case 2: playerThree.setY(playerThree.getY() - 1);
                    break;
            case 3: playerThree.setX(playerThree.getX() + 1);
                    break;
            case 4: playerThree.setY(playerThree.getY() + 1); 
                    break; 
          }
          playerThree.updateList(new Pair(playerThree.getX(), playerThree.getY()));
        }
        
        if(playerFour.isAlive()) {
        switch(playerFour.getDirection()) {
            case 1: playerFour.setX(playerFour.getX() - 1);
                    break;
            case 2: playerFour.setY(playerFour.getY() - 1);
                    break;
            case 3: playerFour.setX(playerFour.getX() + 1);
                    break;
            case 4: playerFour.setY(playerFour.getY() + 1); 
                    break; 
        }
        playerFour.updateList(new Pair(playerFour.getX(), playerFour.getY()));
        }
        
        //changing screen black or white
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

//drawing side bar every frame
void drawSideBar() {
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
    float tw = textWidth("2");
    fill(playerOne.getColor());
    text(playerOne.getName() + ":", 6*width/7, height/3 + 30);
    text(playerOne.getScore(), 6*width/7 + textWidth(playerOne.getName()) + tw, height/3 + 30);
    fill(playerTwo.getColor());
    text(playerTwo.getName() + ":", 6*width/7, height/3 + 60);
    text(playerTwo.getScore(), 6*width/7 + textWidth(playerTwo.getName()) + tw, height/3 + 60);
    if(numOfPlayers == 3 ||numOfPlayers == 4) {
    fill(playerThree.getColor());
    text(playerThree.getName() + ":", 6*width/7, height/3 + 90);
    text(playerThree.getScore(), 6*width/7 + textWidth(playerThree.getName()) + tw, height/3 + 90);
    }
    if(numOfPlayers == 4) {
      fill(playerFour.getColor());
      text(playerFour.getName() + ":", 6*width/7, height/3 + 120);
      text(playerFour.getScore(), 6*width/7 + textWidth(playerFour.getName()) + tw, height/3 + 120);
    }
    
    //buttons for black or white screen
    stroke(0, 0, 0);
    fill(255);
    ellipse(width * 0.9 + 50, height*0.2, 20, 20);
    fill(0);
    ellipse(width * 0.9, height*0.2, 20, 20);
}

void checkIfCollision() {
  //current positions
    Pair playerOnePos = new Pair(playerOne.getX(), playerOne.getY());
    Pair playerTwoPos = new Pair(playerTwo.getX(), playerTwo.getY());
    Pair playerThreePos = new Pair(playerThree.getX(), playerThree.getY());
    Pair playerFourPos = new Pair(playerFour.getX(), playerFour.getY());
    
    //checking if players current position is in list of passed points of other players or itself.. only worth checking if player is alive.. if this happens player is dead
    if(playerOne.isAlive() && ( playerFour.getListOfPassedPoints().contains(playerOnePos) || playerThree.getListOfPassedPoints().contains(playerOnePos) ||
    playerTwo.getListOfPassedPoints().contains(playerOnePos) || playerOne.getListOfPassedPoints().subList(0, playerOne.getListOfPassedPoints().size()-1).contains(playerOnePos))) {
        //if crash play crash sound
        playSound(1);
        // if first to die get 0 points, if second to die get 1 point etc (exponents of number 2).. If n players were in the game winner of round wins 2^(n-2) points
        playerOne.setScore(playerOne.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        playerOne.setAlive(false);
        if(playersLeft == 1) {
          if(playerTwo.isAlive()) gameOverWinnerIs(playerTwo);
          else if(playerThree.isAlive()) gameOverWinnerIs(playerThree);
          else if(playerFour.isAlive()) gameOverWinnerIs(playerFour);
        }
    } else if(playerTwo.isAlive() && (playerFour.getListOfPassedPoints().contains(playerTwoPos) || playerThree.getListOfPassedPoints().contains(playerTwoPos) 
    ||playerOne.getListOfPassedPoints().contains(playerTwoPos) || playerTwo.getListOfPassedPoints().subList(0, playerTwo.getListOfPassedPoints().size()-1).contains(playerTwoPos))) {
        playSound(1);
        playerTwo.setScore(playerTwo.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        playerTwo.setAlive(false);
        if(playersLeft == 1) {
          if(playerOne.isAlive()) gameOverWinnerIs(playerOne);
          else if(playerThree.isAlive()) gameOverWinnerIs(playerThree);
          else if(playerFour.isAlive()) gameOverWinnerIs(playerFour);
        }
    } else if(playerThree.isAlive() && (numOfPlayers == 3 || numOfPlayers == 4) && (playerFour.getListOfPassedPoints().contains(playerThreePos) 
    || playerOne.getListOfPassedPoints().contains(playerThreePos) || playerTwo.getListOfPassedPoints().contains(playerThreePos) 
    || playerThree.getListOfPassedPoints().subList(0, playerThree.getListOfPassedPoints().size()-1).contains(playerThreePos))) {
        playSound(1);
        playerThree.setScore(playerThree.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        playerThree.setAlive(false);
        if(playersLeft == 1) {
          if(playerOne.isAlive()) gameOverWinnerIs(playerOne);
          else if(playerTwo.isAlive()) gameOverWinnerIs(playerTwo);
          else if(playerFour.isAlive()) gameOverWinnerIs(playerFour);
        }
    } else if(playerFour.isAlive() && numOfPlayers == 4 && (playerOne.getListOfPassedPoints().contains(playerFourPos) || playerTwo.getListOfPassedPoints().contains(playerFourPos)
    || playerThree.getListOfPassedPoints().contains(playerFourPos) 
    || playerFour.getListOfPassedPoints().subList(0, playerFour.getListOfPassedPoints().size()-1).contains(playerFourPos))) {
        playSound(1);
        playerFour.setScore(playerFour.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        playerFour.setAlive(false);
        if(playersLeft == 1) {
          if(playerOne.isAlive()) gameOverWinnerIs(playerOne);
          else if(playerTwo.isAlive()) gameOverWinnerIs(playerTwo);
          else if(playerThree.isAlive()) gameOverWinnerIs(playerThree);
        }
    };
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

void checkPlayerOutOfScreen() {
  //for each player check the boundaries play sound, increase the score, kill the player who crosses the boundaries, if it is the last player to die announce the winner
    if(playerOne.isAlive() && (playerOne.getX() >= 5*width/6 || playerOne.getX() <= 0 || playerOne.getY() >= height || playerOne.getY() <= 0)) {
        playSound(1);
        playerOne.setScore(playerOne.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        playerOne.setAlive(false);
        if(playersLeft == 1) {
          if(playerTwo.isAlive()) gameOverWinnerIs(playerTwo);
          else if(playerThree.isAlive()) gameOverWinnerIs(playerThree);
          else if(playerFour.isAlive()) gameOverWinnerIs(playerFour);
        }
    } else if (playerTwo.isAlive() && (playerTwo.getX() >= 5*width/6 || playerTwo.getX() <= 0 || playerTwo.getY() >= height || playerTwo.getY() <= 0)) {
        playSound(1);
        playerTwo.setScore(playerTwo.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        playerTwo.setAlive(false);
         if(playersLeft == 1) {
          if(playerOne.isAlive()) gameOverWinnerIs(playerOne);
          else if(playerThree.isAlive()) gameOverWinnerIs(playerThree);
          else if(playerFour.isAlive()) gameOverWinnerIs(playerFour);
        }
    } else if (playerThree.isAlive() && (numOfPlayers == 3 || numOfPlayers == 4) && (playerThree.getX() >= 5*width/6
    || playerThree.getX() <= 0 || playerThree.getY() >= height ||playerThree.getY() <= 0)) {
        playSound(1);
        playerThree.setScore(playerThree.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        playerThree.setAlive(false);
        if(playersLeft == 1) {
          if(playerOne.isAlive()) gameOverWinnerIs(playerOne);
          else if(playerTwo.isAlive()) gameOverWinnerIs(playerTwo);
          else if(playerFour.isAlive()) gameOverWinnerIs(playerFour);
        }
    } else if (playerFour.isAlive() && numOfPlayers == 4 && (playerFour.getX() >= 5*width/6 || playerFour.getX() <= 0 || playerFour.getY() >= height || playerFour.getY() <= 0)) {
        playSound(1);
        playerFour.setScore(playerFour.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
        playersLeft--;
        playerFour.setAlive(false);
        if(playersLeft == 1) {
          if(playerOne.isAlive()) gameOverWinnerIs(playerOne);
          else if(playerTwo.isAlive()) gameOverWinnerIs(playerTwo);
          else if(playerThree.isAlive()) gameOverWinnerIs(playerThree);
        }
    }
}

void gameOverWinnerIs(Player player) {
    //cheer
    playSound(2);
    //hold the draw loop
    buttonPressed = false;
    drawBackground();
    drawAllPoints();
    fill(255);
    
    player.setScore(player.getScore() + (int)pow(2, numOfPlayers - playersLeft - 1));
    float textWidth1 = textWidth("Igra završena! Pobjedio je " + player.getName());
    rect((width - textWidth1)/2, height/10, textWidth1, 40);
    fill(player.getColor());
    text("Igra završena! Pobjedio je " + player.getName(), (width - textWidth1)/2, height/10 + 35);
    
    drawSideBar();
    if(playerOne.getScore() >= numOfPointsForWin) {
      fill(playerOne.getColor());
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth(playerOne.getName() + "je pobjednik!");
      fill(0);
      text(playerOne.getName() + " je pobjednik!", 5*width/12 - textWidth/2, height/2);
      endCheerSound.play();
      endOfGame = true;
    } else if(playerTwo.getScore() >= numOfPointsForWin) {
      fill(playerTwo.getColor());
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth(playerTwo.getName() + "je pobjednik!");
      fill(0);
      text(playerTwo.getName() + " je pobjednik!", 5*width/12 - textWidth/2, height/2);
      endCheerSound.play();
      endOfGame = true;
    } else if(playerThree.getScore() >= numOfPointsForWin) {
      fill(playerThree.getColor());
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth(playerThree.getName() + "je pobjednik!");  
      fill(0);
      text(playerThree.getName() + " je pobjednik!", 5*width/12 - textWidth/2, height/2);
      endCheerSound.play();
      endOfGame = true;
    } else if(playerFour.getScore() >= numOfPointsForWin) {
      fill(playerFour.getColor());
      rect(0, 0, 5*width/6, height);
      float textWidth = textWidth(playerFour.getName() + "je pobjednik!");
      fill(0);
      text(playerFour.getName() + " je pobjednik!", 5*width/12 - textWidth/2, height/2);
      endCheerSound.play();
      endOfGame = true;
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
    fill(playerOne.getColor());
    stroke(playerOne.getColor());
    for(Pair p : playerOne.getListOfPassedPoints()) {
        ellipse(p.getX(), p.getY(), 5, 5);
    }
    fill(playerTwo.getColor()); 
    stroke(playerTwo.getColor());
    for(Pair p : playerTwo.getListOfPassedPoints()) {
        ellipse(p.getX(), p.getY(), 5, 5);
    }
    if(numOfPlayers == 3 || numOfPlayers == 4) {
      fill(playerThree.getColor());
      stroke(playerThree.getColor());
      for(Pair p : playerThree.getListOfPassedPoints()) {
        ellipse(p.getX(), p.getY(), 5, 5);
      }
    }
    if(numOfPlayers == 4) {
      fill(playerFour.getColor());
      stroke(playerFour.getColor());
      for(Pair p : playerFour.getListOfPassedPoints()) {
        ellipse(p.getX(), p.getY(), 5, 5);
      }
    }
}



void mousePressed() {
    if((overButton(buttonCenterX, buttonCenterY, buttonRadius) && !buttonPressed) || (!endOfGame && !buttonPressed && !started && overButton(11*width/12, height*0.8, buttonRadius) && !frontPage)) {
        if(frontPage) {
          playerOne.setName(textField1.getText().isEmpty() ? "Igrač 1" : textField1.getText());
          textField1.setVisible(false);
          playerTwo.setName(textField2.getText().isEmpty() ? "Igrač 2" : textField2.getText());
          textField2.setVisible(false);
          playerThree.setName(textField3.getText().isEmpty() ? "Igrač 3" : textField3.getText());
          textField3.setVisible(false);
          playerFour.setName(textField4.getText().isEmpty() ? "Igrač 4" : textField4.getText());
          textField4.setVisible(false);
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
        background(255);
        drawBackground();
        frontPage = false;
    } else if(overButton(width * 0.9, height * 0.2, 20) && !frontPage) {
      if(!endOfGame) {
          blackScreen = true;
          drawBackground();
          drawAllPoints();
      }
    } else if(overButton(width * 0.9 + 50, height * 0.2, 20) && !frontPage) {
       if(!endOfGame) {
           blackScreen = false;
           drawBackground();
           drawAllPoints();
       }
    } else  chooseNumberOfPlayers();
    
}

void initializePlayersOnStart() {
   playerOne.setAlive(true);
        playerTwo.setAlive(true);
        playerOne.setX((int)random(width/5, 2*width/3));
        playerOne.setY((int)random(height/5, 4*height/5));
        playerTwo.setX((int)random(width/5, 2*width/3));
        playerTwo.setY((int)random(height/5, 4*height/5));
        if(numOfPlayers == 3 || numOfPlayers == 4) {
            playerThree.setX((int)random(width/5, 2*width/3));
            playerThree.setY((int)random(height/5, 4*height/5));
            playerThree.setDirection((int) random(1, 4.99));
            playerThree.setAlive(true);
        }
        if(numOfPlayers == 4) {
          playerFour.setX((int)random(width/5, 2*width/3));
          playerFour.setY((int)random(height/5, 4*height/5));
          playerFour.setDirection((int) random(1, 4.99));
          playerFour.setAlive(true);
        }
        playersLeft = numOfPlayers;
        playerOne.setDirection((int) random(1, 4.99));
        playerTwo.setDirection((int) random(1, 4.99)); 
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
        if(playerTwo.getDirection() == 4) 
            playerTwo.setDirection(1);
        else playerTwo.setDirection(playerTwo.getDirection() + 1);
    }
    if(key == 'A' || key == 'a') {
        if(playerTwo.getDirection() == 1) 
            playerTwo.setDirection(4);
        else playerTwo.setDirection(playerTwo.getDirection() -1);
    }
    if(key == CODED && keyCode == RIGHT) {
        if(playerOne.getDirection() == 4) 
            playerOne.setDirection(1);
        else playerOne.setDirection(playerOne.getDirection() + 1);
    }
    if(key == CODED && keyCode == LEFT) {
        if(playerOne.getDirection() == 1) 
            playerOne.setDirection(4);
        else playerOne.setDirection(playerOne.getDirection() -1);
    }
    if(numOfPlayers == 3 ||numOfPlayers == 4) {
      if(key == 'J' || key == 'j') {
        if(playerThree.getDirection() == 1) 
            playerThree.setDirection(4);
        else playerThree.setDirection(playerThree.getDirection() -1);
      }
      if(key == 'K' || key == 'k') {
      if(playerThree.getDirection() == 4) 
            playerThree.setDirection(1);
        else playerThree.setDirection(playerThree.getDirection() + 1);
      }
    }
    if(numOfPlayers == 4) {
      if(key == '4') {
       if(playerFour.getDirection() == 1) 
            playerFour.setDirection(4);
        else playerFour.setDirection(playerFour.getDirection() -1);
      }
      if(key == '6') {
        if(playerFour.getDirection() == 4) 
            playerFour.setDirection(1);
        else playerFour.setDirection(playerFour.getDirection() + 1);
      }
    }
}