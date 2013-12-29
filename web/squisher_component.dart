part of mario;

class SquisherComponent extends ComponentPoolable {
  SquisherComponent._();
  
  factory SquisherComponent() {
    SquisherComponent r = new Poolable.of(SquisherComponent, _constructor);
    return r;
  }
  
  static SquisherComponent _constructor() => new SquisherComponent._();
}
