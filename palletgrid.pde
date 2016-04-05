String lines[];
PImage out;
int cellW = 10;
color c = color(0, 255, 0);

lines = loadStrings("Output_5000.txt");
out = createImage(cellW, 6*cellW, RGB);
for (int i = 0; i < lines.length; i++) {
  for (int j = 0; j < 6; j++) {
    if (j != 5) {
      c = unhex(lines[i].substring(lines[i].indexOf("#")+1, lines[i].indexOf(",")-1));
      lines[i] = lines[i].substring(lines[i].indexOf(",")+1);
    } else {
      c = unhex(lines[i].substring(lines[i].indexOf("#")+1, lines[i].indexOf("]")-1));
    }
    //println(hex(c, 6));
    for (int k = 0; k < cellW*cellW; k++) {
      out.pixels[k+j*(cellW*cellW)]=c;
    }
  }
  out.save(i+".png");
  println("--- " + i);
}