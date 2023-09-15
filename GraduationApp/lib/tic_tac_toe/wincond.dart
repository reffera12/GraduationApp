class WinConditions {
  bool checkForWin(List<List<String?>> board) {
    return isHorizontalLine(board) ||
        isVerticalLine(board) ||
        isDiagonalLine(board);
  }

  bool isHorizontalLine(List<List<String?>> board) {
    int c = 0;
    for (int r = 0; r < 3; r++) {
      if (board[r][c] == board[r][c + 1] &&
          board[r][c + 1] == board[r][c + 2] &&
          board[r][c] != null) {
        return true;
      }
    }
    return false;
  }

  bool isVerticalLine(List<List<String?>> board) {
    int r = 0;
    for (int c = 0; c < 3; c++) {
      if (board[r][c] == board[r + 1][c] &&
          board[r + 1][c] == board[r + 2][c] &&
          board[r][c] != null) {
        return true;
      }
    }
    return false;
  }

  bool isDiagonalLine(List<List<String?>> board) {
    // Check for top-left to bottom-right diagonal line
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != null) {
      return true;
    }

    // Check for top-right to bottom-left diagonal line
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != null) {
      return true;
    }
    return false;
  }
}
