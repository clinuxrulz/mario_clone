part of mario;

class Damping extends ComponentPoolable {
  num amount;
  
  Damping._();
  
  factory Damping(num amount) {
    Damping damping = new Poolable.of(Damping, _constructor);
    damping.amount = amount;
    return damping;
  }
  
  static Damping _constructor() => new Damping._();
}
