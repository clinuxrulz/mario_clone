part of engine;

abstract class Surface {
  void dispose() {}
  void clear();
  void drawRect(int x, int y, int width, int height, String colour);
  void fillRect(int x, int y, int width, int height, String colour);
  void drawImage(Image image, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh, bool flipX);
  int get width;
  int get height;
}
