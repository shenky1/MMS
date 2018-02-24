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
    int x, y;
    float t;
    do {
    float u = random(0, 1);
    float v = random(0, 1);
    
    float w = height/3 * u;
    t = 2 * PI * v;
    x = 5 * width/12 + int(w * cos(t));
    y = height/2 + int(w * -sin(t));
    } while(!available(x, y));
    
    player.setX(x);
    player.setY(y);
    
    player.setDirection(t);
} 