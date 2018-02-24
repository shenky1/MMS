private final int STROKE_WEIGHT = 15;
/*
* Draws side bar which shows current players scores.
* Also shows buttons that change background.
*/
private void drawSideBar() {
    textFont(normalFont);
    
    image(oilCanvas, 5*width/6, 0, width, height);

    fill(0);
    stroke(0);
    rect(5*width/6, 0, 5*width/6 + 5, height);

    //information about exit
    textSize(height/30);
    fill(127, 0, 0);
    text("Izlaz: esc", 6*width/7, height/15);
    
    text("Legenda:", 6*width/7, height/5);
    textSize(height/40);
    float textHeight = textAscent() - textDescent();
    fill(speed.getColor());
    drawStar(6*width/7, height/5 + 3*textHeight, 3, 8, 5);
    text(" Ubrzaj igrače", 6*width/7 + 10, height/5 + 3*textHeight + textHeight/2);
    fill(size.getColor());
    drawStar(6*width/7, height/5 + 5*textHeight, 3, 8, 5);
    text(" Podebljaj igrače", 6*width/7 + 10, height/5 + 5*textHeight + textHeight/2);
    fill(changeKeys.getColor());
    drawStar(6*width/7, height/5 + 7*textHeight, 3, 8, 5);
    text(" Promjeni smjer", 6*width/7 + 10, height/5 + 7*textHeight + textHeight/2);

    
    
    fill(127, 0, 0);
    //Curent players scores
    textSize(height/30);
    text("Rezultat:", 6*width/7, height*0.4);
    textSize(height/40);
    drawPlayerScore(playerOne, 3*textHeight);
    drawPlayerScore(playerTwo, 5*textHeight);
    if(numOfPlayers == 3 ||numOfPlayers == 4) {
        drawPlayerScore(playerThree, 7*textHeight);
    }
    if(numOfPlayers == 4) {
        drawPlayerScore(playerFour, 9*textHeight);
    }
}

/*
* Draws a score for each player. Only called in drawSideBar().
*/
private void drawPlayerScore(Player player, float distance) {
    fill(player.getColor());
    text(player.getName()+ ": ", 6*width/7, height*0.4 + distance);
    text(player.getScore(), 6*width/7 + textWidth(player.getName()+ ": "), height*0.4 + distance);
}

/*
* Draw one player current position and update his listOfPassedPoints.
*/
private void drawPlayersCurrentPosition(Player player) {
    if(player.isAlive()) {
        fill(player.getColor());
        stroke(player.getColor());   
        ellipse(player.getX(), player.getY(), player.getSize(), player.getSize());
        player.updateListOfPassedPoints(new Pair(player.getX(), player.getY()));
    }
}

/*
* Draw whole path of a player. Called if on round end user has pressed button to change background.
*/
private void drawWholePath(Player player) {
    ArrayList<Pair> passedPoints = player.getListOfPassedPoints();
    fill(player.getColor());
    stroke(player.getColor());
    for(Pair p : passedPoints) {
        ellipse(p.getX(), p.getY(), player.getSize(), player.getSize());
    }
}

/*
* Draws black or white background over playing area based on users wish.
*/
void drawBackground() {
    fill(0);
    stroke(0);
    strokeWeight(STROKE_WEIGHT);
    ellipse(5*width/12, height/2, width/3, 3*height/7);
    strokeWeight(1);
    image(currentTexture, 0, 0, width, height);
}

private void chooseTextureRandomly() {
    int texture = (int)random(1, 5.99);
    if(texture == 1) {
        currentTexture = snowTexture;
    } else if(texture == 2) {
        currentTexture = blackTexture;
    } else if(texture == 3) {
        currentTexture = brownTexture;
    } else if(texture == 4) {
        currentTexture = parquetTexture;
    } else if (texture == 5) {
         currentTexture = yellowTexture;
    }
}

private void chooseBackgroundRandomly() {
    int background = (int)random(1, 4.99);
    if(background == 1) {
        currentBackground = symmetricalBackground;
    } else if(background == 2) {
        currentBackground = xmasBackground;
    } else if(background == 3) {
        currentBackground = dirtyPaperBackground;
    } else if(background == 4) {
        currentBackground = redBackground;
    } 
}

/*
* Draws again button on side bar. Only called when round is over.
*/
private void drawAgainButton() {
    textSize(height/30);
    betweenRounds = true;
    float textHeight = textAscent() - textDescent();
    float textWidth = textWidth("Nastavi!");
    fill(0, 255, 0);
    strokeWeight(3);
    ellipse(11*width/12, height*0.85, textWidth*0.6, textWidth*0.6);
    strokeWeight(1);
    fill(127, 0, 0);
    text("Nastavi!", 11*width/12 - textWidth/2, height*0.85 + textHeight/2);  
}


