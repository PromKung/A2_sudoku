selectedRow = -1 #-1 mean no cell selected
selectedCol = -1 #-1 mean no cell selected

def setup():
    size(510, 610)
    background(255)
    stroke(0)
    textAlign(CENTER, CENTER)
    textSize(20)


def drawGrid():
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
        i += 1

    #Horizontal
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)
        else:
            strokeWeight(1)
        y = space + i * cellSize
        line(space, y, gridSide - space, y)
        i += 1


def highlightCell():
    if selectedRow != -1 and selectedCol != -1:
        space = 5
        gridSide = 510
        gridSize = gridSide - 2 * space
        cellSize = gridSize / 9.0

        #Highlight part
        fill(200, 220, 255)
        noStroke()
        rect(space + selectedCol * cellSize, space + selectedRow * cellSize, cellSize, cellSize)
        noFill()
        stroke(0)


def drawNumberBoxes():
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

        fill(0)
        textSize(int(boxHeight * 0.65))
        text(str(i + 1), boxX + boxWidth / 2, boxY + boxHeight / 2)
        noFill()
        i += 1


def mousePressed():
    global selectedRow, selectedCol
    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    if space <= mouseX <= gridSide - space and space <= mouseY <= gridSide - space: #Check if it outta grid?
        #Return selectedCol/Row
        selectedCol = int((mouseX - space) / cellSize)
        selectedRow = int((mouseY - space) / cellSize)


def draw():
    background(255)
    highlightCell()
    drawGrid()
    drawNumberBoxes()
