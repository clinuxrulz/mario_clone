part of mario;

class Acceleration extends ComponentPoolable {
  num x, y;
  
  Acceleration._();
  
  factory Acceleration(num x, num y) {
    Acceleration acceleration = new Poolable.of(Acceleration, _constructor);
    acceleration.x = x;
    acceleration.y = y;
    return acceleration;
  }
  
  static Acceleration _constructor() => new Acceleration._();
}
