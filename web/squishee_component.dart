part of mario;

class SquisheeComponent extends ComponentPoolable {
  Engine.Animation squishAnimation;
  num timeUntilDisappear;
  bool alive;
  
  SquisheeComponent._();
  
  factory SquisheeComponent({Engine.Animation squishAnimation, num timeUntilDisappear}) {
    SquisheeComponent r = new Poolable.of(SquisheeComponent, _constructor);
    r.squishAnimation = squishAnimation;
    r.timeUntilDisappear = timeUntilDisappear;
    r.alive = true;
    return r;
  }
  
  static SquisheeComponent _constructor() => new SquisheeComponent._();
}
