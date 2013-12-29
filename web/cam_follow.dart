part of mario;

class CamFollow extends ComponentPoolable {
  CamFollow._();
  
  factory CamFollow() {
    CamFollow r = new Poolable.of(CamFollow, _constructor);
    return r;
  }
  
  static CamFollow _constructor() => new CamFollow._();
}
