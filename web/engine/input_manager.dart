part of engine;

class InputManager {
  Map<int,bool> _keyState = new Map();
  Map<String,int> _bindings = new Map();
  
  InputManager() {
    document.body.onKeyDown.listen((KeyboardEvent e) {
      _keyState[e.keyCode] = true;
    });
    document.body.onKeyUp.listen((KeyboardEvent e) {
      _keyState[e.keyCode] = false;
    });
  }
  
  bool isPressed(String binding) {
    var x = _keyState[_bindings[binding]];
    if (x == null) { return false; }
    return x;
  }
  
  void bind(int keyCode, String binding) {
    _bindings[binding] = keyCode;
  }
}
