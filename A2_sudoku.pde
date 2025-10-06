selectedRow = -1
selectedCol = -1
selectedNumber = 0
gameWon = False

board = []
fixed = []

GRID_SHIFT_DOWN = 40
GRID_TOP_LEFT_X = 5
GRID_TOP_LEFT_Y = 5 + GRID_SHIFT_DOWN
GRID_SIDE = 540
GRID_DRAW_END_Y = GRID_SIDE - GRID_TOP_LEFT_X + GRID_SHIFT_DOWN
GRID_DRAW_END_X = GRID_SIDE - GRID_TOP_LEFT_X

KEYPAD_TOP_Y = 560 + GRID_SHIFT_DOWN
KEYPAD_SIZE = 60
KEYPAD_GAP = 6
KEYPAD_START_X = 25

def setup():
    global board, fixed

    size(540, 900)
    background(255)

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
        print("Loaded board from sudoku_boards.txt")
    except:
        print("sudoku_boards.txt not found, using default board.")
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
    global gameWon
    background(255)

    current_valid = isPuzzleValid()
    current_full = isBoardFull()

    if current_full and current_valid:
        gameWon = True
    else:
        gameWon = False

    highlightCell()
    drawGrid()
    drawNumbers(current_valid)
    drawKeypad()

    textSize(22)
    textAlign(LEFT)
    if selectedNumber > 0:
        fill(0, 100, 200)
        text("Selected: " + str(selectedNumber), KEYPAD_START_X, KEYPAD_TOP_Y - 5)
    elif selectedNumber == 0:
        fill(200, 0, 0)
        text("Mode: DELETE/ERASE", KEYPAD_START_X, KEYPAD_TOP_Y - 5)
    else:
        fill(100)
        text("Select a number.", KEYPAD_START_X, KEYPAD_TOP_Y - 5)

    textAlign(LEFT)
    textSize(26)

    if gameWon:
        fill(0, 180, 0)
        text("YOU WON!", 10, 25)
    elif current_valid:
        fill(0, 180, 0)
        text("Valid Board", 10, 25)
    else:
        fill(255, 0, 0)
        text("Errors Present", 10, 25)

    textAlign(CENTER, CENTER)


def drawGrid():

    gridSize = GRID_SIDE - 2 * GRID_TOP_LEFT_X
    cellSize = gridSize / 9.0

    i = 0
    while i <= 9:
        strokeWeight(3 if i % 3 == 0 else 1)
        x = GRID_TOP_LEFT_X + i * cellSize
        line(x, GRID_TOP_LEFT_Y, x, GRID_DRAW_END_Y)

        y = GRID_TOP_LEFT_Y + i * cellSize
        line(GRID_TOP_LEFT_X, y, GRID_DRAW_END_X, y)
        i += 1


def drawNumbers(isValid):

    gridSize = GRID_SIDE - 2 * GRID_TOP_LEFT_X
    cellSize = gridSize / 9.0

    TEXT_SIZE = int(cellSize * 0.7)
    INSET = 2
    textSize(TEXT_SIZE)

    row = 0
    while row < 9:
        col = 0
        while col < 9:
            num = board[row][col]
            if num != '0':

                x = GRID_TOP_LEFT_X + col * cellSize
                y = GRID_TOP_LEFT_Y + row * cellSize

                rect_x = x + INSET
                rect_y = y + INSET
                rect_size = cellSize - 2 * INSET

                if fixed[row][col]:
                    fill(220)
                else:
                    fill(255)

                noStroke()
                rect(rect_x, rect_y, rect_size, rect_size)

                if not fixed[row][col] and not isValid:
                    fill(200, 0, 0)
                else:
                    fill(0)

                text(num, x + cellSize / 2, y + cellSize / 2)
            col += 1
        row += 1
    noFill()
    textSize(20)


