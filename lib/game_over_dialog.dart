import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  final String score;
  final VoidCallback onPlayAgain;
  final VoidCallback onQuit;
  const GameOverDialog({
    super.key,
    required this.score,
    required this.onPlayAgain,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(141, 171, 81, 1),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('ChainCargo Snake'),
          const SizedBox(height: 10),
          const Text('GameOver'),
          const SizedBox(height: 10),
          const Text('Your score'),
          Text(score),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(
                    34,
                    65,
                    82,
                    1,
                  ),
                ),
              ),
              onPressed: () => onPlayAgain(),
              child: const Text('Try Again')),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(
                    34,
                    65,
                    82,
                    1,
                  ),
                ),
              ),
              onPressed: () => onQuit(),
              child: const Text('Quite Game')),
        ],
      ),
    );
  }
}
