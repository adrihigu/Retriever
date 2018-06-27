
class Trajectory{
  ArrayList<PVector> vertices;
  float res = 10;
  float max_angle = radians(3);
  
  Trajectory(PVector car, PVector ball, PVector end){
    float end_dist = PVector.dist(ball, end);
    float end_res = res/end_dist;
    vertices = new ArrayList<PVector>();
    vertices.add(ball.copy());
    while(PVector.dist(vertices.get(vertices.size() -1), end) >= res){
      PVector last = vertices.get(vertices.size() -1);
      vertices.add(PVector.lerp(last, end, end_res));
    }
    println("A");
    //println(PVector.angleBetween(PVector.sub(vertices.get(0), vertices.get(1)), PVector.sub(car, vertices.get(0))));
    float angle_diff = PVector.angleBetween(PVector.sub(vertices.get(0), vertices.get(1)), PVector.sub(car, vertices.get(0)));
    float angle_dir = 0; // = (car.x - vertices.get(0).x) > 0? 1 : -1;
    PVector dir = PVector.sub(vertices.get(0), vertices.get(1)).normalize();
    PVector dist = PVector.sub(car, vertices.get(0)).normalize();
    //if(sin(dist.heading()) < 0){
    // angle_dir = cos(dist.heading()) >= 0?  -1 : 1;
    //}else if(sin(dist.heading()) > 0){
    //  angle_dir = cos(dist.heading()) >= 0?  1 : -1;
    //}
    angle_dir = cos(dist.heading()) >= 0?  1 : -1;
    print(angle_dir);
    while( angle_diff > max_angle && PVector.dist(vertices.get(0), car) >= res){
      dir = PVector.sub(vertices.get(0), vertices.get(1)).normalize();
      dist = PVector.sub(car, vertices.get(0)).normalize();
      float angle = degrees(trueAngle(dir)) + degrees(angle_dir*max_angle);
      PVector next = PVector.fromAngle(radians(angle)).mult(sqrt(res)).add(vertices.get(0));
      vertices.add(0,next);
      angle_diff = PVector.angleBetween(PVector.sub(vertices.get(0), vertices.get(1)), PVector.sub(car, vertices.get(0)));
      //println(degrees(angle_diff));
      if(vertices.size()>300) break;
    }
    while(PVector.dist(vertices.get(0), car) >= res){
      vertices.add(0, PVector.lerp(vertices.get(0), car, end_res));
    }
  }
  
  private float trueAngle(PVector vec){
    return vec.heading() < 0? 2*PI + vec.heading(): vec.heading();
  }

  void display(){
    noFill();
    stroke(color(66, 244, 66));
    strokeWeight(4);
    beginShape();
    for(PVector v : vertices){
      curveVertex(v.x, v.y);
      //print(v);
    };
    endShape();
  }
}
