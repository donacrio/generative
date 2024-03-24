void setup() {
  size(1024, 1024, P3D);
  
  
  PImage img = loadImage("images/paper.jpg");
  img.resize(width, height);
  image(img, 0, 0);
  
  PGraphics waterTexture = createGraphics(width, height, P2D);
  waterTexture.beginDraw();
  
  // Water elevation matrix creation
  int res = width / 50;
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
  
  // Water colors
  int waterRes = width / 20;
  int waterRows = (int)(height / waterRes) + 1;
  int waterCols = (int)(width / waterRes) + 1;
  
  ArrayList<ArrayList<Watercolor>> waterLayers = new ArrayList<ArrayList<Watercolor>>();
  for (int i = 0; i < 6; i++) {
    waterLayers.add(new ArrayList<Watercolor>());
  }
  for (int y = 0; y < waterRows; y++) {
    for (int x = 0; x < waterCols; x++) {
      float value = waterMatrix[x][y];
      if (value < 0.1) {
        waterLayers.get(0).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else if (value < 0.3) {
        waterLayers.get(1).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else if (value < 0.5) {
        waterLayers.get(2).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else if (value < 0.7) {
        waterLayers.get(3).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else if (value < 0.9) {
        waterLayers.get(4).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else {
        waterLayers.get(5).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
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
      print("\r");
      print("Rendering water layer " + i + "/" + (waterLayers.size() - 1) + ":",(int)(100 * (j + 1) / watercolorLayer.size()) + "%");
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
    waterTexture.image(waterLayerTexture, 0, 0);
  }
  
  // Wave effect
  float minWaveMatrix = Integer.MAX_VALUE;
  float maxWaveMatrix = 0;
  float[][] waveMatrix = new float[waterCols][waterRows];
  for (int y = 0; y < waterRows; y++) {
    for (int x = 0; x < waterCols; x++) {
      float value = sqrt(pow(0.5 * abs(x - waterCols / 2), 2)  + pow(abs(y - 0), 2));
      waveMatrix[x][y] = value;
      if (value < minWaveMatrix) {
        minWaveMatrix = value;
      }
      if (value > maxWaveMatrix) {
        maxWaveMatrix = value;
      }
    }
  }
  // Normalize
  for (int y = 0; y < waterRows; y++) {
    for (int x = 0; x < waterCols; x++) {
      waveMatrix[x][y] = 1 - map(waveMatrix[x][y], minWaveMatrix, maxWaveMatrix, 0, 1);
    }
  }
  
  ArrayList<ArrayList<Watercolor>> waveLayers = new ArrayList<ArrayList<Watercolor>>();
  for (int i = 0; i < 6; i++) {
    waveLayers.add(new ArrayList<Watercolor>());
  }
  for (int y = 0; y < waterRows; y++) {
    for (int x = 0; x < waterCols; x++) {
      float value = waveMatrix[x][y];
      if (value < 0.1) {
        waveLayers.get(0).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else if (value < 0.3) {
        waveLayers.get(1).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else if (value < 0.5) {
        waveLayers.get(2).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else if (value < 0.7) {
        waveLayers.get(3).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else if (value < 0.9) {
        waveLayers.get(4).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      } else {
        waveLayers.get(5).add(new Watercolor(x * waterRes, y * waterRes, waterRes));
      }
    }
  }
  
  println("");
  for (int i = 0; i < waveLayers.size(); i++) {
    PGraphics waveLayerTexture = createGraphics(width, height, P2D);
    waveLayerTexture.beginDraw();
    waveLayerTexture.background(waterColors[i]);
    waveLayerTexture.endDraw();
    
    PGraphics waveMask = createGraphics(width, height, P2D);
    waveMask.beginDraw();
    waveMask.colorMode(RGB, 255,255, 255, 1);
    waveMask.noStroke();
    waveMask.fill(255, 255, 255,0.005);
    ArrayList<Watercolor> waveLayer = waveLayers.get(i);
    for (int j = 0; j < waveLayer.size(); j++) {
      print("\r");
      print("Rendering shore layer " + i + "/" + (waveLayers.size() - 1) + ":",(int)(100 * (j + 1) / waveLayer.size()) + " % ");
      Watercolor watercolor = waveLayer.get(j);
      for (Polygon polygon : watercolor.shape) { 
        waveMask.beginShape();
        for (Coordinate coord : polygon.getExteriorRing().getCoordinates()) {
          waveMask.vertex((float)coord.x,(float) coord.y);
        }
        waveMask.endShape();
      }
    }
    waveMask.endDraw();
    waveLayerTexture.mask(waveMask);
    waterTexture.image(waveLayerTexture, 0, 0);
  }
  waterTexture.endDraw();
  
  // Water elevation rendering
  pushMatrix();
  translate(0, 300);
  rotateX(PI / 3);
  // image(waterTexture, 0, 0);
  noStroke();
  for (int y = 0; y < rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    texture(waterTexture);
    for (int x = 0; x < cols; x++) {
      vertex(x * waterRes, y * waterRes, 50 * (waterMatrix[x][y] - 0.5), x * waterRes, y * waterRes);
      vertex(x * waterRes,(y + 1) * waterRes, 50 * (waterMatrix[x][y + 1] - 0.5), x * waterRes,(y + 1) * waterRes);
    }
    endShape();
  }
  popMatrix();
  // image(waterTexture, 0, 0);
  //int rockRes = width / 50;
  //int rockRows = (int)(height /rockRes) + 1;
  //int rowCols = (int)(width / rockRes) + 1;
  //colorMode(HSB, 360, 100, 100,1);
  //color[] rockColors = {
  //color(120, 1.3, 29.8, 1),
  //color(96, 4.6, 42.7, 1),
  //color(192, 67.6, 53.3, 1),
  //color(60, 5.2, 89.8, 1),
  //color(15, 27.3, 17.3, 1),
  //color(15, 38.1, 32.9, 1)
  //};
  
  //float[][] rockMatrix = new float[rowCols][rockRows];
  //float minRockMatrix = Integer.MAX_VALUE;
  //float maxRockMatrix = 0;
  //float yOff = 0;
  //for (int y = 0; y < rockRows;y++) {
  //float xOff = 0;
  //for (int x = 0; x < rowCols; x++) {
  //float value = noise(xOff,yOff);
  //rockMatrix[x][y] = value;
  //if (value < minRockMatrix) {
  //minRockMatrix = value;
  //}
  //if (value > maxRockMatrix) {
  //maxRockMatrix = value;
  //}
  //xOff += waterXIncr;
  //}
  //yOff += waterYIncr;
  // }
  //// Normalize
  //for (int y = 0; y < rockRows;y++) {
  //for (int x = 0; x < rowCols; x++) {
  //rockMatrix[x][y] = map(rockMatrix[x][y], minRockMatrix, maxRockMatrix, 0, 50);
  //}
  // }
  
  //PGraphics rockTexture = createGraphics(width, height, P3D);
  //rockTexture.beginDraw();
  //rockTexture.translate(0, 300);
  //rockTexture.rotateX(PI / 3);
  //rockTexture.colorMode(RGB, 255, 255, 255, 1);
  //rockTexture.background(0, 0, 0);
  //rockTexture.stroke(255, 255, 255, 1.0);
  //rockTexture.noFill();
  //for (int y = 0; y < rockRows - 1; y++) {
  //rockTexture.beginShape(TRIANGLE_STRIP);
  //for (int x = 0; x < rowCols; x++) {
  //rockTexture.vertex(x * rockRes, y * rockRes, rockMatrix[x][y]);
  //rockTexture.vertex(x * rockRes,(y + 1) * rockRes, rockMatrix[x][y + 1]);
  //}
  //rockTexture.endShape();
  // }
  //rockTexture.endDraw();
  //image(rockTexture, 0, 0);
  //for (int y = 0; y < waterRows; y++) {
  //for (int x = 0; x < waterCols; x++) {
  //float value = map(waterMatrix[x][y] +waveMatrixs[x][y], 0, 2, 0, 1);
  //fill(value * 255);
  //rect(x * waterRes, y * waterRes, waterRes, waterRes);
  //}
  // }
  
  save("out/final.png");  
  noLoop();
}