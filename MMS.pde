import processing.video.*; //<>// //<>// //<>//
import ddf.minim.*;
import g4p_controls.*;
import java.lang.reflect.Method;

AudioPlayer crashSound, cheerSound, startSound, endCheerSound;
Minim minim;//audio context

Movie loadingVideo;
int startVideo;

PImage redBackground, xmasBackground, dirtyPaperBackground, symmetricalBackground, currentBackground, oilCanvas, blueStamp, redStamp, greenStamp,
       purpleStamp, snowTexture, blackTexture, parquetTexture, brownTexture, yellowTexture, currentTexture, frontPageBackground, newGameBackground;
PGraphics mask1, mask2;

PFont titleFont, menuFont, menuFontBold, normalFont;

boolean startRound = false; // start button
boolean startCounter = false;  // used for countdown
boolean frontScreen = true; // am I on front page
boolean newGame = false;
boolean endOfGame = false; // Any player reached numOfPointsToWin;
boolean fillPlayerScreen = false;
boolean betweenRounds;

boolean playVideo;
boolean player1Screen, player2Screen, player3Screen, player4Screen;

float textWidth;
float textHeight;

int numOfPlayers; // starting number of players
int playersLeft; // how many players are alive at any time during the game

int numOfPointsForWin = 30; //final number of points to win

Player playerOne, playerTwo, playerThree, playerFour;

ArrayList<Player> listOfPlayers;

int secondsToStart = 3;
int startInterval; // counter
float startTime; // time calculated with millis() when button is pressed.. Used for countdown

Booster speed, size, changeKeys;

//colors for gradient.. Copied from internet
color b1 = color(255);
color b2 = color(0);
color c1 = color(204, 102, 0);
color c2 = color(0, 102, 153);

//choosing names
GTextField nameField;

GButton btnLeft, btnRight;
GButton btn2Players, btn3Players, btn4Players;

Class[] parameterTypes;

void setup() {
   // size(900,600);
    fullScreen();
    frameRate(20);
    
    rectMode(CORNERS);
    ellipseMode(RADIUS);
    
    parameterTypes = new Class[1];
    parameterTypes[0] = MMS.Player.class;
    
    frontPageBackground = loadImage(dataPath("Pictures/frontPageBackground.png"));
    newGameBackground = loadImage(dataPath("Pictures/newGameBackground.jpg"));
    redBackground = loadImage(dataPath("Pictures/redBackground.jpg"));
    xmasBackground = loadImage(dataPath("Pictures/christmasBackground.jpg"));
    symmetricalBackground = loadImage(dataPath("Pictures/symmetricalBackground.png"));
    dirtyPaperBackground = loadImage(dataPath("Pictures/dirtyPaperBackground.jpg"));
    oilCanvas = loadImage(dataPath("Pictures/oil canvas.jpg"));
    redStamp = loadImage(dataPath("Pictures/redStamp.png"));
    blueStamp = loadImage(dataPath("Pictures/blueStamp.png"));
    greenStamp = loadImage(dataPath("Pictures/greenStamp.png"));
    purpleStamp = loadImage(dataPath("Pictures/purpleStamp.png"));
    snowTexture = loadImage(dataPath("Pictures/snowTexture.jpg"));
    blackTexture = loadImage(dataPath("Pictures/blackTexture.jpg"));
    parquetTexture = loadImage(dataPath("Pictures/parquetTexture.jpg"));
    yellowTexture = loadImage(dataPath("Pictures/yellowTexture.jpg"));
    brownTexture = loadImage(dataPath("Pictures/brownTexture.jpg"));
    
    
    snowTexture.resize(width, height);
    blackTexture.resize(width, height);
    brownTexture.resize(width, height);
    parquetTexture.resize(width, height);
    yellowTexture.resize(width, height);
    
    mask1 = createGraphics(snowTexture.width, snowTexture.height, JAVA2D);
    mask1.beginDraw();
    mask1.background(0);
    mask1.fill(255);
    mask1.noStroke();
    mask1.ellipse(5*width/12, height/2, 2*width/3, 6*height/7);
    mask1.endDraw();
    
    snowTexture.mask(mask1);
    blackTexture.mask(mask1);
    brownTexture.mask(mask1);
    parquetTexture.mask(mask1);
    yellowTexture.mask(mask1);

    loadingVideo = new Movie(this, dataPath("Videos/loadingVideo.mp4"));
    
    textSize(width/60);
    playerOne = new Player("Player 1", 37, 39, color(255, 0, 0)); // <-, ->
    playerTwo = new Player("Player 2", 65, 68, color(0, 0, 255)); // A, D
    playerThree = new Player("Player 3", 66, 77, color(0, 100, 0)); // B,M
    playerFour = new Player("Player 4", 52, 54, color(165, 20, 140)); // 4, 6

    listOfPlayers = new ArrayList<Player>();
    listOfPlayers.add(playerOne);
    listOfPlayers.add(playerTwo);
    listOfPlayers.add(playerThree);
    listOfPlayers.add(playerFour);
    
    minim = new Minim(this);
    crashSound = minim.loadFile(dataPath("Sounds/crash.mp3"));
    cheerSound = minim.loadFile(dataPath("Sounds/cheer.mp3"));
    startSound = minim.loadFile(dataPath("Sounds/startMusic.mp3"));
    endCheerSound = minim.loadFile(dataPath("Sounds/endCheer.mp3"));    
 
    size = new Booster(0, 0, color(255, 255, 0));
    speed = new Booster(0, 0, color(0, 255, 255));
    changeKeys = new Booster(0, 0, color(255, 0, 255));
    
    //initial number of players
    numOfPlayers = 2;
    playersLeft = 2;
   
    titleFont = createFont(dataPath("Fonts/titleCurved2.otf"), height/10);
    menuFont = createFont(dataPath("Fonts/menu.ttf"), height/13);
    menuFontBold = createFont(dataPath("Fonts/menuBold.ttf"), height/13);
    normalFont = createFont(dataPath("Fonts/CaviarDreams_Bold.ttf"), 60);

    drawStartScreen();    

    //looping but not well.. Not continuous
    startSound.loop();


}

