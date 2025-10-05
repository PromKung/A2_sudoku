selectedRow = -1
selectedCol = -1
selectedNumber = -1
gameWon = False

board = []
fixed = []

def setup():
    global board, fixed
    size(540, 850)
    background(255)

    chosen = [
        "530070000",
        "600195000",
        "098000060",
        "800060003",
        "400803001",
        "700020006",
        "060000280",
        "000419005",
        "000080079"
    ]

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

def draw():
    background(255)
    highlightCell()
    drawGrid()
    drawNumbers()
    drawKeypad()

def drawGrid():
    space = 5
    gridSide = 540
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

def drawNumbers():
    space = 5
    gridSide = 540
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

def highlightCell():
    if selectedRow != -1 and selectedCol != -1:
        space = 5
        gridSide = 540
        gridSize = gridSide - 2*space
        cellSize = gridSize / 9.0

        fill(180, 210, 255)
        noStroke()
        rect(space + selectedCol*cellSize, space + selectedRow*cellSize, cellSize, cellSize)
        noFill()
        stroke(0)

# ---------- Keypad (closer to grid, less bottom gap) ----------
def drawKeypad():
    padY = 560  # move closer to grid
    padSize = 60
    gap = 6
    totalWidth = 3 * padSize + 2 * gap
    startX = (width - totalWidth) / 2

    fill(255)
    stroke(0)
    strokeWeight(2)

    num = 1
    r = 0
    while r < 3:
        c = 0
        while c < 3:
            x = startX + c * (padSize + gap)
            y = padY + r * (padSize + gap)
            rect(x, y, padSize, padSize)
            fill(0)
            textSize(26)
            text(str(num), x + padSize/2, y + padSize/2)
            fill(255)
            num += 1
            c += 1
        r += 1

    # Delete button (center bottom)
    delX = startX + (padSize + gap)
    delY = padY + 3 * (padSize + gap)
    fill(255, 180, 180)
    rect(delX, delY, padSize, padSize)
    fill(0)
    text("DEL", delX + padSize/2, delY + padSize/2)
    fill(255)

def mousePressed():
    global selectedRow, selectedCol, selectedNumber
    space = 5
    gridSide = 540
    gridSize = gridSide - 2*space
    cellSize = gridSize / 9.0

    if space <= mouseX <= gridSide-space and space <= mouseY <= gridSide-space:
        selectedCol = int((mouseX-space)/cellSize)
        selectedRow = int((mouseY-space)/cellSize)
        return

    padY = 560
    padSize = 60
    gap = 6
    totalWidth = 3 * padSize + 2 * gap
    startX = (width - totalWidth) / 2

    r = 0
    num = 1
    while r < 3:
        c = 0
        while c < 3:
            x = startX + c * (padSize + gap)
            y = padY + r * (padSize + gap)
            if x <= mouseX <= x + padSize and y <= mouseY <= y + padSize:
                if selectedRow != -1 and selectedCol != -1:
                    board[selectedRow][selectedCol] = str(num)
            num += 1
            c += 1
        r += 1

    # Delete button detection
    delX = startX + (padSize + gap)
    delY = padY + 3 * (padSize + gap)
    if delX <= mouseX <= delX + padSize and delY <= mouseY <= delY + padSize:
        if selectedRow != -1 and selectedCol != -1:
            board[selectedRow][selectedCol] = '0'
