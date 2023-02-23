// import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:snaake/snake.dart';
import 'package:snaake/utils/colors.dart';
import 'package:snaake/utils/consts.dart';

import 'board.dart';
import 'game_over_dialog.dart';

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
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance
        .addPostFrameCallback((_) => showStartGamePopUp(context));

    // if (mounted) {
    //   showStartGamePopUp();
    // }
  }

  static List<int> snakePosition = [0, 1, 2, 3, 4];
  static final randomNumber = Random();
  SnakeDirection direction = SnakeDirection.right;
  bool gameHasStarted = false;
  int columnCount = 10;
  int currentRow = 0;

  Timer? timer;
  int food = randomNumber.nextInt(Consts.numberOfSquares - 1);

  void generateNewFood() {
    food = randomNumber.nextInt(Consts.numberOfSquares - 1);
  }

  void startGame() {
    direction = SnakeDirection.right;
    gameHasStarted = true;
    timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverPopUp();
      }
    });
  }

  void showStartGamePopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ccaGreen,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: Image.asset('assets/game_logo.png').image),
                const SizedBox(height: 10),
                Image(image: Image.asset('assets/start_game.png').image),
                const SizedBox(height: 10),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(buttonColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      startGame();
                    },
                    child: const Text('Start Game')),
              ],
            ),
          );
        });
  }

  // Pause Game
  void pauseToggleGame() {
    if (gameHasStarted) {
      gameHasStarted = false;

      setState(() {});

      if (timer != null) {
        timer!.cancel();
      }
    } else {
      gameHasStarted = true;
      const duration = Duration(milliseconds: 150);
      timer = Timer.periodic(duration, (Timer timer) {
        updateSnake();
        if (gameOver()) {
          timer.cancel();
          _showGameOverPopUp();
        }
      });
    }
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

  void _showGameOverPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) => GameOverDialog(
        score: '${snakePosition.length - 5}',
        onPlayAgain: () {
          Navigator.of(context).pop();
          snakePosition.length = 5;
          snakePosition = [0, 1, 2, 3, 4];
          startGame();
        },
        onQuit: () {
          //TODO: move to real app
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ccaGreen,
      appBar: AppBar(
        title: const Text('ChainCargo'),
        centerTitle: true,
        backgroundColor: ccaGreen,
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Image(image: AssetImage('assets/pallet.png')),
                        Text('x ${snakePosition.length - 5}')
                      ],
                    ),
                    IconButton(
                        onPressed: pauseToggleGame,
                        icon: gameHasStarted
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow))
                  ],
                ),
              ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Consts.numberOfSquares,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Consts.rowCount,
                        ),
                        itemBuilder: (context, index) {
                          // increase the current row on every 11th tile
                          if (index % Consts.rowCount == 0) {
                            currentRow += 1;
                          }

                          bool isGray = index.isOdd;

                          if (currentRow.isEven) {
                            isGray = !isGray;
                          }

                          return createTile(
                              snakePosition: snakePosition,
                              index: index,
                              isGrey: isGray,
                              food: food,
                              direction: direction);
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
