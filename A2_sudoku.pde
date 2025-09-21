def setup():
    size(510, 610)
    background(255)  # white background
    stroke(0)        # black lines

def drawGrid():
    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    # Draw vertical lines
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)
        else:
            strokeWeight(1)
        x = space + i * cellSize
        line(x, space, x, gridSide - space)
        i += 1

    # Draw horizontal lines
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)
        else:
            strokeWeight(1)
        y = space + i * cellSize
        line(space, y, gridSide - space, y)
        i += 1

def draw():
    background(255)  # clear each frame
    drawGrid()
