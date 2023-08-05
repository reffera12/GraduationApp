class WinConditions {
  bool checkForWin(List<List<String?>> board) {
    return isHorizontalLine(board) ||
        isVerticalLine(board) ||
        isDiagonalLine(board);
  }

  bool isLine(List<List<String?>> board, {int index1 = 0, int index2 = 0}) {
    if (board[index1][index2] == board[index1][index2 + 1] &&
        board[index1][index2 + 1] == board[index1][index2 + 2] &&
        board[index1][index2] != null) {
      return true;
    }
    return false;
  }

  bool isHorizontalLine(List<List<String?>> board) {
    for (int r = 0; r < 3; r++) {
      if (isLine(board, index1: r)) {
        return true;
      }
    }
    return false;
  }

  bool isVerticalLine(List<List<String?>> board) {
    for (int c = 0; c < 3; c++) {
      if (isLine(board, index1: c)) {
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