void movieEvent(Movie m) {
     m.read();
}


void draw() {
  
     if(playVideo) {
         image(loadingVideo, 0, 0, width, height);
     }
     
     if(millis() - startVideo > 1000 * loadingVideo.duration() && playVideo) {
         playVideo = false;
         startGame();
     }
  
    if(frontScreen) {
        updateMouse();
    }
      
    if(startCounter) {    
        startCountdown();
    }
  
    if(startRound) {
        drawSideBar();
        for(Player p : listOfPlayers) 
            if(p.isAlive()) { 
                for(int i = 0; i < p.getSpeed(); i++) {
                    move(p);
                    checkIfCollision(p);
                    checkIfKeysPressed(p);
                    drawPlayersCurrentPosition(p);
                }
            } 
        try {
            initializeBooster(speed, "makeAllPlayersFasterExcept");
            initializeBooster(size, "makeAllPlayersBiggerExcept");
            initializeBooster(changeKeys, "makeAllPlayersChangeKeysExcept");
          } catch(Exception e) {
              println(e.getMessage());      
          }
          
          if(speed.getActive()) {
            drawBooster(speed); //<>//
          }
          
          if(size.getActive()) {
            drawBooster(size);
          }
          
          if(changeKeys.getActive()) {
            drawBooster(changeKeys);
        }
    }
}

/*
* Starts countdown. From startInterval to 0.  
* Draws initial positions of players. 
* When startInterval reaches 0 starts the game.
*/
private void startCountdown() {
    if(millis() - startTime > 1000 && startInterval >= 0) {
        drawBackground();
        for(Player p : listOfPlayers) {
            fill(p.getColor());
            stroke(p.getColor());
            ellipse(p.getX(), p.getY(), p.getSize(), p.getSize());
            //Little circle of radius 1 indicating starting direction before round starts 
            fill(255, 255, 0);
            ellipse(p.getX() + p.getSize() * cos(p.getDirection()), p.getY() + p.getSize() * -sin(p.getDirection()), 1, 1);
        }
        
        fill(127, 0, 0);
        text(str(startInterval - 1), 5*width/12, (height - textWidth("0"))/2);
        startTime = millis();
        startInterval--;
    }
    
    if(startInterval == 0) {
        startCounter = false;
        drawBackground();
        startRound = true;
        size.setStartInterval(3);
        speed.setStartInterval(3);
        changeKeys.setStartInterval(3);
        speed.setStartTime(millis());
        size.setStartTime(millis());
        changeKeys.setStartTime(millis());
    }
}

