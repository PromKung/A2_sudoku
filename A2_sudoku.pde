selectedRow = -1
selectedCol = -1
selectedNumber = -1
gameWon = False

board = [] # Sudoku numbers as strings
fixed = [] # True if number is from the puzzle

# ---------------- Setup ----------------
def setup():
    global board, fixed
    size(510, 610)
    background(255)

    boards = []
    try:
        lines = loadStrings("sudoku_boards.txt")

        current_board = []
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            if line == "":
                if current_board:
                    boards.append(current_board)
                    current_board = []
            else:
                current_board.append(line)
            i += 1

        if current_board:
            boards.append(current_board)

    except:
        # fallback board if file not found
        boards = [["530070000",
                   "600195000",
                   "098000060",
                   "800060003",
                   "400803001",
                   "700020006",
                   "060000280",
                   "000419005",
                   "000080079"]]


    import random
    chosen = random.choice(boards)

    board = []
    fixed = []
    for row_line in chosen:
        row_nums = []
        row_fixed = []
        for ch in row_line:
            row_nums.append(ch)
            row_fixed.append(ch != '0')
        board.append(row_nums)
        fixed.append(row_fixed)

    stroke(0)
    textAlign(CENTER, CENTER)
    textSize(20)

# ---------------- Draw ----------------
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
        fill(0)
        textSize(50)
        text("Congratulations!\n YOU WIN", width/2, height/2)
        noLoop()

# ---------------- Grid ----------------
def drawGrid():
    space = 5
    gridSide = 510
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    i = 0
    while i <= 9:
        strokeWeight(3 if i % 3 == 0 else 1)
        x = space + i * cellSize
        line(x, space, x, gridSide - space)
        y = space + i * cellSize
        line(space, y, gridSide - space, y)
        i += 1

# ---------------- Numbers ----------------
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
                fill(0) if fixed[row][col] else fill(70, 130, 255)
                textSize(int(cellSize * 0.7))
                text(num, space + col*cellSize + cellSize/2,
                          space + row*cellSize + cellSize/2)
            col += 1
        row += 1
    noFill()
    textSize(20)

# ---------------- Number boxes ----------------
def drawNumberBoxes():
    gap = 5
    totalGapWidth = gap * (9 - 1)
    availableWidth = width - 2*gap - totalGapWidth
    boxWidth = availableWidth / 9
    boxHeight = height - 510 - 2*gap
    boxY = 510 + gap

    i = 0
    while i < 9:
        boxX = gap + i * (boxWidth + gap)
        noFill()
        strokeWeight(2)
        rect(boxX, boxY, boxWidth, boxHeight)

        fill(0)
        textSize(int(boxHeight*0.65))
        text(str(i+1), boxX + boxWidth/2, boxY + boxHeight/2)
        fill(255)
        i += 1

# ---------------- Cell highlights ----------------
def highlightRelatedCells():
    if selectedRow != -1 and selectedCol != -1:
        space = 5
        gridSide = 510
        gridSize = gridSide - 2*space
        cellSize = gridSize / 9.0

        fill(200, 220, 255)
        noStroke()

        # Row
        col = 0
        while col < 9:
            rect(space + col*cellSize, space + selectedRow*cellSize, cellSize, cellSize)
            col += 1

        # Column
        row = 0
        while row < 9:
            rect(space + selectedCol*cellSize, space + row*cellSize, cellSize, cellSize)
            row += 1

        # 3x3 block
        startRow = (selectedRow // 3) * 3
        startCol = (selectedCol // 3) * 3
        r = 0
        while r < 3:
            c = 0
            while c < 3:
                rect(space + (startCol+c)*cellSize, space + (startRow+r)*cellSize, cellSize, cellSize)
                c += 1
            r += 1

        noFill()
        stroke(0)

def highlightCell():
    if selectedRow != -1 and selectedCol != -1:
        space = 5
        gridSide = 510
        gridSize = gridSide - 2*space
        cellSize = gridSize / 9.0

        fill(150, 200, 255)
        noStroke()
        rect(space + selectedCol*cellSize, space + selectedRow*cellSize, cellSize, cellSize)
        noFill()
        stroke(0)

# ---------------- Mouse ----------------
def mousePressed():
    global selectedRow, selectedCol, selectedNumber
    if gameWon:
        return

    space = 5
    gridSide = 510
    gridSize = gridSide - 2*space
    cellSize = gridSize / 9.0

    # Sudoku grid
    if space <= mouseX <= gridSide-space and space <= mouseY <= gridSide-space:
        selectedCol = int((mouseX-space)/cellSize)
        selectedRow = int((mouseY-space)/cellSize)
        return

    # Number boxes
    gap = 5
    totalGapWidth = gap*(9-1)
    availableWidth = width - 2*gap - totalGapWidth
    boxWidth = availableWidth / 9
    boxHeight = height - 510 - 2*gap
    boxY = 510 + gap

    if boxY <= mouseY <= boxY + boxHeight:
        i = 0
        while i < 9:
            boxX = gap + i*(boxWidth + gap)
            if boxX <= mouseX <= boxX + boxWidth:
                selectedNumber = i+1
                if selectedRow != -1 and selectedCol != -1:
                    placeNumber(selectedRow, selectedCol, selectedNumber)
                break
            i += 1

# ---------------- Sudoku logic ----------------
def isValid(row, col, number):
    c = 0
    while c < 9:
        if board[row][c] == str(number):
            return False
        c += 1
    r = 0
    while r < 9:
        if board[r][col] == str(number):
            return False
        r += 1
    startRow = (row//3)*3
    startCol = (col//3)*3
    r = 0
    while r < 3:
        c = 0
        while c < 3:
            if board[startRow+r][startCol+c] == str(number):
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

def checkWinSimple():
    row = 0
    while row < 9:
        col = 0
        while col < 9:
            if board[row][col] == '0':
                return False
            col += 1
        row += 1
    return True
