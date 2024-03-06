int WIDTH = 2500;
int HEIGHT = 2000;
float SCALE = 5;
float PERLIN_INCR = 0.01;

void drawRocks() {
  int rows = (int)(HEIGHT / SCALE) + 1;
  int cols = (int)(WIDTH / SCALE) + 1;
  
  PGraphics sandTexture = _createSandTexture(SAND_TEXTURE_N_WATERCOLOR, SAND_PALETTE);
  
  float[][] elevation = new float[cols][rows];
  float yOff = 0;
  for (int y = 0; y < rows; y++) {
    float xOff = 0;
    for (int x = 0; x < cols; x++) {
      elevation[x][y] = map(noise(xOff, yOff), 0, 1, -500, 500);
      xOff += PERLIN_INCR;
    }
    yOff += PERLIN_INCR;
  }
  
  PGraphics rocks = createGraphics(width, height, P3D);
  rocks.beginDraw();
  rocks.background(0);
  
  rocks.directionalLight(255, 255, 255, 1, -1, -1);
  // rocks.ambientLight(50, 50, 50);
  
  rocks.noStroke();
  rocks.fill(255);
  
  rocks.translate(0, height / 2);
  rocks.rotateX(PI / 3);
  rocks.translate( -WIDTH / 2, -HEIGHT / 2);
  for (int y = 0; y < rows - 1; y++) {
    rocks.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols - 1; x++) {
      rocks.vertex(x * SCALE, y * SCALE, elevation[x][y]);
      rocks.vertex(x * SCALE,(y + 1) * SCALE, elevation[x][y + 1]);
    }
    rocks.endShape();
  }
  rocks.endDraw();
  
  PGraphics waterTexture = _createWaterTexture(
    0.005,
    WATER_TEXTURE_WEIGHT,
    WATER_TEXTURE_PALETTE
   );
  image(waterTexture, 0, 0);
  
  sandTexture.mask(rocks);
  image(sandTexture, 0, 0);
}