import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/ai.dart';
import 'package:tic_tac_toe/wincond.dart';

enum Players {
  AI,
  Player,
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  List<List<String?>> boardState = [
    [null, null, null],
    [null, null, null],
    [null, null, null],
  ];

  Random random = Random();
  String winner = '';
  late bool gameOver;
  late String symbol;
  late Players currentPlayer;
  //  late bool showLine;
  // late Offset lineStart;

  @override
  Widget build(BuildContext context) {
    return gameOver
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Container(
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AlertDialog(
                      title: Text("Game Over"),
                      content: Text(
                        "$winner is the winner!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: GoogleFonts.gluten().fontFamily,
                            fontWeight: FontWeight.bold),
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
                                restartGame();
                              });
                            },
                            child: (Text("Replay"))),
                      ],
                    ),
                  ),
                ),
              ),
            ))
        : Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                height: 500,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  shrinkWrap: true,
                  primary: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                      child: GestureDetector(
                        onTap: () {
                          print(currentPlayer);
                          if (!gameOver && !isBoardFull(boardState)) {
                            setState(() {
                              makeMove(index);
                              makeAiMove();
                            });
                          }
                        },
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CustomPaint(
                            painter: BoardPainter(board: boardState),
                            size: Size(200, 200),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 9,
                ),
              ),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    int firstPlayer = random.nextInt(2);
    currentPlayer = Players.values[firstPlayer];
    symbol = currentPlayer == Players.Player ? 'X' : 'O';
    print(symbol);
    gameOver = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  restartGame() {
    boardState = [
      [null, null, null],
      [null, null, null],
      [null, null, null],
    ];
    winner = '';
    gameOver = false;
  }

  void makeMove(int index) {
    int row = index ~/ 3;
    int col = index % 3;
    if (boardState[row][col] == null) {
      boardState[row][col] = symbol;
    }
    print(currentPlayer);
    // print(symbol);
    togglePlayer();
    checkWinConditions();
  }

  togglePlayer() {
    currentPlayer =
        currentPlayer == Players.Player ? Players.AI : Players.Player;
    symbol = currentPlayer == Players.Player ? 'X' : 'O';
  }

  void makeAiMove() {
    TicTacToeAI ai = TicTacToeAI(boardState);
    int bestMove = ai.getBestMove(boardState);
    int row = bestMove ~/ 3;
    int col = bestMove % 3;

    boardState[row][col] = symbol;
    print(currentPlayer);
    print(symbol);
    togglePlayer();
    checkWinConditions();
  }

  void checkWinConditions() {
    WinConditions winCon = WinConditions();
    if (winCon.checkForWin(boardState)) {
      togglePlayer();
      winner = currentPlayer.toString();
      gameOver = true;
    }
  }

  bool isBoardFull(List<List<String?>> board) {
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (board[r][c] == ' ') {
          return false;
        }
      }
    }
    return true;
  }
}

class BoardPainter extends CustomPainter {
  final List<List<String?>> board;
  BoardPainter({required this.board});

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / 3;
    final cellHeight = size.height / 3;
    final symbolSize = min(cellWidth, cellHeight) * 0.7;

    final xPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final oPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final centerX = cellWidth * col + cellWidth / 2;
        final centerY = cellHeight * row + cellHeight / 2;
        final symbol = board[row][col];

        final borderPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

        // Draw the outside border
        canvas.drawRect(
            Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);

        if (symbol == 'X') {
          final symbolSize = cellWidth * 0.8;

          final startPoint =
              Offset(centerX - symbolSize / 2, centerY - symbolSize / 2);
          final endPoint =
              Offset(centerX + symbolSize / 2, centerY + symbolSize / 2);

          canvas.drawLine(startPoint, endPoint, xPaint);
        }

        if (symbol == 'O') {
          canvas.drawOval(
              Rect.fromCircle(
                  center: Offset(centerX, centerY), radius: symbolSize / 2),
              oPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
