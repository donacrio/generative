import processing.svg.*;

void setup() {
  size(595,  842);
  
  beginRecord(SVG, "out/final.svg");
  
  background(255);
  
  int frame = (int)(width * 0.05);
  int w = width - frame;
  int h = height - frame;
  
  int res = 8;
  int rows = h / res;
  int cols = w / res;
  
  float perlinIncr = 0.02;
  noiseDetail(8,0.4);
  
  int size = 18;
  
  float[][] blueNoise = createPerlinNoise(rows, cols, 0, perlinIncr);  
  pushMatrix();
  translate(frame / 2, frame / 2);
  stroke(0, 0, 255);
  noFill();
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float value = blueNoise[x][y]; 
      circle(x * res, y * res, value * size);
    }
  }
  popMatrix();
  
  float[][] redNoise = createPerlinNoise(rows, cols, random(1000) , perlinIncr);  
  pushMatrix();
  translate(frame / 2, frame / 2);
  // translate(res / 2, res / 2);
  stroke(255, 0, 0);
  noFill();
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float value = redNoise[x][y]; 
      circle(x * res, y * res, value * size);
    }
  }
  popMatrix();
  
  endRecord();
  noLoop();
}

float[][] createPerlinNoise(int rows, int cols, float offset, float incr) {
  float[][] noise = new float[cols][rows];
  float minVal = Integer.MAX_VALUE;
  float maxVal = Integer.MIN_VALUE;
  float yOff = offset;
  for (int y = 0; y < rows; y++) {
    float xOff = offset;
    for (int x = 0; x < cols; x++) {
      float value = noise(xOff, yOff);
      minVal = min(minVal, value);
      maxVal = max(maxVal, value);
      noise[x][y] = noise(xOff, yOff);
      xOff += incr;
    }
    yOff += incr;
  }
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      noise[x][y] = map(noise[x][y], minVal, maxVal, 0, 1);
    }
  }
  return noise;
}
