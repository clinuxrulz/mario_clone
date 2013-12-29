part of mario;

class Position extends ComponentPoolable {
  num lastX, lastY;
  num x, y;
  
  Position._();
  
  factory Position(num x, num y) {
    Position position = new Poolable.of(Position, _constructor);
    position.x = x;
    position.y = y;
    position.lastX = 0;
    position.lastY = 0;
    return position;
  }
  
  static Position _constructor() => new Position._();
}
