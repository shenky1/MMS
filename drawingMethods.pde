/*
* Draws the playing area. Left of side bar.
* Its called only when counter starts.
* Draws an ellipse and fills outside of ellipse with players colors.
*/
private void drawPlayingArea() {
    int heightHalf = height/2;
    int widthHalf = 5*width/12;
    float widthSqr = pow(widthHalf,2);
    float heightSqr = pow(heightHalf, 2);
    ellipse(widthHalf, heightHalf, widthHalf, heightHalf);
    for(int i = 0; i < 5*width/6; ++i) {
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
}

/*
* Draws side bar which shows current players scores.
* Also shows buttons that change background.
*/
private void drawSideBar() {
   
    image(oilCanvas, 5*width/6, 0, width, height);

    fill(0);
    stroke(0);
    rect(5*width/6, 0, 5*width/6 + 5, height);

    //information about exit
    textSize((width + height)/60);
    fill(127, 0, 0);
    text("Izlaz: esc", 6*width/7, height/15);
    
    text("Legenda:", 6*width/7, height/5);
    textSize((width + height)/100);
    float textHeight = textAscent() - textDescent();
    fill(speed.getColor());
    drawStar(6*width/7, height/5 + 2*textHeight, 3, 8, 5);
    text(" Ubrzaj igrače", 6*width/7 + 5, height/5 + 2*textHeight);
    fill(size.getColor());
    drawStar(6*width/7, height/5 + 4*textHeight, 3, 8, 5);
    text(" Podebljaj igrače", 6*width/7 + 5, height/5 + 4*textHeight);
    fill(changeKeys.getColor());
    drawStar(6*width/7, height/5 + 6*textHeight, 3, 8, 5);
    text(" Promjeni smjer", 6*width/7 + 5, height/5 + 6*textHeight);

    
    
    fill(127, 0, 0);
    //Curent players scores
    textSize((width + height)/60);
    text("Rezultat:", 6*width/7, height*0.4);
    textSize((width + height)/100);
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
    ellipse(width * 0.9  + width/30, height/9, width/60, width/60);
    fill(0);
    ellipse(width * 0.9, height/9, width/60, width/60);
    
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
void drawBackground(boolean blackScreen) {
    if(blackScreen) {
        fill(0);
        stroke(255);
    } else {
        fill(255);
        stroke(0);
    }
    strokeWeight(15);
    ellipse(5*width/12, height/2, width/3, 3*height/7);
    strokeWeight(1);
}

/*
* Draws again button on side bar. Only called when round is over.
*/
private void drawAgainButton() {
    fill(0, 255, 0);
    strokeWeight(3);
    ellipse(11*width/12, height*0.85, width/20, width/20);
    strokeWeight(1);
    fill(127, 0, 0);
    textSize((width + height)/70);
    float textHeight = textAscent() - textDescent();
    float textWidth = textWidth("Nastavi!");
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
      for (int i = 0; i < width; i++) {
          for (int j = 0; j < height; j++) {
              if (dist(i, j, x, y) <= 100) {
                  color c = get(i, j);
                  if(!blackScreen && c != color(255)) return false;
                  if(blackScreen && c != color(0)) return false;
              }
          }
      }
      return true;
}

private void drawBooster(Booster booster) {
      pushMatrix();
      if(!blackScreen) {
          fill(255);
          stroke(255);
      } else {
          fill(0);
          stroke(0);
      }
      ellipse(booster.getX(), booster.getY(), 10, 10);
      translate(booster.getX(), booster.getY());
      rotate(frameCount / -10.0);
      fill(booster.getColor());
      stroke(booster.getColor());
      drawStar(0, 0, 3, 8, 5); 
      popMatrix();
}



/*
* Draws titles and players in their positions on start screen. Called after video ends.
*/
private void drawTitleAndPlayers() {
    fill(0, 0, 255);   
    textSize((height + width)/50);
    textWidth = textWidth(title);
    textHeight = textAscent() - textDescent();
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
    text(left, width/3 - textWidth - buttonWidth, height/7 + 6*textHeight);
    text(right, width/3 - textWidth - buttonWidth, height/7 + 8*textHeight);  
    text(name, 2*width/3, height/7 + 4*textHeight);
    text(left, 2*width/3, height/7 + 6*textHeight);
    text(right, 2*width/3, height/7 + 8*textHeight);
    text(name, width/3 - textWidth - buttonWidth, height/2 + 4*textHeight);
    text(left, width/3 - textWidth - buttonWidth, height/2 + 6*textHeight);
    text(right, width/3 - textWidth - buttonWidth, height/2 + 8*textHeight);  
    text(name, 2*width/3, height/2 + 4*textHeight);
    
    text(left, 2*width/3, height/2 + 6*textHeight);
    text(right, 2*width/3, height/2 + 8*textHeight);  
    
    textField1 = new GTextField(this, width/3 - textWidth - buttonWidth + textNameWidth, height/7 + 3*textHeight, textFieldWidth, textHeight);
    textField1.setPromptText(player + "1");
    textField2 = new GTextField(this, 2*width/3 + textNameWidth, height/7 + 3*textHeight, textFieldWidth, textHeight);
    textField2.setPromptText(player + "2");
    textField3 = new GTextField(this, width/3 - textWidth - buttonWidth + textNameWidth, height/2 + 3*textHeight, textFieldWidth, textHeight);
    textField3.setPromptText(player + "3");
    textField4 = new GTextField(this, 2*width/3 + textNameWidth, height/2 + 3*textHeight, textFieldWidth, textHeight);
    textField4.setPromptText(player + "4");
    
    //button for players to choose keys
    btnL1 = new GButton(this, width/3 - textWidth - buttonWidth + textWidth, height/7 + 5*textHeight, buttonWidth, buttonHeight, "LIJEVO");
    btnR1 = new GButton(this, width/3 - textWidth - buttonWidth + textWidth, height/7 + 7*textHeight, buttonWidth, buttonHeight, "DESNO");
    btnL2 = new GButton(this, 2*width/3 + textWidth, height/7 + 5*textHeight, buttonWidth, buttonHeight, "A");
    btnR2 = new GButton(this, 2*width/3 + textWidth, height/7 + 7*textHeight, buttonWidth, buttonHeight, "D"); 
    btnL3 = new GButton(this, width/3 - textWidth - buttonWidth + textWidth, height/2 + 5*textHeight, buttonWidth, buttonHeight, "B");
    btnR3 = new GButton(this, width/3 - textWidth - buttonWidth + textWidth, height/2 + 7*textHeight, buttonWidth, buttonHeight, "M"); 
    btnL4 = new GButton(this, 2*width/3 + textWidth, height/2 + 5*textHeight, buttonWidth, buttonHeight, "4");
    btnR4 = new GButton(this, 2*width/3 + textWidth, height/2 + 7*textHeight, buttonWidth, buttonHeight, "6"); 
    
}

/*
* Draws start button and buttons to choose 2,3 or 4 players. Called after video ends.
*/
private void drawStartAndChoosePlayers() {
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
}

/*
* Draw a booster in a shape of a star
*/
void drawStar(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}