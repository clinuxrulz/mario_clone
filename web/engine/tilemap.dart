part of engine;

abstract class Tilemap {
  String get backgroundColour;
  int get rows;
  int get cols;
  int get tileWidth;
  int get tileHeight;
  Map<String,Tileset> get tilesets;
  int get layerCount;
  TileLayer getLayer(int index);
  TileLayer getLayerByName(String name) {
    for (int i = 0; i < layerCount; ++i) {
      TileLayer layer = getLayer(i);
      if (layer.name == name) {
        return layer;
      }
    }
  }
}
