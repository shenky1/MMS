

class Player {
  private String name;
  private int x;
  private int y;
  private int direction;
  private color col;
  private int score;
  private boolean alive;
  private ArrayList<Pair> listOfPassedPoints;
  private int left;
  private int right;
  private Pair winTextPosition;
//  private int leftCoded;
//  private int rightCoded;
  
 public Player(String name, int x, int y, int direction, color col) {
    this.name = name;
    this.x = x;
    this.y = y;
    this.direction = direction;
    this.listOfPassedPoints = new ArrayList<Pair>();
    this.col = col;
    score = 0;
    alive = false;
 }
 
 public Player(int left, int right, color col, Pair winTextPosition) { 
   this("player", 0, 0, 1, color(0, 0, 0));
   this.left = left;
   this.right = right;
   this.col = col;
   this.winTextPosition = winTextPosition;
 }
 
 /*public Player(int leftCoded, int rightCoded) {
   this((char)0, (char)0);
   this.leftCoded = leftCoded;
   this.rightCoded = rightCoded;
 }
 */
 
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
 
 public int getDirection(){
   return direction;
 }
 
 public void setDirection(int direction) {
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
  
  public Pair getWinTextPosition() {
    return winTextPosition;
  }
  
  public void setWinTextPosition(Pair winTextPosition) {
    this.winTextPosition = winTextPosition;
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
  
 /*   public int getLeftCoded() {
    return leftCoded;
  }
  
  public void setLeftCoded(int c) {
    this.leftCoded = c;
  }
  
  public int getRightCoded() {
    return rightCoded;
  }
  
  public void setRightCoded(int c) {
    this.rightCoded = c;
  }
  */
}