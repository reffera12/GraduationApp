class TicTacToeAI {
  static const List<List<int>> winningCombos = [
    // Horizontal lines
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],

    // Vertical lines
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],

    // Diagonal lines
    [0, 4, 8],
    [2, 4, 6],
  ];
  List<List<String?>> board;

  TicTacToeAI(this.board);

  int getBestMove(List<List<String?>> board) {
    // Use a heuristic algorithm to determine the best play

    // Initial rank based on the number of winning combos
    // that go through the cell
    List<int> cellRank = [3, 2, 3, 2, 4, 2, 3, 2, 3];

    // Demote any cells already taken
    for (int i = 0; i < board.length; i++) {
      int row = i ~/ 3;
      int col = i % 3;
      if (board[row][col] != ' ') {
        cellRank[i] -= 99;
      }
    }

    // Look for partially completed combos
    for (List<int> combo in winningCombos) {
      int a = combo[0];
      int b = combo[1];
      int c = combo[2];

      if (board[a ~/ 3][a % 3] == board[b ~/ 3][b % 3]) {
        if (board[a ~/ 3][a % 3] != ' ' && board[c ~/ 3][c % 3] == ' ') {
          cellRank[c] += 10;
        }
      }

      if (board[a ~/ 3][a % 3] == board[c ~/ 3][c % 3]) {
        if (board[a ~/ 3][a % 3] != ' ' && board[b ~/ 3][b % 3] == ' ') {
          cellRank[b] += 10;
        }
      }

      if (board[b ~/ 3][b % 3] == board[c ~/ 3][c % 3]) {
        if (board[b ~/ 3][b % 3] != ' ' && board[a ~/ 3][a % 3] == ' ') {
          cellRank[a] += 10;
        }
      }
    }

    // Determine the best move to make
    int bestCell = -1;
    int highest = -999;

    // Step through cellRank to find the best available score
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        int index = r * 3 + c;
        if (cellRank[index] > highest && board[r][c] == ' ') {
          highest = cellRank[index];
          bestCell = index;
        }
      }
    }

    return bestCell;
  }
}
