part of mario;

class CollisionRect extends ComponentPoolable {
  num x, y, lenX, lenY;
  
  CollisionRect._();
  
  factory CollisionRect({num x, num y, num lenX, num lenY}) {
    CollisionRect rect = new Poolable.of(CollisionRect, _constructor);
    rect.x = x;
    rect.y = y;
    rect.lenX = lenX;
    rect.lenY = lenY;
    return rect;
  }
  
  static CollisionRect _constructor() => new CollisionRect._();
  
  num get minX => x;
  num get minY => y;
  num get maxX => x + lenX;
  num get maxY => y + lenY;
}
