

class Player {
  private String name;
  private int x;
  private int y;
  private color col;
  private int score;
  private boolean alive;
  private ArrayList<Pair> listOfPassedPoints;
  private int left;
  private int right;
  private Pair winTextPosition;
  private int size;
  private float direction;

  
 public Player(String name, int x, int y, int direction, color col) {
    this.name = name;
    this.x = x;
    this.y = y;
    this.direction = direction;
    this.listOfPassedPoints = new ArrayList<Pair>();
    this.col = col;
    this.score = 0;
    this.alive = false;
    this.size = 5;
 }
 
 public Player(int left, int right, color col, Pair winTextPosition) { 
   this("player", 0, 0, 1, color(0, 0, 0));
   this.left = left;
   this.right = right;
   this.col = col;
   this.winTextPosition = winTextPosition;
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
  
  public Pair getWinTextPosition() {
    return winTextPosition;
  }
  
  public void setWinTextPosition(Pair winTextPosition) {
    this.winTextPosition = winTextPosition;
  }
 
  public int getSize() {
    return size;
  }
  
  public void setSize(int size) {
    this.size = size;
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
}