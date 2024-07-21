
class Rectangle {
  PVector min;
  PVector max;
  
  Rectangle(float minX, float minY, float maxX, float maxY) {
    this.min = new PVector(minX, minY);
    this.max = new PVector(maxX, maxY);
  }
}

ArrayList<Rectangle> createLayout(Rectangle parent, int depth, int maxDepth, ArrayList<Rectangle> rectangles) {
  boolean splitVertical = randomBoolean();
  Rectangle r1;
  Rectangle r2;
  if (splitVertical) {
    float cut = random(parent.min.x, parent.max.x);
    r1 = new Rectangle(parent.min.x, parent.min.y, cut, parent.max.y);
    r2 = new Rectangle(cut, parent.min.y, parent.max.x, parent.max.y);
  } else {
    
    float cut = random(parent.min.y, parent.max.y);
    r1 = new Rectangle(parent.min.x, parent.min.y, parent.max.x, cut);
    r2 = new Rectangle(parent.min.x, cut, parent.max.x, parent.max.y);
  }
  if (depth == maxDepth) {
    rectangles.add(r1);
    rectangles.add(r2);
  } else {
    createLayout(r1, depth + 1, maxDepth, rectangles);
    createLayout(r2, depth + 1, maxDepth, rectangles);
  }
  
  return rectangles;
}

boolean randomBoolean() {
  return random(1) > 0.5;
}