private void initializeBooster(Booster booster, String methodName) {
    if(millis() - booster.getStartTime() > 1000 && booster.getStartInterval() > 0 && !booster.getActive()) {
        booster.setStartTime(millis());
        booster.setStartInterval(booster.getStartInterval() - 1);
    }
        
    if(booster.getStartInterval() == 0 && !booster.getActive()) {
        int x, y;
        do {
            float u = random(0, 1);
            float v = random(0, 1);
            float t = 2 * PI * v;
            x = int(sqrt(u) * cos(t) * 3*width/10);
            y = int(sqrt(u) * -sin(t) * 3*height/8);
        } while(!available(5*width/12 + x, height/2 + y));
        booster.setX(5*width/12 + x);
        booster.setY(height/2 + y);
        booster.setActive(true);
        booster.setStartInterval(8);
        try {
            booster.setTask(MMS.class.getMethod(methodName, Player.class));
        } catch(NoSuchMethodException e) {
          println(e.getMessage()); //<>//
        }
    }     
}

private boolean available(int x, int y) {
    for (int i = x - 10; i <= x + 10; i++) {
        for (int j = y - 10; j < y + 10; j++) {
            color c = get(i, j);
            if(hasCrashedIntoPlayer(c) 
            || c == size.getColor() || c == speed.getColor()
            || c == changeKeys.getColor()) return false;
        }
    }
    return true;
}

private void drawBooster(Booster booster) {
    pushMatrix();
    mask1.ellipse(booster.getX(), booster.getY(), BOOSTER_SIZE/2 + 2, BOOSTER_SIZE/2 + 2);
    currentTexture.mask(mask1);
    image(currentTexture, booster.getX() - BOOSTER_SIZE, booster.getY() - BOOSTER_SIZE, 2*(BOOSTER_SIZE + 2), 2*(BOOSTER_SIZE + 2));  
    translate(booster.getX(), booster.getY());
    rotate(frameCount / -10.0);
    fill(booster.getColor());
    stroke(booster.getColor());
    drawStar(0, 0, 3, BOOSTER_SIZE/2, 5); 
    popMatrix();
}

private void drawStartScreen() {
    image(frontPageBackground, 0, 0, width, height);
    textFont(titleFont);  
    fill(0);
    text("Beware!", width/20, height*0.45);
    text("the CURVE", width/9, height*0.45 + (textAscent() - textDescent())*1.5);
   
    textFont(menuFont);
    text("NEW GAME", width*0.8 - textWidth("NEW GAME")/2, height*0.5);
    text("EXIT", width*0.8 - textWidth("EXIT")/2, height*0.5 + (textAscent() - textDescent())*1.5);
   
}

private void checkIfMouseAboveMenu() {
    if(width*0.8 - textWidth("NEW GAME")/2 <= mouseX && mouseX <= width*0.8 + textWidth("NEW GAME")/2 && height*0.5 >= mouseY && height*0.5 - textAscent() + textDescent() <= mouseY) {
        frontScreen = false;
        textFont(menuFontBold);
        textSize(height/10);
        float textHeight = textAscent() - textDescent();
        nameField = new GTextField(this, width*0.4 + textWidth("Name: "), (height - textHeight)/2, width/10, textHeight/2);
        nameField.setVisible(false);
        btnLeft = new GButton(this, width*0.4 + textWidth("Right: "), height/2 + textHeight, width/20, textHeight);
        btnRight = new GButton(this, width*0.4 + textWidth("Right: "), height/2 + 3*textHeight, width/20, textHeight);
        btnLeft.setVisible(false);
        btnRight.setVisible(false);
        drawNewGameScreen();
        newGame = true;
    } else if(width*0.8 - textWidth("EXIT")/2 <= mouseX && mouseX <= width*0.8 + textWidth("EXIT")/2 && height*0.5 + (textAscent() - textDescent())*1.5 >= mouseY && height*0.5 + (textAscent() - textDescent())/2 <= mouseY) {
         exit();
    }
}

private void drawMenu(int pos) {
    image(frontPageBackground, 0, 0, width, height);
    textFont(titleFont);  
    fill(0);
    text("Beware!", width/20, height*0.45);
    text("the CURVE", width/9, height*0.45 + (textAscent() - textDescent())*1.5);
    if(pos == 0) {
        textFont(menuFont);
        text("NEW GAME", width*0.8 - textWidth("NEW GAME")/2, height*0.5);
        text("EXIT", width*0.8 - textWidth("EXIT")/2, height*0.50 + (textAscent() - textDescent())*1.5);
    } else if(pos == 1) {
        textFont(menuFontBold);
        fill(127, 0, 0);
        text("NEW GAME", width*0.8 - textWidth("NEW GAME")/2, height*0.5);
        textFont(menuFont);
        fill(0);
        text("EXIT", width*0.8 - textWidth("EXIT")/2, height*0.50 + (textAscent() - textDescent())*1.5);
    } else if(pos == 2) {
        textFont(menuFont);
        text("NEW GAME", width*0.8 - textWidth("NEW GAME")/2, height*0.5);
        fill(127, 0, 0);
        textFont(menuFontBold);
        text("EXIT", width*0.8 - textWidth("EXIT")/2, height*0.50 + (textAscent() - textDescent())*1.5);
        fill(0);
    }
}

