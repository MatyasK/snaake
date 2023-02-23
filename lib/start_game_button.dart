import 'package:flutter/material.dart';

class StartGameButton extends StatelessWidget {
  final VoidCallback onPress;
  const StartGameButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: const Text(
              'S T A R T',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            onPressed: () => onPress(),
          ),
        ],
      ),
    );
  }
}
