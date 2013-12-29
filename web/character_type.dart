part of mario;

class CharacterType {
  final String _value;
  const CharacterType._internal(this._value);
  toString() => "CharacterType.$_value";
  
  static const MARIO = const CharacterType._internal("MARIO");
  static const GOOMBA = const CharacterType._internal("GOOMBA");
}
