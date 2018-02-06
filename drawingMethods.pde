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
    //white rectangle first
    fill(255);
    rect(5*width/6, 0, width, height);
    
    //information about exit
    textSize((width + height)/60);
    fill(127, 0, 0);
    text("Izlaz: esc", 6*width/7, height/10);

    //current players' scores
    text("Rezultat:", 6*width/7, height/3);
    textSize((width + height)/100);
    float textHeight = textAscent() - textDescent();
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
    ellipse(width * 0.9  + width/30, height*0.2, width/60, width/60);
    fill(0);
    ellipse(width * 0.9, height*0.2, width/60, width/60);
}

/*
* Draws a score for each player. Only called in drawSideBar().
*/
private void drawPlayerScore(Player player, float distance) {
    fill(player.getColor());
    text(player.getName()+ ": ", 6*width/7, height/3 + distance);
    text(player.getScore(), 6*width/7 + textWidth(player.getName()+ ": "), height/3 + distance);
}


/*
* Go through all players and draw current position of all alive players.
*/
void drawAllPlayersCurrentPositions() {
    for(Player p : listOfPlayers) {
        if(p.isAlive()) drawPlayersCurrentPosition(p);
    }
}

/*
* Draw one player current position and update his listOfPassedPoints.
*/
private void drawPlayersCurrentPosition(Player player) {
    fill(player.getColor());
    stroke(player.getColor());
    ellipse(player.getX(), player.getY(), player.getSize(), player.getSize());
    player.updateListOfPassedPoints(new Pair(player.getX(), player.getY()));
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
    } else {
        fill(255);
    }
    ellipse(5*width/12, height/2, 5*width/12, height/2);
}

/*
* Draws again button on side bar. Only called when round is over.
*/
private void drawAgainButton() {
    fill(0, 255, 0);
    ellipse(11*width/12, height*0.8, width/20, width/20);
    fill(127, 0, 0);
    textSize((width + height)/70);
    float textHeight = textAscent() - textDescent();
    float textWidth = textWidth("Nastavi!");
    text("Nastavi!", 11*width/12 - textWidth/2, height*0.8 + textHeight/2);  
}