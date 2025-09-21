def setup():
    size(510, 610)  #Leave 100 y axis for number boxes
    background(255)
    stroke(0)
    textAlign(CENTER, CENTER)  # center text in box
    textSize(20)  # adjust font size

def drawGrid():  #Draw grid of sudoku
    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    #Vertical
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)
        else:
            strokeWeight(1)
        x = space + i * cellSize
        line(x, space, x, gridSide - space)
        i = i + 1

    #Horizontal
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)
        else:
            strokeWeight(1)
        y = space + i * cellSize
        line(space, y, gridSide - space, y)
        i = i + 1

def drawNumberBoxes():  #Draw number boxes under the grid
    gap = 5
    boxY = 510 + gap
    boxHeight = height - 510 - 2 * gap
    totalGapWidth = gap * (9 - 1)
    availableWidth = width - 2 * gap - totalGapWidth
    boxWidth = availableWidth / 9

    strokeWeight(3)
    i = 0
    while i < 9:
        boxX = gap + i * (boxWidth + gap)
        noFill()
        rect(boxX, boxY, boxWidth, boxHeight)
        
        #Draw number
        fill(0)
        textSize(int(boxHeight * 0.65))
        text(str(i + 1), boxX + boxWidth / 2, boxY + boxHeight / 2)  #Box + Wid/Hei /2 = middle of box
        
        i = i + 1

def draw():
    background(255)
    drawGrid()
    drawNumberBoxes()
