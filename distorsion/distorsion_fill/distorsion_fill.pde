import processing.svg.*;


// RENDERING PARAMS
int WIDTH = 405;
int HEIGHT = 540;
int RESOLUTION = max(int(WIDTH * 0.001), 1);

// NOISE PARAMS
float OFFSET_INCREMENT = 0.005;
float DISPLACEMENT = 0.01;

// DRAWING PARAMS
int N_LINES = 20;
float STROKE = 1.0;


// GLOBAL UTILS
int X_MIN = -int(WIDTH * 0.5);
int X_MAX = int(WIDTH * 1.5);
int Y_MIN = -int(HEIGHT * 0.5);
int Y_MAX = int(HEIGHT * 1.5);

void setup() {
  size(810, 1080);
  noLoop();
  beginRecord(SVG, "distorsion.svg");
  
  colorMode(HSB, 360, 100, 100);
  background(0, 0, 100);
}

void draw (){
  noiseSeed(int(random(Integer.MAX_VALUE)));
  float[][] grid = make_noise_grid(RESOLUTION);
 
   color[] colors = {
     color(237, 90, 51),
     color(0, 0.4, 93.3),
     color(54, 77.5, 94.1),
     color(0, 91.2, 84.3)
   };
   
   for(int i = 0; i < N_LINES; i++) {
   color c = colors[int(random(colors.length))];
   float x = (i + 0.5) * WIDTH / N_LINES;
   draw_curve(x, c, grid, RESOLUTION);
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

void draw_curve(float x, color c, float[][] grid, int resolution) {
  x = x - X_MIN;
   
  fill(c);
  noStroke();
  beginShape();
  for(int i=0; i < HEIGHT; i++) {
    float y = i - Y_MIN;
    int col_index = int(x / resolution);
    int row_index = int(y / resolution);
    
    if(col_index > 0 && col_index < grid.length && row_index > 0 && row_index < grid.length) {
      float grid_displacement = grid[col_index][row_index];
      x += x + WIDTH * grid_displacement;
      vertex(x, y);
    }
  }
  endShape();
}
