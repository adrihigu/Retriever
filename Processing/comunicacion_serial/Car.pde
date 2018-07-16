static class Car{
  private AtomicFloat x;
  private AtomicFloat y;
  private AtomicFloat xF;
  private AtomicFloat yF;
  private AtomicFloat xB;
  private AtomicFloat yB;
  private AtomicFloat dirX;
  private AtomicFloat dirY;
  private final float cWidth;
  private final float cHeight;
  private final String frontColor;
  private final String backColor;
  //private BallArray balls;
  private final int carColor;
  private final comunicacion_serial parent;
  private final PShape carShape;

  Car(float cW, float cH, String fColor, String bColor, comunicacion_serial p){
  //Car(float cW, float cH, String fColor, String bColor, BallArray b, prueba_camara_aerea p){
    parent = p;
    x = new AtomicFloat();
    y = new AtomicFloat();
    xF = new AtomicFloat();
    yF = new AtomicFloat();
    xB = new AtomicFloat();
    yB = new AtomicFloat();
    dirX = new AtomicFloat();
    dirY = new AtomicFloat();
    cWidth = cW;
    cHeight = cH;
    frontColor = fColor;
    backColor = bColor;
    //balls = b;
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
  public PVector getPosF(){
    return new PVector(xF.get(), yF.get());
  }
  public PVector getPosB(){
    return new PVector(xB.get(), yB.get());
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
  public PVector getDir(){
    return new PVector(getDirX(), getDirY()).normalize();
  }
  public void set(float xF, float yF, float xB, float yB){
    this.xF.set(xF);
    this.yF.set(yF);
    this.xB.set(xB);
    this.yB.set(yB);
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
