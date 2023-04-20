Path p_exit4_esca1;
Path p_esca3_exit2;
Path p_esca2_exit3;
Path p_exit1_esca3;
Path p_exit4_exit1;
Path p_exit2_exit3;

boolean modelRuns = false;
// model route !
Path p_exit1_exit3;
ArrayList<Path> paths;
ArrayList<Passenger> passengers;
Passenger model;

int width = 1000;
int height = 580;
int exitW = 100;
int exitH = 40;

void setup() {
  size(1000, 580);
  newPath();

  // making up random passengers
  passengers = new ArrayList<Passenger>();
  for (int i = 0; i < 200; i++) {
    newPassenger(green);
  }
  newPassenger(red);
}

void draw() {  
  background(bg);
  MRT();
  displayMRTPoint();
  p_exit4_esca1.display();
  p_esca3_exit2.display();
  p_esca2_exit3.display();  
  p_exit1_esca3.display();
  p_exit4_exit1.display();
  p_exit2_exit3.display();
  p_exit1_exit3.display();
  
  for (int i = 0; i < 200; i++) {
    passengers.get(i).display(); 
    //if (keyPressed) {
      passengers.get(i).run();
      if (modelRuns) passengers.get(i).modelEnters(passengers.get(200));
    //}
  }
  passengers.get(200).run_model();
   if (modelRuns) {
   passengers.get(200).display(); 
  }
}

void mouseClicked() {
  passengers.get(200).location = exit1.copy();
  modelRuns = true;
}

void newPassenger(color c) {
  float maxspeed = 1.5;
  float maxforce = 0.5;
  Path p;
  if (c == red) {
    maxspeed = 1;
    p = p_exit1_exit3; 
  } else {
  int draw = int(random(paths.size()));
  p = paths.get(draw);
  }
  PVector point = p.points.get(0);
  PVector noise = new PVector(0, 0);
  while ((abs(noise.x) < 2) || (abs(noise.y) < 2)) {
    noise = new PVector(random(-20, 20), random(-20, 20));
  }
  PVector pos = PVector.add(point, noise);

  passengers.add(new Passenger(pos.x, pos.y, maxspeed, 
                  maxforce, p, c));
}

void newPath() {
  paths = new ArrayList<Path>();

  p_exit4_esca1 = new Path(turquo);
  p_exit4_esca1.addPoint(exit40);
  p_exit4_esca1.addPoint(middL);
  p_exit4_esca1.addPoint(esca10);
  paths.add(p_exit4_esca1);

  p_esca3_exit2 = new Path(turquo);
  p_esca3_exit2.addPoint(esca3);
  p_esca3_exit2.addPoint(middR);
  p_esca3_exit2.addPoint(exit20);
  paths.add(p_esca3_exit2);

  p_esca2_exit3 = new Path(turquo);
  p_esca2_exit3.addPoint(esca2);
  p_esca2_exit3.addPoint(middUM);
  p_esca2_exit3.addPoint(middUL);
  p_esca2_exit3.addPoint(exit30);
  paths.add(p_esca2_exit3);

  p_exit1_esca3 = new Path(turquo);
  p_exit1_esca3.addPoint(exit1);
  p_exit1_esca3.addPoint(middR);
  p_exit1_esca3.addPoint(esca30);
  paths.add(p_exit1_esca3);

  p_exit4_exit1 = new Path(turquo);
  PVector p411 = PVector.add(middDL, new PVector(0, 20));
  PVector p412 = PVector.add(middDR, new PVector(0, 20));
  p_exit4_exit1.addPoint(exit4);
  p_exit4_exit1.addPoint(p411);
  p_exit4_exit1.addPoint(p412);
  p_exit4_exit1.addPoint(exit10);
  paths.add(p_exit4_exit1);

  p_exit2_exit3 = new Path (turquo); 
  p_exit2_exit3.addPoint(exit2);
  PVector p1 = PVector.add(exit2, new PVector(0, 70));
  p_exit2_exit3.addPoint(p1);
  PVector p2 = PVector.add(exit3, new PVector(0, 70));
  PVector p12 = PVector.add(p1, p2).mult(0.5);
  p_exit2_exit3.addPoint(p12);
  p_exit2_exit3.addPoint(p2);
  p_exit2_exit3.addPoint(exit30);
  paths.add(p_exit2_exit3);
  
  // model route !!
  p_exit1_exit3 = new Path(pink_a);
  PVector p131 = PVector.add(middDR, new PVector(0, -20));
  PVector p132 = PVector.add(middDL, new PVector(0, -20));
  p_exit1_exit3.addPoint(exit1);
  p_exit1_exit3.addPoint(p131);
  p_exit1_exit3.addPoint(p132);
  p_exit1_exit3.addPoint(exit30);
  paths.add(p_exit1_exit3);
}
