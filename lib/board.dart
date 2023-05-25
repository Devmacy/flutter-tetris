import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tetris/dot.dart';
import 'package:flutter_tetris/piece.dart';
import 'package:flutter_tetris/values.dart';

// 创建一个二维数组
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

int score = 0;
bool isGameOver = false;

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece =
      Piece(type: Tetromino.values[Random().nextInt(Tetromino.values.length)]);

  // Piece currentPiece = Piece(type: Tetromino.J);

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    // 时间循环
    Duration frameRate = Duration(milliseconds: milliseconds);
    gameLoop(frameRate);
  }

  /// 游戏循环
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        clearLines();
        checkLanding();

        if (isGameOver) {
          timer.cancel();
          showGameOverDialog();
        }

        currentPiece.movePiece(Direction.down);
      });
    });
  }

  // 碰撞检测
  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // 检查出界
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }
    return false;
  }

  // 检查着陆
  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      createNewPiece();
    }
  }

  // 创建新的方块
  void createNewPiece() {
    Random random = Random();

    Tetromino randomType =
        Tetromino.values[random.nextInt(Tetromino.values.length)];

    currentPiece = Piece(type: randomType);
    // currentPiece = Piece(type: Tetromino.J);
    currentPiece.initializePiece();

    isGameOver = gameOver();
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void clearLines() {
    for (int row = colLength - 1; row >= 0; row--) {
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          break;
        }
        if (col == (rowLength - 1)) {
          score += rowLength;
          for (int r = row; r > 0; r--) {
            gameBoard[r] = List.from(gameBoard[r - 1]);
          }
          gameBoard[0] = List.generate(row, (index) => null);
        }
      }
    }
  }

  bool gameOver() {
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Game Over'),
              content: Text('Your score is: $score'),
              actions: [
                TextButton(
                    onPressed: () {
                      restGame();
                      Navigator.pop(context);
                    },
                    child: const Text('Play Again'))
              ],
            ));
  }

  void restGame() {
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    isGameOver = false;
    score = 0;

    createNewPiece();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: rowLength * colLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength,
                ),
                itemBuilder: (context, index) {
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;
                  if (currentPiece.position.contains(index)) {
                    return Pixel(
                        color: currentPiece.color, child: index.toString());
                  } else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(
                      color: tetrominoColor[tetrominoType] ?? Colors.white,
                      child: '',
                      // child: '',
                    );
                  } else {
                    return Pixel(
                        color: const Color(0x56565661),
                        child: index.toString());
                  }
                }),
          ),
          Text(
            'score:$score',
            style: const TextStyle(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back)),
                IconButton(
                    onPressed: rotatePiece,
                    color: Colors.white,
                    icon: const Icon(Icons.rotate_right)),
                IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_forward)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
