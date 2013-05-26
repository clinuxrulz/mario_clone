part of engine;

class HtmlCanvasImage implements Image {
  ImageElement image;
  
  HtmlCanvasImage(this.image);
  
  int width() {
    return image.width;
  }
  
  int height() {
    return image.height;
  }
}
