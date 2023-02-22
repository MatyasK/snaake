import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int rows = 20;
  final int columns = 10;
  final int cellSize = 20;
  final int snakeInitialLength = 3;
  final Duration snakeMoveInterval = Duration(milliseconds: 300);

  List<int> snakePositions = [];
  Direction direction = Direction.right;
  int foodPosition = -1;
  int score = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      snakePositions.clear();
      for (int i = 0; i < snakeInitialLength; i++) {
        snakePositions.add((columns ~/ 2) + i + (rows ~/ 2) * columns);
      }
      direction = Direction.right;
      foodPosition = generateFood();
      score = 0;
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }
      timer = Timer.periodic(snakeMoveInterval, (Timer t) => moveSnake());
    });
  }

  void moveSnake() {
    setState(() {
      int newHeadPosition = 0;
      switch (direction) {
        case Direction.up:
          newHeadPosition = snakePositions.first - columns;
          break;
        case Direction.down:
          newHeadPosition = snakePositions.first + columns;
          break;
        case Direction.left:
          newHeadPosition = snakePositions.first - 1;
          break;
        case Direction.right:
          newHeadPosition = snakePositions.first + 1;
          break;
      }

      if (snakePositions.contains(newHeadPosition) ||
          newHeadPosition < 0 ||
          newHeadPosition >= rows * columns) {
        // Snake collided with itself or with a wall
        resetGame();
        return;
      }

      snakePositions.insert(0, newHeadPosition);
      if (newHeadPosition == foodPosition) {
        // Snake ate the food
        foodPosition = generateFood();
        score++;
      } else {
        // Snake didn't eat the food, so remove the tail
        snakePositions.removeLast();
      }
    });
  }

  int generateFood() {
    final random = Random();
    int foodPosition = random.nextInt(rows * columns);
    while (snakePositions.contains(foodPosition)) {
      foodPosition = random.nextInt(rows * columns);
    }
    return foodPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) {
          if (direction == Direction.up || direction == Direction.down) {
            return;
          }
          if (details.delta.dy > 0) {
            direction = Direction.down;
          } else {
            direction = Direction.up;
          }
        },
        onHorizontalDragUpdate: (details) {
          if (direction == Direction.left || direction == Direction.right) {
            return;
          }
          if (details.delta.dx > 0) {
            direction = Direction.right;
          } else {
            direction = Direction.left;
          }
        },
        child: CustomPaint(
          painter: SnakePainter(
            rows: rows,
            columns: columns,
            cellSize: cellSize,
            snakePositions: snakePositions,
            foodPosition: foodPosition,
          ),
          child: Container(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: resetGame,
            ),
            Text("Score: $score"),
          ],
        ),
      ),
    );
  }
}

class SnakePainter extends CustomPainter {
  final int rows;
  final int columns;
  final int cellSize;
  final List<int> snakePositions;
  final int foodPosition;

  SnakePainter({
    required this.rows,
    required this.columns,
    required this.cellSize,
    required this.snakePositions,
    required this.foodPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.grey[200]!;
    canvas.drawRect(
      Rect.fromLTWH(
          0, 0, columns * cellSize.toDouble(), rows * cellSize.toDouble()),
      paint,
    );

// Draw snake
    paint.color = Colors.green;
    for (int i = 0; i < snakePositions.length; i++) {
      int x = snakePositions[i] % columns;
      int y = snakePositions[i] ~/ columns;
      canvas.drawRect(
        Rect.fromLTWH(x * cellSize.toDouble(), y * cellSize.toDouble(),
            cellSize.toDouble(), cellSize.toDouble()),
        paint,
      );
    }

// Draw food
    paint.color = Colors.red;
    int foodX = foodPosition % columns;
    int foodY = foodPosition ~/ columns;
    canvas.drawRect(
      Rect.fromLTWH(foodX * cellSize.toDouble(), foodY * cellSize.toDouble(),
          cellSize.toDouble(), cellSize.toDouble()),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
