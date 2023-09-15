import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final String imgPath;
  final bool isWhite;

  const DeadPiece({super.key, required this.imgPath, required this.isWhite});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imgPath,
      color: isWhite ? Colors.white : Colors.black,
    );
  }
}
