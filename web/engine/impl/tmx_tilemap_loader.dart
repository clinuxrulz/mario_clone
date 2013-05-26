part of engine;

class TmxTilesetLoader implements TilemapLoader {
  Stream<Tilemap> loadTileset(data) {
    String s = data;
    XmlElement xmlElement = XML.parse(s.substring(s.indexOf("<map")));
    return new Future.value(new TmxTilemap(xmlElement)).asStream();
  }
}
