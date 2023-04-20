void MRT() {
  // exit 1
  pushMatrix();
  translate(50, 0);
  fill(rose);
  noStroke();
  rect(0, 0, exitW, exitH);
  popMatrix();

  // exit 2
  pushMatrix();
  translate(width-50-exitW, 0);
  fill(rose);
  noStroke();
  rect(0, 0, exitW, exitH);
  popMatrix();

  // exit 3
  pushMatrix();
  translate(width-50-exitW, height-exitH);
  fill(rose);
  noStroke();
  rect(0, 0, exitW, exitH);
  popMatrix();

  // exit 4
  pushMatrix();
  translate(50, height-exitH);
  fill(rose);
  noStroke();
  rect(0, 0, exitW, exitH);
  popMatrix();

  // platform
  pushMatrix();
  translate(width/2-500/2, height/2-150/2);
  fill(gold);
  noStroke();
  rect(0, 0, 500, 150);
  popMatrix();

  // escalator 1
  pushMatrix();
  translate(width/2-500/2, height/2-exitW/2);
  fill(255);
  noStroke();
  rect(0, 0, exitH, exitW);
  popMatrix();

  // escalator 2
  pushMatrix();
  translate(width/2+500/2-exitH, height/2-exitW/2);
  fill(255);
  noStroke();
  rect(0, 0, exitH, exitW);
  popMatrix();

  // escalator 3
  pushMatrix();
  translate(width/2-exitW/2, height/2-150/2);
  fill(255);
  noStroke();
  rect(0, 0, exitW, exitH);
  popMatrix();

  return;
}

PVector exit1 = new PVector(width-100/2-50, height-exitH/2);
PVector exit2 = new PVector(width-100/2-50, 40/2);
PVector exit3 = new PVector(150-exitW/2, 40/2);
PVector exit4 = new PVector(150-exitW/2, height-exitH/2);

PVector exit10 = new PVector(width-100/2-50, height);
PVector exit20 = new PVector(width-100/2-50, 0);
PVector exit30 = new PVector(150-exitW/2, 0);
PVector exit40 = new PVector(150-exitW/2, height);

PVector esca1 = new PVector(width/2-500/2+exitH/2, height/2);
PVector esca3 = new PVector(width/2+500/2-exitH/2, height/2);
PVector esca2 = new PVector(width/2, height/2-150/2+exitH/2);

PVector esca10 = new PVector(width/2-500/2+exitH, height/2);
PVector esca30 = new PVector(width/2+500/2-exitH, height/2);
PVector esca20 = new PVector(width/2, height/2-150/2+exitH);


PVector middL = PVector.add(exit3, exit4).mult(0.5);
PVector middR = PVector.add(exit2, exit1).mult(0.5);

// generating the vector that push up the middle point...
PVector a = PVector.sub(esca2, esca1);
PVector posy = PVector.sub(exit3, exit4).normalize();
PVector goesup = posy.mult(a.dot(posy)/2);

PVector middUL1 = PVector.add(exit3, middL).mult(0.5);
PVector middUL = PVector.add(middUL1, goesup);
PVector middUR1 = PVector.add(exit2, middR).mult(0.5);
PVector middUR = PVector.add(middUR1, goesup);
PVector middUM = PVector.add(middUL, middUR).mult(0.5);

PVector middDL1 = PVector.add(middL, exit4).mult(0.5);
PVector middDL = PVector.add(middDL1, new PVector(0, 20));

PVector middDR1 = PVector.add(middR, exit1).mult(0.5);
PVector middDR = PVector.add(middDR1, new PVector(0, 20));

void displayPoint(PVector p) {
  fill(violet);
  ellipse(p.x, p.y, 10, 10);
  return;
}

void displayMRTPoint() {
  displayPoint(exit1);
  displayPoint(exit2);
  displayPoint(exit3);
  displayPoint(exit4);
  displayPoint(esca1);
  displayPoint(esca2);
  displayPoint(esca3);
  displayPoint(middL);
  displayPoint(middR);
  displayPoint(middUL);
  displayPoint(middUR);
  displayPoint(middUM);
  displayPoint(middDL);
  displayPoint(middDR);
  return;
}
