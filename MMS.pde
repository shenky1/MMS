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
  //  size(900,600);
    fullScreen();
    frameRate(30);
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
                checkIfKeysPressed(p);
            }        
        drawAllPlayersCurrentPositions();
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
    }
}

/*
* Moving player. Called only in draw method.
* Depending on player direction calculates new x and y values.
*/
private void Move(Player player) {
    int x = int(player.getSize() * cos(player.getDirection()));
    int y = int(player.getSize() * -sin(player.getDirection()));
    player.setX(player.getX() + x);
    player.setY(player.getY() + y);
}

/*
* Plays a sound and prepares it to play again (rewind).
*/ //<>//
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