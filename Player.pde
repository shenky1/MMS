
class Player {
    /*
    *  Name of a player.
    */
    private String name;
    /*
    *  Current x axis position.
    */
    private int x;
    /*
    *  Current y axis position.
    */
    private int y;
    /*
    *  Color of a player.
    */
    private color col;
    /*
    *  Current score of a player.
    */
    private int score;
    /*
    *  Is player alive or not.
    */
    private boolean alive;
    /*
    *  List of points player has passed.
    */
    private ArrayList<Pair> listOfPassedPoints;
    /*
    *  Ascii value of player's left key.
    */
    private int left;
    /*
    *  Ascii value of player's left key.
    */
    private int right;
    /*
    *  Current size of a player.
    */
    private int size;
    /*
    * Current speed of a player.
    */
    private int speed;
    /*
    *  Current direction (angle) of a player.
    */
    private float direction;
    /*
    *  Tells us if left key was pressed.
    */
    private boolean leftPressed;
    /*
    *  Tells us if right key was pressed.
    */
    private boolean rightPressed;
    /*
    *  Tells us if keys were changed.
    */
    private boolean keysChanged;
    
    /*
    * Constructor.
    */
    public Player(String name, int x, int y, int direction, color col) {
        this.name = name;
        this.x = x; 
        this.y = y;
        this.direction = direction;
        this.col = col;
        
        this.listOfPassedPoints = new ArrayList<Pair>();
        this.size = 4;
        this.speed = 1;
    }
 
    public Player(int left, int right, color col, Pair winTextPosition) { 
        this("player", 0, 0, 1, color(0, 0, 0));
        this.left = left;
        this.right = right;
        this.col = col;
    }

 
    public String getName() {
        return name;
    }
 
    public void setName(String name) {
        this.name = name;
    }
 
    public int getX() {
        return x;
    }
   
    public int getY() {
        return y;
    }
   
    public void setX(int x) {
        this.x = x;
    }
   
    public void setY(int y) {
        this.y = y;
    }
   
    public float getDirection(){
        return direction;
    }
   
    public void setDirection(float direction) {
        this.direction = direction;
    }
   
    public color getColor() {
        return col;
    }
   
    public void setColor(color col) {
        this.col = col;
    }
   
    public int getScore() {
        return score;
    }
    
    public void setScore(int score) {
        this.score = score;
    }
    
    public boolean isAlive() {
        return alive;
    }
    
    public void setAlive(boolean alive) {
        this.alive = alive;
    }
    
    public ArrayList<Pair> getListOfPassedPoints() {
        return listOfPassedPoints;
    }
    
    public void setListOfPassedPoints(ArrayList<Pair> listOfPassedPoints) {
        this.listOfPassedPoints = listOfPassedPoints;
    }
    
    public void updateListOfPassedPoints(Pair p) {
        listOfPassedPoints.add(p);
    }
   
    public int getSize() {
        return size;
    }
    
    public void setSize(int size) {
        this.size = size;
    }
    
    public int getSpeed() {
        return speed;
    }
    
    public void setSpeed(int speed) {
        this.speed = speed;
    }
    
    public int getLeft() {
        return left;
    }
    
    public void setLeft(char c) {
        this.left = c;
    }
    
    public int getRight() {
        return right;
    }
    
    public void setRight(char c) {
        this.right = c;
    }
    
    public boolean isLeftPressed() {
        return leftPressed;
    }
    
    public void setLeftPressed(boolean leftPressed) {
        this.leftPressed = leftPressed;
    }
    
    public boolean isRightPressed() {
        return rightPressed;
    }
    
    public void setRightPressed(boolean rightPressed) {
        this.rightPressed = rightPressed;
    }
    
    public boolean isKeysChanged() {
        return keysChanged;
    }
    
    public void setKeysChanged(boolean keysChanged) {
       this.keysChanged = keysChanged;
       
    }
    
    public void changeKeys() {
        int changeKey = left;
        left = right;
        right = changeKey;   
        keysChanged = !keysChanged;
    }
}