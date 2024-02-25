int[] SKECTH_BACKGROUND = {223,197,164}; // SAND
int[] WATER_TEXTURE_BACKGROUND = {98,125,154}; // BLUE
int[][] WATER_TEXTURE_PALETTE = {
  {186,187,189} , // GREY
  {46,50,87} , // DARK BLUE
  {98,125,154} , // BLUE
  {255,254,247} // CREAM
};

void setup() {
  size(1008, 720, P2D);
  
  //Create water texture
  float waterTexturePerlin = 0.05;
  float waterTextureWeight = 1;
  FlowField waterTextureFlowField = new FlowField(waterTexturePerlin, waterTextureWeight * 2, waterTextureWeight * 1.0);
  
  PGraphics waterTexture = createGraphics(width, height, P2D);
  waterTexture.beginDraw();
  waterTexture.background(WATER_TEXTURE_BACKGROUND[0], WATER_TEXTURE_BACKGROUND[1], WATER_TEXTURE_BACKGROUND[2]);
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
  float waterPerlin = 0.001;
  float waterWeight = 10;
  FlowField waterFlowField = new FlowField(waterPerlin, waterWeight * 3, waterWeight * 1.5);
  
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
  
  
  background(SKECTH_BACKGROUND[0], SKECTH_BACKGROUND[1], SKECTH_BACKGROUND[2]);
  image(waterTexture, 0, 0);
  
  drawCanvas();
  
  save("out/final.png");  
  noLoop();
}