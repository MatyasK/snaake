import 'package:flutter/material.dart';
import 'package:snaake/utils/colors.dart';

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
      backgroundColor: ccaGreen,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(image: Image.asset('assets/game_logo.png').image),
          const SizedBox(height: 10),
          Image(image: Image.asset('assets/game_over.png').image),
          const SizedBox(height: 10),
          const Text('Your score'),
          Text(score),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
              ),
              onPressed: () => onPlayAgain(),
              child: const Text('Try Again')),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  buttonColor,
                ),
              ),
              onPressed: () => onQuit(),
              child: const Text('Quiote Game')),
        ],
      ),
    );
  }
}
