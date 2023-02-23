import 'package:flutter/material.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({
    super.key,
    required this.isOdd,
    required this.index,
    required this.boardTileType,
  });

  final bool isOdd;
  final int index;
  final BoardTileType boardTileType;

  static BoardTile createTile({
    required List<int> snakePosition,
    required int index,
    required int food,
  }) {
    if (snakePosition.contains(index)) {
      // Check if this is the head of snake
      if (index == snakePosition.last) {
        return BoardTile(
          isOdd: index.isOdd,
          boardTileType: BoardTileType.snakeHead,
          index: index,
        );
      }

      // Check if this is the tail of snake
      if (index == snakePosition.first) {
        return BoardTile(
          isOdd: index.isOdd,
          boardTileType: BoardTileType.snakeTail,
          index: index,
        );
      }

      return BoardTile(
        isOdd: index.isOdd,
        boardTileType: BoardTileType.snakeBody,
        index: index,
      );
    }

    if (index == food) {
      return BoardTile(
        isOdd: index.isOdd,
        boardTileType: BoardTileType.food,
        index: index,
      );
    }
    return BoardTile(
      isOdd: index.isOdd,
      boardTileType: BoardTileType.empty,
      index: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: isOdd ? Colors.blueGrey : Colors.grey,
          child: boardTileType.isElement
              ? Image.asset(
                  boardTileType.assetPath,
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                )
              : const SizedBox(
                  height: 100,
                  width: 100,
                ),
        ),
      ),
    );
  }
}

enum BoardTileType {
  empty(false, ''),
  snakeHead(true, 'assets/front.png'),
  snakeBody(true, 'assets/body.png'),
  snakeTail(true, 'assets/tail.png'),
  food(true, 'assets/pallet.png');

  final bool isElement;
  final String assetPath;
  const BoardTileType(this.isElement, this.assetPath);
}
