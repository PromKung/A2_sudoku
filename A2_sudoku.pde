selectedRow = -1    # Cell clicked on the grid, mainly for highlighting
selectedCol = -1
selectedNumber = 0  # 0 means 'delete' or no number selected from keypad
gameWon = False

board = []          # Current state of the board ('1'-'9' or '0')
fixed = []          # Boolean array: True if the number is part of the initial puzzle

# --- Layout Constants for 540x900 Screen ---
GRID_SHIFT_DOWN = 40 # Space created at the top for the status text
GRID_TOP_LEFT_X = 5
GRID_TOP_LEFT_Y = 5 + GRID_SHIFT_DOWN # Grid starts lower
GRID_SIDE = 540 
GRID_DRAW_END_Y = GRID_SIDE - GRID_TOP_LEFT_X + GRID_SHIFT_DOWN # 535 + 40 = 575
GRID_DRAW_END_X = GRID_SIDE - GRID_TOP_LEFT_X # 535

KEYPAD_TOP_Y = 560 + GRID_SHIFT_DOWN # Keypad also shifts down
KEYPAD_SIZE = 60
KEYPAD_GAP = 6
KEYPAD_START_X = 25 # Start X for keypad changed by user
# ---------------------------------------------

def setup():
    global board, fixed
    
    size(540, 900) # Updated canvas size
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

# -----------------------------------------------
# Drawing Functions
# -----------------------------------------------

def draw():
    global gameWon
    background(255)
    
    # 1. Check Game Status
    current_valid = isPuzzleValid()
    current_full = isBoardFull()
    
    if current_full and current_valid:
        gameWon = True
    else:
        gameWon = False

    # 2. Drawing Order
    highlightCell() 
    drawGrid()
    drawNumbers(current_valid) 
    drawKeypad()
    
    # 3. Status Text (Selected Number/Mode)
    # Positioning: Above the keypad, aligned with the keypad's start X
    textSize(22) 
    textAlign(LEFT)
    if selectedNumber > 0:
        fill(0, 100, 200)
        # Using the corrected vertical offset for "Selected" text
        text("Selected: " + str(selectedNumber), KEYPAD_START_X, KEYPAD_TOP_Y - 5) 
    elif selectedNumber == 0:
        fill(200, 0, 0)
        text("Mode: DELETE/ERASE", KEYPAD_START_X, KEYPAD_TOP_Y - 5)
    else:
        fill(100)
        text("Select a number.", KEYPAD_START_X, KEYPAD_TOP_Y - 5)

    # 4. Win/Valid Status Text
    # Positioning: Top Left, above the grid
    textAlign(LEFT) 
    textSize(26)
    
    if gameWon:
        fill(0, 180, 0)
        text("🏆 YOU WON! 🥳", 10, 25) # Top-Left positioning
    elif current_valid:
        fill(0, 180, 0)
        text("Valid Board 👍", 10, 25)
    else:
        fill(255, 0, 0)
        text("Errors Present ❌", 10, 25)
        
    # Reset alignment for the grid numbers and keypad text
    textAlign(CENTER, CENTER) 


def drawGrid():
    
    gridSize = GRID_SIDE - 2 * GRID_TOP_LEFT_X
    cellSize = gridSize / 9.0

    i = 0
    while i <= 9:
        strokeWeight(3 if i % 3 == 0 else 1)
        x = GRID_TOP_LEFT_X + i * cellSize
        # Vertical lines: Fixed start Y and end Y
        line(x, GRID_TOP_LEFT_Y, x, GRID_DRAW_END_Y)
        
        y = GRID_TOP_LEFT_Y + i * cellSize
        # Horizontal lines: Fixed start X and end X
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

                # Fill rectangle coordinates, reduced by INSET on all sides
                rect_x = x + INSET
                rect_y = y + INSET
                rect_size = cellSize - 2 * INSET

                # Determine background color
                if fixed[row][col]:
                    fill(220) # Fixed number background (Gray)
                else:
                    fill(255) # User-entered number background (White)

                noStroke()
                rect(rect_x, rect_y, rect_size, rect_size)

                # Determine text color
                if not fixed[row][col] and not isValid:
                    fill(200, 0, 0) # Red if invalid
                else:
                    fill(0) # Black

                text(num, x + cellSize / 2, y + cellSize / 2)
            col += 1
        row += 1
    noFill()
    textSize(20)


