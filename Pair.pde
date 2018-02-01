class Pair {
    private int x;
    private int y;
  
    public Pair(int x, int y) {
        this.x = x;
        this.y = y;
    }
  
    public int getX() {
        return x;
    }
  
    public int getY() {
        return y;
    }
  
    @Override
    public boolean equals(Object p) {
      if(x == ((Pair)p).getX() && y == ((Pair)p).getY()) return true;
      return false;
    }
}