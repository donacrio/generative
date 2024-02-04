import processing.svg.*;

// RENDERING PARAMS
int WIDTH = 810;
int HEIGHT = 1080;
int X_MIN = -int(WIDTH * 0.5);
int X_MAX = int(WIDTH * 1.5);
int Y_MIN = -int(HEIGHT * 0.5);
int Y_MAX = int(HEIGHT * 1.5);
int RESOLUTION = max(int(WIDTH * 0.001), 1);

// NOISE PARAMS
float OFFSET_INCREMENT = 0.005;
float DISPLACEMENT = 0.1;

// DRAWING PARAMS
int N_LINES = 50;
float STROKE = 1.0;

void setup() {
  size(1620, 2160);
  noLoop();
  beginRecord(SVG, "out/distorsion.svg");
  
  colorMode(HSB, 360, 100, 100);
  background(0, 0, 100);
}

void draw (){
  noiseSeed(int(random(Integer.MAX_VALUE)));
  float[][] grid = make_noise_grid(RESOLUTION);
   
  stroke(0, 100, 50);  
  for(int i = 0; i < N_LINES; i++) { 
   float x = i * WIDTH / N_LINES;
   draw_curve(x, grid, RESOLUTION);
  }
  
  stroke(240, 100, 50);
  for(int i = 0; i < N_LINES; i++) { 
   float x = (i + 0.5) * WIDTH / N_LINES;
   draw_curve(x, grid, RESOLUTION);
  }
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
      
      grid[i][j] = map(noise(x_off, y_off), 0, 1.0, - DISPLACEMENT, DISPLACEMENT);
 
    }
  }
  
 return grid;
}

void draw_curve(float x, float[][] grid, int resolution) {
  x = x - X_MIN;
   
  noFill();
  strokeWeight(STROKE);
  beginShape();
  for(int i=0; i < HEIGHT; i++) {
    float y = i - Y_MIN;
    int col_index = int(x / resolution);
    int row_index = int(y / resolution);
    
    if(col_index > 0 && col_index < grid.length && row_index > 0 && row_index < grid.length) {
      float grid_displacement = grid[col_index][row_index];
      vertex(x + WIDTH * grid_displacement, y);
    }
  }
  endShape();
}
