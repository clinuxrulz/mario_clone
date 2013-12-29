part of mario;

class Velocity extends ComponentPoolable {
  num x, y;
  
  Velocity._();
  
  factory Velocity(num x, num y) {
    Velocity velocity = new Poolable.of(Velocity, _constructor);
    velocity.x = x;
    velocity.y = y;
    return velocity;
  }
  
  static Velocity _constructor() => new Velocity._();
}
