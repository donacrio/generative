import java.util.stream.Collectors;
import java.util.Arrays;
import java.util.List;
import processing.svg.*;

GeometryFactory GF;

float S = 0.001;
float R = 0.1;

int N_RACOONS_ROW = 8;
int N_RACOONS_COL = 8;

void setup() {
  size(1080, 1080);
  GF = new GeometryFactory();
  
  // Load Racoon geometry
  Polygon baseRacoon = GF.createPolygon();
  WKTReader reader = new WKTReader(GF);
  try {
    baseRacoon = (Polygon) reader.read(loadStrings("data/racoon.txt")[0]);
  } catch(ParseException e) {
    println(e);
  }
  
  // Transforms base racoon to base shape
  AffineTransformation baseTransformation = new AffineTransformation();
  Point centroid = baseRacoon.getCentroid();
  baseTransformation.translate( -centroid.getX(), -centroid.getY());
  double diameter = 2 * (new MinimumBoundingCircle(baseRacoon)).getRadius();
  baseTransformation.scale(0.95 * width / (diameter * N_RACOONS_ROW),0.95 * height / (diameter * N_RACOONS_COL));
  baseTransformation.rotate(PI);
  baseRacoon = (Polygon) baseTransformation.transform(baseRacoon);
  
  beginRecord(SVG, "out/final.svg");
  
  background(255);
  noFill();
  stroke(0);    
  for (int i = 0; i < N_RACOONS_ROW; i++) {
    for (int j = 0; j < N_RACOONS_COL; j++) {
      float tolerance = min(width / N_RACOONS_ROW, height / N_RACOONS_COL) * S * pow(j + 1, 3);
      Polygon racoon = (Polygon) DouglasPeuckerSimplifier.simplify(baseRacoon, tolerance);
      pushMatrix();
      translate((width / N_RACOONS_ROW) * ((N_RACOONS_ROW - i - 1) + 0.5),(height / N_RACOONS_COL) * ((N_RACOONS_COL - j - 1) + 0.5));
      drawRounded(racoon.getExteriorRing().getCoordinates(), R * pow((i + 1), 2) * pow((j + 1), 2));
      for (int n = 0; n < racoon.getNumInteriorRing(); n++) {
        drawRounded(racoon.getInteriorRingN(n).getCoordinates(), R * pow((i + 1), 2) * pow((j + 1), 2));
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