private void drawNewGameScreen() { 
    image(newGameBackground, 0, 0, width, height);
    PShape left = createShape();
    PShape right = createShape();
    left.beginShape();
    left.fill(255, 255, 0);
    left.stroke(5);
    left.vertex(width/25, height/2);
    left.vertex(width/12, height*0.55);
    left.vertex(width/12, height*0.45);
    left.endShape(CLOSE);
    shape(left);
    right.beginShape();
    right.fill(255, 220, 0);
    right.stroke(5);
    right.vertex(24*width/25, height/2);
    right.vertex(11*width/12, height*0.55);
    right.vertex(11*width/12, height*0.45);
    right.endShape(CLOSE);
    shape(right);
    
    textFont(menuFontBold);
    fill(200, 0, 0);
    textSize(height/10);
    float textWidth = textWidth("Choose number of players");
    text("Choose number of players", (width - textWidth)/2, height/4);
    
    int buttonRadius = width/10;
    btn2Players = new GButton(this, width/2 - 2*buttonRadius, height/2, buttonRadius, buttonRadius, "2"); 
    btn3Players = new GButton(this, (width - buttonRadius)/2, height/2, buttonRadius, buttonRadius, "3");
    btn4Players = new GButton(this, width/2 + buttonRadius, height/2, buttonRadius, buttonRadius, "4");
    btn2Players.setLocalColor(4, color(255, 0, 0));
    btn3Players.setLocalColor(4, color(255, 0, 0));
    btn4Players.setLocalColor(4, color(255, 0, 0));
    btn2Players.setLocalColor(3, color(0, 0, 255));
    btn3Players.setLocalColor(3, color(0, 0, 255));
    btn4Players.setLocalColor(3, color(0, 0, 255));
}

private void drawScreenPlayer(int i) {
    image(newGameBackground, 0, 0, width, height);
    PShape left = createShape();
    PShape right = createShape();
    left.beginShape();
    left.fill(255, 255, 0);
    left.stroke(5);
    left.vertex(width/25, height/2);
    left.vertex(width/12, height*0.55);
    left.vertex(width/12, height*0.45);
    left.endShape(CLOSE);
    shape(left);
    textFont(menuFontBold);
    textSize(height/10);
        
    if(i != numOfPlayers) {
        right.beginShape();
        right.fill(255, 220, 0);
        right.stroke(5);
        right.vertex(24*width/25, height/2);
        right.vertex(11*width/12, height*0.55);
        right.vertex(11*width/12, height*0.45);
        right.endShape(CLOSE);
        shape(right);
    } else {
        right.beginShape();
        right.fill(255, 255, 1);
        right.stroke(5);
        right.vertex(24*width/25, height*0.53);
        right.vertex(24*width/25, height*0.46);
        right.vertex(0.9*width, height*0.42);
        right.vertex(5*width/6, height*0.46);
        right.vertex(5*width/6, height*0.53);
        right.vertex(0.9*width, height*0.57);
        right.endShape(CLOSE);
        shape(right);
        fill(200, 0, 1);
        text("GO!", 0.9*width - textWidth("GO!")/2, height/2 + (textAscent() - textDescent())/2); 

    }
        fill(200, 0, 0);
        text("Player " + i + ":", (width - textWidth("Player 1:"))/2, height*0.3);
        text("Name: ", width*0.4, height/2);
        text("Left: ", width* 0.4, height/2 + 2*(textAscent() - textDescent()));
        text("Right: ", width* 0.4, height/2 + 4*(textAscent() - textDescent()));
        
        if(i == 1) {
            nameField.setText(playerOne.getName());
            btnLeft.setText(asciiToKey(playerOne.getLeft()) + "");
            btnRight.setText(asciiToKey(playerOne.getRight()) + "");
        } else if(i == 2) {
            nameField.setText(playerTwo.getName());
            btnLeft.setText(asciiToKey(playerTwo.getLeft()) + "");
            btnRight.setText(asciiToKey(playerTwo.getRight()) + ""); 
        } else if(i == 3) {
            nameField.setText(playerThree.getName());
            btnLeft.setText(asciiToKey(playerThree.getLeft()) + "");
            btnRight.setText(asciiToKey(playerThree.getRight()) + "");
        } else if(i == 4) {
            nameField.setText(playerFour.getName());
            btnLeft.setText(asciiToKey(playerFour.getLeft()) + "");
            btnRight.setText(asciiToKey(playerFour.getRight()) + "");
        }
}

private void startGame() {
    startSound.close();
    frontScreen = false;

    initializePlayersOnStart();

    playerOne.getListOfPassedPoints().clear();
    playerTwo.getListOfPassedPoints().clear();
    playerThree.getListOfPassedPoints().clear();
    playerFour.getListOfPassedPoints().clear();

    startCounter = true;  
    drawSideBar();
    chooseBackgroundRandomly();
    image(currentBackground, 0, 0, 5*width/6, height);
    chooseTextureRandomly();
    drawBackground();
    fill(127, 0, 0);        
    startTime = millis();
    startInterval = secondsToStart;
    text(str(startInterval), 5*width/12, (height - textWidth("0"))/2);  
}

/*
* Draw a booster in a shape of a star
*/
void drawStar(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  strokeWeight(3);
  stroke(0);
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  strokeWeight(1);
  }
  endShape(CLOSE);
}