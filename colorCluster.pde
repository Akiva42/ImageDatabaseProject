PImage img;
ArrayList<Datum> datums = new ArrayList<Datum>();

int nCentroids = 6;
ArrayList<Centroid> centroids = new ArrayList<Centroid>();

boolean drawLines;
float zoom = 2.5;
PGraphics output;

void setup() {
  size(800, 800, P3D);
  img = loadImage("test.png");
  output = createGraphics(nCentroids*100,100);
  for (int i = 0; i< img.pixels.length; i++) {
    datums.add(new Datum(img.pixels[i]));
  }
  for (int i = 0; i<nCentroids; i++) {
    centroids.add(new Centroid());
  }
  findNearestCentroids();
}

void draw() {
  findNearestCentroids();
  reCalculateCentroidPos();
  background(128);
  translate(width/2, height/2);
  rotateX(radians(map(mouseY, 0, width, 360, 0)));
  rotateY(radians(map(mouseX, 0, width, 0, 360)));
  scale(zoom);
  strokeWeight(1);
  stroke(255);
  noFill();
  box(255);
  translate(-128, -128, -128);
  for (int i = 0; i < centroids.size(); i++) {
    centroids.get(i).draw();
  }
  strokeWeight(3);
  for (int i = 0; i< img.pixels.length; i++) {
    stroke(img.pixels[i]);
    Datum tempDatum = datums.get(i);
    point(tempDatum.c.x, tempDatum.c.y, tempDatum.c.z);
    if (drawLines) {
      stroke(tempDatum.myCentroid.c);
      strokeWeight(1);
      line(tempDatum.c.x, tempDatum.c.y, tempDatum.c.z, tempDatum.myCentroid.pos.x, tempDatum.myCentroid.pos.y, tempDatum.myCentroid.pos.z);
    }
  }
}
//----------
void findNearestCentroids() {
  for (int i = 0; i < datums.size(); i++) {
    datums.get(i).dist = -1;
    for (int j = 0; j < centroids.size(); j++) {
      Centroid tempC = centroids.get(j);
      centroids.get(j).numberOfDatums = 0;
      float distince = dist(datums.get(i).c.x, datums.get(i).c.y, datums.get(i).c.z, tempC.pos.x, tempC.pos.y, tempC.pos.z);
      if (datums.get(i).dist > distince || datums.get(i).dist < 0) {
        datums.get(i).dist = distince;
        datums.get(i).myCentroid = centroids.get(j);
        centroids.get(j).numberOfDatums ++;
      }
    }
  }
  for (int i = 0; i < centroids.size(); i++) {
    if (centroids.get(i).numberOfDatums == 0) {
      centroids.get(i).pos = new PVector(random(255), random(255), random(255));
    }
  }
}
//---------------
void reCalculateCentroidPos() {
  float sumX = 0;
  float sumY = 0;
  float sumZ = 0;
  int numberOfDatums = 0;
  for (int j = 0; j < centroids.size(); j++) {
    for (int i = 0; i < datums.size(); i++) {
      if (datums.get(i).myCentroid == centroids.get(j)) {
        numberOfDatums ++;
        sumX += datums.get(i).c.x;
        sumY += datums.get(i).c.y;
        sumZ += datums.get(i).c.z;
      }
    }
    centroids.get(j).pos = new PVector(sumX/numberOfDatums, sumY/numberOfDatums, sumZ/numberOfDatums);
  }
}
//-----------------
void reSeed() {
  centroids.clear();
  for (int i = 0; i < nCentroids; i ++) {
    centroids.add(new Centroid());
  }
}
//-----------------
class Centroid {
  public PVector pos = new PVector(random(255), random(255), random(255));
  public color c = color(random(128, 255), random(128, 255), random(128, 255));
  float displaySize = random(10, 20);
  public int numberOfDatums = 0;
  public Centroid() {
  }
  void draw() {
    stroke(c);
    strokeWeight(20);
    point(pos.x, pos.y, pos.z);
    pushMatrix();
    float boxSize = map(numberOfDatums, 0, datums.size()/nCentroids/10, 5, 100);
    fill(color(pos.x, pos.y, pos.z));
    stroke(color(pos.x, pos.y, pos.z));
    strokeWeight(2);
    line(pos.x, pos.y,pos.z,pos.x+boxSize/2,boxSize/2,boxSize/2);
    noStroke();
    translate(pos.x,0,0);
    box(boxSize);
    popMatrix();
  }
}

//-----------
class Datum {
  public PVector c;
  public PVector pos;
  public Centroid myCentroid;
  public float dist = -1;
  Datum(color c_) {
    c = new PVector(red(c_), green(c_), blue(c_));
  }
}
//-------------
void keyPressed() {
  if (key == 'l') {
    drawLines = !drawLines;
  }
  if (key == 'r') {
    reSeed();
  }
  if (key == 's') {
    //saveFrame("screenGrab-######.png");
    //println("savedImage");
    output.beginDraw();
    for(int i = 0; i < nCentroids; i++){
      output.fill(color(centroids.get(i).pos.x, centroids.get(i).pos.y, centroids.get(i).pos.z));
      output.noStroke();
      output.rect(i*100,0,100,100);
    }
    output.endDraw();
    output.save("output.jpg");
  }
}
//-------------
void mouseWheel(MouseEvent event) {
  zoom += event.getCount();
  println(zoom);
}