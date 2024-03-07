

PGraphics createElevationMask(
  float[][] elevationMatrix,
  float scale,
  float threshold
 ) {
  int rows = elevationMatrix[0].length;
  int cols = elevationMatrix.length;
  
  PGraphics mask = createGraphics(width, height, P2D);
  mask.beginDraw();
  mask.noStroke();
  
  for (int y = 0; y < rows; y++) {
    mask.beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      float elevation = elevationMatrix[x][y];
      mask.fill(0);
      if (elevation > threshold) {
        mask.fill(255);
      }
      mask.vertex(x * scale, y * scale);
      mask.vertex(x * scale,(y + 1) * scale);
    }
    mask.endShape();
  }
  mask.endDraw();
  
  return mask;
}

float[][] createGradientElevationMatrix(int rows, int cols, float perlin_incr) {
  float[][] elevationMatrix = createElevationMatrix(rows, cols, perlin_incr);
  float[][] gradientMatrix = createGradientMatrix(rows, cols);
  float[][] matrix = new float[cols][rows];
  float maxValue = 0;
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float value = elevationMatrix[x][y] * gradientMatrix[x][y];
      matrix[x][y] = value;
      if (value > maxValue) {
        maxValue = value;
      }
    }
  }
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      matrix[x][y] /= maxValue;
    }
  }
  return matrix;
}

float[][] createElevationMatrix(int rows, int cols, float perlin_incr) {
  // noiseDetail(8, 0.5);
  float[][] elevations = new float[cols][rows];
  float yOff = 0;
  for (int y = 0; y < rows; y++) {
    float xOff = 0;
    for (int x = 0; x < cols; x++) {
      elevations[x][y] = noise(xOff, yOff);
      xOff += perlin_incr;
    }
    yOff += perlin_incr;
  }
  
  return elevations;
}

float[][] createGradientMatrix(int rows, int cols) {
  float centerX = cols / 2;
  float centerY = rows / 2;
  float maxGradient = 0;
  float[][] gradients = new float[cols][rows];
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float gradient = sqrt(pow(abs(x - centerX), 2)  + pow(abs(y - centerY), 2));
      gradients[x][y] = gradient;
      if (gradient > maxGradient) {
        maxGradient = gradient;
      }
    }
  }
  // Normalize gradient and inverse values
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      gradients[x][y] = 1 - (gradients[x][y] / maxGradient);
    }
  }
  return gradients;
}