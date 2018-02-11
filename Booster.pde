class Booster {
    private int x;
    private int y;
    private int startInterval;
    private int startTime;
    private boolean active;
    private color col;
    private Method task;
  
    public Booster(int x, int y, color col) {
        this.x = x;
        this.y = y;
        this.startInterval = 3;
        this.startTime = millis();
        this.active = false;
        this.col = col;
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
    
    public void setStartInterval(int startInterval) {
        this.startInterval = startInterval;
    }
    
    public int getStartInterval() {
        return startInterval;
    }
    
    public void setStartTime(int startTime) {
        this.startTime = startTime;
    }
    
    public int getStartTime() {
        return startTime;
    }
    
    public boolean getActive() {
        return active;
    }
    
    public void setActive(boolean active) {
        this.active = active;
    }
    
    public color getColor() {
        return col;
    }
    
    public void setColor(color col) {
        this.col = col;
    }
    
    public Method getTask() {
      return task;
    }
    
    public void setTask(Method task) {
        this.task = task;
    }
}