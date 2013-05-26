part of engine;

// https://github.com/bjorn/tiled/wiki/TMX-Map-Format
class TmxTilemap extends Tilemap {
  XmlElement _xml;
  Map<String,TmxTileset> _tilesets;
  List<TmxTileLayer> _layers;
  
  TmxTilemap(XmlElement xml) {
    this._xml = xml;
    _init();
  }
  
  void _init() {
    _tilesets = new Map();
    _layers = new List();
    _xml.children.forEach((XmlElement child) {
      if (child.name == "tileset") {
        TmxTileset tileset = new TmxTileset(child);
        _tilesets[tileset.name] = tileset;
      } else if (child.name == "layer") {
        _layers.add(new TmxTileLayer(child));
      }
    });
  }
  
  String get backgroundColour {
    return _xml.attributes["backgroundcolor"];
  }
  
  int get rows {
    return int.parse(_xml.attributes["height"]);
  }
  
  int get cols {
    return int.parse(_xml.attributes["width"]);
  }
  
  int get tileWidth {
    return int.parse(_xml.attributes["tilewidth"]);
  }
  
  int get tileHeight {
    return int.parse(_xml.attributes["tileheight"]);
  }
  
  Map<String,Tileset> get tilesets {
    return _tilesets;
  }
  
  int get layerCount {
    return _layers.length;
  }
  
  TileLayer getLayer(int index) {
    return _layers[index];
  }
}
