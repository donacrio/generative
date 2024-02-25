import processing.svg.*;


void setup() {
  size(720, 720);
  
  
  //Setup water
  float waterPerlin = 0.001;
  float waterWeight = 25;
  FlowField waterFlowField = new FlowField(waterPerlin, waterWeight * 10, waterWeight * 1.5);
  
  beginRecord(SVG, "out/final.svg");
  
  background(234,230,218); 
  
  // Rendering water
  noFill();
  stroke(0, 76, 92);
  strokeWeight(waterWeight);
  for (FlowLine line : waterFlowField.lines) {
    beginShape();
    for (Coordinate coord : line.path) {
      vertex((float) coord.x,(float) coord.y);
    }  
    endShape();
  }
  
  endRecord();
  noLoop();
}