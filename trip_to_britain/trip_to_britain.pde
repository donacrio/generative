float ELEVATION_SCALE = 1;
float ELEVATION_ELEVATION_PERLIN_INCR = 0.005;

int SAND_TEXTURE_WATERCOLOR_NUMBER = 300;
int SAND_TEXTURE_WATERCOLOR_RADIUS = 100;
int[][] SAND_PALETTE = {
  {199,191,187} ,
  {223,215,202} ,
  {233,227,222} ,
  {186,140,72} ,
  {164,114,80}
};

float WATER_TEXTURE_PERLIN = 0.0025;
float WATER_TEXTURE_WEIGHT = 5;
int[][] WATER_TEXTURE_PALETTE = {
  {6,66,115} , 
  {118,182,196} , 
  {127,205,255} ,
  {29,162,216} ,
  {222,243,246}
};


void setup() {
  size(2160, 2106, P2D);
  
  int rows = (int)(height / ELEVATION_SCALE) + 1;
  int cols = (int)(width / ELEVATION_SCALE) + 1;
  float[][] elevationMatrix = createGradientElevationMatrix(
    rows,
    cols,
    ELEVATION_ELEVATION_PERLIN_INCR * ELEVATION_SCALE
   );
  
  PGraphics waterTexture = createWaterTexture(WATER_TEXTURE_PERLIN, WATER_TEXTURE_WEIGHT, WATER_TEXTURE_PALETTE);
  // PGraphics waterTexture = createGraphics(width, height, P2D);
  // waterTexture.beginDraw();
  // waterTexture.background(127,205,255);
  // waterTexture.endDraw();
  PGraphics waterMask = createElevationMask(
    elevationMatrix, ELEVATION_SCALE, 0
   );
  waterTexture.mask(waterMask);
  image(waterTexture, 0, 0);
  
  PGraphics sandTexture = createSandTexture();
  // PGraphics sandTexture = createGraphics(width, height, P2D);
  // sandTexture.beginDraw();
  // sandTexture.background(236,204,162);
  // sandTexture.endDraw();
  PGraphics sandMask = createElevationMask(
    elevationMatrix, ELEVATION_SCALE, 0.55
   );
  sandTexture.mask(sandMask);
  image(sandTexture, 0, 0);
  
  PGraphics rockTexture = createGraphics(width, height, P2D);
  rockTexture.beginDraw();
  rockTexture.background(101,83,83);
  rockTexture.endDraw();
  PGraphics rockMask = createElevationMask(
    elevationMatrix, ELEVATION_SCALE, 0.65
   );
  rockTexture.mask(rockMask);
  image(rockTexture, 0, 0);
  
  PGraphics grassTexture = createGraphics(width, height, P2D);
  grassTexture.beginDraw();
  grassTexture.background(65,152,10);
  grassTexture.endDraw();
  PGraphics grassMask = createElevationMask(
    elevationMatrix, ELEVATION_SCALE, 0.75
   );
  grassTexture.mask(grassMask);
  image(grassTexture, 0, 0);
  
  // drawCanvas();
  
  save("out/final.png");  
  noLoop();
}