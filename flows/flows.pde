import processing.svg.*;

// RENDERING PARAMS
int WIDTH = 405;
int HEIGHT = 540;
int X_MIN = -int(WIDTH * 0.5);
int X_MAX = int(WIDTH * 1.5);
int Y_MIN = -int(HEIGHT * 0.5);
int Y_MAX = int(HEIGHT * 1.5);
int RESOLUTION = max(int(WIDTH * 0.001), 1);

// NOISE PARAMS
float OFFSET_INCREMENT = 0.001;
float DISPLACEMENT = 0.1;

// DRAW PARAMS
int N_LINES = 200;
int LINE_LENGTH = 2000;
float STROKE_WEIGHT = 3;

void setup() {
  size(810, 1080);
  noLoop();
  beginRecord(SVG, "out/flows.svg");
  
  colorMode(HSB, 360, 100, 100);
  background(0, 100, 0);
}

void draw (){
  noiseSeed(int(random(Integer.MAX_VALUE)));
  float[][] grid = make_noise_grid(RESOLUTION);
   
  stroke(0, 0, 100);
  strokeWeight(STROKE_WEIGHT);
  //draw_random(N_LINES, grid, RESOLUTION);
  draw_grid(N_LINES, grid, RESOLUTION);
  
  println("DONE!");
}

float[][] make_noise_grid(int resolution) {
  int n_cols = (X_MAX- X_MIN) / resolution;
  int n_rows = (Y_MAX - Y_MIN) / resolution;
  float[][] grid = new float[n_cols][n_rows];
    
  float x_off = 0.0;
  for(int i=0; i<n_cols; i++) {
    x_off += OFFSET_INCREMENT;
    
    float y_off = 0.0;
    for(int j=0; j<n_rows; j++) {
      y_off += OFFSET_INCREMENT;
      
      grid[i][j] = map(noise(x_off, y_off), 0, 1.0, 0, 2 * PI); // Smooth curves
      //grid[i][j] = PI * int(map(noise(x_off, y_off), 0, 1.0, 0, 6.0)) / 6; // Smooth curves
 
    }
  }
  
 return grid;
}

void draw_curve(float x_start, float y_start, int n_steps, float[][] grid, int resolution) {
  float x = x_start - X_MIN;
  float y = y_start - Y_MIN;

  noFill();
  beginShape();
  for(int i=0; i<n_steps; i++) {
    
    
    int col_index = int(x / resolution);
    int row_index = int(y / resolution);
    if(col_index > 0 && col_index < grid.length && row_index > 0 && row_index < grid.length) {
      float grid_angle = grid[col_index][row_index];
      x += DISPLACEMENT * cos(grid_angle);
      y += DISPLACEMENT * sin(grid_angle);
      vertex(x, y);
    }
  }
  endShape();
}

void draw_grid(int n_lines, float[][] grid, int resolution) {
  int n_i = int(sqrt(float(WIDTH)/float(HEIGHT)*n_lines));
  int n_j = int(sqrt(float(HEIGHT)/float(WIDTH)*n_lines));
  for(int i=0; i<n_i; i++) {
    for(int j=0; j<n_j; j++) {
      float x = WIDTH * i / n_i;
      float y = HEIGHT * j / n_j;
      int n_steps = int(LINE_LENGTH * randomGaussian());
      draw_curve(x, y, n_steps, grid, resolution);
    }
  } 
}

void draw_random(int n_lines, float[][] grid, int resolution) {
  for(int i=0; i<n_lines; i++) {
    int x = int(WIDTH * random(1));
    int y = int(HEIGHT * random(1));
    int n_steps = int(LINE_LENGTH * randomGaussian());
    draw_curve(x, y, n_steps, grid, resolution);
  } 
}
