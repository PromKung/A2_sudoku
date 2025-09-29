selectedRow = -1
selectedCol = -1
selectedNumber = -1

# Initialize empty 9x9 grid using while loops
grid = []

row = 0
while row < 9:
    newRow = []
    col = 0
    while col < 9:
        newRow.append(0)  # 0 means empty
        col += 1
    grid.append(newRow)
    
    # Optional: mark 3-row blocks in code for clarity
    if (row + 1) % 3 == 0:
        pass  # End of a 3-row block
    row += 1

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
    drawNumbers()
    drawNumberBoxes()

def drawGrid():
    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    # Vertical lines
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)
        else:
            strokeWeight(1)
        x = space + i * cellSize
        line(x, space, x, gridSide - space)
        i += 1

    # Horizontal lines
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

        fill(200, 220, 255)   # light blue highlight
        noStroke()
        rect(space + selectedCol * cellSize, space + selectedRow * cellSize, cellSize, cellSize)
        noFill()
        stroke(0)

def drawNumbers():
    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    row = 0
    while row < 9:
        col = 0
        while col < 9:
            num = grid[row][col]
            if num != 0:
                fill(0)
                textSize(int(cellSize * 0.7))
                text(str(num),
                     space + col * cellSize + cellSize / 2,
                     space + row * cellSize + cellSize / 2)
            col += 1
        row += 1
    noFill()
    textSize(20)

def placeNumber(row, col, number):
    if 0 <= row < 9 and 0 <= col < 9:
        grid[row][col] = number

def mousePressed():
    global selectedRow, selectedCol, selectedNumber
    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    # Check click inside Sudoku grid
    if space <= mouseX <= gridSide - space and space <= mouseY <= gridSide - space:
        selectedCol = int((mouseX - space) / cellSize)
        selectedRow = int((mouseY - space) / cellSize)
        print("Grid cell selected:", selectedRow, selectedCol)
        return

    # Check click on number boxes
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
                # Place number in selected cell
                if selectedRow != -1 and selectedCol != -1:
                    placeNumber(selectedRow, selectedCol, selectedNumber)
                break
            i += 1
