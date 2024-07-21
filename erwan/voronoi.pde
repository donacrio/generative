import megamu.mesh.*;

PGraphics meshify(PImage img) {
  Voronoi mesh = createMesh(img, 1000, 0);
  
  PGraphics output = createGraphics(img.width, img.height);
  img.loadPixels();
  for (MPolygon region : mesh.getRegions()) {
    // Draw shape in blank to retreive pixel coordinates within shape
    PGraphics tmp = createGraphics(img.width, img.height);
    tmp.beginDraw();
    color shapeColor = color(255);
    tmp.background(0);
    tmp.noStroke();
    tmp.fill(shapeColor);
    tmp.beginShape();
    for (float[] coord : region.getCoords()) {
      tmp.vertex(coord[0], coord[1]);
    }
    tmp.endShape(CLOSE);
    tmp.endDraw();
    
    // Iterate through all pixels
    // Average pixel color if within shape
    float r = 0;
    float g = 0;
    float b = 0;
    int nPixels = 0;
    tmp.loadPixels();
    for (int i = 0; i < tmp.pixels.length; i++) {
      if (tmp.pixels[i] == shapeColor) {
        r += img.pixels[i] >> 16 & 0xFF;
        g += img.pixels[i] >> 8 & 0xFF;
        b += img.pixels[i] & 0xFF;
        nPixels++;    
      }
    }
    color c = color(r / nPixels, g / nPixels, b / nPixels);
    
    output.beginDraw();
    output.stroke(0);
    output.fill(c);
    output.beginShape();
    for (float[] coord : region.getCoords()) {
      output.vertex(coord[0], coord[1]);
    }
    output.endShape(CLOSE);
    output.endDraw();
  }
  return output;
}

Voronoi createMesh(PImage img, int nPoints, int it) {
  ArrayList<PVector> points = sampleDensityPoints(img, nPoints);
  Voronoi voronoi = new Voronoi(toFloatArray(points));
  return lloydRelaxation(voronoi, it);
}

ArrayList<PVector> sampleDensityPoints(PImage img, int n) {
  img.loadPixels();
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (int i = 0; i < n; i++) {
    float x = random(img.width);
    float y = random(img.height);
    if (random(50, 255) > blue(img.pixels[(int)y * img.width + (int)x])) {
      points.add(new PVector(x, y));
    } else {
      i--;
    }
  }
  return points;
}

PImage createEdgeImage(PImage img) {
  float[][] kernel = {
    { - 1, -1, -1} ,
    { - 1,  8, -1} ,
    { - 1, -1, -1}
  };
  
  PImage grayImg = img.copy();
  grayImg.filter(GRAY);
  grayImg.filter(BLUR);
  PImage edgeImg = createImage(grayImg.width, grayImg.height, RGB);
  for (int y = 1; y < grayImg.height - 1; y++) {
    for (int x = 1; x < grayImg.width - 1; x++) {
      float sum = 0; // 128 to avoid sharp edges
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          int pos = (y + ky) * grayImg.width + (x + kx);
          float val = blue(grayImg.pixels[pos]);
          sum += kernel[ky + 1][kx + 1] * val;
        }
      }
      edgeImg.pixels[y * edgeImg.width + x] = color(sum);
    }
  }
  edgeImg.updatePixels();
  
  return edgeImg;
}

Voronoi lloydRelaxation(Voronoi voronoi, int it) {
  for (int i = 0; i < it; i++) {
    ArrayList<PVector> points = new ArrayList<PVector>();
    for (MPolygon region : voronoi.getRegions()) {
      points.add(computeCentroid(fromFloatArray(region.getCoords())));
    }
    voronoi = new Voronoi(toFloatArray(points));
  }
  return voronoi;
}

PVector computeCentroid(ArrayList<PVector> points) {
  float area = 0;
  PVector centroid = new PVector(0, 0);
  for (int i = 0; i < points.size(); i++) {
    PVector p1 = points.get(i);
    PVector p2 = points.get((i + 1) % points.size());
    float cross = p1.cross(p2).mag();
    area += cross;
    centroid.x += (p1.x + p2.x) * cross;
    centroid.y += (p1.y + p2.y) * cross;
  }
  area /= 2;
  centroid.div(6 * area);
  return centroid;
}

float[][] toFloatArray(ArrayList<PVector> points) {
  float[][] pointsArr = new float[points.size()][2];
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    pointsArr[i][0] = p.x;
    pointsArr[i][1] = p.y;
  }
  return pointsArr;
}

ArrayList<PVector> fromFloatArray(float[][] pointsArr) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (float[] point : pointsArr) {
    points.add(new PVector(point[0], point[1]));
  }
  return points;
}