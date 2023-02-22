// import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
  static int numberOfSquares = 540;
  int numberInRow = 20;
  bool gameHasStarted = false;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(numberOfSquares - 1);
  void generateNewFood() {
    food = randomNumber.nextInt(numberOfSquares - 1);
  }

  void startGame() {
    gameHasStarted = true;
    snakePosition = [45, 65, 85, 105, 125];
    const duration = const Duration(milliseconds: 150);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  var direction = 'down';
  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > numberOfSquares - numberInRow) {
            snakePosition
                .add(snakePosition.last + numberInRow - numberOfSquares);
          } else {
            snakePosition.add(snakePosition.last + numberInRow);
          }

          break;

        case 'up':
          if (snakePosition.last < numberInRow) {
            snakePosition
                .add(snakePosition.last - numberInRow + numberOfSquares);
          } else {
            snakePosition.add(snakePosition.last - numberInRow);
          }
          break;

        case 'left':
          if (snakePosition.last % numberInRow == 0) {
            snakePosition.add(snakePosition.last - 1 + numberInRow);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }

          break;

        case 'right':
          if ((snakePosition.last + 1) % numberInRow == 0) {
            snakePosition.add(snakePosition.last + 1 - numberInRow);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;

        default:
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
            title: Text('GAME OVER'),
            content: Text('You\'re score: ' + snakePosition.length.toString()),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Play Again'),
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
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 400,
          child: Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (direction != 'up' && details.delta.dy > 0) {
                      direction = 'down';
                    } else if (direction != 'down' && details.delta.dy < 0) {
                      direction = 'up';
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (direction != 'left' && details.delta.dx > 0) {
                      direction = 'right';
                    } else if (direction != 'right' && details.delta.dx < 0) {
                      direction = 'left';
                    }
                  },
                  child: Container(
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: numberOfSquares,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: numberInRow),
                        itemBuilder: (BuildContext context, int index) {
                          if (snakePosition.contains(index)) {
                            return Center(
                              child: Container(
                                padding: EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                          if (index == food) {
                            return Container(
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(color: Colors.green)),
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(color: Colors.grey[900])),
                            );
                          }
                        }),
                  ),
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
                      child: Text(
                        's t a r t',
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
