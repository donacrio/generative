float[][] points;

void setup() {
  size(1500, 667);
  
  PImage img = loadImage("britain.jpg");
  img.resize(width / 3, height);
  image(img, 0, 0);
  
  PImage edgeImg = createEdgeImage(img);
  edgeImg.resize(width / 3, height);
  // image(edgeImg, 0, 0); 
  
  ArrayList<PVector> points = sampleDensityPoints(edgeImg, 10000);
  
  PGraphics pg = createGraphics(width / 3, height);
  pg.beginDraw();
  pg.background(0);
  pg.noStroke();
  pg.fill(255);
  for (PVector point : points) {
    pg.circle(point.x, point.y, 1);
  }
  pg.endDraw();
  image(pg, 2 * width / 3, 0); 
  
  PImage meshified = meshify(img);
  img.resize(width / 3, height);
  image(meshified, width / 3, 0);
  
  
  noLoop();
}
