part of engine;

class HtmlCanvasScreen implements Surface {
  int _width;
  int _height;
  CanvasElement _canvas;
  
  HtmlCanvasScreen(width, height) {
    _width = width;
    _height = height;
    _init();
  }
  
  void _init() {
    var screen = document.getElementById("screen");
    _canvas = new CanvasElement();
    _canvas.width = _width;
    _canvas.height = _height;
    _canvas.style.width = "100%";
    screen.children.add(_canvas);
  }
  
  void dispose() {
    var screen = document.getElementById("screen");
    screen.children.remove(_canvas);
  }
  
  void clear() {
    var ctx = _canvas.context2D;
    ctx.clearRect(0, 0, _width, _height);
  }
  
  void drawRect(int x, int y, int width, int height, String colour) {
    var ctx = _canvas.context2D;
    ctx.strokeStyle = colour;
    ctx.strokeRect(x, y, width, height);
  }
  
  void fillRect(int x, int y, int width, int height, String colour) {
    var ctx = _canvas.context2D;
    ctx.fillStyle = colour;
    ctx.fillRect(x, y, width, height);
  }
  
  void drawImage(Image source, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh, bool flipX) {
    var ctx = _canvas.context2D;
    HtmlCanvasImage _source = source;
    if (!flipX) {
      ctx.drawImageScaledFromSource(_source.image, sx, sy, sw, sh, dx, dy, dw, dh);
    } else {
      ctx.save();
      ctx.translate(dx, 0);
      ctx.scale(-1, 1);
      ctx.drawImageScaledFromSource(_source.image, sx, sy, sw, sh, 0, dy, dw, dh);
      ctx.restore();
    }
  }
  
  int get width {
    return _width;
  }
  
  int get height {
    return _height;
  }
}
