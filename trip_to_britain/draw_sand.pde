void drawSand(int n, int[][] palette) {
  PGraphics sandTexture = _createSandTexture(n, palette);
  image(sandTexture, 0, 0);
}

PGraphics _createSandTexture(int n, int[][] palette) {
  PGraphics sandTexture = createGraphics(width, height, P2D);
  sandTexture.beginDraw();
  
  for (int i = 0; i < n; i++) {
    // Watercolor base color texture
    PGraphics texture = createGraphics(width, height, P2D);
    texture.beginDraw();
    int[] c = palette[(int)(palette.length * Math.random())];
    texture.background(c[0], c[1], c[2]);
    texture.endDraw();
    
    float x = random(0, width);
    float y = random(0, height);
    float radius = random(0, 150);
    Watercolor watercolor = new Watercolor(x, y, radius);
    
    // Watercolor layer mask
    PGraphics mask = createGraphics(width, height, P2D);
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