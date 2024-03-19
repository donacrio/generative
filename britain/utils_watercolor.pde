class Watercolor {
  
  private GeometryFactory gf;
  ArrayList<Polygon> shape;
  
  Watercolor(Polygon polygon) {   
    this.gf = new GeometryFactory();
    this.shape = createWatercolorShape(polygon);
  }
  
  Watercolor(float x, float y, float radius) {
    Coordinate[] coords = new Coordinate[9];
    for (int i = 0; i < 8; i++) {
      coords[i] = new Coordinate(x + radius * cos(i * 2 * PI / 8), y + radius * sin(i * 2 * PI / 8));
    }
    coords[8] = coords[0];
    GeometryFactory gf = new GeometryFactory();
    this.gf = gf;
    Polygon polygon = gf.createPolygon(coords);
    this.shape = createWatercolorShape(polygon);
  }
  
  private ArrayList<Polygon> createWatercolorShape(Polygon polygon) {    
    ArrayList<Polygon> polygons = new ArrayList<Polygon>();
    Polygon basePolygon = polygon;
    basePolygon = this.createWatercolorShapeStep(basePolygon);
    for (int i = 0; i < 60; i++) {
      if (i ==  20 || i ==  40) {
        basePolygon = this.createWatercolorShapeStep(basePolygon);
      }
      Polygon newPolygon = basePolygon;
      for (int j = 0; j < 3; j++) {
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