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

    # ---- Try reading from file ----
    boards = []
    try:
        lines = loadStrings("sudoku_boards.txt")
        current_board = []
        for line in lines:
            line = line.strip()
            if line != "":
                current_board.append(line)
        if len(current_board) == 9:
            boards.append(current_board)
        print("✅ Loaded board from sudoku_boards.txt")
    except:
        print("⚠️ sudoku_boards.txt not found, using default board.")
        boards = [[
            "030204508",
            "004607002",
            "005003004",
            "021000040",
            "050932000",
            "060000300",
            "500470000",
            "600310750",
            "000080079"
        ]]

    # ---- use the first (and only) board ----
    chosen = boards[0]

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
    inset = 1.5

    row = 0
    while row < 9:
        col = 0
        while col < 9:
            num = board[row][col]
            if num != '0':
                x = space + col * cellSize + inset
                y = space + row * cellSize + inset
                size = cellSize - 2 * inset

                if fixed[row][col]:
                    fill(200)
                else:
                    fill(255)

                noStroke()
                rect(x, y, size, size)

                fill(0)
                textSize(int(cellSize * 0.7))
                text(num, space + col * cellSize + cellSize / 2,
                          space + row * cellSize + cellSize / 2)
            col += 1
        row += 1
    noFill()
    textSize(20)


def highlightCell():
    if selectedRow != -1 and selectedCol != -1:
        space = 5
        gridSide = 540
        gridSize = gridSide - 2 * space
        cellSize = gridSize / 9.0

        fill(180, 210, 255)
        noStroke()
        rect(space + selectedCol * cellSize, space + selectedRow * cellSize, cellSize, cellSize)
        noFill()
        stroke(0)


def drawKeypad():
    padY = 560
    padSize = 60
    gap = 6
    totalWidth = 3 * padSize + 2 * gap
    startX = (width - totalWidth) / 2

    fill(255)
    stroke(0)
    strokeWeight(2)

    nums = [[7, 8, 9], [4, 5, 6], [1, 2, 3]]
    r = 0
    while r < 3:
        c = 0
        while c < 3:
            x = startX + c * (padSize + gap)
            y = padY + r * (padSize + gap)
            rect(x, y, padSize, padSize)
            fill(0)
            textSize(26)
            text(str(nums[r][c]), x + padSize / 2, y + padSize / 2)
            fill(255)
            c += 1
        r += 1

    delX = startX + (padSize + gap)
    delY = padY + 3 * (padSize + gap)
    fill(255, 180, 180)
    rect(delX, delY, padSize, padSize)
    fill(0)
    text("DEL", delX + padSize / 2, delY + padSize / 2)
    fill(255)


def mousePressed():
    global selectedRow, selectedCol
    space = 5
    gridSide = 540
    gridSize = gridSide - 2 * space
    cellSize = gridSize / 9.0

    if space <= mouseX <= gridSide - space and space <= mouseY <= gridSide - space:
        selectedCol = int((mouseX - space) / cellSize)
        selectedRow = int((mouseY - space) / cellSize)
        return

    padY = 560
    padSize = 60
    gap = 6
    totalWidth = 3 * padSize + 2 * gap
    startX = (width - totalWidth) / 2

    nums = [[7, 8, 9], [4, 5, 6], [1, 2, 3]]
    r = 0
    while r < 3:
        c = 0
        while c < 3:
            x = startX + c * (padSize + gap)
            y = padY + r * (padSize + gap)
            if x <= mouseX <= x + padSize and y <= mouseY <= y + padSize:
                if selectedRow != -1 and selectedCol != -1:
                    board[selectedRow][selectedCol] = str(nums[r][c])
            c += 1
        r += 1

    delX = startX + (padSize + gap)
    delY = padY + 3 * (padSize + gap)
    if delX <= mouseX <= delX + padSize and delY <= mouseY <= delY + padSize:
        if selectedRow != -1 and selectedCol != -1:
            board[selectedRow][selectedCol] = '0'
