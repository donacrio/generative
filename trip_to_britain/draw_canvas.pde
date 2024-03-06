void drawCanvas() {
  float spacing = 5;
  for (int i = -width; i < height + width; i += spacing) {
    stroke(255, random(10, 30));
    drawCanvasLine(i, 0, i + height, height);
  }
  for (int i = height + width; i >= -width; i -= spacing) {
    stroke(255, random(10, 30));
    drawCanvasLine(i, 0, i - height, height);
  }
}

void drawCanvasLine(float x1, float y1, float x2, float y2) {
  float tmp;
  /* Swap coordinates if needed so that x1 <= x2 */
  if (x1 > x2) { tmp = x1; x1 = x2; x2 = tmp; tmp = y1; y1 = y2; y2 = tmp; }
  
  float dx = x2 - x1;
  float dy = y2 - y1;
  float step = 1;
  
  if (x2 < x1)
  step = -step;
  
  float sx = x1;
  float sy = y1;
  for (float x = x1+step; x <= x2; x+=step) {
  float y = y1 + step * dy * (x - x1) / dx;
  strokeWeight(1 + map(noise(sx, sy), 0, 1, -0.5, 0.5));
  line(sx, sy, x + map(noise(x, y), 0, 1, -1, 1), y + map(noise(x, y), 0, 1, -1, 1));
  sx = x;
  sy = y;
}
}