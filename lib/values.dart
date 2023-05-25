import 'dart:ui';

enum Tetromino { L, J, I, O, S, Z, T }

enum Direction { up, down, left, right }

int rowLength = 10;
int colLength = 16;

// 间隔时间
int milliseconds = 300;

const Map<Tetromino, Color> tetrominoColor = {
  Tetromino.L: Color(0xFFFFA500),
  Tetromino.J: Color.fromARGB(255, 0, 102, 255),
  Tetromino.I: Color.fromARGB(255, 242, 0, 255),
  Tetromino.O: Color(0xFFFFFF00),
  Tetromino.S: Color(0xFF008000),
  Tetromino.Z: Color(0xFFFF0000),
  Tetromino.T: Color.fromARGB(255, 144, 0, 255),
};
