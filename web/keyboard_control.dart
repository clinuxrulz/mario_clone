part of mario;

class KeyboardControl extends ComponentPoolable {
  KeyboardControl._();
  
  factory KeyboardControl() {
    KeyboardControl r = new Poolable.of(KeyboardControl, _constructor);
    return r;
  }
  
  static KeyboardControl _constructor() => new KeyboardControl._();
}