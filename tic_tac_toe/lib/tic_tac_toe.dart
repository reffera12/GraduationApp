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
  String winner = 'Player';
  late bool gameOver;
  late String symbol;
  late Players currentPlayer;
  //  late bool showLine;
  // late Offset lineStart;

  @override
  Widget build(BuildContext context) {
    return gameOver
        ? Scaffold(
            body: SingleChildScrollView(
              child: Center(
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
                        content:
                        Column(
                          children: [
                            Text(
                              "$winner is the winner!",
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
                                  restartGame();
                                });
                              },
                              child: (Text("Replay"))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ))
        : Scaffold(
            body: Center(
              child: SizedBox(
                  width: 600,
                  height: 600,
                  child: Container(
                    width: 600,
                    height: 600,
                    color: Colors.grey,
                    child: GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        var position = details.localPosition;
                        setState(() {
                          makeMove(position, Size(600, 600));
                          print(currentPlayer);

                          makeAiMove();
                        });
                      },
                      child: CustomPaint(
                        painter: BoardPainter(board: boardState),
                        size: Size(600, 600),
                      ),
                    ),
                  )),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    int firstPlayer = random.nextInt(2);
    currentPlayer = Players.values[firstPlayer];
    symbol = currentPlayer == Players.Player ? 'X' : 'O';
    if (currentPlayer == Players.AI) {
      makeAiMove();
    }
    gameOver = true;
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

  void makeMove(Offset tapPosition, Size boardSize) {
    final cellWidth = boardSize.width / 3;
    final cellHeight = boardSize.height / 3;

    int row = (tapPosition.dy / cellHeight).floor();
    int col = (tapPosition.dx / cellWidth).floor();

    if (boardState[row][col] == null) {
      boardState[row][col] = symbol;
      togglePlayer();
    }
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
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        boardState[row][col] = symbol;
        togglePlayer();
        checkWinConditions();
      });
    });
  }

  void checkWinConditions() {
    WinConditions winCon = WinConditions();
    if (winCon.checkForWin(boardState)) {
      togglePlayer();
      winner = currentPlayer.toString();
      gameOver = true;
    } else if (isBoardFull(boardState)) {
      winner = "Draw!";
      gameOver = true;
    }
  }

  bool isBoardFull(List<List<String?>> board) {
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        if (board[r][c] == null) {
          return false;
        }
      }
    }
    gameOver = true;
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

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    final linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draw vertical lines
    for (int col = 1; col < 3; col++) {
      final x = col * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Draw horizontal lines
    for (int row = 1; row < 3; row++) {
      final y = row * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Draw the outside border
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final centerX = cellWidth * col + cellWidth / 2;
        final centerY = cellHeight * row + cellHeight / 2;
        final symbol = board[row][col];

        if (symbol == 'X') {
          final symbolSize = cellWidth * 0.8;

          final startPoint1 =
              Offset(centerX - symbolSize / 2, centerY - symbolSize / 2);
          final endPoint1 =
              Offset(centerX + symbolSize / 2, centerY + symbolSize / 2);

          final startPoint2 =
              Offset(centerX - symbolSize / 2, centerY + symbolSize / 2);
          final endPoint2 =
              Offset(centerX + symbolSize / 2, centerY - symbolSize / 2);

          canvas.drawLine(startPoint1, endPoint1, xPaint);
          canvas.drawLine(startPoint2, endPoint2, xPaint);
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
