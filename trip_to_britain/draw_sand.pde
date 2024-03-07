void drawSand(int n, int weight, int[][] palette) {
  PGraphics sandTexture = createSandTexture(n, weight, palette);
  image(sandTexture, 0, 0);
}
PGraphics createSandTexture(int n, int weight, int[][] palette) {
  PGraphics texture = createGraphics(width, height, P2D);
  int SIZE = 500;
  PGraphics pattern = createSandTexturePattern(SIZE, SIZE, n, weight, palette);
  texture.beginDraw();
  for (int i = 0; i <= width / SIZE; i ++) {
    for (int j = 0; j <= height / SIZE; j ++) {
      texture.pushMatrix();
      texture.translate(i * SIZE, j * SIZE);
      pattern.scale(i % 2 == 0 ? 1 :-  1, j % 2 ==  0 ? 1 :-  1);
      texture.image(pattern, 0, 0);
      texture.popMatrix();
    } 
  }
  texture.endDraw();
  
  return texture;
}
PGraphics createSandTexturePattern(int w, int h, int n, int r, int[][] palette) {
  PGraphics sandTexture = createGraphics(w, h, P2D);
  sandTexture.beginDraw();
  
  for (int i = 0; i < n; i++) {
    println("Creating sand watercolor " + i + " of " + n);
    // Watercolor base color texture
    PGraphics texture = createGraphics(w, h, P2D);
    texture.beginDraw();
    int[] c = palette[(int)(palette.length * Math.random())];
    texture.background(c[0], c[1], c[2]);
    texture.endDraw();
    
    float x = random(0, w);
    float y = random(0, h);
    float radius = random(0, r);
    Watercolor watercolor = new Watercolor(x, y, radius);
    
    // Watercolor layer mask
    PGraphics mask = createGraphics(w, h, P2D);
    mask.beginDraw();
    mask.noStroke();
    for (Polygon polygon : watercolor.shape) { 
      // Each layer will let 2% of the color 
      mask.fill(255, 255, 255, 5);
      mask.beginShape();
      for (Coordinate coord : polygon.getExteriorRing().getCoordinates()) {
        mask.vertex((float)coord.x,(float) coord.y);
      }
      mask.endShape();
    }
    mask.endDraw();
    
    texture.mask(mask);
    sandTexture.image(texture, 0, 0);
  }
  sandTexture.endDraw();
  
  return sandTexture;
}