def highlightCell():
    if selectedRow != -1 and selectedCol != -1:
        gridSize = GRID_SIDE - 2 * GRID_TOP_LEFT_X
        cellSize = gridSize / 9.0

        fill(180, 210, 255, 150)
        noStroke()
        rect(GRID_TOP_LEFT_X + selectedCol * cellSize, GRID_TOP_LEFT_Y + selectedRow * cellSize, cellSize, cellSize)
        noFill()
        stroke(0)


def drawKeypad():

    stroke(0)
    strokeWeight(2)

    nums = [[7, 8, 9], [4, 5, 6], [1, 2, 3], [0, 0, 0]]

    r = 0
    while r < 4:
        c = 0
        while c < 3:
            num_val = nums[r][c]
            x = KEYPAD_START_X + c * (KEYPAD_SIZE + KEYPAD_GAP)
            y = KEYPAD_TOP_Y + r * (KEYPAD_SIZE + KEYPAD_GAP)

            if r < 3:
                if selectedNumber == num_val:
                    fill(180, 210, 255)
                else:
                    fill(255)

                rect(x, y, KEYPAD_SIZE, KEYPAD_SIZE)
                fill(0)
                textSize(KEYPAD_SIZE * 0.5)
                text(str(num_val), x + KEYPAD_SIZE / 2, y + KEYPAD_SIZE / 2)

            if r == 3 and c == 0:
                if selectedNumber == 0:
                    fill(255, 180, 180, 200)
                else:
                    fill(255, 180, 180)

                rect(x, y, KEYPAD_SIZE, KEYPAD_SIZE)
                fill(0)
                text("DEL", x + KEYPAD_SIZE / 2, y + KEYPAD_SIZE / 2)

            c += 1
        r += 1

    noFill()
    textSize(20)


def mousePressed():
    global selectedRow, selectedCol, selectedNumber, board, fixed

    gridSize = GRID_SIDE - 2 * GRID_TOP_LEFT_X
    cellSize = gridSize / 9.0

    r = 0
    nums = [[7, 8, 9], [4, 5, 6], [1, 2, 3], [0, 0, 0]]

    while r < 4:
        c = 0
        while c < 3:
            num_val = nums[r][c]
            x = KEYPAD_START_X + c * (KEYPAD_SIZE + KEYPAD_GAP)
            y = KEYPAD_TOP_Y + r * (KEYPAD_SIZE + KEYPAD_GAP)

            if x <= mouseX <= x + KEYPAD_SIZE and y <= mouseY <= y + KEYPAD_SIZE:

                if r < 3:
                    selectedNumber = num_val
                elif r == 3 and c == 0:
                    selectedNumber = 0
                else:
                    return

                selectedRow = -1
                selectedCol = -1
                return
            c += 1
        r += 1

    if GRID_TOP_LEFT_X <= mouseX <= GRID_DRAW_END_X and GRID_TOP_LEFT_Y <= mouseY <= GRID_DRAW_END_Y:
        col = int((mouseX - GRID_TOP_LEFT_X) / cellSize)
        row = int((mouseY - GRID_TOP_LEFT_Y) / cellSize)

        if not fixed[row][col]:
            board[row][col] = str(selectedNumber)

            selectedRow = row
            selectedCol = col
        return

    selectedNumber = 0
    selectedRow = -1
    selectedCol = -1


def check_segment(segment):
    nums = [int(n) for n in segment if n != '0']
    return len(nums) == len(set(nums))

def isPuzzleValid():
    for row in range(9):
        if not check_segment(board[row]):
            return False

    for col in range(9):
        column_segment = [board[row][col] for row in range(9)]
        if not check_segment(column_segment):
            return False

    for start_row in range(0, 9, 3):
        for start_col in range(0, 9, 3):
            block_segment = []
            for row in range(start_row, start_row + 3):
                for col in range(start_col, start_col + 3):
                    block_segment.append(board[row][col])
            if not check_segment(block_segment):
                return False

    return True

def isBoardFull():
    row = 0
    while row < 9:
        col = 0
        while col < 9:
            if board[row][col] == '0':
                return False
            col += 1
        row += 1
    return True