def highlightCell():
    if selectedRow != -1 and selectedCol != -1:
        gridSize = GRID_SIDE - 2 * GRID_TOP_LEFT_X
        cellSize = gridSize / 9.0

        fill(180, 210, 255, 150) # Light Blue with transparency
        noStroke()
        rect(GRID_TOP_LEFT_X + selectedCol * cellSize, GRID_TOP_LEFT_Y + selectedRow * cellSize, cellSize, cellSize)
        noFill()
        stroke(0)


def drawKeypad():
    
    stroke(0)
    strokeWeight(2)

    # nums is used to loop through the positions
    nums = [[7, 8, 9], [4, 5, 6], [1, 2, 3], [0, 0, 0]]
    
    r = 0
    while r < 4:
        c = 0
        while c < 3:
            num_val = nums[r][c]
            x = KEYPAD_START_X + c * (KEYPAD_SIZE + KEYPAD_GAP)
            y = KEYPAD_TOP_Y + r * (KEYPAD_SIZE + KEYPAD_GAP)
            
            # Keypad buttons 1-9 (first three rows)
            if r < 3:
                # Highlight selected number
                if selectedNumber == num_val:
                    fill(180, 210, 255)
                else:
                    fill(255)
                
                rect(x, y, KEYPAD_SIZE, KEYPAD_SIZE)
                fill(0)
                textSize(KEYPAD_SIZE * 0.5)
                text(str(num_val), x + KEYPAD_SIZE / 2, y + KEYPAD_SIZE / 2)
            
            # DEL button (now in the first position of the last row: r=3, c=0)
            if r == 3 and c == 0: # <-- CHANGE HERE
                if selectedNumber == 0:
                    fill(255, 180, 180, 200) # Lighter red if selected
                else:
                    fill(255, 180, 180) # Red for DEL

                rect(x, y, KEYPAD_SIZE, KEYPAD_SIZE)
                fill(0)
                text("DEL", x + KEYPAD_SIZE / 2, y + KEYPAD_SIZE / 2)
                
            c += 1
        r += 1

    noFill()
    textSize(20)


# -----------------------------------------------
# Logic and Interaction Functions
# -----------------------------------------------

def mousePressed():
    global selectedRow, selectedCol, selectedNumber, board, fixed
    
    gridSize = GRID_SIDE - 2 * GRID_TOP_LEFT_X
    cellSize = gridSize / 9.0

    # 1. Keypad Click (Selects the number)
    
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
                    selectedNumber = num_val # Select 1-9
                # DEL is now r=3, c=0
                elif r == 3 and c == 0: # <-- CHANGE HERE
                    selectedNumber = 0 # Select DEL/Erase
                else:
                    return
                    
                selectedRow = -1 # Deselect cell on number selection
                selectedCol = -1
                return
            c += 1
        r += 1

    # 2. Grid Click (Places the currently selected number)
    
    # Use the pre-calculated end points for accurate hit-testing
    if GRID_TOP_LEFT_X <= mouseX <= GRID_DRAW_END_X and GRID_TOP_LEFT_Y <= mouseY <= GRID_DRAW_END_Y:
        col = int((mouseX - GRID_TOP_LEFT_X) / cellSize)
        row = int((mouseY - GRID_TOP_LEFT_Y) / cellSize)
        
        # Only allow changes if the cell is not fixed
        if not fixed[row][col]:
            # Place the currently selected number (or '0' for delete)
            board[row][col] = str(selectedNumber)
            
            # Set the selected cell to the one just changed for temporary highlight
            selectedRow = row
            selectedCol = col
        return
    
    # If a click missed the grid and keypad, clear the number selection
    selectedNumber = 0
    selectedRow = -1
    selectedCol = -1


# -----------------------------------------------
# Sudoku Validation Logic
# -----------------------------------------------

def check_segment(segment):
    # Filters out '0' (empty cells) and checks for duplicates in the remaining numbers
    nums = [int(n) for n in segment if n != '0']
    return len(nums) == len(set(nums))

def isPuzzleValid():
    # 1. Check Rows
    for row in range(9):
        if not check_segment(board[row]):
            return False

    # 2. Check Columns
    for col in range(9):
        column_segment = [board[row][col] for row in range(9)]
        if not check_segment(column_segment):
            return False

    # 3. Check 3x3 Blocks
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
    # Checks if every cell has a number (is not '0')
    row = 0
    while row < 9:
        col = 0
        while col < 9:
            if board[row][col] == '0':
                return False
            col += 1
        row += 1
    return True
