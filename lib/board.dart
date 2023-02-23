import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snaake/snake.dart';
import 'package:snaake/utils/colors.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({
    super.key,
    required this.isOdd,
    required this.index,
    required this.boardTileType,
    required this.direction,
  });

  final bool isOdd;
  final int index;
  final SnakeDirection direction;
  final BoardTileType boardTileType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(5),
        child: Container(
          color: isOdd ? lightGreyColor : darkGreyColor,
          child: boardTileType.isElement
              ? (boardTileType != BoardTileType.snakeHead)
                  ? Image.asset(
                      boardTileType.assetPath,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    )
                  : _createSnakeHead(type: boardTileType, direction: direction)
              : const SizedBox(
                  height: 100,
                  width: 100,
                ),
        ),
      ),
    );
  }

  Widget _createSnakeHead(
      {required BoardTileType type, required SnakeDirection direction}) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: _getMatrix(direction: direction),
      child: Image.asset(
        type.assetPath,
        height: 100,
        width: 100,
        fit: BoxFit.contain,
      ),
    );
  }

  Matrix4 _getMatrix({required SnakeDirection direction}) {
    if (direction.isDown) {
      return Matrix4.rotationZ(270 * pi / 180);
    }
    if (direction.isUp) {
      return Matrix4.rotationZ(pi / 2);
    }
    if (direction.isRight) {
      return Matrix4.rotationY(pi);
    }
    return Matrix4.rotationY(pi * 180);
  } /*
  SnakeDirection.up() : transform =
  SnakeDirection.down() : transform =
  SnakeDirection.left() : transform =  Matrix4.rotationY(pi * 180);
  SnakeDirection.right() : transform =*/
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

BoardTile createTile({
  required List<int> snakePosition,
  required int index,
  required bool isGrey,
  required int food,
  required SnakeDirection direction,
}) {
  if (snakePosition.contains(index)) {
    // Check if this is the head of snake
    if (index == snakePosition.last) {
      return BoardTile(
        isOdd: isGrey,
        boardTileType: BoardTileType.snakeHead,
        index: index,
        direction: direction,
      );
    }

    // Check if this is the tail of snake
    if (index == snakePosition.first) {
      return BoardTile(
        isOdd: isGrey,
        boardTileType: BoardTileType.snakeTail,
        index: index,
        direction: direction,
      );
    }

    return BoardTile(
      isOdd: isGrey,
      boardTileType: BoardTileType.snakeBody,
      index: index,
      direction: direction,
    );
  }

  if (index == food) {
    return BoardTile(
      isOdd: isGrey,
      boardTileType: BoardTileType.food,
      index: index,
      direction: direction,
    );
  }
  return BoardTile(
    isOdd: isGrey,
    boardTileType: BoardTileType.empty,
    index: index,
    direction: direction,
  );
}
