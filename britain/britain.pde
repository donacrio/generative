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
  float[][] noise = new float[cols][rows];
  float minValue = Integer.MAX_VALUE;
  float maxValue = 0;
  float yOff = 0;
  for (int y = 0; y < rows; y++) {
    float xOff = 0;
    for (int x = 0; x < cols; x++) {
      float value = noise(xOff, yOff);
      noise[x][y] = value;
      if (value < minValue) {
        minValue = value;
      }
      if (value > maxValue) {
        maxValue = value;
      }
      xOff += xIncr;
    }
    yOff += yIncr;
  }
  // Normalize
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      noise[x][y] = map(noise[x][y], minValue, maxValue, 0, 1);
    }
  }
  
  ArrayList<ArrayList<Watercolor>> watercolorLayers = new ArrayList<ArrayList<Watercolor>>();
  for (int i = 0; i < 6; i++) {
    watercolorLayers.add(new ArrayList<Watercolor>());
  }
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      float value = noise[x][y];
      if (value < 0.1) {
        watercolorLayers.get(0).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.3) {
        watercolorLayers.get(1).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.5) {
        watercolorLayers.get(2).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.7) {
        watercolorLayers.get(3).add(new Watercolor(x * res, y * res, res));
      } else if (value < 0.9) {
        watercolorLayers.get(4).add(new Watercolor(x * res, y * res, res));
      } else {
        watercolorLayers.get(5).add(new Watercolor(x * res, y * res, res));
      }
    }
  }
  
  colorMode(HSB, 360, 100, 100, 1);
  color[] colors = {
    color(191, 82.9, 27.5, 1),
      color(192, 79.6, 38.4, 1),
      color(192, 67.6, 53.3, 1),
      color(191, 50.0, 58.8, 1),
      color(192,26.8, 76.1, 1),
      color(180, 13.5, 78.4, 1)
    };
  
  for (int i = 0; i < watercolorLayers.size(); i++) {
    PGraphics layerTexture = createGraphics(width, height, P2D);
    layerTexture.beginDraw();
    layerTexture.background(colors[i]);
    layerTexture.endDraw();
    
    PGraphics mask = createGraphics(width, height, P2D);
    mask.beginDraw();
    mask.colorMode(RGB, 255, 255, 255, 1);
    mask.noStroke();
    mask.fill(255, 255, 255, 0.005);
    ArrayList<Watercolor> watercolorLayer = watercolorLayers.get(i);
    for (int j = 0; j < watercolorLayer.size(); j++) {
      println("layer " + i + "/" + (watercolorLayers.size() - 1) + ":",(int)(100 * j / watercolorLayer.size()) + "%");
      Watercolor watercolor = watercolorLayer.get(j);
      for (Polygon polygon : watercolor.shape) { 
        mask.beginShape();
        for (Coordinate coord : polygon.getExteriorRing().getCoordinates()) {
          mask.vertex((float)coord.x,(float) coord.y);
        }
        mask.endShape();
      }
    }
    mask.endDraw();
    layerTexture.mask(mask);
    image(layerTexture, 0, 0);
  }
  
  save("out/final.png");  
  noLoop();
}