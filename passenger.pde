class Passenger {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;              // additional variable for size
  float maxspeed;
  float maxforce;
  float mass;
  Path path;            // the path the passenger is following
  color passengerColor;

  Passenger(float x, float y, float s, float f, Path p, color c) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(0.05, 0.1), random(0.02, 0.1));
    location = new PVector(x, y);
    r = 2.5;
    maxspeed = s;
    maxforce = f;
    mass = 1;
    path = p;
    passengerColor = c;
  }

  void applyBehaviors(ArrayList passengers) {
    PVector fol = follow();
    PVector sep = separate(passengers);
    PVector ali = align(passengers);
    fol.mult(1.0);    // following the designated path
    sep.mult(0.2);      // separation rule
    ali.mult(0.05);   // alignment rule
    applyForce(fol);
    applyForce(sep);
    applyForce(ali);
  }

  void run() {
    update();
    applyBehaviors(passengers);
    border();
  }

  void run_model() {
    update();
    PVector fol = follow();
    applyForce(fol);
  }

  void update() {
    //    PVector noiseV = new PVector(random(-0.05, 0.05), random(-0.05, 0.05));
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
    // println(location);
  }

  void applyForce(PVector force) {
    acceleration.add(force.mult(1/mass));
  }

  void modelEnters(Passenger model) {
    PVector steer = new PVector(0, 0);
    PVector target = new PVector(0, 0);
    passengerColor = green;
    maxspeed = 1.5;
    if (PVector.dist(model.location, location) < 100) {
      maxspeed = 0.4;
      passengerColor = violet;
      PVector mol_next_loc = PVector.add(model.location.copy(),
        model.velocity.copy().mult(10));
      PVector loc_to_mol = PVector.sub(mol_next_loc, location);
      if (velocity.dot(loc_to_mol) > 0) { // i can 'see' the model
        
        PVector dir = PVector.sub(model.location, location).normalize();
        float distance = PVector.dist(model.location, location);
        float len = distance - 20;    // apart by 20 !
        target = dir.mult(len);
        steer = seek(target);
        steer.limit(maxforce/2);
      }
    }
    applyForce(steer);
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList boids) {

    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0; i < boids.size(); i++) {
      float desiredseparation = r*3;
      if (i == 200) desiredseparation = r*20;
      Passenger other = (Passenger) boids.get(i);
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Passenger> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Passenger other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist) && other.path == path) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
  }

  void display() {      // triangle vehicle
    float theta = velocity.heading() + PI/2;
    fill(passengerColor);
    //    stroke(sunset);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }

  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // PVector that points from a to p
    PVector ap = PVector.sub(p, a);
    // PVector that points from a to b
    PVector ab = PVector.sub(b, a);

    //[full] Using the dot product for scalar projection
    ab.normalize();
    ab.mult(ap.dot(ab));
    //[end]
    // Finding the normal point along the line segment
    PVector normalPoint = PVector.add(a, ab);

    return normalPoint;
  }

  void border() {
    float upperX = width/2 + 210;
    float lowerX = width/2 - 210;
    float upperY = height/2 + 75;
    float lowerY = height/2 - 75 + 40;
    boolean inPlatform = (location.x > lowerX && location.x < upperX)
      && (location.y > lowerY && location.y < upperY);

    if (inPlatform) {
      PVector noise = new PVector(random(-40, 40), random(-40, 40));
      if (noise.y > 20) {
        location = PVector.add(esca3, noise);
        path = p_esca3_exit2;
      } else if (noise.y > -10) {
        location = PVector.add(exit2, noise);
        path = p_exit2_exit3;
      } else {
        location = PVector.add(exit1, noise);
        path = p_exit1_exit3;
      }
    }

    boolean outOfStation = location.x < 0 || location.x > width ||
      location.y < 0 || location.y > height;

    if (outOfStation) {
      PVector noise = new PVector(random(-40, 40), random(-40, 40));
      if (noise.y > 5) {
        location = PVector.add(esca2, noise);
        path = p_esca2_exit3;
      } else if (noise.y > -30) {
        location = PVector.add(exit4, noise);
        if (int(noise.x) %2 == 0) {
          path = p_exit4_esca1;
        } else {
          path = p_exit4_exit1;
        }
      } else {
        location = PVector.add(exit1, noise);
        path = p_exit1_esca3;
      }
    }
  }

  PVector follow() {
    // Predict position 50 (arbitrary choice) frames ahead
    // This could be based on speed
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(50);
    PVector predictpos = PVector.add(location, predict);

    // Now we must find the normal to the path from the predicted position
    // We look at the normal for each line segment and pick out the closest one

    PVector normal = null;
    PVector target = null;
    float worldRecord = 1000000;  // Start with a very high record distance that can easily be beaten

    // Loop through all points of the path
    for (int i = 0; i < path.points.size()-1; i++) {

      // Look at a line segment
      PVector a = path.points.get(i);
      PVector b = path.points.get(i+1);

      // Get the normal point to that line
      PVector normalPoint = getNormalPoint(predictpos, a, b);
      // This only works because we know our path goes from left to right
      // We could have a more sophisticated test to tell if the point is in the line segment or not
      if (PVector.dist(a, normalPoint) + PVector.dist(b, normalPoint)
        > PVector.dist(a, b)) { // if normalPoint is not on ab
        normalPoint = b;
      }

      // How far away are we from the path?
      float distance = PVector.dist(predictpos, normalPoint);
      // Did we beat the record and find the closest line segment?
      if (distance < worldRecord) {
        worldRecord = distance;
        // If so the target we want to steer towards is the normal
        normal = normalPoint;

        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        PVector dir = PVector.sub(b, a);
        dir.normalize();
        // This is an oversimplification
        // Should be based on distance to path & velocity
        dir.mult(5);
        target = normalPoint.get();
        target.add(dir);
      }
    }

    // Only if the distance is greater than the path's radius do we bother to steer
    if (worldRecord > path.radius) {
      return seek(target);
    } else {
      return new PVector(0, 0);
    }
  }
}
