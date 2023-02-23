import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snaake/snake.dart';
import 'package:snaake/start_game_button.dart';
import 'package:snaake/utils/consts.dart';

import 'board.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<int> snakePosition = [0, 1, 2, 3, 4];
  static final randomNumber = Random();
  SnakeDirection direction = SnakeDirection.right;

  bool gameHasStarted = false;

  int food = randomNumber.nextInt(Consts.numberOfSquares - 1);

  void generateNewFood() {
    food = randomNumber.nextInt(Consts.numberOfSquares - 1);
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  void updateSnake() {
    setState(() {
      if (direction == SnakeDirection.down) {
        if (snakePosition.last > Consts.numberOfSquares - Consts.rowCount) {
          snakePosition.add(
              snakePosition.last + Consts.rowCount - Consts.numberOfSquares);
        } else {
          snakePosition.add(snakePosition.last + Consts.rowCount);
        }
      }

      if (direction.isUp) {
        if (snakePosition.last < Consts.rowCount) {
          snakePosition.add(
              snakePosition.last - Consts.rowCount + Consts.numberOfSquares);
        } else {
          snakePosition.add(snakePosition.last - Consts.rowCount);
        }
      }

      if (direction.isLeft) {
        if (snakePosition.last % Consts.rowCount == 0) {
          snakePosition.add(snakePosition.last - 1 + Consts.rowCount);
        } else {
          snakePosition.add(snakePosition.last - 1);
        }
      }

      if (direction.isRight) {
        if ((snakePosition.last + 1) % Consts.rowCount == 0) {
          snakePosition.add(snakePosition.last + 1 - Consts.rowCount);
        } else {
          snakePosition.add(snakePosition.last + 1);
        }
      }

      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }


  void _showGameOverScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('GAME OVER'),
            content: Text('You\'re score: ${snakePosition.length}'),
            actions: [
              ElevatedButton(
                child: const Text('Play Again'),
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (!direction.isUp && details.delta.dy > 0) {
                      direction = SnakeDirection.down;
                    } else if (!direction.isDown && details.delta.dy < 0) {
                      direction = SnakeDirection.up;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (!direction.isLeft && details.delta.dx > 0) {
                      direction = SnakeDirection.right;
                    } else if (!direction.isRight && details.delta.dx < 0) {
                      direction = SnakeDirection.left;
                    }
                  },
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Consts.numberOfSquares,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Consts.rowCount,
                    ),
                    itemBuilder: (context, index) => createTile(
                      snakePosition: snakePosition,
                      index: index,
                      food: food,
                      direction: direction
                    ),
                  ),
                ),
              ),
              StartGameButton(onPress: (!gameHasStarted) ? startGame : () {})
            ],
          ),
        ),
      ),
    );
  }
}
