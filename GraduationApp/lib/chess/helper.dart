import 'package:tic_tac_toe/chess/piece.dart';

bool isWhite(int index) {
  int row = index ~/ 8;
  int col = index % 8;

  bool isWhite = (row + col) % 2 == 0 ? true : false;
  return isWhite;
}

List<List<int>> calculateRawMoves(int row, int col, ChessPiece? selectedPiece,
    List<List<ChessPiece?>> board) {
  List<List<int>> candidateMoves = [];

  if (selectedPiece == null) {
    return [];
  }

  int direction = selectedPiece.isWhite ? -1 : 1;

  switch (selectedPiece.type) {
    case ChessPieceType.pawn:
      //General move
      if (isInBoard(row + direction, col) &&
          board[row + direction][col] == null) {
        candidateMoves.add([row + direction, col]);
      }
      //First move
      if (row == 1 && !selectedPiece.isWhite ||
          row == 6 && selectedPiece.isWhite) {
        if (isInBoard(row + 2 * direction, col) &&
            board[row + direction][col] == null &&
            board[row + 2 * direction][col] == null) {
          candidateMoves.add([row + 2 * direction, col]);
        }
      }
      //Attack move
      if (isInBoard(row + direction, col + 1) &&
          board[row + direction][col + 1] != null &&
          board[row + direction][col + 1]!.isWhite != selectedPiece.isWhite) {
        candidateMoves.add([row + direction, col + 1]);
      }
      if (isInBoard(row + direction, col - 1) &&
          board[row + direction][col - 1] != null &&
          board[row + direction][col - 1]!.isWhite != selectedPiece.isWhite) {
        candidateMoves.add([row + direction, col - 1]);
      }
      break;

    case ChessPieceType.rook:
      var directions = [
        [-1, 0],
        [1, 0],
        [0, 1],
        [0, -1]
      ];
      for (var direction in directions) {
        var i = 1;
        while (true) {
          var newRow = row + i * direction[0];
          var newCol = col + i * direction[1];
          if (!isInBoard(newRow, newCol)) {
            break;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }
          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }
      break;
    case ChessPieceType.bishop:
      var directions = [
        [-1, 1],
        [1, 1],
        [-1, -1],
        [1, -1]
      ];
      for (var direction in directions) {
        var i = 1;
        while (true) {
          var newRow = row + i * direction[0];
          var newCol = col + i * direction[1];
          if (!isInBoard(newRow, newCol)) {
            break;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }
          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }
      break;
    case ChessPieceType.knight:
      var knightMoves = [
        [-2, -1],
        [-2, 1],
        [-1, 2],
        [1, 2],
        [1, -2],
        [-1, -2],
        [2, -1],
        [2, 1]
      ];
      for (var move in knightMoves) {
        var newRow = row + move[0];
        var newCol = col + move[1];
        if (!isInBoard(newRow, newCol)) {
          continue;
        }
        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
            candidateMoves.add([newRow, newCol]);
          } else {
            continue;
          }
        }
        candidateMoves.add([newRow, newCol]);
      }
      break;
    case ChessPieceType.king:
      var directions = [
        [-1, 0],
        [1, 0],
        [0, 1],
        [0, -1],
        [-1, 1],
        [1, 1],
        [-1, -1],
        [1, -1]
      ];
      for (var direction in directions) {
        var i = 1;

        var newRow = row + i * direction[0];
        var newCol = col + i * direction[1];
        if (!isInBoard(newRow, newCol)) {
          continue;
        }
        if (board[newRow][newCol] != null) {
          if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
            candidateMoves.add([newRow, newCol]);
          } else {
            continue;
          }
        }
        candidateMoves.add([newRow, newCol]);
      }
      break;
    case ChessPieceType.queen:
      var directions = [
        [-1, 0],
        [1, 0],
        [0, 1],
        [0, -1],
        [-1, 1],
        [1, 1],
        [-1, -1],
        [1, -1]
      ];
      for (var direction in directions) {
        var i = 1;
        while (true) {
          var newRow = row + i * direction[0];
          var newCol = col + i * direction[1];
          if (!isInBoard(newRow, newCol)) {
            break;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }
          candidateMoves.add([newRow, newCol]);
          i++;
        }
      }
      break;
    default:
  }
  return candidateMoves;
}

bool isInBoard(int row, int col) {
  return row >= 0 && row <= 7 && col >= 0 && col <= 7;
}
