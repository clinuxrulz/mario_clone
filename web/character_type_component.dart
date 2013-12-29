part of mario;

class CharacterTypeComponent extends ComponentPoolable {
  CharacterType type;
  
  CharacterTypeComponent._();
  
  factory CharacterTypeComponent(CharacterType type) {
    CharacterTypeComponent r = new Poolable.of(CharacterTypeComponent, _constructor);
    r.type = type;
    return r;
  }
  
  static CharacterTypeComponent _constructor() => new CharacterTypeComponent._();
}
