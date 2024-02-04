import java.util.stream.Collectors;
import processing.svg.*;

GeometryFactory GF;

float S = 0.001;
float R = 0.1;

int N_RACOONS_ROW = 1;
int N_RACOONS_COL = 1;

void setup() {
  size(720, 720);
  
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
  baseTransformation.translate(-centroid.getX(),-centroid.getY());
  double diameter = 2*(new MinimumBoundingCircle(baseRacoon)).getRadius();
  baseTransformation.scale(0.95*width/(diameter*N_RACOONS_ROW),0.95*height/(diameter*N_RACOONS_COL));
  baseTransformation.rotate(PI);
  baseRacoon = (Polygon) baseTransformation.transform(baseRacoon);

  beginRecord(SVG, "out/final.svg");
  
  background(255);
  noFill();
  stroke(0);    
  for(int i=0; i<N_RACOONS_ROW; i++) {
    for(int j=0; j<N_RACOONS_COL; j++) {
      float tolerance = min(width/N_RACOONS_ROW, height/N_RACOONS_COL) * S * pow(j+1, 3);
      Polygon racoon = (Polygon) DouglasPeuckerSimplifier.simplify(baseRacoon, tolerance);
      pushMatrix();
      translate((width/N_RACOONS_ROW) * ((N_RACOONS_ROW-i-1)+0.5), (height/N_RACOONS_COL) * ((N_RACOONS_COL-j-1)+0.5));
      drawRounded(racoon.getExteriorRing().getCoordinates(), R*(i+1));
      for(int n=0; n<racoon.getNumInteriorRing(); n++) {
        drawRounded(racoon.getInteriorRingN(n).getCoordinates(), R*(i+1));
      }
      popMatrix();
    }
  }
  
  endRecord();
  
  noLoop();
}

void drawRounded(Coordinate[] coords, float radius) {
  noFill();
  stroke(0);
  Vector2D a, b, c;
  a =  Vector2D.create(coords[coords.length - 1]);
  for(int i=0; i<coords.length; i++) {
    b = Vector2D.create(coords[i%coords.length]);
    c = Vector2D.create(coords[(i+1)%coords.length]);
    Vector2D ba = b.subtract(a).normalize();
    Vector2D bc = b.subtract(c).normalize();
    
    
    float sinA = (float) -ba.dot(bc.rotate(PI / 2));
    float sinA90 = (float) ba.dot(bc);
    float angle = asin(sinA);
    
    double radDirection = 1;
    int drawDirection = 0;
    
    if (sinA90 < 0) {
      if(angle > 0) {
        radDirection = -1;
        drawDirection = 1;
      }
      angle += PI;
    } else if (angle > 0){
      radDirection = -1;
      drawDirection = 1;
    }
    
    float lenOut = abs((cos(angle/2) * radius) / sin(angle/2));
    float cRadius = radius;
    if (lenOut > min((float) ba.length() / 2, (float) bc.length() / 2)) {
      lenOut = min((float) ba.length() / 2, (float) bc.length() / 2);
      cRadius = abs((lenOut * sin(angle/2)) / cos(angle/2));
    }

    double x = b.getX() + bc.getX() * lenOut - bc.getY() * cRadius * radDirection;
    double y = b.getY() + bc.getY() * lenOut + bc.getX() * cRadius * radDirection;
    
    arc((float) x, (float) y, (float) cRadius, (float) cRadius, (float) (ba.angle() + (PI / 2) * radDirection), (float) (bc.angle() - (PI / 2) * radDirection), drawDirection);
  }
}


//function roundedPoly(ctx, points, radiusAll) {
//  radius = radiusAll;
//  len = points.length;
//  p1 = points[len - 1];

//  for (i = 0; i < len; i++) {
//    p2 = points[i % len];
//    p3 = points[(i + 1) % len];

//    A = createVector(p1.x, p1.y);
//    B = createVector(p2.x, p2.y);
//    C = createVector(p3.x, p3.y);

//    (BA = A.sub(B)), (BC = C.sub(B));

//    (BAnorm = BA.copy().normalize()), (BCnorm = BC.copy().normalize());

//    sinA = -BAnorm.dot(BCnorm.copy().rotate(PI / 2));
//    sinA90 = BAnorm.dot(BCnorm);
//    angle = asin(sinA);

//    (radDirection = 1), (drawDirection = false);
//    if (sinA90 < 0) {
//      angle < 0 ? (angle += PI) : ((angle += PI), (radDirection = -1), (drawDirection = true));
//    } else {
//      angle > 0 ? ((radDirection = -1), (drawDirection = true)) : 0;
//    }
    
//    // accelDir = BAnorm.rotate(PI/2).copy().add(BCnorm)
//    // radDirection = Math.sign(accelDir.dot(BCnorm.rotate(PI / 2)))
//    // drawDirection = radDirection === -1

//    p2.radius ? (radius = p2.radius) : (radius = radiusAll);

//    halfAngle = angle / 2;
//    lenOut = abs((cos(halfAngle) * radius) / sin(halfAngle));

//    // Special part A
//    if (lenOut > min(BA.mag() / 2, BC.mag() / 2)) {
//      lenOut = min(BA.mag() / 2, BC.mag() / 2);
//      cRadius = abs((lenOut * sin(halfAngle)) / cos(halfAngle));
//    } else {
//      cRadius = radius;
//    }

//    x =
//      B.x +
//      BC.normalize().x * lenOut -
//      BC.normalize().y * cRadius * radDirection;
//    y =
//      B.y +
//      BC.normalize().y * lenOut +
//      BC.normalize().x * cRadius * radDirection;

//    ctx.arc(
//      x,
//      y,
//      cRadius,
//      BA.heading() + (PI / 2) * radDirection,
//      BC.heading() - (PI / 2) * radDirection,
//      drawDirection
//    );

//    p1 = p2;
//    p2 = p3;
//  }
//  ctx.closePath();
//}
