void drawWater(
  float texture_perlin,
  float texture_weight,
  int[][] texture_palette,
  float mask_perlin,
  float mask_weight
 ){
  PGraphics waterTexture = _createWaterTexture(texture_perlin, texture_weight, texture_palette);
  PGraphics waterMask = _createWaterMask(mask_perlin, mask_weight);
  waterTexture.mask(waterMask);
  image(waterTexture, 0, 0);
}

PGraphics _createWaterTexture(float perlin, float weight, int[][] palette) {  
  FlowField waterTextureFlowField = new FlowField(perlin,weight * 2,weight * 1.0);
  
  PGraphics waterTexture = createGraphics(width, height, P2D);
  waterTexture.beginDraw();
  waterTexture.background(255);
  waterTexture.noFill();
  waterTexture.strokeWeight(weight);
  for (FlowLine line : waterTextureFlowField.lines) {
    int[] c = palette[(int)(palette.length * Math.random())];
    waterTexture.stroke(c[0], c[1], c[2]);
    waterTexture.beginShape();
    for (Coordinate coord : line.path) {
      waterTexture.vertex((float) coord.x,(float) coord.y);
    } 
    waterTexture.endShape();
  }
  waterTexture.endDraw();
  
  return waterTexture;
}

PGraphics _createWaterMask(float perlin, float weight) {
  FlowField waterFlowField = new FlowField(perlin, weight * 6, weight * 3);
  
  PGraphics waterMask = createGraphics(width, height, P2D);
  waterMask.beginDraw();
  waterMask.noFill();
  waterMask.stroke(255);
  waterMask.strokeWeight(weight);
  for (FlowLine line : waterFlowField.lines) {
    waterMask.beginShape();
    for (Coordinate coord : line.path) {
      waterMask.vertex((float) coord.x,(float) coord.y);
    } 
    waterMask.endShape();
  }
  waterMask.endDraw();
  
  return waterMask;
}