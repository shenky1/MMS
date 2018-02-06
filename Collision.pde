/*
* If players is alive and 
* If collision occured plays sound, sets player new points and announces round winner if there is only one player left.
*/
private void checkIfCollision(Player player) {
    if(hasCrashed(player)) {
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
    float directionStart = player.getDirection() - PI/2;
    float directionEnd = directionStart + PI;
    float directionToCheck = directionStart;
    while(directionToCheck <= directionEnd) {
         int xToCheck = int(player.getX() + (player.getSize() + 2) * cos(directionToCheck));
         int yToCheck = int(player.getY() + (player.getSize() + 2) * -sin(directionToCheck));
         color col = get(xToCheck, yToCheck);
         if(col != color(255) && col != color(0)) {
             println(directionToCheck, col, xToCheck, yToCheck, player.getX(), player.getY());  
             return true;
         }
         directionToCheck += 2*PI/360;
    }
    return false;
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
    text("Runda završena!", 6*width/7, height/2 + 2*textHeight);
    text("Pobjednik:", 6*width/7, height/2 + 4*textHeight); 
    text(player.getName(), 6*width/7, height/2 + 6*textHeight);
    fill(255);
    textSize(width/60);
    text("POBJEDNIK!", player.getWinTextPosition().getX(), player.getWinTextPosition().getY());
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
    
    ellipse(5*width/12, height/2, width/2, height/2);
    float textWidth = textWidth(player.getName() + "je pobjednik!");
    fill(0);
    text(player.getName() + " je pobjednik!", 5*width/12 - textWidth/2, height/2);
    playSound(endCheerSound);
    endOfGame = true;
    noLoop();
}