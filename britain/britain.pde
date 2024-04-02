void setup() {
  size(720, 1015, OPENGL);
  
  background(255);
  
  float frameRatio = 0.9;
  float w = width - (1.0 - frameRatio) * height;
  float h = frameRatio * height;
  // drawFrame(w, h);
  drawSea(width / 2, height / 2, w, h, w / 10);
  
  save("out/final.png");  
  noLoop();
}

void drawFrame(float w, float h) {
  rectMode(CENTER);
  colorMode(RGB, 255, 255, 255, 1.0);
  fill(255, 255, 255, 0.4);
  noStroke();
  rect(width / 2,height / 2 , w, h);
}

void drawSea(float centerX, float centerY, float w, float h,float res) {
  float xIncr = 0.01 * res;
  float yIncr = 0.01 * res;
  int rows = (int)(h / res) + 1;
  int cols = (int)(w / res) + 1;
  
  // Create water elevation matrix
  noiseDetail(8, 0.6);
  float[][] matrix = new float[cols][rows];
  float minVal = Integer.MAX_VALUE;
  float maxVal = 0;
  float yOff = 0;
  for (int y = 0; y < rows; y++) {
    float xOff = 0;
    for (int x = 0; x < cols; x++) {
      float value = noise(xOff, yOff);
      matrix[x][y] = value;
      if (value < minVal) {
        minVal = value;
      }
      if (value > maxVal) {
        maxVal = value;
      }
      xOff += xIncr;
    }
    yOff += yIncr;
  }
  // Normalize
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      matrix[x][y] = map(matrix[x][y], minVal, maxVal, 0, 1);
    }
  }
  
  // Create water color layers and sort by elevation
  colorMode(HSB, 360, 100, 100, 1);
  color[] colors = {
    color(191, 82.9, 27.5, 0.02),
      color(192, 79.6, 38.4, 0.02),
      color(192, 67.6, 53.3, 0.02),
      color(191, 50.0, 58.8, 0.02),
      color(192,26.8, 76.1, 0.02),
      color(180, 13.5, 78.4, 0.02),
    };
  Painting painting = new Painting((int)w,(int)h);
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float value = matrix[x][y];
      if (value < 0.1) {
        painting.watercolors.add(new Watercolor(x * res, y * res, 0.5 * res, colors[0]));
      } else if (value < 0.3) {
        painting.watercolors.add(new Watercolor(x * res, y * res, 0.5 * res, colors[1]));
      } else if (value < 0.5) {
        painting.watercolors.add(new Watercolor(x * res, y * res, 0.5 * res, colors[2]));
      } else if (value < 0.7) {
        painting.watercolors.add(new Watercolor(x * res, y * res, 0.5 * res, colors[3]));
      } else if (value < 0.9) {
        painting.watercolors.add(new Watercolor(x * res, y * res, 0.5 * res, colors[4]));
      } else {
        painting.watercolors.add(new Watercolor(x * res, y * res, 0.5 * res, colors[5]));
      }
    }
  }
  painting.render();
}

