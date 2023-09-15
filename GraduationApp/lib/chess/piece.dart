enum ChessPieceType { pawn, rook, bishop, knight, king, queen }

class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  final String imgPath;

  ChessPiece(
      {required this.type, required this.isWhite, required this.imgPath});
}
