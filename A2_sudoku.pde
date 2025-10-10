selectedRow = -1
selectedCol = -1
selectedNum = 0
gameWon = False

init_number = []
user_number = []

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
    global init_number, user_number

    size(540, 900)
    background(255)

    boards = []
    try:
        lines = loadStrings("sudoku_boards.txt")
        current_board = []
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            if line != "":
                current_board.append(line)
            i += 1
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

    init_number = []
    user_number = []
    i = 0
    while i < 9:
        row_line = chosen[i]
        init_row = []
        user_row = []
        j = 0
        while j < 9:
            init_row.append(int(row_line[j]))
            user_row.append(0)
            j += 1
        init_number.append(init_row)
        user_number.append(user_row)
        i += 1

    stroke(0)
    textAlign(CENTER, CENTER)
    textSize(20)


def draw():
    global gameWon
    background(255)

    full = isBoardFull(init_number, user_number)

    if full and valid:
        gameWon = True
    else:
        gameWon = False

    highlightCell()
    drawGrid()
    drawNumber(init_number, user_number)
    drawNumpad()
    valid = IsSudokuValid(init_number, user_number)

    textSize(22)
    textAlign(LEFT)
    if selectedNum > 0:
        fill(0, 100, 200)
        text("Selected: " + str(selectedNum), KEYPAD_START_X, KEYPAD_TOP_Y - 5)
    else:
        fill(200, 0, 0)
        text("Delete Mode", KEYPAD_START_X, KEYPAD_TOP_Y - 5)

    textAlign(LEFT)
    textSize(26)
    if gameWon:
        fill(0, 180, 0)
        text("YOU WON!", 10, 25)
    elif valid:
        fill(0, 180, 0)
        text("Good :)", 10, 25)
    else:
        fill(255, 0, 0)
        text("Not Good :(", 10, 25)

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


def drawNumber(init_number, user_number):
    gridSize = GRID_SIDE - 2 * GRID_TOP_LEFT_X
    cellSize = gridSize / 9.0
    TEXT_SIZE = int(cellSize * 0.7)
    INSET = 2
    textSize(TEXT_SIZE)

    row = 0
    while row < 9:
        col = 0
        while col < 9:
            num = init_number[row][col]
            usr = user_number[row][col]

            x = GRID_TOP_LEFT_X + col * cellSize
            y = GRID_TOP_LEFT_Y + row * cellSize
            rect_x = x + INSET
            rect_y = y + INSET
            rect_size = cellSize - 2 * INSET

            # Draw initial number (fixed)
            if num > 0:
                fill(220)
                noStroke()
                rect(rect_x, rect_y, rect_size, rect_size)
                fill(0)
                text(str(num), x + cellSize / 2, y + cellSize / 2)
            # Draw user number
            elif usr > 0:
                fill(255)
                noStroke()
                rect(rect_x, rect_y, rect_size, rect_size)
                fill(0)
                text(str(usr), x + cellSize / 2, y + cellSize / 2)
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


def drawNumpad():
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
                if selectedNum == num_val:
                    fill(180, 210, 255)
                else:
                    fill(255)
                rect(x, y, KEYPAD_SIZE, KEYPAD_SIZE)
                fill(0)
                textSize(KEYPAD_SIZE * 0.5)
                text(str(num_val), x + KEYPAD_SIZE / 2, y + KEYPAD_SIZE / 2)
            if r == 3 and c == 0:
                if selectedNum == 0:
                    fill(255, 180, 180, 200)
                else:
                    fill(255, 180, 180)
                rect(x, y, KEYPAD_SIZE, KEYPAD_SIZE)
                fill(0)
                text("X", x + KEYPAD_SIZE / 2, y + KEYPAD_SIZE / 2)
            c += 1
        r += 1
    noFill()
    textSize(20)


def mousePressed():
    NumpadPressed()
    SudokuPressed()


def NumpadPressed():
    global selectedNum, selectedRow, selectedCol
    nums = [[7, 8, 9], [4, 5, 6], [1, 2, 3], [0, 0, 0]]
    r = 0
    while r < 4:
        c = 0
        while c < 3:
            num_val = nums[r][c]
            x = KEYPAD_START_X + c * (KEYPAD_SIZE + KEYPAD_GAP)
            y = KEYPAD_TOP_Y + r * (KEYPAD_SIZE + KEYPAD_GAP)
            if x <= mouseX <= x + KEYPAD_SIZE and y <= mouseY <= y + KEYPAD_SIZE:
                if r < 3:
                    selectedNum = num_val
                elif r == 3 and c == 0:
                    selectedNum = 0
                selectedRow = -1
                selectedCol = -1
                return
            c += 1
        r += 1


