private final int BOOSTER_SIZE = 16;

/*
* If players is alive and 
* If collision occured plays sound, sets player new points and announces round winner if there is only one player left.
*/
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

/*
* Checks if player has crashed.
* If a circle around his new position has reached a pixel that is not black or white this method will return false. 
*/
private boolean hasCrashed(Player player) {
    float directionStart = player.getDirection() - PI/3;
    float directionEnd = directionStart + 2*PI/3;
    while(directionStart <= directionEnd) {
         int xToCheck = int(player.getX() + player.getSize() * cos(directionStart));
         int yToCheck = int(player.getY() + player.getSize() * -sin(directionStart));
         color col = get(xToCheck, yToCheck);
         if(col != color(255) && col != color(0)) {
             if(dist(xToCheck, yToCheck, speed.getX(), speed.getY()) < BOOSTER_SIZE) {
                  doBoosterTask(speed, player);
             } else if(dist(xToCheck, yToCheck, size.getX(), size.getY()) < BOOSTER_SIZE) {
                  doBoosterTask(size, player);
             } else if(dist(xToCheck, yToCheck, changeKeys.getX(), changeKeys.getY()) < BOOSTER_SIZE) {
                  doBoosterTask(changeKeys, player);
             } else if(crashedIntoPlayer(player, col)) {
                  return true;
             }
         } else if(grayPixel(col) || col == color(0))  {
             fillRemainingPixels(player);
             int x = int(5*width/12 + (width/3 - player.getSize()) * cos(PI - player.getDirection()));
             int y = int(height/2 + (3*height/7 - player.getSize()) * sin(PI - player.getDirection()));           
             player.setX(x);
             player.setY(y);
             return false;
         }
         directionStart += 2*PI/360;
    }
    return false;
}

private boolean grayPixel (color p){
  if(red(p) != 255 && red(p) != 0 && red(p) == green(p) && green(p) == blue(p)) { // R = G, G = B
    return true;
  }
  return false;
}

private void fillRemainingPixels(Player player) {  
  int pixelsXLeft = player.getX() - player.getSize();
  int pixelsXRight = player.getX() + player.getSize();
  int pixelsYUp = player.getY() - player.getSize();
  int pixelsYDown = player.getY() + player.getSize();
       for(int i = pixelsXLeft; i <= pixelsXRight; ++i)
            for(int j = pixelsYUp; j <= pixelsYDown; ++j) {
                color col = get(i,j);
                if(dist(i,j, player.getX(), player.getY()) < player.getSize() && !grayPixel(col) && col != color(0)) {
                    set(i,j, player.getColor());
                }
            }
};

private boolean crashedIntoPlayer(Player player, color col) {
  int pixelsXLeft = player.getX() - player.getSize();
  int pixelsXRight = player.getX() + player.getSize();
  int pixelsYUp = player.getY() - player.getSize();
  int pixelsYDown = player.getY() + player.getSize();
  for(Player p : listOfPlayers) {
      if(col == p.getColor()) {
         for(int i = pixelsXLeft; i <= pixelsXRight; ++i)
            for(int j = pixelsYUp; j <= pixelsYDown; ++j) {
                color col1 = get(i,j);
                if(dist(i,j, player.getX(), player.getY()) < player.getSize() && col1 != p.getColor()) {
                    set(i,j, player.getColor());
                }
            }
          return true;
      }
  }
  return false;
}

private boolean hasCrashedIntoPlayer(color col) {
  for(Player p : listOfPlayers) {
    if(col == p.getColor()) {
        return true;
    }
  }
  return false;
}

private void doBoosterTask(Booster booster, Player player) {
     if(booster.getShown()) {
         try {
             booster.getTask().invoke(this, player, booster);
             booster.setActive(true);
         } catch(Exception e) {
           println(e.getMessage()); //<>//
         }
         booster.setShown(false);
         booster.setCollector(player);
         currentTexture.mask(mask1);
         image(currentTexture, booster.getX() - BOOSTER_SIZE, booster.getY() - BOOSTER_SIZE, 2*(BOOSTER_SIZE + 1), 2*(BOOSTER_SIZE + 1));      
     }
}

/*
* Announces round winner.
* Plays sound, stop draw method, updates players points and side bar, 
* Also checks if game is over.
*/
private void announceRoundWinner(Player player) {
    playSound(cheerSound);
    startRound = false;
    
    if(player.isAlive()) {
        int pointsWon = (int)pow(2, numOfPlayers - playersLeft - 1);
        player.setScore(player.getScore() + pointsWon);
        player.setAlive(false);
    }
    
    drawSideBar();
    
    textSize(height/40);
    float textHeight = textAscent() - textDescent();
    fill(player.getColor());
    text("Runda završena!", 6*width/7, height*0.6 + 2*textHeight);
    text("Pobjednik:", 6*width/7, height*0.6 + 4*textHeight); 
    text(player.getName(), 6*width/7, height*0.6 + 6*textHeight);
    
    placeStamp(player);
    
    checkIfGameOver();
}

private void placeStamp(Player player) {
    if(player == playerOne) {
        image(redStamp, width * 0.03, height * 0.05, width/10, width/10);
    } else if(player == playerTwo) {
        image(blueStamp, width * 0.7, height * 0.05, width/10, width/10);
    } else if(player == playerThree) {
        image(greenStamp, width * 0.03, height * 0.75, width/10, width/10);
    } else {
        image(purpleStamp, width * 0.7, height * 0.75, width/10, width/10);
    }
}

/*
* After round winner is announced checks if any player's score has reached number of points for ultimate win and game over. 
* If so, announces final winner.
* Else, draws again button on side bar.
*/
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



/*
* Announces final winner. 
* Colors playing area into winners color, writes a message and plays end cheer sound.
* Also stops the loop.
*/
private void announceFinalWinner(Player player) {
    fill(player.getColor());
    
    ellipse(5*width/12, height/2, width/3, 3*height/7);
    float textWidth = textWidth(player.getName() + "je pobjednik!");
    fill(0);
    text(player.getName() + " je pobjednik!", 5*width/12 - textWidth/2, height/2);
    playSound(endCheerSound);
    endOfGame = true;
    drawSideBar();
    noLoop();
}

public void makeAllPlayersFasterExcept(Player player, Booster booster) {
    if(booster.getActive()) {
        for(Player p : listOfPlayers) 
            if(p != player) p.setSpeed(p.getSpeed() - 1);
        booster.setActive(false);
    } else {
      for(Player p : listOfPlayers) 
            if(p != player) p.setSpeed(p.getSpeed() + 1);
    }
}

public void makeAllPlayersBiggerExcept(Player player, Booster booster) {
  if(booster.getActive()) {
        for(Player p : listOfPlayers) 
            if(p != player) {
                p.setX(int(p.getX() + 2 * cos(p.getDirection())));
                p.setY(int(p.getY() + 2 * -sin(p.getDirection())));
                p.setSize(2*p.getSize()/3);
            }
        booster.setActive(false);
    } else {
     for(Player p : listOfPlayers) 
         if(p != player) p.setSize(3*p.getSize()/2);  
     }
}

public void makeAllPlayersChangeKeysExcept(Player player, Booster booster) {
    for(Player p : listOfPlayers) 
        if(p != player) p.changeKeys();
    if(booster.getActive()) {
        booster.setActive(false);
    }
}