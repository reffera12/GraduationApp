// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';

class Sudoku extends StatefulWidget {
  const Sudoku({super.key});

  @override
  State<Sudoku> createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  int boardAxisCount = 9;

  List<List<String?>> board = List.generate(9, (_) => List.filled(9, ''));
  List<String?> numbers = List.generate(9, (index) => (index + 1).toString());
  List<Coordinate> initiallyFilledCells = [];

  late bool gameOver;
  late String chosenNum;
  late String initialNum;
  late int selectedCell;
  final random = Random();

  @override
  Widget build(BuildContext context) {
    int boardLength = board.expand((sublist) => sublist).length;
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
          )
        : Scaffold(
            body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: 1100,
                      height: 1100,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.blueAccent,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: boardAxisCount),
                          itemBuilder: (context, index) {
                            int row = index ~/ boardAxisCount;
                            int col = index % boardAxisCount;

                            // Calculate whether the cell is at the edge of the 3x3 square
                            bool isTopEdge = row % 3 == 0;
                            bool isBottomEdge = row % 3 == 2;
                            bool isLeftEdge = col % 3 == 0;
                            bool isRightEdge = col % 3 == 2;

                            return Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  top: isTopEdge
                                      ? BorderSide(
                                          color: Colors.black, width: 2.0)
                                      : BorderSide(color: Colors.grey),
                                  bottom: isBottomEdge
                                      ? BorderSide(
                                          color: Colors.black,
                                          width: 2.0,
                                        )
                                      : BorderSide(color: Colors.grey),
                                  left: isLeftEdge
                                      ? BorderSide(
                                          color: Colors.black, width: 2.0)
                                      : BorderSide(color: Colors.grey),
                                  right: isRightEdge
                                      ? BorderSide(
                                          color: Colors.black, width: 2.0)
                                      : BorderSide(color: Colors.grey),
                                )),
                                child: GestureDetector(
                                    onTap: () {
                                      selectedCell = index;
                                      setState(() {
                                        if (!isGameOver(board)) {
                                          makeMove(index);
                                        }
                                      });
                                    },
                                    child: Text(
                                      '${board[row][col]}',
                                      style: TextStyle(
                                        height: 3,
                                        fontSize: 28,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      textHeightBehavior: TextHeightBehavior(
                                          leadingDistribution:
                                              TextLeadingDistribution.even),
                                    )));
                          },
                          itemCount: boardLength,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: SizedBox(
                    width: 900,
                    height: 100,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: boardAxisCount,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          child: GestureDetector(
                              onTap: () {
                                pickNumber(index);
                              },
                              child: Text(
                                '${numbers[index]}',
                                style: TextStyle(
                                  height: 3,
                                  fontSize: 28,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                textHeightBehavior: TextHeightBehavior(
                                    leadingDistribution:
                                        TextLeadingDistribution.even),
                              )),
                        );
                      },
                      itemCount: numbers.length,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    clearCell(
                        selectedCell); // Call the clearCell method when the button is pressed
                  },
                  child: Text('Clear Cell'),
                ),
              ],
            ),
          ));
  }

  void initState() {
    super.initState();
    gameOver = false;
    chosenNum = '';
    selectedCell = 0;

    initiallyFilledCells = generateRandomInitiallyFilledCells();

    for (var cell in initiallyFilledCells) {
      int row = cell.row;
      int col = cell.col;
      initialNum = setNumber(row, col);
      if (initialNum != '') {
        board[row][col] = initialNum;
      }
    }
  }

  void dispose() {
    super.dispose();
  }

  void makeMove(int index) {
    int row = index ~/ boardAxisCount;
    int col = index % boardAxisCount;

    if (!isCellFilled(row, col)) {
      board[row][col] = chosenNum;
      setState(() {});
    } else {
      print("This number cannot be changed");
    }
  }

  void clearCell(int index) {
    chosenNum = '';
  }

  void pickNumber(int index) {
    chosenNum = (index + 1).toString();
  }

  // Function to generate random initially filled cells for the Sudoku puzzle
  List<Coordinate> generateRandomInitiallyFilledCells() {
    List<Coordinate> initiallyFilledCells = [];

    while (initiallyFilledCells.length < 20) {
      int row = random.nextInt(boardAxisCount);
      int col = random.nextInt(boardAxisCount);
      Coordinate newCell = Coordinate(row, col);

      if (!initiallyFilledCells.contains(newCell)) {
        initiallyFilledCells.add(newCell);
      }
    }

    return initiallyFilledCells;
  }

  bool hasDuplicate(int row, int col, String? number) {
    // Check for duplicates in the row
    for (int i = 0; i < boardAxisCount; i++) {
      if (i != col && board[row][i] == number) {
        return true;
      }
    }

    // Check for duplicates in the column
    for (int i = 0; i < boardAxisCount; i++) {
      if (i != row && board[i][col] == number) {
        return true;
      }
    }

    // Calculate the starting row and column of the 3x3 square
    int squareStartRow = (row ~/ 3) * 3;
    int squareStartCol = (col ~/ 3) * 3;

    // Check for duplicates within the 3x3 square
    for (int i = squareStartRow; i < squareStartRow + 3; i++) {
      for (int j = squareStartCol; j < squareStartCol + 3; j++) {
        if (i != row && j != col && board[i][j] == number) {
          return true;
        }
      }
    }

    return false;
  }

// Function to check if a cell is initially filled
  isCellFilled(int row, int col) {
    return initiallyFilledCells
        .any((cell) => cell.row == row && cell.col == col);
  }

  String setNumber(int row, int col) {
    initialNum = (random.nextInt(boardAxisCount) + 1).toString();
    if (!hasDuplicate(row, col, initialNum)) {
      return initialNum;
    } else {
      return setNumber(row, col);
    }
  }

  bool isGameOver(List<List<String?>> board) {
    for (int r = 0; r < boardAxisCount; r++) {
      for (int c = 0; c < boardAxisCount; c++) {
        if (board[r][c] == null || hasDuplicate(r, c, board[r][c])) {
          return false;
        }
      }
    }
    gameOver = true;
    return true;
  }

  void restartGame() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => Sudoku(),
    ));
  }
}

class Coordinate {
  final int row;
  final int col;

  Coordinate(this.row, this.col);
}
