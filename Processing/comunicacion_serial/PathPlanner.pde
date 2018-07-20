class PathPlanner{ //<>// //<>// //<>//
  //private BallArray balls;
  private Car car;
  private comunicacion_serial p;
  private int index;
  private ArrayList<PVector> path;
  private final float PROXIMITY_THRESHOLD = 0.15;
  private final float STOP_MARGIN = 10;
  private final float FINAL_THRESHOLD = 0.22;
  private final float ROT_CONST = 10/(-0.20310407595025542);
  private final float LIN_CONST = 80/(-0.0757495414577356);
  private final int WAITING = 0;
  private final int RETURN_ONEBALL = 1;
  private final int RETURN_ALLBALL = 2;
  private final int TRACK = 3;
  private final int REACH = 5;
  private final int _RETURN = 4;
  public int mode;
  private boolean catched;
  private AtomicFloat goalX;
  private AtomicFloat goalY;
  private final float MAX_ANGLE_DIFF = radians(3);
  private MiniPID linPid;
  private MiniPID rotPid;
  private double rotOut;
  private double linOut;
  private final double KP_LIN = 0.05;
  private final double KI_LIN = 0;
  private final double KD_LIN = 0;
  private final double KP_ROT = 0.05;
  private final double KI_ROT = 0;
  private final double KD_ROT = 0;
  private boolean isRot = true;
  // PathPlanner(BallArray b, Car c, comunicacion_serial p){
  //PathPlanner(BallArray b, Car c, int m, prueba p){
  PathPlanner(Car c, int m, comunicacion_serial p){
    //balls = b;
    car = c;
    mode = m;
    this.p = p;
    index = 0;
    catched = false;
    goalX = new AtomicFloat();
    goalY = new AtomicFloat();
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
    if(mode == TRACK && path.size() == 1){
      //println(point, car.getPos());
      //println(car.getPos().sub(point).mag());
      return car.getPos().sub(point).mag() <= FINAL_THRESHOLD;
    }
     if(mode == RETURN_ONEBALL){
      //println(point, car.getPos());
      //println(car.getPos().sub(point).mag());
      return car.getPos().sub(point).mag() <= PROXIMITY_THRESHOLD;
    }
    return car.getPos().sub(point).mag() <= PROXIMITY_THRESHOLD;
  }

  public void setMode(int mode){
    this.mode = mode;
  }

  public PVector getGoal(){
    return path.get(0).copy();
  }

  public boolean nextGoal(){
    if(mode == REACH && path.size() == 1){
      return true;
    }
    path.remove(0);
    return path.size() == 1;
  }
  
  public void setGoal(float x, float y){
    goalX.set(x);
    goalY.set(y);
  }
  public boolean update(){
    path = new ArrayList<PVector>();
    if(mode == TRACK){
      for(int i = 1; i <= p.ballArray.size(); i++){
        if(p.ballArray.getBall(i).getColor() == #FF0000){ // RED
          path.add(p.ballArray.getBall(i).getPos());
          break;
        }
      }
      
      rotPid = new MiniPID(KP_ROT, KI_ROT, KD_ROT);
      linPid = new MiniPID(KP_LIN, KI_LIN, KD_LIN);
      rotPid.setDirection(true);
      isRot = true;
      return true;
    }
    else if(mode == RETURN_ONEBALL){
      for(int i = 1; i <= p.ballArray.size(); i++){
        if(p.ballArray.getBall(i).getColor() == #FF0000){ // RED
          path.add(p.ballArray.getBall(i).getPos());
          path.add(new PVector(0 ,0));
          break;
        }
      }
      
      rotPid = new MiniPID(KP_ROT, KI_ROT, KD_ROT);
      linPid = new MiniPID(KP_LIN, KI_LIN, KD_LIN);
      rotPid.setDirection(true);
      isRot = true;
      return true;
    }
    else{
      path.add(p.carrito.getPos());
      return false;
    }
  }
  
  public boolean isGoalInFront(float angle){
    return angle <= MAX_ANGLE_DIFF? true : false;
  }
  
  public void followPath(float angle){
    linOut =  linPid.getOutput(PVector.dist(getGoal(),p.carrito.getPos()), 0);
    rotOut = rotPid.getOutput(angle, 0);
    //println("lin: ", linOut, " rot: ", rotOut);
    //println("linFix: ", fixLin(angle), " rotFix: ", fixRot(fixLin(angle), PVector.dist(getGoal(),p.carrito.getPos())));
    //println("lin: ", linOut*LIN_CONST, " rot: ", rotOut*ROT_CONST);
  }
  
  public int checkDir(float angle){
    return p.carrito.getDir().copy().cross(PVector.sub(getGoal(),p.carrito.getPos())).z >= 0? -1 : 1;
  }
  
  public boolean applyPath(){ // retorna falso cuando se acabo el camino
    if(path == null || path.size() == 0) return false;
    if(isReached(getGoal())){
      if(nextGoal()){ // se acabo el camino
        p.duty = 0;
        p.dutySide = 0;
        return false;
      }
      else{
        nextGoal();
        linPid.reset();
        rotPid.reset();
      }
    }
    float angle =  PVector.angleBetween(PVector.sub(getGoal(),p.carrito.getPos()), p.carrito.getDir());
    int dir = checkDir(angle);
    followPath(angle);
    //println(degrees(angle));
    if(isGoalInFront(angle)){
       p.dutySide = (int)fixRot(fixLin(angle), PVector.dist(getGoal(),p.carrito.getPos()));
       p.duty = (int)fixLin(angle);
       p.M1mTx = false;
       p.M2mTx = false;
       p.ds = dir == -1? 0: 1;
    }
    else if(dir == -1){ // counter clockwise
      p.duty = (int)fixRot(fixLin(angle), PVector.dist(getGoal(),p.carrito.getPos()));
      p.M1mTx = false;
      p.M2mTx = true;
    }else if(dir == 1){ // clockwise
      //p.duty = rotOut;
      p.duty = (int)fixRot(fixLin(angle), PVector.dist(getGoal(),p.carrito.getPos()));
      p.M1mTx = true;
      p.M2mTx = false;
    }
    return true;
  }
  
  public float fixLin(float currentAngle){
    if(currentAngle < MAX_ANGLE_DIFF){
      if((linOut*LIN_CONST) > 27){
        return (float)(linOut*LIN_CONST);
      }
      if((linOut*LIN_CONST) > STOP_MARGIN &(linOut*LIN_CONST) <= 27){
        return (float)27;
      }
    }
    else{
      return (float)0;
    }
    
    if((linOut*LIN_CONST) < STOP_MARGIN){
      return (float)0;
    }
    return 0;
  }
  
  public float fixRot(float linFix,float currentDistance){
    if((linOut*LIN_CONST) < STOP_MARGIN){
      
      return 0;
    } else
    return (float)((rotOut*ROT_CONST) + ((linFix == 0) ? 10 : 0));
    //if(currentDistance > FINAL_THRESHOLD + 10){
    //  if(linFix == 0)
    //    return (float)(rotOut*ROT_CONST) + 27;
    //  else{
    //    return 0;
    //  }
    //}
    //else{
    //  return (float)(rotOut*ROT_CONST);
    //}
  }
  
}
