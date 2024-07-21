final float SIGMA = 10;
final float RHO = 28;
final float BETA = 8 / 3;

final int N_PARTICLES = 50_000;
ArrayList<PVector> particles;


final float dt = 0.001;
final int step = 1;

void setup() {
  size(720, 720, P3D);
  background(0);
  
  particles = new ArrayList<PVector>();
  
  for(int i = 0; i < N_PARTICLES; i++) {
    float x = random(1);
    float y = random(1);
    float z = random(1);
    float scale = random(300) * (pow(random(1),(1/3))) / sqrt(pow(x,2) + pow(y,2) + pow(z,2));
    PVector particle = new PVector(x*scale, y*scale, z*scale);
    particles.add(particle);
  }
  
  noStroke();
  fill(255);

  camera(
    width / 2.0,
    height / 2.0,
    (height/2.0) / tan(PI*30.0 / 180.0),
    0,
    0,
    0,
    0,
    1,
    0
  );
}

void draw() {
  background(0);
  for (PVector particle : particles) {   
    particle.add(getLorentz(particle).mult(dt));

    pushMatrix();
    translate(particle.x, particle.y, particle.z);
    sphere(1);
    popMatrix();
  }

  saveFrame("out/frame-######.png");
}
 
PVector getLorentz(PVector p) {
      return new PVector(
        SIGMA * (p.y - p.x),
        p.x * (RHO - p.z) - p.y,
        p.x * p.y - BETA * p.z
        );
    }