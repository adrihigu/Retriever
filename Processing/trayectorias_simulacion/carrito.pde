
class Car extends Mover{
  // dimensions
  float width;
  float height;
  PVector forward_direction;
  private float current_vertex_index;
  private Trajectory t;

  Car(float m, PVector pos, float w, float h){
    super(m,pos.x,pos.y);
    this.height = h;
    this.width = w;
  }

  void followTrajectory(Trajectory t){
    this.t = t;
    current_vertex_index = 0;
  }
  void update(){
    PVector normal = new PVector(this.position.x, this.position.y - this.height/2);
    super.update();
  }
  void display() {
    stroke(255);
    strokeWeight(2);
    fill(255, 200);
    rect(position.x - this.width/2, position.y - this.height/2, this.width, this.height);
  
  }
}
