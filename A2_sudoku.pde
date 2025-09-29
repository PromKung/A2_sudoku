selectedRow = -1
selectedCol = -1
selectedNumber = -1

def setup():
    size(510, 610)
    background(255)
    stroke(0)
    textAlign(CENTER, CENTER)
    textSize(20)

def draw():
    background(255)
    highlightCell()
    drawGrid()
    drawNumberBoxes()

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

def drawNumberBoxes():
    gap = 5
    totalGapWidth = gap * (9 - 1)
    availableWidth = width - 2 * gap - totalGapWidth
    boxWidth = availableWidth / 9
    boxHeight = height - 510 - 2 * gap
    boxY = 510 + gap

    i = 0
    while i < 9:
        boxX = gap + i * (boxWidth + gap)
        noFill()
        strokeWeight(2)
        rect(boxX, boxY, boxWidth, boxHeight)

        fill(0)
        textSize(int(boxHeight * 0.65))
        text(str(i + 1), boxX + boxWidth / 2, boxY + boxHeight / 2)
        fill(255)  # reset fill
        i += 1

def highlightCell():
    if selectedRow != -1 and selectedCol != -1:
        space = 5
        gridSide = 510
        gridSize = gridSide - 2 * space
        cellSize = gridSize / 9.0

        #Highlight part
        fill(200, 220, 255)   # light blue fill
        noStroke()            # no border for the highlight
        rect(space + selectedCol * cellSize, space + selectedRow * cellSize, cellSize, cellSize)
        noFill()
        stroke(0)

def mousePressed():
    global selectedRow, selectedCol, selectedNumber
    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    #Check if click is inside Sudoku grid
    if space <= mouseX <= gridSide - space and space <= mouseY <= gridSide - space:
        selectedCol = int((mouseX - space) / cellSize)
        selectedRow = int((mouseY - space) / cellSize)
        print("Grid cell selected:", selectedRow, selectedCol)
        return

    #Check if click is inside number boxes
    gap = 5
    totalGapWidth = gap * (9 - 1)
    availableWidth = width - 2 * gap - totalGapWidth
    boxWidth = availableWidth / 9
    boxHeight = height - 510 - 2 * gap
    boxY = 510 + gap

    if boxY <= mouseY <= boxY + boxHeight:
        i = 0
        while i < 9:
            boxX = gap + i * (boxWidth + gap)
            if boxX <= mouseX <= boxX + boxWidth:
                selectedNumber = i + 1
                print("Number selected:", selectedNumber)
                break
            i += 1
