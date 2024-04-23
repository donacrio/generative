class Painting {
  int w;
  int h;
  ArrayList<Watercolor> watercolors;
  
  private int _i = 0;
  private int _j = 0;
  private Integer _maxNumLayers;
  
  Painting(int w, int h) {
    this.w = w;
    this.h = h;
    this.watercolors = new ArrayList<Watercolor>();
  }
  
  private Integer maxNumLayer() {
    if (this._maxNumLayers == null) {
      this._maxNumLayers = 0;
      for (Watercolor watercolor : watercolors) {
        this._maxNumLayers = Math.max(this._maxNumLayers, watercolor.shape.size());
      }
    }
    return this._maxNumLayers;
  }
  
  boolean drawNext(PGraphics pg) {
    if (this._i < this.maxNumLayer()) {
      if (this._j < this.watercolors.size()) {
        println(this._i * this.watercolors.size() + this._j, this._i, this._j);
        Watercolor watercolor = this.watercolors.get(this._j);
        Polygon layer = watercolor.shape.get(this._i);
        PGraphics texture = createGraphics(this.w, this.h);
        texture.beginDraw();
        texture.background(watercolor.c);
        texture.endDraw();
        PGraphics textureMask = createGraphics(this.w, this.h);
        textureMask.beginDraw();
        textureMask.noStroke();
        textureMask.colorMode(RGB, 255, 255, 255, 1);
        textureMask.background(0, 0, 0, 1);
        textureMask.fill(255,255,255, 0.05);
        textureMask.beginShape();
        for (Coordinate coord : layer.getExteriorRing().getCoordinates()) {
          textureMask.vertex((float)coord.x,(float) coord.y);
        }
        textureMask.endShape();
        textureMask.endDraw();
        PGraphics mask = createGraphics(this.w, this.h);
        mask.beginDraw();
        mask.fill(255, 255, 255, 1);
        mask.noStroke();
        mask.fill(0,0,0, 1);
        for (int i = 0; i < 1000; i++) {
          mask.ellipse(
            random(0, this.w),
            random(0, this.h),
           (float)boundedRandomGaussian(0.03 * width, 0.005 * width, 0, width),
           (float)boundedRandomGaussian(0.03 * height, 0.005 * height, 0, height)
           );
        }
        textureMask.blend(mask, 0, 0, this.w, this.h, 0, 0, this.w, this.h, DARKEST);
        texture.mask(textureMask);
        pg.image(texture, 0, 0);
        
        this._j++;
        if (this._j == this.watercolors.size()) {
          this._j = 0;
          this._i++;
          if (this._i == this.maxNumLayer()) {
            return false;
          }
        }
      }
    }
    return true;
  }
}


class Watercolor {
  
  private GeometryFactory gf;
  ArrayList<Polygon> shape;
  color c;
  
  Watercolor(Polygon polygon, color c) {   
    this.gf = new GeometryFactory();
    this.shape = createWatercolorShape(polygon);
    this.c = c;
  }
  
  Watercolor(float x, float y, float radius, color c) {
    Coordinate[] coords = new Coordinate[9];
    for (int i = 0; i < 8; i++) {
      coords[i] = new Coordinate(x + radius * cos(i * 2 * PI / 8), y + radius * sin(i * 2 * PI / 8));
    }
    coords[8] = coords[0];
    GeometryFactory gf = new GeometryFactory();
    this.gf = gf;
    Polygon polygon = gf.createPolygon(coords);
    this.shape = createWatercolorShape(polygon);
    this.c = c;
  }
  
  private ArrayList<Polygon> createWatercolorShape(Polygon polygon) {    
    ArrayList<Polygon> polygons = new ArrayList<Polygon>();
    Polygon basePolygon = polygon;
    basePolygon = this.createWatercolorShapeStep(basePolygon);
    for (int i = 0; i < 30; i++) {
      if (i ==  10 || i ==  20) {
        basePolygon = this.createWatercolorShapeStep(basePolygon);
      }
      Polygon newPolygon = basePolygon;
      for (int j = 0; j < 6; j++) {
        newPolygon = this.createWatercolorShapeStep(newPolygon);
      }
      polygons.add(newPolygon);
    }
    return polygons;
  }
  
  private Polygon createWatercolorShapeStep(Polygon polygon) {
    ArrayList<Coordinate> exteriorCoords = new ArrayList<Coordinate>();
    for (int i = 0; i < polygon.getExteriorRing().getCoordinates().length - 1; i++) {
      Vector2D curr = Vector2D.create(polygon.getExteriorRing().getCoordinateN(i));
      Vector2D next = Vector2D.create(polygon.getExteriorRing().getCoordinateN(i + 1));
      
      // Random Gaussian start point centered on middle segment
      double weight = boundedRandomGaussian(0.5, 0.1, 0, 1);
      Vector2D mid = curr.multiply(weight).add(next.multiply(1 - weight));
      // Random Gaussian direction
      double angle = boundedRandomGaussian(PI / 2, PI / 8, 0, PI);
      Vector2D direction = next.subtract(curr).rotate( -angle);
      // Magnitude centered around edge magnitude, always positive
      double magnitude = boundedRandomGaussian(0.5, 0.3, 0, 1);
      Vector2D newMid = mid.add(direction.multiply(magnitude));
      
      exteriorCoords.add(curr.toCoordinate());
      exteriorCoords.add(newMid.toCoordinate());
    }
    exteriorCoords.add(polygon.getExteriorRing().getCoordinateN(polygon.getExteriorRing().getCoordinates().length - 1));    
    return this.gf.createPolygon(exteriorCoords.toArray(new Coordinate[0]));
  }
}

double boundedRandomGaussian(double mean, double sigma, double min, double max) {
  double sample = mean * (1 + sigma * randomGaussian());
  while(sample < min || sample > max) {
    sample = mean * (1 + sigma * randomGaussian());
  }
  return sample;
}