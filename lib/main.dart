// import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

enum SnakeDirection {
  up,
  down,
  left,
  right,
}

enum BoardTileType {
  empty,
  snakeHead,
  snakeBody,
  snakeTail,
  food,
}

extension BoardTileBody on BoardTileType {
  bool get isSnake =>
      this == BoardTileType.snakeHead ||
      this == BoardTileType.snakeBody ||
      this == BoardTileType.snakeTail ||
      this == BoardTileType.food;

  String get bodyPartAssetUrl {
    switch (this) {
      case BoardTileType.snakeHead:
        return 'assets/front.png';
      case BoardTileType.snakeBody:
        return 'assets/body.png';
      case BoardTileType.snakeTail:
        return 'assets/tail.png';
      case BoardTileType.food:
        return 'assets/pallet.png';
      default:
        return '';
    }
  }
}

extension SnakeDirectionText on SnakeDirection {
  bool get isDown => this == SnakeDirection.down;
  bool get isUp => this == SnakeDirection.up;
  bool get isLeft => this == SnakeDirection.left;
  bool get isRight => this == SnakeDirection.right;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  static int numberOfSquares = 100;
  int numberInRow = 10;
  bool gameHasStarted = false;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(numberOfSquares - 1);

  void generateNewFood() {
    food = randomNumber.nextInt(numberOfSquares - 1);
  }

  void startGame() {
    gameHasStarted = true;
    snakePosition = [45, 65, 85, 105, 125];
    const duration = Duration(milliseconds: 150);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  SnakeDirection direction = SnakeDirection.down;
  void updateSnake() {
    setState(() {
      if (direction.isDown) {
        if (snakePosition.last > numberOfSquares - numberInRow) {
          snakePosition.add(snakePosition.last + numberInRow - numberOfSquares);
        } else {
          snakePosition.add(snakePosition.last + numberInRow);
        }
      }

      if (direction.isUp) {
        if (snakePosition.last < numberInRow) {
          snakePosition.add(snakePosition.last - numberInRow + numberOfSquares);
        } else {
          snakePosition.add(snakePosition.last - numberInRow);
        }
      }

      if (direction.isLeft) {
        if (snakePosition.last % numberInRow == 0) {
          snakePosition.add(snakePosition.last - 1 + numberInRow);
        } else {
          snakePosition.add(snakePosition.last - 1);
        }
      }

      if (direction.isRight) {
        if ((snakePosition.last + 1) % numberInRow == 0) {
          snakePosition.add(snakePosition.last + 1 - numberInRow);
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
            actions: <Widget>[
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
      //appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
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
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: numberOfSquares,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numberInRow),
                      itemBuilder: (BuildContext context, int index) {
                        if (snakePosition.contains(index)) {
                          // Check if this is the head of snake
                          if (index == snakePosition.last) {
                            return BoardTile(
                              isOdd: index.isOdd,
                              boardTileType: BoardTileType.snakeHead,
                            );
                          }

                          // Check if this is the tail of snake
                          if (index == snakePosition.first) {
                            return BoardTile(
                              isOdd: index.isOdd,
                              boardTileType: BoardTileType.snakeTail,
                            );
                          }

                          return BoardTile(
                            isOdd: index.isOdd,
                            boardTileType: BoardTileType.snakeBody,
                          );
                        }

                        if (index == food) {
                          return BoardTile(
                            isOdd: index.isOdd,
                            boardTileType: BoardTileType.food,
                          );
                        } else {
                          return BoardTile(
                            isOdd: index.isOdd,
                            boardTileType: BoardTileType.empty,
                          );
                        }
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (gameHasStarted == false) {
                          startGame();
                        }
                      },
                      child: const Text(
                        's t a r t',
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BoardTile extends StatelessWidget {
  const BoardTile({
    Key? key,
    required this.isOdd,
    required this.boardTileType,
  }) : super(key: key);

  final bool isOdd;
  final BoardTileType boardTileType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
            color: isOdd ? Colors.blueGrey : Colors.grey,
            child: boardTileType.isSnake
                ? Image(image: AssetImage(boardTileType.bodyPartAssetUrl))
                : null),
      ),
    );
  }
}
