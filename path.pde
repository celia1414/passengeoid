 class Path {
  // A Path is now an ArrayList of points (PVector objects).
  ArrayList<PVector> points;
  float radius;
  color pathColor;

  Path(color c) {
    pathColor = c;
    radius = 50;
    points = new ArrayList<PVector>();
  }

  //[full] This function allows us to add points to the path.
  void addPoint(PVector p) {
    PVector point = new PVector(p.x,p.y);
    points.add(point);
  }
  //[end]

  //[full] Display the path as a series of points.
  void display() {
    strokeWeight(radius*2);
    stroke(pathColor,100);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x,v.y);
    }
    endShape();
    
    strokeWeight(1);
    stroke(0);
    noFill();
    beginShape();
    for (PVector v : points) {
      vertex(v.x,v.y);
    }
    endShape();
  }
}
