import org.apache.commons.math3.distribution.PoissonDistribution;

GeometryFactory GF;
Polygon basePolygon;

void setup() {
  size(720, 720);
  
  GF = new GeometryFactory();
  
  try {
  WKTReader r = new WKTReader();
  basePolygon = (Polygon) r.read("POLYGON((0 0, 0 4, 3 4, 3 0, 0 0))");
  } catch(ParseException e) {
    println(e);
  }
  
  AffineTransformation baseTransformation = new AffineTransformation();
  Point centroid = basePolygon.getCentroid();
  baseTransformation.translate(-centroid.getX(),-centroid.getY());
  double diameter = 2*(new MinimumBoundingCircle(basePolygon)).getRadius();
  baseTransformation.scale(0.1*width/diameter, 0.1*height/diameter);
  
  Painting painting = new Painting();
  
  AffineTransformation transformationUp = new AffineTransformation(baseTransformation);
  transformationUp = transformationUp.translate(0.0, -(float)height/4);
  //transformationUp = transformationUp.scale(0.8, 0.65);
  Watercolor watercolorUp = new Watercolor((Polygon) transformationUp.transform(basePolygon), color(255, 150, 150));
  painting.addToLayer(1, watercolorUp);
  
  //AffineTransformation transformationLeft = new AffineTransformation(baseTransformation);
  //transformationLeft = transformationLeft.translate(-0.71/4 * width, 0.71/4 * height);
  //Watercolor watercolorLeft = new Watercolor((Polygon) transformationLeft.transform(basePolygon), color(150, 255, 150));
  //painting.addToLayer(1, watercolorLeft);
  
  //AffineTransformation transformationRight = new AffineTransformation(baseTransformation);
  //transformationRight = transformationRight.translate(0.71/4 * width, 0.71/4 * height);
  //Watercolor watercolorRight = new Watercolor((Polygon) transformationRight.transform(basePolygon), color(150, 150, 255));
  //painting.addToLayer(1, watercolorRight);
  
  background(255);
  translate(width/2, width/2);
  painting.render();
  
  noLoop();
}
