def setup():
    size(510, 510)
    background(255)  # white background
    stroke(0)        # black lines

    space = 5                  # space from edges
    gridSize = 510 - 2 * space # drawing area
    cellSize = gridSize / 9.0

    # Draw vertical lines
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)  # thicker line for 3x3 blocks
        else:
            strokeWeight(1)  # normal line
        x = space + i * cellSize
        line(x, space, x, height - space)
        i += 1

    # Draw horizontal lines
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)
        else:
            strokeWeight(1)
        y = space + i * cellSize
        line(space, y, width - space, y)
        i += 1

def draw():
    pass  # empty because the grid is static
