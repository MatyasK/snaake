
enum SnakeDirection {
  up,
  down,
  left,
  right;
}

extension SnakeDirectionText on SnakeDirection {
  bool get isDown => this == SnakeDirection.down;
  bool get isUp => this == SnakeDirection.up;
  bool get isLeft => this == SnakeDirection.left;
  bool get isRight => this == SnakeDirection.right;
}