/*
* Moving player. Called only in draw method.
* Depending on player direction calculates new x and y values.
*/
private void move(Player player) {
    int x = int(4 * cos(player.getDirection()));
    int y = int(4 * -sin(player.getDirection()));
    player.setX(player.getX() + x);
    player.setY(player.getY() + y);
}

/*
* Plays a sound and prepares it to play again (rewind).
*/
private void playSound(AudioPlayer sound) {
    sound.play();
    sound.rewind();
}

/*
* Handles events for buttons that aren't from G4P library.
*/
void mousePressed() {
    if(betweenRounds && overButton(11*width/12, height*0.85, width/20)) {  
        betweenRounds = false;
        startCounter = true;  
        initializePlayersOnStart();
        chooseBackgroundRandomly();
        image(currentBackground, 0, 0, 5*width/6, height);
        drawSideBar();
        chooseTextureRandomly();
        drawBackground();
        startInterval = secondsToStart;
        fill(127, 0, 0);
        text(str(startInterval), 5*width/12, (height - textWidth("0"))/2);    
        startTime = millis();
        playerOne.getListOfPassedPoints().clear();
        playerTwo.getListOfPassedPoints().clear();
        playerThree.getListOfPassedPoints().clear();
        playerFour.getListOfPassedPoints().clear();
        speed.setActive(false);
        size.setActive(false);
        changeKeys.setActive(false);
        for(Player p : listOfPlayers) {
            p.setSpeed(1);
            p.setSize(5);
            if(p.isKeysChanged()) {
                p.changeKeys();   
            }
        }
    } else if(frontScreen) checkIfMouseAboveMenu(); 
    else if(newGame && get(mouseX, mouseY) == color(255,255,0)) {
      frontScreen = true;
      newGame = false;
      drawStartScreen();
      btn2Players.setVisible(false);
      btn3Players.setVisible(false);
      btn4Players.setVisible(false);
    } else if(get(mouseX, mouseY) == color(255,220,0) && newGame) {
          newGame = false;
          player1Screen = true;
          btn2Players.setVisible(false);
          btn3Players.setVisible(false);
          btn4Players.setVisible(false);
          nameField.setVisible(true);
          btnLeft.setVisible(true);
          btnRight.setVisible(true);
          drawScreenPlayer(1);
    } else if(player1Screen && get(mouseX, mouseY) == color(255,255,0)) {
          newGame = true;
          player1Screen = false;
          playerOne.setName(nameField.getText().isEmpty() ? "Player 1" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
          nameField.setVisible(false);
          btnLeft.setVisible(false);
          btnRight.setVisible(false);
          drawNewGameScreen();
    } else if(player1Screen && get(mouseX, mouseY) == color(255,220,0)) {
         player2Screen = true;
         player1Screen = false;
         playerOne.setName(nameField.getText().isEmpty() ? "Player 1" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
         drawScreenPlayer(2);
    } else if(player2Screen && get(mouseX, mouseY) == color(255,255,0)) {
         player2Screen = false;
         player1Screen = true;
         playerTwo.setName(nameField.getText().isEmpty() ? "Player 2" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
         drawScreenPlayer(1);
    } else if(player2Screen && get(mouseX, mouseY) == color(255, 220, 0)) {
         player3Screen = true;
         player2Screen = false;
         playerTwo.setName(nameField.getText().isEmpty() ? "Player 2" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
         drawScreenPlayer(3);
    } else if(player3Screen && get(mouseX, mouseY) == color(255, 255, 0)) {
         player3Screen = false;
         player2Screen = true;
         playerThree.setName(nameField.getText().isEmpty() ? "Player 3" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
         drawScreenPlayer(2);
    } else if(player3Screen && get(mouseX, mouseY) == color(255, 220, 0)) {
         player4Screen = true;
         player3Screen = false;
         playerThree.setName(nameField.getText().isEmpty() ? "Player 3" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
         drawScreenPlayer(4);
    } else if(player4Screen && get(mouseX, mouseY) == color(255, 255, 0)) {
         player3Screen = true;
         player4Screen = false;
         playerFour.setName(nameField.getText().isEmpty() ? "Player 4" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
         drawScreenPlayer(3);
    } else if(!startRound && get(mouseX, mouseY) == color(255, 255, 1) ||  get(mouseX, mouseY) == color(200, 0, 1)) {
      if(player2Screen) {
        playerTwo.setName(nameField.getText().isEmpty() ? "Player 2" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
        startSound.close();
        loadingVideo.play();
        startVideo = millis();
        playVideo = true;
      } else if(player3Screen) {
        playerThree.setName(nameField.getText().isEmpty() ? "Player 3" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
        startSound.close();
        loadingVideo.play();
        startVideo = millis();
        playVideo = true;     
      } else if(player4Screen) {
        playerFour.setName(nameField.getText().isEmpty() ? "Player 4" : nameField.getText().length() > 8 ? nameField.getText().substring(0,8) : nameField.getText());
        loadingVideo.play();
        startSound.close();
        startVideo = millis();
        playVideo = true;  
      }
        nameField.setVisible(false);
        btnLeft.setVisible(false);
        btnRight.setVisible(false);
    }
}

/*
* Checks if mouse if over button used in mousePressed().
*/
boolean overButton(float buttonCenterX, float buttonCenterY, float buttonRadius)  {
    if(dist(mouseX, mouseY, buttonCenterX, buttonCenterY) <= buttonRadius) return true;
    else return false;
}

/*
* If in game key or keyCode equals to any player's left or right key. Set boolean variable of a player that his left or right key is not pressed anymore (released).
* If start screen adjusts buttons' text and set players' new keys.
*/
void keyPressed() {
    if(startRound) {
        for(Player player : listOfPlayers) {
            if(key == player.getLeft() || key == Character.toLowerCase(player.getLeft()) || keyCode == player.getLeft() || keyCode  == Character.toLowerCase(player.getLeft())) {
                player.setLeftPressed(true);
            } else if (key == player.getRight() || key == Character.toLowerCase(player.getRight()) || keyCode == player.getRight() || keyCode  == Character.toLowerCase(player.getRight())) {
                player.setRightPressed(true);
            }
        }
    } else {
        if(player1Screen) {
            setPlayerKeys(playerOne, btnLeft, Turn.LEFT);
            setPlayerKeys(playerOne, btnRight, Turn.RIGHT);
        } else if(player2Screen) {
            setPlayerKeys(playerTwo, btnLeft, Turn.LEFT);
            setPlayerKeys(playerTwo, btnRight, Turn.RIGHT);
        } else if(player3Screen) {
            setPlayerKeys(playerThree, btnLeft, Turn.LEFT);
            setPlayerKeys(playerThree, btnRight, Turn.RIGHT);
        } else if(player4Screen) {
            setPlayerKeys(playerFour, btnLeft, Turn.LEFT);
            setPlayerKeys(playerFour, btnRight, Turn.RIGHT);
        }
    }
}


/*
* If key or keyCode equals to any player's left or right key. Set boolean variable of a player that his left or right key is not pressed anymore (released).
*/
void keyReleased() {
    if(!frontScreen) {
        for(Player player : listOfPlayers) {
            if(key == player.getLeft() || key == Character.toLowerCase(player.getLeft()) || keyCode == player.getLeft() || keyCode  == Character.toLowerCase(player.getLeft())) {
                player.setLeftPressed(false);
            } else if (key == player.getRight() || key == Character.toLowerCase(player.getRight()) || keyCode == player.getRight() || keyCode  == Character.toLowerCase(player.getRight())) {
                player.setRightPressed(false);
            }
         }
    } 
}



/*
* If button is one of choose player button change their colors and set num of players and players left variables.
* If button is start button
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
    } else { 
        button.setFocus(true);
        if (button == btnLeft || button == btnRight) {
            button.setText("Pritisni tipku");
        } 
    }
}

void updateMouse() {
  if(overRect(int(width*0.8 - textWidth("NEW GAME")/2), int(height*0.5), (int)textWidth("NEW GAME"), int(textAscent() - textDescent()))) {
      drawMenu(1);
  } else if(overRect(int(width*0.8 - textWidth("EXIT")/2), int(height*0.5 + (textAscent() - textDescent())*1.5), int(textWidth("EXIT")), int(textAscent() - textDescent()))){
      drawMenu(2);
  } else {
      drawMenu(0);
  }
}

boolean overRect(int x, int y, int wid, int hei) {
  if (mouseX >= x && mouseX <= x+wid && 
      mouseY <= y && mouseY >= y-hei) {
    return true;
  } else {
    return false;
  }
}