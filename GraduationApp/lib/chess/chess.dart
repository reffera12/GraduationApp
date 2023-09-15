// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/chess/helper.dart';
import 'package:tic_tac_toe/chess/piece.dart';
import 'package:tic_tac_toe/chess/square.dart';

import 'dead_piece.dart';

class Chess extends StatefulWidget {
  const Chess({super.key});

  @override
  State<Chess> createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  late List<List<ChessPiece?>> board;
  List<List<int>> validMoves = [];
  List<ChessPiece> whitePiecesTaken = [];
  List<ChessPiece> blackPiecesTaken = [];
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];

  ChessPiece? selectedPiece;

  int selectedRow = -1;
  int selectedCol = -1;
  bool isSelected = false;
  bool isValidMove = false;
  late ChessPiece? capturedPiece;
  bool isWhiteTurn = true;
  bool inCheck = false;
  late bool gameOver;
  String winner = '';

  @override
  Widget build(BuildContext context) {
    return gameOver
        ? Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    height: 200,
                    child: AlertDialog(
                      title: Text("Game Over"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            winner != "Draw"
                                ? "$winner is the winner!"
                                : "Draw!",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: GoogleFonts.gluten().fontFamily,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: (Text("Back to menu")),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                resetGame();
                              });
                            },
                            child: (Text("Replay"))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Center(
            child: Column(children: [
              Text(inCheck ? "Check!" : ""),
              Container(
                width: 880,
                height: 150,
                color: Colors.blueGrey,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemCount: whitePiecesTaken.length,
                  itemBuilder: (context, index) => DeadPiece(
                    imgPath: whitePiecesTaken[index].imgPath,
                    isWhite: true,
                  ),
                ),
              ),
              Container(
                width: 880,
                height: 880,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3)),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    int row = index ~/ 8;
                    int col = index % 8;

                    isSelected = selectedRow == row && selectedCol == col;

                    checkMoves(row, col);

                    return Square(
                      isWhite: isWhite(index),
                      piece: board[row][col],
                      isSelected: isSelected,
                      isValidMove: isValidMove,
                      onTap: () {
                        pieceSelected(row, col);
                      },
                    );
                  },
                  itemCount: 8 * 8,
                ),
              ),
              Container(
                height: 150,
                width: 880,
                color: Colors.blueGrey,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemCount: blackPiecesTaken.length,
                  itemBuilder: (context, index) => DeadPiece(
                    imgPath: blackPiecesTaken[index].imgPath,
                    isWhite: false,
                  ),
                ),
              ),
            ]),
          ));
  }

  void initializeBoard() {
    board = List.generate(8, (index) => List.filled(8, null));

    //Place pawns
    for (int i = 0; i < board.length; i++) {
      board[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          isWhite: false,
          imgPath: 'assets/white_pawn.png');
      board[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imgPath: 'assets/white_pawn.png',
      );
    }

    //Place kings
    board[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imgPath: 'assets/white_king.png');
    board[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imgPath: 'assets/white_king.png');

    //Place queens
    board[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imgPath: 'assets/white_queen.png');
    board[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imgPath: 'assets/white_queen.png');

    //Place bishops
    board[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imgPath: 'assets/white_bishop.png');
    board[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imgPath: 'assets/white_bishop.png');
    board[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imgPath: 'assets/white_bishop.png');
    board[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imgPath: 'assets/white_bishop.png');

    //Place knights
    board[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imgPath: 'assets/white_knight.png');
    board[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imgPath: 'assets/white_knight.png');
    board[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imgPath: 'assets/white_knight.png');
    board[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imgPath: 'assets/white_knight.png');
    //Place rooks
    board[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imgPath: 'assets/white_rook.png');
    board[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imgPath: 'assets/white_rook.png');
    board[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imgPath: 'assets/white_rook.png');
    board[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imgPath: 'assets/white_rook.png');
  }

  void pieceSelected(int row, int col) {
    setState(() {
      if (board[row][col] != null && selectedPiece == null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedCol = col;
          selectedRow = row;
        }
      } else if (board[row][col] != null &&
          board[row][col]!.isWhite != selectedPiece!.isWhite) {
        movePiece(row, col);
      } else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      } else {
        selectedPiece = null;
        selectedRow = -1;
        selectedCol = -1;
        validMoves = [];
      }

      validMoves = calculateRealMoves(row, col, selectedPiece, true);
      print(validMoves);
    });
  }

  void resetGame() {
    setState(() {
      initializeBoard();
      whitePiecesTaken.clear();
      blackPiecesTaken.clear();
      gameOver = false;
    });
  }

  void initState() {
    super.initState();
    board = [];
    gameOver = false;
    initializeBoard();
  }

  void dispose() {
    super.dispose();
  }

  void checkMoves(row, col) {
    isValidMove = false;
    for (var position in validMoves) {
      if (position[0] == row && position[1] == col) {
        isValidMove = true;
      }
    }
  }

  void movePiece(int newRow, int newCol) {
    if (board[newRow][newCol] != null) {
      capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece!);
      } else if (!capturedPiece!.isWhite) {
        blackPiecesTaken.add(capturedPiece!);
      }
    }

    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    if (isKingInCheck(!isWhiteTurn)) {
      inCheck = true;
    } else {
      inCheck = false;
    }
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    if (isCheckMate(!isWhiteTurn)) {
      setState(() {
        gameOver = true;
      });
      print(gameOver);
    }
    toggleTurn();
  }

  toggleTurn() {
    isWhiteTurn = isWhiteTurn ? false : true;
  }

  isKingInCheck(bool isWhiteKing) {
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves =
            calculateRealMoves(i, j, board[i][j], false);

        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  List<List<int>> calculateRealMoves(
    int row,
    int col,
    ChessPiece? selectedPiece,
    bool checkSimulation,
  ) {
    List<List<int>> realMoves = [];
    List<List<int>> candidateMoves =
        calculateRawMoves(row, col, selectedPiece, board);

    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        if (simulatedMoveIsSafe(
          selectedPiece,
          row,
          col,
          endRow,
          endCol,
        )) {
          realMoves.add(move);
        }
      }
    } else {
      realMoves = candidateMoves;
    }
    return realMoves;
  }

  bool simulatedMoveIsSafe(
    ChessPiece? piece,
    int startRow,
    int startCol,
    int endRow,
    int endCol,
  ) {
    ChessPiece? oGPiecePos = board[endRow][endCol];
    List<int>? oGKingPos;

    if (piece!.type == ChessPieceType.king) {
      oGKingPos = piece.isWhite ? whiteKingPosition : blackKingPosition;

      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(piece.isWhite);

    board[startRow][startCol] = piece;
    board[endRow][endCol] = oGPiecePos;

    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = oGKingPos!;
      } else {
        blackKingPosition = oGKingPos!;
      }
    }

    return !kingInCheck;
  }

  bool isCheckMate(bool isWhiteKing) {
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }

        List<List<int>> pieceMoves =
            calculateRealMoves(i, j, board[i][j], true);

        if (pieceMoves.isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }
}
