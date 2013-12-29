part of mario;

class MaxVelocity extends ComponentPoolable {
  num x, y;
  
  MaxVelocity._();
  
  factory MaxVelocity(num x, num y) {
    MaxVelocity velocity = new Poolable.of(MaxVelocity, _constructor);
    velocity.x = x;
    velocity.y = y;
    return velocity;
  }
  
  static MaxVelocity _constructor() => new MaxVelocity._();
}
