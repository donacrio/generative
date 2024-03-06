int SAND_TEXTURE_N_WATERCOLOR = 300;
int[][] SAND_PALETTE = {
  {246,215,176} ,
  {242,210,169} ,
  {236,204,162} ,
  {231,196,150} ,
  {225,191,146} 
};

float WATER_TEXTURE_PERLIN = 0.05;
float WATER_TEXTURE_WEIGHT = 1;
int[][] WATER_TEXTURE_PALETTE = {
  {6,66,115} , 
  {118,182,196} , 
  {127,205,255} ,
  {29,162,216} ,
  {222,243,246}
};
float WATER_MASK_PERLIN = 0.0025;
float WATER_MASK_WEIGHT = 10;


void setup() {
  size(1008, 720, P2D);
  
  // drawSand(SAND_TEXTURE_N_WATERCOLOR, SAND_PALETTE);
  
  // drawWater(
  //   WATER_TEXTURE_PERLIN,
  //   WATER_TEXTURE_WEIGHT,
  //   WATER_TEXTURE_PALETTE, 
  //   WATER_MASK_PERLIN, 
  //   WATER_MASK_WEIGHT
  //  );
  
  drawRocks();
  
  // drawCanvas();
  
  save("out/final.png");  
  noLoop();
}