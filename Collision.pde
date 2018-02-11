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
    float directionStart = player.getDirection() - PI/4;
    float directionEnd = directionStart + PI/2;
    while(directionStart <= directionEnd) {
         int xToCheck = int(player.getX() + player.getSize() * cos(directionStart));
         int yToCheck = int(player.getY() + player.getSize() * -sin(directionStart));
         color col = get(xToCheck, yToCheck);
         if(col != color(255) && col != color(0)) {
             if(hue(col) == hue(speed.getColor())) {
                  removeBoosterAndDoTask(speed, player);
             } else if(hue(col) == hue(size.getColor())) {
                  removeBoosterAndDoTask(size, player);
             } else if(hue(col) == hue(changeKeys.getColor())) {
                  removeBoosterAndDoTask(changeKeys, player);
             } else {
                if(crashedIntoPlayer(col)) return true;
             }
         } else if(grayPixel(col) || (col == color(0) && !blackScreen) || (col == color(255) && blackScreen))  {
             int dx = 5*width/12 - xToCheck;
             int dy = height/2 - yToCheck;
             int x = int(xToCheck + 2*dx);
             int y = int(yToCheck + 2*dy);
             player.setX(x);
             player.setY(y);
             return false;
         }
         directionStart += PI/8;
    }
    return false;
}

private boolean grayPixel (color p){
  if(red(p) != 255 && red(p) != 0 && red(p) == green(p) && green(p) == blue(p)) { // R = G, G = B
    return true;
  }
  return false;
}

private boolean crashedIntoPlayer(color col) {
  for(Player p : listOfPlayers) {
    if(col == p.getColor()) {
      return true;
    }
  }
  return false;
}

private void removeBoosterAndDoTask(Booster booster, Player player) {
     if(booster.getActive()) {
         if(blackScreen) {
             fill(0);
             stroke(0);
         } else {
             fill(255);
             stroke(255);
         }
         ellipse(booster.getX(), booster.getY(), 10, 10);
         try {
             booster.getTask().invoke(this, player);
         } catch(Exception e) {
           println(e.getMessage()); //<>//
         }
         booster.setActive(false);
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
    
    int pointsWon = (int)pow(2, numOfPlayers - playersLeft - 1);
    player.setScore(player.getScore() + pointsWon);
    float textHeight = textAscent() - textDescent();
    drawSideBar();
    fill(player.getColor());
    text("Runda završena!", 6*width/7, height*0.6 + 2*textHeight);
    text("Pobjednik:", 6*width/7, height*0.6 + 4*textHeight); 
    text(player.getName(), 6*width/7, height*0.6 + 6*textHeight);
    fill(255);
    checkIfGameOver();
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
    
    ellipse(5*width/12, height/2, 5*width/12, height/2);
    float textWidth = textWidth(player.getName() + "je pobjednik!");
    fill(0);
    text(player.getName() + " je pobjednik!", 5*width/12 - textWidth/2, height/2);
    playSound(endCheerSound);
    endOfGame = true;
    noLoop();
}

public void makeAllPlayersFasterExcept(Player player) {
   for(Player p : listOfPlayers) {
      if(p != player) {
                 p.setSpeed(p.getSpeed() + 1);
             }
      }
}

public void makeAllPlayersBiggerExcept(Player player) {
     for(Player p : listOfPlayers) {
         if(p != player) {
             p.setSize(3*p.getSize()/2);
         }
     }
}

public void makeAllPlayersChangeKeysExcept(Player player) {
     for(Player p : listOfPlayers) {
         if(p != player) {
             p.changeKeys();
         }
     }
}