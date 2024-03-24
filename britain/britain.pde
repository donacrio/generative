void setup() {
  size(1024, 1024, P2D);
  
  PImage img = loadImage("images/paper.jpg");
  img.resize(width, height);
  image(img, 0, 0);
  
  int res = width / 20;
  float xIncr = 0.01 * res;
  float yIncr = 0.01 * res;
  int rows = (int)(height / res) + 1;
  int cols = (int)(width / res) + 1;
  
  noiseDetail(8, 0.6);
  float[][] waterMatrix = new float[cols][rows];
  float minWaterMatrix = Integer.MAX_VALUE;
  float maxWaterMatrix = 0;
  float yOff = 0;
  for (int y = 0; y < rows; y++) {
    float xOff = 0;
    for (int x = 0; x < cols; x++) {
      float value = noise(xOff, yOff);
      waterMatrix[x][y] = value;
      if (value < minWaterMatrix) {
        minWaterMatrix = value;
      }
      if (value > maxWaterMatrix) {
        maxWaterMatrix = value;
      }
      xOff += xIncr;
    }
    yOff += yIncr;
  }
  // Normalize
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      waterMatrix[x][y] = map(waterMatrix[x][y], minWaterMatrix, maxWaterMatrix, 0, 1);
    }
  }
  
  ArrayList<ArrayList<Watercolor>> waterLayers = new ArrayList<ArrayList<Watercolor>>();
  for (int i = 0; i < 6; i++) {
    waterLayers.add(new ArrayList<Watercolor>());
  }
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float value = waterMatrix[x][y];
      if (value < 0.1) {
        waterLayers.get(0).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.3) {
        waterLayers.get(1).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.5) {
        waterLayers.get(2).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.7) {
        waterLayers.get(3).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.9) {
        waterLayers.get(4).add(new Watercolor(x * res, y * res, res));
      } else {
        waterLayers.get(5).add(new Watercolor(x * res, y * res, res));
      }
    }
  }
  
  colorMode(HSB, 360, 100, 100, 1);
  color[] waterColors = {
    color(191, 82.9, 27.5, 1),
      color(192, 79.6, 38.4, 1),
      color(192, 67.6, 53.3, 1),
      color(191, 50.0, 58.8, 1),
      color(192,26.8, 76.1, 1),
      color(180, 13.5, 78.4, 1)
    };
  
  println("");
  for (int i = 0; i < waterLayers.size(); i++) {
    PGraphics waterLayerTexture = createGraphics(width, height, P2D);
    waterLayerTexture.beginDraw();
    waterLayerTexture.background(waterColors[i]);
    waterLayerTexture.endDraw();
    
    PGraphics waterMask = createGraphics(width, height, P2D);
    waterMask.beginDraw();
    waterMask.colorMode(RGB, 255, 255, 255, 1);
    waterMask.noStroke();
    waterMask.fill(255, 255, 255, 0.005);
    ArrayList<Watercolor> watercolorLayer = waterLayers.get(i);
    for (int j = 0; j < watercolorLayer.size(); j++) {
      print("\rRendering water layer " + i + "/" + (waterLayers.size() - 1) + ":",(int)(100 * j / watercolorLayer.size()) + "%");
      Watercolor watercolor = watercolorLayer.get(j);
      for (Polygon polygon : watercolor.shape) { 
        waterMask.beginShape();
        for (Coordinate coord : polygon.getExteriorRing().getCoordinates()) {
          waterMask.vertex((float)coord.x,(float) coord.y);
        }
        waterMask.endShape();
      }
    }
    waterMask.endDraw();
    waterLayerTexture.mask(waterMask);
    image(waterLayerTexture, 0, 0);
  }
  
  float minShoreMatrix = Integer.MAX_VALUE;
  float maxShoreMatrix = 0;
  float[][] shoreMatrix = new float[cols][rows];
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float value = sqrt(pow(abs(x - cols), 2)  + pow(0.5 * abs(y - rows / 2), 2));
      shoreMatrix[x][y] = value;
      if (value < minShoreMatrix) {
        minShoreMatrix = value;
      }
      if (value > maxShoreMatrix) {
        maxShoreMatrix = value;
      }
    }
  }
  // Normalize
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      shoreMatrix[x][y] = 1 - map(shoreMatrix[x][y], minShoreMatrix, maxShoreMatrix, 0, 1);
    }
  }
  
  ArrayList<ArrayList<Watercolor>> shoreLayers = new ArrayList<ArrayList<Watercolor>>();
  for (int i = 0; i < 6; i++) {
    shoreLayers.add(new ArrayList<Watercolor>());
  }
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float value = shoreMatrix[x][y];
      if (value < 0.1) {
        shoreLayers.get(0).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.3) {
        shoreLayers.get(1).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.5) {
        shoreLayers.get(2).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.7) {
        shoreLayers.get(3).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.9) {
        shoreLayers.get(4).add(new Watercolor(x * res, y * res, res));
      } else {
        shoreLayers.get(5).add(new Watercolor(x * res, y * res, res));
      }
    }
  }
  
  colorMode(HSB, 360, 100, 100, 1);
  color[] shoreColors = {
    color(191, 82.9, 27.5, 1),
      color(192, 79.6, 38.4, 1),
      color(192, 67.6, 53.3, 1),
      color(191, 50.0, 58.8, 1),
      color(192,26.8, 76.1, 1),
      color(180, 13.5, 78.4, 1)
    };
  
  println("");
  for (int i = 0; i < shoreLayers.size(); i++) {
    PGraphics shoreLayerTexture = createGraphics(width, height, P2D);
    shoreLayerTexture.beginDraw();
    shoreLayerTexture.background(shoreColors[i]);
    shoreLayerTexture.endDraw();
    
    PGraphics shoreMask = createGraphics(width, height, P2D);
    shoreMask.beginDraw();
    shoreMask.colorMode(RGB, 255, 255, 255, 1);
    shoreMask.noStroke();
    shoreMask.fill(255, 255, 255, 0.005);
    ArrayList<Watercolor> shoreLayer = shoreLayers.get(i);
    for (int j = 0; j < shoreLayer.size(); j++) {
      print("\rRendering shore layer " + i + "/" + (shoreLayers.size() - 1) + ":",(int)(100 * j / shoreLayer.size()) + "%");
      Watercolor watercolor = shoreLayer.get(j);
      for (Polygon polygon : watercolor.shape) { 
        shoreMask.beginShape();
        for (Coordinate coord : polygon.getExteriorRing().getCoordinates()) {
          shoreMask.vertex((float)coord.x,(float) coord.y);
        }
        shoreMask.endShape();
      }
    }
    shoreMask.endDraw();
    shoreLayerTexture.mask(shoreMask);
    image(shoreLayerTexture, 0, 0);
  }
  
  
  // for (int y = 0; y < rows; y++) {
  //   for (int x = 0; x < cols; x++) {
  //     float value = map(waterMatrix[x][y] +shoreMatrixs[x][y], 0, 2, 0, 1);
  //     fill(value * 255);
  //     rect(x * res, y * res, res, res);
  //   }
  // }
  
  save("out/final.png");  
  noLoop();
}