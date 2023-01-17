import fisica.*;
FWorld world;

color white          = #FFFFFF;
color black          = #000000;
color cyan           = #00FFFF;
color middleGreen    = #00FF00;
color leftGreen      = #009F00;
color rightGreen     = #006F00;
color green          = #004F00;
color red            = #FF0000;  
color orangered      = #FF5500;
color purple         = #9000FF;
color pink           = #FF03F3;
color blue           = #0000FF;
color orange         = #F0A000;
color brown          = #996633;
color treeTrunkBrown = #FF9500;
color tgreen         = #1F9740;

//terrain
PImage map, mapp, mappp, bridge, spike, ice, stone, treeTrunk, treeIntersect, treeMiddle, treeEndWest, treeEndEast, trampoline;
//lava
PImage[] lava;
PImage[] animate;
int numberOfFrames;

int gridSize = 32;
float zoom = 2;
boolean upkey, downkey, leftkey, rightkey, wkey, akey, skey , dkey, qkey, ekey, spacekey;
FPlayer player;
ArrayList<FGameObject> terrain;


void setup() {
  size(600, 600);
  Fisica.init(this);
  terrain = new ArrayList<FGameObject>();
  loadImages();
  loadWorld(mappp);
  loadPlayer();

      }
 
 void loadImages() {
    map = loadImage("pixelmap.png");
    mapp = loadImage("mapwicetree.png");
    mappp = loadImage("mappp.png");
    ice = loadImage("ice.png");
    treeTrunk = loadImage("tree_trunk.png");
    ice.resize(32, 32);
    stone = loadImage("stone.png");
    treeIntersect = loadImage("tree_intersect.png");
    treeMiddle = loadImage("treetop_center.png");
    treeEndWest = loadImage("treetop_w.png");
    treeEndEast = loadImage("treetop_e.png");
    spike = loadImage("spike.png");
    bridge = loadImage("bridge_center.png");
    trampoline = loadImage("trampoline.png");
    
    
    //load lava
    lava = new PImage[6];
    lava[0] = loadImage("lava0.png");
    lava[1] = loadImage("lava1.png");
    lava[2] = loadImage("lava2.png");
    lava[3] = loadImage("lava3.png");
    lava[4] = loadImage("lava4.png");
    lava[5] = loadImage("lava5.png");
    
   
    
    
 }
  
  void loadWorld(PImage img) {
  world = new FWorld(-2000, -2000, 2000, 2000);
  world.setGravity(0, 900);  
  
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
    
      color c = img.get(x, y); //color of current pixel
      color s = img.get(x, y+1); //color below current pixel
      color w = img.get(x-1, y); //color west of current pixel
      color e = img.get(x+1, y); //color east of current pixel
   
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y *gridSize);
        b.setStatic(true);
        if ( c == black) {  //stone block
        b.attachImage(stone);
        b.setFriction(4);
        b.setName("stone");
        world.add(b);
      }
     else if (c == cyan) { //iceblock
        b.setFriction(0);
        b.attachImage(ice); 
        b.setName("ice");
        world.add(b);
      }
     else if (c == treeTrunkBrown) {
        b.attachImage(treeTrunk);
        b.setSensor(true);  //setSensor turns block into ghost, u can pass thru it
        b.setName("tree trunk");
        world.add(b);
      }
     else if (c == middleGreen && s == treeTrunkBrown) { //intersection
      b.attachImage(treeIntersect);
      b.setName("treetop");
      world.add(b);
      }
     else if (c == middleGreen && w == middleGreen & e == middleGreen) { //mid piece
      b.attachImage(treeMiddle);
      b.setName("treetop");
      world.add(b);
      }
      else if (c == middleGreen && w != middleGreen) { //west endcap
      b.attachImage(treeEndWest);
      b.setName("treetop");
      world.add(b);
      }
      else if (c == middleGreen && e != middleGreen) { //east endcap
      b.attachImage(treeEndEast);
      b.setName("treetop");
      world.add(b);
    }
    else if (c == purple) {
      b.attachImage(spike);
      b.setName("spike");
      world.add(b);
    }
    else if (c == tgreen) {
      b.attachImage(trampoline);
      b.setVelocity(x, -800);
      b.setName("trampoline");
      world.add(b);
    }
    else if (c == pink) {
      FBridge br = new FBridge(x*gridSize, y*gridSize);
      terrain.add(br);
      world.add(br);
    }
    else if (c == orangered) {
      FLava la = new FLava(x*gridSize, y*gridSize);
      terrain.add(la);
      world.add(la);
    }
      
    }
  }
  }

void loadPlayer() {
  player = new FPlayer();
  world.add(player);
}

void draw() {
  background(white);
  drawWorld();
  actWorld();
  player.act();
}

void actWorld() {
 player.act();
  for (int i = 0; i < terrain.size(); i++) {
    FGameObject t = terrain.get(i);
    t.act();
  }
  
}

void drawWorld() {
  pushMatrix();
  translate(-player.getX()*zoom+width/2, -player.getY()*zoom+height/2);
  scale(zoom);
  world.step();
  world.draw();
  popMatrix();
}
