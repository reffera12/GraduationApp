// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/chess/piece.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMove,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    if (isSelected) {
      squareColor = Colors.grey[600];
    } else if (isValidMove) {
      squareColor = Colors.grey[500];
    } else {
      squareColor = isWhite ? Colors.blue[300] : Colors.blueAccent[700];
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
            color: squareColor),
        child: GestureDetector(
          onTap: onTap,
          child: piece != null
              ? Image.asset(
                  piece!.imgPath,
                  color: piece!.isWhite ? Colors.white : Colors.black,
                )
              : null,
        ));
  }
}
