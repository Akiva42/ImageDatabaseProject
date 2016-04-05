PImage img;

void setup() {
  size(512, 512);
  background(0);
  colorMode(HSB);
  for (int j = 0; j < 100; j++) {
    img = loadImage(j + ".jpg");
    strokeWeight(2);
    for (int i = 0; i < img.pixels.length; i++) {
      float x = map(hue(img.pixels[i]), 0, 255, 0, width);
      float y = map(saturation(img.pixels[i]), 0, 255, 0, height);
      stroke(img.pixels[i]);
      point(x, y);
      //line(x, 0, x, height);
    }
    println("done");
    saveFrame("out__" + j + ".png");
    background(0);
  }
}

void draw() {
}

void keyPressed() {
  if (key == 's') {
    saveFrame("out_######.png");
  }
}