def SudokuPressed():
    global selectedRow, selectedCol, user_number
    gridSize = GRID_SIDE - 2 * GRID_TOP_LEFT_X
    cellSize = gridSize / 9.0

    if GRID_TOP_LEFT_X <= mouseX <= GRID_DRAW_END_X and GRID_TOP_LEFT_Y <= mouseY <= GRID_DRAW_END_Y:
        col = int((mouseX - GRID_TOP_LEFT_X) / cellSize)
        row = int((mouseY - GRID_TOP_LEFT_Y) / cellSize)
        if init_number[row][col] == 0:
            user_number[row][col] = selectedNum
            selectedRow = row
            selectedCol = col


def IsSudokuValid(init_number, user_number):
    combined_number = [[0]*9 for _ in range(9)]
    i = 0
    isValid = True
    while i < 9:
        j = 0
        while j < 9:
            if user_number[i][j] != 0:
                combined_number[i][j] = user_number[i][j]
            else:
                combined_number[i][j] = init_number[i][j]
            j += 1
        i += 1

    # Column check
    i = 0
    while i < 9:
        seen = [False]*10
        j = 0
        while j < 9:
            num = combined_number[j][i]
            if num != 0:
                if seen[num]:
                    fill(255, 0, 0, 75)
                    rectMode(CORNERS)
                    rect(GRID_TOP_LEFT_X + i * (GRID_SIDE-2*GRID_TOP_LEFT_X)/9, GRID_TOP_LEFT_Y,
                         GRID_TOP_LEFT_X + (i+1) * (GRID_SIDE-2*GRID_TOP_LEFT_X)/9, GRID_DRAW_END_Y)
                    rectMode(CORNER)
                    isValid = False
                else:
                    seen[num] = True
            j += 1
        i += 1

    # Row check
    i = 0
    while i < 9:
        seen = [False]*10
        j = 0
        while j < 9:
            num = combined_number[i][j]
            if num != 0:
                if seen[num]:
                    fill(255, 0, 0, 75)
                    rectMode(CORNERS)
                    rect(GRID_TOP_LEFT_X, GRID_TOP_LEFT_Y + i * (GRID_SIDE-2*GRID_TOP_LEFT_X)/9,
                         GRID_DRAW_END_X, GRID_TOP_LEFT_Y + (i+1) * (GRID_SIDE-2*GRID_TOP_LEFT_X)/9)
                    rectMode(CORNER)
                    isValid = False
                else:
                    seen[num] = True
            j += 1
        i += 1

    # Block check
    i = 0
    while i < 3:
        j = 0
        while j < 3:
            seen = [False]*10
            i2 = 0
            while i2 < 3:
                j2 = 0
                while j2 < 3:
                    num = combined_number[i*3 + i2][j*3 + j2]
                    if num != 0:
                        if seen[num]:
                            fill(255, 0, 0, 75)
                            rectMode(CORNERS)
                            rect(GRID_TOP_LEFT_X + j*3*(GRID_SIDE-2*GRID_TOP_LEFT_X)/9,
                                 GRID_TOP_LEFT_Y + i*3*(GRID_SIDE-2*GRID_TOP_LEFT_X)/9,
                                 GRID_TOP_LEFT_X + (j*3 + 3)*(GRID_SIDE-2*GRID_TOP_LEFT_X)/9,
                                 GRID_TOP_LEFT_Y + (i*3 + 3)*(GRID_SIDE-2*GRID_TOP_LEFT_X)/9)
                            rectMode(CORNER)
                            isValid = False
                        else:
                            seen[num] = True
                    j2 += 1
                i2 += 1
            j += 1
        i += 1

    return isValid


def isBoardFull(init_number, user_number):
    i = 0
    while i < 9:
        j = 0
        while j < 9:
            if init_number[i][j] == 0 and user_number[i][j] == 0:
                return False
            j += 1
        i += 1
    return True
