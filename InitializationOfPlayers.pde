/*
* Initialize all players that are alive. Their number depends on users wish.
*
*/
private void initializePlayersOnStart() {
    initializePlayer(playerOne);
    initializePlayer(playerTwo);
    if(numOfPlayers >= 3) initializePlayer(playerThree);
    if(numOfPlayers == 4) initializePlayer(playerFour);
    playersLeft = numOfPlayers;
}

/*
* Initialize one players starting position and direction randomly.
*/ 
private void initializePlayer(Player player) {
    player.setAlive(true);
    float u = random(0, 1);
    float v = random(0, 1);
    
    float w = height/3 * u;
    float t = 2 * PI * v;
    int x = int(w * cos(t));
    int y = int(w * sin(t));
    
    player.setX(5*width/12 + x);
    player.setY(height/2 + y);
    
    player.setDirection(t);
} 