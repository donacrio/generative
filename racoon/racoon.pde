import java.util.stream.Collectors;
import java.util.Arrays;
import java.util.List;
import processing.svg.*;

GeometryFactory GF;


int N_RACOONS_ROW = 4;
int N_RACOONS_COL = 6;

void setup() {
  size(1080, 1620);
  GF = new GeometryFactory();
  
  // Load Racoon geometry
  MultiPolygon baseRacoon = GF.createMultiPolygon();
  WKTReader reader = new WKTReader(GF);
  try {
    Polygon[] loaded = {(Polygon) reader.read(loadStrings("data/racoon.txt")[0])};
    baseRacoon = GF.createMultiPolygon(loaded);
  } catch(ParseException e) {
    println(e);
  }  
  // Transforms base racoon to base shape
  AffineTransformation baseTransformation = new AffineTransformation();
  Point centroid = baseRacoon.getCentroid();
  baseTransformation.translate( -centroid.getX(), -centroid.getY());
  double diameter = 2 * (new MinimumBoundingCircle(baseRacoon)).getRadius();
  baseTransformation.scale(0.90 * width / (diameter * N_RACOONS_ROW), 0.90 * height / (diameter * N_RACOONS_COL));
  baseTransformation.rotate(PI);
  baseRacoon = (MultiPolygon) baseTransformation.transform(baseRacoon);
  
  beginRecord(SVG, "out/final.svg");
  
  background(255);
  noFill();
  stroke(0);    
  for (int i = 0; i < N_RACOONS_ROW; i++) {
    for (int j = 0; j < N_RACOONS_COL; j++) {
      float tolerance = min(width / N_RACOONS_ROW, height / N_RACOONS_COL) * 0.005 * pow(j + 2, 2) * sqrt(i + 1);
      Geometry simplified = DouglasPeuckerSimplifier.simplify(baseRacoon, tolerance);
      MultiPolygon racoon;
      if (simplified instanceof Polygon) {
        Polygon[] polys = new Polygon[1];
        polys[0] = (Polygon) simplified;
        racoon = GF.createMultiPolygon(polys);
      } else {
        racoon = (MultiPolygon) simplified;
      }
      pushMatrix();
      translate((width / N_RACOONS_ROW) * ((N_RACOONS_ROW - i - 1) + 0.5),(height / N_RACOONS_COL) * ((N_RACOONS_COL - j - 1) + 0.5));
      float radius = tolerance * 0.15 * (i + 1) * sqrt(j + 1);
      for (int p = 0; p < racoon.getNumGeometries(); p++) {
        Polygon polygon = (Polygon) racoon.getGeometryN(p);
        drawRounded(polygon.getExteriorRing().getCoordinates(), radius);
        for (int n = 0; n < polygon.getNumInteriorRing(); n++) {
          drawRounded(polygon.getInteriorRingN(n).getCoordinates(), radius);
        }
      } 
      popMatrix();
    }
  }
  
  endRecord();
  
  noLoop();
}

void drawRounded(Coordinate[] coords, float radius) {
  ArrayList<Coordinate> closed = convertToClosed(Arrays.asList(coords), radius);
  beginShape();
  for (int i = 0, last = closed.size(); i<last; i += 3) { //>
    Coordinate c1 = closed.get(i);
    Coordinate c2 = closed.get(i + 1);
    Coordinate c3 = closed.get(i + 2);
    double[] c = roundIsosceles(c1, c2, c3, 0.75);
    vertex((float) c1.x,(float) c1.y);
    bezierVertex((float) c[0],(float) c[1],(float) c[2],(float) c[3],(float) c3.x,(float) c3.y);
  }
  endShape(CLOSE);
}

ArrayList<Coordinate> convertToClosed(List<Coordinate> coords, float radius) {
  ArrayList<Coordinate> closed = new ArrayList<Coordinate>();
  for (int i = 0, last = coords.size(); i < last; i++) {
    Coordinate p1 = coords.get(i);
    Coordinate p2 = coords.get((i + 1) % last);
    Coordinate p3 = coords.get((i + 2) % last);
    
    double dx1 = p2.x - p1.x;
    double dy1 = p2.y - p1.y;
    double m1 = sqrt((float)(dx1 * dx1 + dy1 * dy1));
    Coordinate p2l = new Coordinate(p2.x - radius * dx1 / m1, p2.y - radius * dy1 / m1);
    
    double dx2 = p3.x - p2.x;
    double dy2 = p3.y - p2.y;
    double m2 = sqrt((float)(dx2 * dx2 + dy2 * dy2));
    Coordinate p2r = new Coordinate(p2.x + radius * dx2 / m2, p2.y + radius * dy2 / m2);
    
    closed.add(p2l);
    closed.add(p2);
    closed.add(p2r);
  }
  return closed;
}

double[] roundIsosceles(Coordinate c1, Coordinate c2, Coordinate c3, float t) {
  double mt = 1 - t;
  double c1x = (mt * c1.x + t * c2.x);
  double c1y = (mt * c1.y + t * c2.y);
  double c2x = (mt * c3.x + t * c2.x);  
  double  c2y = (mt * c3.y + t * c2.y);
  return new double[]{ c1x, c1y, c2x, c2y };
}