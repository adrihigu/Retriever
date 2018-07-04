static class Car{
  private AtomicFloat x;
  private AtomicFloat y;
  private AtomicFloat dirX;
  private AtomicFloat dirY;
  private final float cWidth;
  private final float cHeight;
  private final String frontColor;
  private final String backColor;
  private BallArray balls;
  private final int carColor;
  private final prueba_camara_aerea parent;
  private final PShape carShape;

  Car(float cW, float cH, String fColor, String bColor, BallArray b, prueba_camara_aerea p){
    parent = p;
    x = new AtomicFloat();
    y = new AtomicFloat();
    dirX = new AtomicFloat();
    dirY = new AtomicFloat();
    cWidth = cW;
    cHeight = cH;
    frontColor = fColor;
    backColor = bColor;
    balls = b;
    carColor = #808080;
    carShape = parent.createShape();
    carShape.beginShape();
    carShape.fill(carColor);
    carShape.noStroke();
    carShape.vertex(0, 0);
    carShape.vertex(cWidth, 0);
    carShape.vertex(cWidth, cHeight);
    carShape.vertex(0, cHeight);
    carShape.endShape();
  }
  public PVector getPos(){
    return new PVector(getX(), getY());
  }
  public float getX(){
    return x.get();
  }
  public float getY(){
    return y.get();
  }
  public float getDirX(){
    return dirX.get();
  }
  public float getDirY(){
    return dirY.get();
  }
  public void set(float xF, float yF, float xB, float yB){
    x.set((xF + xB)/2);
    y.set((yF + yB)/2);
    dirX.set((xF - xB)/sqrt(sq(xF - xB) + sq(yF - yB)));
    dirY.set((yF - yB)/sqrt(sq(xF - xB) + sq(yF - yB)));
  }
  public String getFColor(){
    return frontColor;
  }
  public String getBColor(){
    return backColor;
  }
  public void setMatrix(){
    carShape.resetMatrix();
    //parent.shapeMode(CENTER);
    carShape.translate(getX(),getY());  
    carShape.rotate((new PVector(getDirX(),getDirY())).heading()-HALF_PI);
    carShape.translate(-cWidth/2, -cHeight/2);
  }
  public void display(){
    parent.shape(carShape, 0,0);
  }
}
