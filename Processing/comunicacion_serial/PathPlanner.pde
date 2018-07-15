class PathPlanner{
  private BallArray balls;
  private Car car;
   private comunicacion_serial p;
  private int index;
  private ArrayList<PVector> path;
  private final float PROXIMITY_THRESHOLD = 3;
  private final int WAITING = 0;
  private final int RETURN_ONEBALL = 1;
  private final int RETURN_ALLBALL = 2;
  private final int TRACK = 3;
  private final int RETURN = 4;
  public int mode;
  private boolean catched;

  // PathPlanner(BallArray b, Car c, comunicacion_serial p){
  PathPlanner(BallArray b, Car c, int m, comunicacion_serial p){
    balls = b;
    car = c;
    mode = m;
    this.p = p;
    index = 0;
    catched = false;
  }
  public boolean isCatched(){
    return catched;
  }
  public void setCatched(boolean b){
    catched = b;
  }
  public boolean hasFinished(){
    return path.size() == 0? true : isReached(path.get(path.size() -1));
  }

  public boolean isReached(PVector point){
    return car.getPos().sub(point).mag() <= PROXIMITY_THRESHOLD;
  }

  public void set(int mode){
    this.mode = mode;
  }

  public PVector getGoal(){
    return path.get(0).copy();
  }

  public boolean nextGoal(){
    path.remove(0);
    return path.size() == 1;
  }

  public boolean update(){
    path = new ArrayList<PVector>();
    if(balls.size() == 0){ //<>//
      return false;
    }
    if(mode == TRACK){ //<>//
      for(int i = 1; i <= p.ballArray.size(); i++){
        if(p.ballArray.getBall(i).getColor() == #FF0000){ // RED
          path.add(p.ballArray.getBall(i).getPos());
          break;
        }
      }
      // println("AHAHHAHHA");
      // path.add(new PVector(300,300));
      return true;
    }
    else{
      // path.add(car.getPos());
      path.add(new PVector(300,300));
      return false;
    }
  }
}
