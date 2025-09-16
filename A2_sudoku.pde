void setup() {
  size(510, 510);
  background(255); // white background
  stroke(0);       // black lines

  int margin = 5;           // space from edges
  int gridSize = 510 - 2 * margin; // drawing area
  float cellSize = gridSize / 9.0;

  // Draw vertical lines
  int i = 0;
  while (i <= 9) {
    if (i % 3 == 0) {
      strokeWeight(3); // thicker line for 3x3 blocks
    } else {
      strokeWeight(1); // normal line
    }
    float x = margin + i * cellSize;
    line(x, margin, x, height - margin);
    i++;
  }

  // Draw horizontal lines
  i = 0;
  while (i <= 9) {
    if (i % 3 == 0) {
      strokeWeight(3);
    } else {
      strokeWeight(1);
    }
    float y = margin + i * cellSize;
    line(margin, y, width - margin, y);
    i++;
  }
}

void draw() {
  // empty because the grid is static
}
