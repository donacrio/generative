int step = 100;

System system;

void setup() {
  size(500, 500);
  
  system = new System(1);
  
  for (int i = 0; i < 3; i++) {
    float weight = randomGaussian() * 1;
    system.register(new Particle(weight, weight * 10, new PVector(random(width), random(height)), new PVector(0, 0), new PVector(0, 0)));
  }
}

void draw() {
  for (int i = 0; i < step; i++) {
    system.update();
  }
  
  background(0);
  for (Particle p : system.particles) {
    ellipse(p.position.x, p.position.y, p.radius, p.radius);
    println(p.acceleration);
  }
}

class Particle {
  float weight;
  float radius;
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  Particle(float weight, float radius, PVector position, PVector velocity, PVector acceleration) {
    this.weight = weight;
    this.radius = radius;
    this.position = position;
    this.velocity = velocity;
    this.acceleration = acceleration;
  }
  
  void update(PVector acceleration) {
    this.acceleration = acceleration;
    velocity.add(acceleration);
    position.add(velocity);
    
    if (position.x > width) {
      position.x = 0;
    }
    if (position.x < 0) {
      position.x = width;
    }
    if (position.y > height) {
      position.y = 0;
    }
    if (position.y < 0) {
      position.y = height;
    }
  }
}

class System {
  float G;
  ArrayList<Particle> particles;
  
  System(float G) {
    this.G = G;
    this.particles = new ArrayList<Particle>();
  }
  
  void register(Particle p) {
    particles.add(p);
  }
  
  void update() {
    for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      PVector acceleration = new PVector(0, 0);
      for (int j = 0; j < particles.size(); j++) {
        if (i != j) {
          Particle other = particles.get(j);
          PVector direction = PVector.sub(other.position, p.position);
          PVector contrib = direction.mult(other.weight).div(pow(direction.mag(), 3) + 100);
          println(contrib.mult(this.G));
          acceleration.add(contrib);
        }
      }
      p.update(acceleration.mult(this.G));
    }
  }
}