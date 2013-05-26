part of engine;

class HtmlCanvasImageLoader implements ImageLoader {
  static HtmlCanvasImageLoader _instance = null;
  factory HtmlCanvasImageLoader() {
    if (_instance == null) {
      _instance = new HtmlCanvasImageLoader._init();
    }
    return _instance;
  }
  HtmlCanvasImageLoader._init() {
  }
  Stream<Image> loadImage(String path) {
    ImageElement img = new ImageElement(src:path);
    return img.onLoad.map((_) => new HtmlCanvasImage(img));
  }
}
