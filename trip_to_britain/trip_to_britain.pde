int[][] WATER_TEXTURE_PALETTE = {
  {6,66,115} , 
  {118,182,196} , 
  {127,205,255} ,
  {29,162,216} ,
  {222,243,246}
};

int[][] SAND_PALETTE = {
  {246,215,176} ,
  {242,210,169} ,
  {236,204,162} ,
  {231,196,150} ,
  {225,191,146} 
};

void setup() {
  size(1008, 720, P2D);
  
  //Create water texture
  float waterTexturePerlin = 0.05;
  float waterTextureWeight = 1;
  FlowField waterTextureFlowField = new FlowField(waterTexturePerlin, waterTextureWeight * 2, waterTextureWeight * 1.0);
  
  PGraphics waterTexture = createGraphics(width, height, P2D);
  waterTexture.beginDraw();
  waterTexture.background(255);
  waterTexture.noFill();
  waterTexture.strokeWeight(waterTextureWeight);
  for (FlowLine line : waterTextureFlowField.lines) {
    int[] c = WATER_TEXTURE_PALETTE[(int)(WATER_TEXTURE_PALETTE.length * Math.random())];
    waterTexture.stroke(c[0], c[1], c[2]);
    waterTexture.beginShape();
    for (Coordinate coord : line.path) {
      waterTexture.vertex((float) coord.x,(float) coord.y);
    } 
    waterTexture.endShape();
  }
  waterTexture.endDraw();
  
  //Create water flow lines mask
  float waterPerlin = 0.0025;
  float waterWeight = 10;
  FlowField waterFlowField = new FlowField(waterPerlin, waterWeight * 6, waterWeight * 3);
  
  PGraphics waterMask = createGraphics(width, height, P2D);
  waterMask.beginDraw();
  waterMask.noFill();
  waterMask.stroke(255);
  waterMask.strokeWeight(waterWeight);
  for (FlowLine line : waterFlowField.lines) {
    waterMask.beginShape();
    for (Coordinate coord : line.path) {
      waterMask.vertex((float) coord.x,(float) coord.y);
    } 
    waterMask.endShape();
  }
  waterMask.endDraw();
  waterTexture.mask(waterMask);
  
  
  noStroke();
  int nWatercolors = 300;
  for (int i = 0; i < nWatercolors; i++) {
    // Watercolor base color texture
    PGraphics texture = createGraphics(width, height, P2D);
    texture.beginDraw();
    int[] c = SAND_PALETTE[(int)(SAND_PALETTE.length * Math.random())];
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
    image(texture, 0, 0);
  }
  
  image(waterTexture, 0, 0);
  
  drawCanvas();
  
  save("out/final.png");  
  noLoop();
}