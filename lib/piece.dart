import 'package:flutter/services.dart';
import 'package:flutter_tetris/board.dart';
import 'package:flutter_tetris/values.dart';

class Piece {
  Tetromino type;

  Piece({required this.type});

  List<int> position = [];

  Color get color {
    return tetrominoColor[type] ?? const Color(0xFFFFFFFF);
  }

  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = [-25, -15, -5, -6];
        break;
      case Tetromino.I:
        position = [-7, -6, -5, -4];
        break;
      case Tetromino.O:
        position = [-26, -16, -25, -15];
        break;
      case Tetromino.S:
        position = [-25, -26, -16, -17];
        break;
      case Tetromino.Z:
        position = [-26, -25, -15, -14];
        break;
      case Tetromino.T:
        position = [-26, -16, -6, -15];
        break;
      default:
    }
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  void rotatePiece() {
    // o是对称直接返回
    if (type == Tetromino.O) {
      return;
    }

    // 设置原点
    int a = (position[1] / rowLength).floor();
    int b = position[1] % rowLength;

    List<int> newPosition = [0, 0, 0, 0];
    for (int i = 0; i < position.length; i++) {
      int x = (position[i] / rowLength).floor();
      int y = position[i] % rowLength;
      newPosition[i] = (b - a + x) + (a + b - y) * rowLength;
    }
    if (checkPositionValid(newPosition, position)) {
      position = newPosition;
    }
  }

  bool checkPositionValid(List<int> newPosition, List<int> oldPosition) {
    bool valid = true;


    // 旋转后的是否和其他方块冲突
    valid = !newPosition.any((element) =>
        gameBoard[(element / rowLength).floor()][element % rowLength] != null);

    return valid;
  }
}
