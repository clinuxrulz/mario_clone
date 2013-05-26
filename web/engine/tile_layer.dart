part of engine;

abstract class TileLayer {
  String get name;
  int getGlobalTileId(int rowIndex, int colIndex);
}
