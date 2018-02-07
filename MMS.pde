import processing.video.*; //<>// //<>// //<>//
import ddf.minim.*;
import g4p_controls.*;

AudioPlayer crashSound, cheerSound, startSound, endCheerSound;
Minim minim;//audio context

Movie loadingVideo;
int startVideo;

boolean startRound = false; // start button
boolean startCounter = false;  // used for countdown
boolean frontPage = true; // am I on front page
boolean blackScreen = false; // do I want black board or white
boolean endOfGame = false; // Any player reached numOfPointsToWin;
boolean boosterShown = false;
boolean playVideo;

float textWidth;
float textHeight;

int numOfPlayers; // starting number of players
int playersLeft; // how many players are alive at any time during the game

int numOfPointsForWin = 30; //final number of points to win

Player playerOne, playerTwo, playerThree, playerFour;

int doubleSpeedBoosterX;
int doubleSpeedBoosterY;

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
  //  size(900,600);
    fullScreen();
    frameRate(20);
    
    loadingVideo = new Movie(this, "loadingVideo.mp4");
    loadingVideo.play();
    startVideo = millis();
    playVideo = true;
    
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
    
    PFont startPageFont = createFont("CaviarDreams_Bold.ttf", 60);
    textFont(startPageFont); 
    
    rectMode(CORNERS);
    ellipseMode(RADIUS);

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
        setGradient(0, 0, width/2, height, b1, b2, 2);
        setGradient(width/2, 0, width/2, height, b2, b1, 2);
        drawTitleAndPlayers();  
        drawStartAndChoosePlayers();    
    
        //looping but not well.. Not continuous
        startSound.loop();
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
        drawBooster();
    }
}

/*
* Starts countdown. From startInterval to 0.  
* Draws initial positions of players. 
* When startInterval reaches 0 starts the game.
*/
private void startCountdown() {
    drawSideBar();
    if(millis() - startTime > 1000 && startInterval >= 0) {
        drawPlayingArea();
        drawBackground(blackScreen);
           
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
        drawBackground(blackScreen);
        drawPlayingArea();
        startRound = true;
        startInterval = 3;
        startTime = millis();
    }
}

/*
* Moving player. Called only in draw method.
* Depending on player direction calculates new x and y values.
*/
private void move(Player player) {
    int x = int(player.getSize() * cos(player.getDirection()));
    int y = int(player.getSize() * -sin(player.getDirection()));
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
        boosterShown = false;
        for(Player p : listOfPlayers) {
            p.setSpeed(1);
        }
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

/*
* Checks if mouse if over button used in mousePressed().
*/
boolean overButton(float buttonCenterX, float buttonCenterY, float buttonRadius)  {
    if(dist(mouseX, mouseY, buttonCenterX, buttonCenterY) <= buttonRadius) return true;
    else return false;
}

/*
* Set gradient on front screen.
* (Background color).
*/
private void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {
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


/*
* If in game key or keyCode equals to any player's left or right key. Set boolean variable of a player that his left or right key is not pressed anymore (released).
* If start screen adjusts buttons' text and set players' new keys.
*/
void keyPressed() {
    if(!frontPage) {
        for(Player player : listOfPlayers) {
            if(key == player.getLeft() || key == Character.toLowerCase(player.getLeft()) || keyCode == player.getLeft() || keyCode  == Character.toLowerCase(player.getLeft())) {
                player.setLeftPressed(true);
            } else if (key == player.getRight() || key == Character.toLowerCase(player.getRight()) || keyCode == player.getRight() || keyCode  == Character.toLowerCase(player.getRight())) {
                player.setRightPressed(true);
            }
        }
    } else {
        setPlayerKeys(playerOne, btnL1, Turn.LEFT);
        setPlayerKeys(playerOne, btnR1, Turn.RIGHT);
        setPlayerKeys(playerTwo, btnL2, Turn.LEFT);
        setPlayerKeys(playerTwo, btnR2, Turn.RIGHT);
        setPlayerKeys(playerThree, btnL3, Turn.LEFT);
        setPlayerKeys(playerThree, btnR3, Turn.RIGHT);
        setPlayerKeys(playerFour, btnL4, Turn.LEFT);
        setPlayerKeys(playerFour, btnR4, Turn.RIGHT);
    }
}

/*
* If key or keyCode equals to any player's left or right key. Set boolean variable of a player that his left or right key is not pressed anymore (released).
*/
void keyReleased() {
    if(!frontPage) {
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
    } else if (button == btnStart) {
        background(255);
        startSound.close();
        frontPage = false;
        
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
  
        initializePlayersOnStart();
  
        playerOne.getListOfPassedPoints().clear();
        playerTwo.getListOfPassedPoints().clear();
        playerThree.getListOfPassedPoints().clear();
        playerFour.getListOfPassedPoints().clear();
  
        startCounter = true;  
        startTime = millis();
        startInterval = secondsToStart;
    } else { 
        button.setFocus(true);
        if (button == btnL1 || button == btnL2 || button == btnL3 || button == btnL4 || button == btnR1 || button == btnR2 || button == btnR3 || button == btnR4) {
            button.setText("Pritisni tipku");
        } 
    }
}