def setup():
    size(510, 510)
    background(255)  # white background
    stroke(0)        # black lines

    margin = 5                  # space from edges
    gridSize = 510 - 2 * margin # drawing area
    cellSize = gridSize / 9.0

    # Draw vertical lines
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)  # thicker line for 3x3 blocks
        else:
            strokeWeight(1)  # normal line
        x = margin + i * cellSize
        line(x, margin, x, height - margin)
        i += 1

    # Draw horizontal lines
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)
        else:
            strokeWeight(1)
        y = margin + i * cellSize
        line(margin, y, width - margin, y)
        i += 1

def draw():
    pass  # empty because the grid is static
