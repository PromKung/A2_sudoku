selectedRow = -1
selectedCol = -1
selectedNumber = -1
gameWon = False

# Sudoku puzzle: '0' means empty
board = [
    ['5','3','0','0','7','0','0','0','0'],
    ['6','0','0','1','9','5','0','0','0'],
    ['0','9','8','0','0','0','0','6','0'],
    ['8','0','0','0','6','0','0','0','3'],
    ['4','0','0','8','0','3','0','0','1'],
    ['7','0','0','0','2','0','0','0','6'],
    ['0','6','0','0','0','0','2','8','0'],
    ['0','0','0','4','1','9','0','0','5'],
    ['0','0','0','0','8','0','0','7','9']
]

# Track fixed cells (original numbers)
fixed = []
row = 0
while row < 9:
    newRow = []
    col = 0
    while col < 9:
        if board[row][col] != '0':
            newRow.append(True)
        else:
            newRow.append(False)
        col += 1
    fixed.append(newRow)
    row += 1

def setup():
    size(510, 610)
    background(255)
    stroke(0)
    textAlign(CENTER, CENTER)
    textSize(20)

def draw():
    global gameWon
    background(255)
    if not gameWon:
        highlightRelatedCells()
        highlightCell()
        drawGrid()
        drawNumbers()
        drawNumberBoxes()
    else:
        fill(0, 0, 0)
        textSize(50)
        text("Congratulations!\n YOU WIN", width/2, height/2)
        noLoop()  # stop the draw loop after winning

def drawGrid():
    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    #Vertical lines
    i = 0
    while i <= 9:
        if i % 3 == 0:
            strokeWeight(3)
        else:
            strokeWeight(1)
        x = space + i * cellSize
        line(x, space, x, gridSide - space)
        i += 1

    #Horizontal lines
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
        fill(255)
        i += 1

def highlightRelatedCells():
    if selectedRow != -1 and selectedCol != -1:
        space = 5
        gridSide = 510
        gridSize = gridSide - 2 * space
        cellSize = gridSize / 9.0

        fill(200, 220, 255)
        noStroke()

        #Row
        col = 0
        while col < 9:
            rect(space + col * cellSize, space + selectedRow * cellSize, cellSize, cellSize)
            col += 1

        #Column
        row = 0
        while row < 9:
            rect(space + selectedCol * cellSize, space + row * cellSize, cellSize, cellSize)
            row += 1

        #3x3 block
        startRow = (selectedRow // 3) * 3
        startCol = (selectedCol // 3) * 3
        r = 0
        while r < 3:
            c = 0
            while c < 3:
                rect(space + (startCol + c) * cellSize, space + (startRow + r) * cellSize, cellSize, cellSize)
                c += 1
            r += 1

        noFill()
        stroke(0)

def highlightCell():
    if selectedRow != -1 and selectedCol != -1:
        space = 5
        gridSide = 510
        gridSize = gridSide - 2 * space
        cellSize = gridSize / 9.0

        fill(150, 200, 255)
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
            num = board[row][col]
            if num != '0':
                if fixed[row][col]:
                    fill(0)
                else:
                    fill(70, 130, 255)
                textSize(int(cellSize * 0.7))
                text(str(num),
                     space + col * cellSize + cellSize / 2,
                     space + row * cellSize + cellSize / 2)
            col += 1
        row += 1
    noFill()
    textSize(20)

def isValid(row, col, number):
    #Row
    c = 0
    while c < 9:
        if board[row][c] == str(number):
            return False
        c += 1
    #Column
    r = 0
    while r < 9:
        if board[r][col] == str(number):
            return False
        r += 1
    #3x3 block
    startRow = (row // 3) * 3
    startCol = (col // 3) * 3
    r = 0
    while r < 3:
        c = 0
        while c < 3:
            if board[startRow + r][startCol + c] == str(number):
                return False
            c += 1
        r += 1
    return True

def placeNumber(row, col, number):
    global gameWon
    if 0 <= row < 9 and 0 <= col < 9:
        if not fixed[row][col]:
            if isValid(row, col, number):
                board[row][col] = str(number)
                if checkWinSimple():
                    gameWon = True
            else:
                print("Invalid placement!")

def checkWinSimple():
    row = 0
    while row < 9:
        col = 0
        while col < 9:
            if board[row][col] == '0':  # empty cell
                return False
            col += 1
        row += 1
    return True

def mousePressed():
    global selectedRow, selectedCol, selectedNumber
    if gameWon:
        return

    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    #Sudoku grid
    if space <= mouseX <= gridSide - space and space <= mouseY <= gridSide - space:
        selectedCol = int((mouseX - space) / cellSize)
        selectedRow = int((mouseY - space) / cellSize)
        print("Grid cell selected:", selectedRow, selectedCol)
        return

    #Number boxes
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
                if selectedRow != -1 and selectedCol != -1:
                    placeNumber(selectedRow, selectedCol, selectedNumber)
                break
            i += 1
