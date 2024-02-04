import processing.svg.*;


float LINE_WEIGHT = 30;
float LINE_SEPARATION = 50;
float SEPARATION_FACTOR = 1.5;

GeometryFactory GF;
void setup() {
  size(4200, 2970);
  
  GF = new GeometryFactory();
   
  FlowField water = new FlowField(LINE_SEPARATION*SEPARATION_FACTOR);
  
  beginRecord(SVG, "out/final.svg");
  
  background(234,230,218); 
  noFill();
  stroke(0, 76, 92);
  strokeWeight(LINE_WEIGHT);
  for(FlowLine line : water.lines) {
    beginShape();
    for(Coordinate coord : line.path) {
      vertex((float) coord.x, (float) coord.y);
    }  
    endShape();
  }
  
  endRecord();
  noLoop();
}
